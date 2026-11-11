import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../l10n/l10n.dart';
import '../page_home/details_page.dart';
import '../util/tailwind_colors.dart';
import '../widgets/dialog_screen_base.dart';

class const RebalancePage({super.key}) extends StatefulWidget {
  @override
  State<RebalancePage> createState() => _RebalancePageState();
}

class _RebalancePageState extends State<RebalancePage> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, FullData?>(
      builder: (context, state) {
        if (state == null) {
          return const SizedBox.shrink();
        }

        const colorName = 'emerald';
        final primaryColor = getPrimaryColor(context, colorName);
        final primaryColorWeaker = getPrimaryColorWeaker(context, colorName);
        final backgroundDialogColor =
            getBackgroundDialogColor(context, colorName);
        final currency = state.settings.currencySymbol;
        final buyOnly = state.settings.buyOnly;
        final rxPrefs = RxSharedPreferences.getInstance();

        final deposit = double.tryParse(_amountController.text) ?? 0.0;

        final targetedItems =
            state.allItems.where((i) => i.targetPercent > 0).toList();
        final targetedWallets = state.walletsMap.values
            .where((w) => w.targetPercent > 0)
            .toList();

        final minCashForItems =
            (state.buyOnlyTotalForItems() - state.totalValue)
                .clamp(0.0, double.infinity);
        final minCashForWallets =
            (state.buyOnlyTotalForWallets - state.totalValue)
                .clamp(0.0, double.infinity);
        final autoFillCash =
            targetedItems.isNotEmpty ? minCashForItems : minCashForWallets;

        final itemDeltas = _computeItemDeltas(state, deposit, buyOnly);
        final walletDeltas = _computeWalletDeltas(state, deposit, buyOnly);

        return DialogScreenBase(
          colorName: colorName,
          backgroundDialogColor: backgroundDialogColor,
          appBarTitle: context.l10n.rebalanceCalculator,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.buyOnlyRebalance),
              subtitle: Text(
                context.l10n.buyOnlyRebalanceSubtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              value: buyOnly,
              onChanged: (val) async {
                await rxPrefs.setBool('buyOnly', val);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              onChanged: (_) => setState(() {}),
              textAlign: TextAlign.right,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: const <TextInputFormatter>[
                DecimalTextInputFormatter(),
              ],
              decoration: InputDecoration(
                filled: true,
                fillColor: getInputFillColor(context),
                labelText: context.l10n.amountToInvest,
                hintText: '0.00',
                prefixText: '$currency ',
                labelStyle: TextStyle(color: primaryColor),
                border: getInputDecorationBorder(primaryColor),
                focusedBorder: getInputDecorationBorder(primaryColor),
                enabledBorder: getInputDecorationBorder(primaryColor),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (autoFillCash > 0.005)
                  ActionChip(
                    visualDensity: VisualDensity.compact,
                    avatar: Icon(
                      Icons.auto_awesome_rounded,
                      size: 14,
                      color: primaryColor,
                    ),
                    label: Text(
                      '${context.l10n.autoFillBuyOnly}: $currency${toCurrency(autoFillCash)}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    onPressed: () {
                      setState(() {
                        _amountController.text =
                            autoFillCash.toStringAsFixed(2);
                      });
                    },
                  ),
                for (final preset in const ['100', '500', '1000'])
                  ActionChip(
                    visualDensity: VisualDensity.compact,
                    label: Text('+$currency$preset'),
                    onPressed: () {
                      final current =
                          double.tryParse(_amountController.text) ?? 0;
                      final next = current + double.parse(preset);
                      setState(() {
                        _amountController.text =
                            next == next.truncateToDouble()
                                ? next.toInt().toString()
                                : next.toStringAsFixed(2);
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (targetedItems.isEmpty && targetedWallets.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  context.l10n.noTargetsSet,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
            else ...[
              if (targetedWallets.isNotEmpty) ...[
                for (final wallet in targetedWallets)
                  _AllocationTile(
                    name: wallet.name,
                    color: tailwindPalette(wallet.colorName).s500,
                    currentValue: wallet.totalValue,
                    delta: walletDeltas[wallet.id] ?? 0,
                    targetPercent: wallet.targetPercent,
                    currency: currency,
                  ),
                if (targetedItems.isNotEmpty) const Divider(height: 24),
              ],
              if (targetedItems.isNotEmpty)
                for (final item in targetedItems)
                  _AllocationTile(
                    name: item.name,
                    color: item.color,
                    currentValue: item.totalValue,
                    delta: itemDeltas[item.id] ?? 0,
                    targetPercent: item.targetPercent,
                    currency: currency,
                  ),
            ],
            if (targetedItems.isNotEmpty &&
                itemDeltas.values.any((d) => d.abs() >= 0.01)) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: backgroundDialogColor,
                  backgroundColor: primaryColor,
                ),
                icon: const Icon(Icons.check_rounded),
                label: Text(context.l10n.applyInvestment),
                onPressed: () => _applyItemDeltas(state, itemDeltas),
              ),
            ],
            const SizedBox(height: 8),
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: primaryColorWeaker),
              icon: const Icon(Icons.close_rounded),
              label: Text(context.l10n.dialogCancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Map<int, double> _computeWalletDeltas(
    FullData state,
    double deposit,
    bool buyOnly,
  ) {
    final targeted =
        state.walletsMap.values.where((w) => w.targetPercent > 0).toList();
    if (targeted.isEmpty) return const {};

    if (!buyOnly) {
      final newTotal = state.totalValue + deposit;
      return {
        for (final w in targeted)
          w.id: newTotal * (w.targetPercent / 100) - w.totalValue,
      };
    }

    if (deposit <= 0) {
      final reqTotal = state.buyOnlyTotalForWallets;
      return {
        for (final w in targeted)
          w.id: (reqTotal * (w.targetPercent / 100) - w.totalValue)
              .clamp(0.0, double.infinity),
      };
    }

    final newTotal = state.totalValue + deposit;
    final gaps = <int, double>{
      for (final w in targeted)
        w.id: (newTotal * (w.targetPercent / 100) - w.totalValue)
            .clamp(0.0, double.infinity),
    };
    final totalGap = gaps.values.fold<double>(0, (a, b) => a + b);
    if (totalGap > 0) {
      return {
        for (final w in targeted) w.id: deposit * (gaps[w.id]! / totalGap),
      };
    }
    final totalTargetWeight =
        targeted.fold<double>(0, (a, w) => a + w.targetPercent);
    return {
      for (final w in targeted)
        w.id: totalTargetWeight > 0
            ? deposit * (w.targetPercent / totalTargetWeight)
            : 0,
    };
  }

  Map<int, double> _computeItemDeltas(
    FullData state,
    double deposit,
    bool buyOnly,
  ) {
    final targeted =
        state.allItems.where((i) => i.targetPercent > 0).toList();
    if (targeted.isEmpty) return const {};

    if (!buyOnly) {
      final newTotal = state.totalValue + deposit;
      return {
        for (final item in targeted)
          item.id: () {
            final base = state.settings.relativeTarget
                ? (state.walletsMap[item.walletId]?.totalValue ?? 0) + deposit
                : newTotal;
            return base * (item.targetPercent / 100) - item.totalValue;
          }(),
      };
    }

    if (deposit <= 0) {
      return {
        for (final item in targeted)
          item.id: () {
            final reqTotal = state.buyOnlyTotalForItems(item.walletId);
            return (reqTotal * (item.targetPercent / 100) - item.totalValue)
                .clamp(0.0, double.infinity);
          }(),
      };
    }

    final newTotal = state.totalValue + deposit;
    final gaps = <int, double>{
      for (final item in targeted)
        item.id: () {
          final base = state.settings.relativeTarget
              ? (state.walletsMap[item.walletId]?.totalValue ?? 0) + deposit
              : newTotal;
          return (base * (item.targetPercent / 100) - item.totalValue)
              .clamp(0.0, double.infinity);
        }(),
    };
    final totalGap = gaps.values.fold<double>(0, (a, b) => a + b);
    if (totalGap > 0) {
      return {
        for (final item in targeted)
          item.id: deposit * (gaps[item.id]! / totalGap),
      };
    }
    final totalTargetWeight =
        targeted.fold<double>(0, (a, i) => a + i.targetPercent);
    return {
      for (final item in targeted)
        item.id: totalTargetWeight > 0
            ? deposit * (item.targetPercent / totalTargetWeight)
            : 0,
    };
  }

  Future<void> _applyItemDeltas(
    FullData state,
    Map<int, double> deltas,
  ) async {
    final db = context.read<DataCubit>().db;
    for (final item in state.allItems) {
      final delta = deltas[item.id] ?? 0;
      if (delta.abs() < 0.01) continue;
      final newTotalValue =
          (item.totalValue + delta).clamp(0.0, double.infinity);
      final newUnitPrice =
          item.quantity > 0 ? newTotalValue / item.quantity : newTotalValue;
      await db.updateItem(
        item: item,
        name: item.name,
        price: newUnitPrice.toStringAsFixed(2),
        quantity: item.quantity.toString(),
        target: item.targetPercent >= 0 ? item.targetPercent.toString() : '',
      );
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}

class const _AllocationTile({
  required final String name,
  required final Color color,
  required final double currentValue,
  required final double delta,
  required final double targetPercent,
  required final String currency,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final greenColor = isDark
        ? TailwindColor.green.palette.s400
        : TailwindColor.green.palette.s700;
    final redColor = isDark
        ? TailwindColor.rose.palette.s400
        : TailwindColor.red.palette.s600;
    final isHold = delta.abs() < 0.005;
    final isBuy = delta > 0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 32,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.firaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$currency ${toCurrency(currentValue)} • ${formatPercent(targetPercent)}%',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            isHold
                ? '✓ ${context.l10n.hold}'
                : '${isBuy ? "↑ +" : "↓ "}$currency ${toCurrency(delta)}',
            style: GoogleFonts.firaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isHold
                  ? Theme.of(context).colorScheme.onSurfaceVariant
                  : (isBuy ? greenColor : redColor),
            ),
          ),
        ],
      ),
    );
  }
}
