import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../l10n/l10n.dart';
import '../util/numbers.dart';
import '../util/tailwind_colors.dart';
import '../widgets/dialog_screen_base.dart';
import '../util/error_handler.dart';
import 'rebalance_plan.dart';

class const RebalancePage({super.key}) extends StatefulWidget {
  @override
  State<RebalancePage> createState() => _RebalancePageState();
}

class _RebalancePageState extends State<RebalancePage> {
  final TextEditingController _amountController = TextEditingController();

  bool _applying = false;

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
        final backgroundDialogColor = getBackgroundDialogColor(
          context,
          colorName,
        );
        final currency = state.settings.currencySymbol;
        final buyOnly = state.settings.buyOnly;
        final rxPrefs = RxSharedPreferences.getInstance();

        final parsedDeposit = double.tryParse(_amountController.text);
        final explicitDeposit =
            parsedDeposit != null &&
            parsedDeposit.isFinite &&
            parsedDeposit >= 0 &&
            (state.totalValue + parsedDeposit).isFinite;
        final deposit = explicitDeposit ? parsedDeposit : 0.0;
        final targetedItems = state.allItems
            .where((i) => i.targetPercent >= 0)
            .toList();
        final targetedWallets = state.walletsMap.values
            .where((w) => w.targetPercent >= 0)
            .toList();
        final itemHoldings = [
          for (final item in targetedItems)
            (id: item.id, value: item.totalValue, target: item.targetPercent),
        ];
        final walletHoldings = [
          for (final wallet in targetedWallets)
            (
              id: wallet.id,
              value: wallet.totalValue,
              target: wallet.targetPercent,
            ),
        ];
        final relative =
            state.settings.relativeTarget && targetedItems.isNotEmpty;
        final groups = {
          for (final wallet in state.walletsMap.values)
            if (targetedItems.any((item) => item.walletId == wallet.id))
              wallet.id: (
                value: wallet.totalValue,
                weight: wallet.targetPercent,
                holdings: [
                  for (final item in targetedItems)
                    if (item.walletId == wallet.id)
                      (
                        id: item.id,
                        value: item.totalValue,
                        target: item.targetPercent,
                      ),
                ],
              ),
        };
        final holdings = targetedItems.isEmpty ? walletHoldings : itemHoldings;
        final autoFillCash = relative
            ? null
            : minimumBuyOnlyCash(holdings, state.totalValue);
        final activeDeltas = relative
            ? allocateRelative(groups, cash: deposit, buyOnly: buyOnly)
            : allocate(
                holdings,
                total: state.totalValue,
                cash: deposit,
                buyOnly: buyOnly,
              );
        final actionableDeltas = {
          for (final entry in activeDeltas.entries)
            if (entry.value.abs() >= 0.005) entry.key: entry.value,
        };
        final unallocated =
            deposit - actionableDeltas.values.fold(0.0, (a, b) => a + b);
        final trades = targetedItems
            .where((item) => actionableDeltas.containsKey(item.id))
            .toList();
        final invalidTrade = trades.any(
          (item) =>
              !(quantityAfterTrade(
                    item.price,
                    item.totalValue,
                    activeDeltas[item.id]!,
                  )?.isFinite ??
                  false),
        );
        final invalidTargets =
            (relative
                    ? groups.values.map((group) => group.holdings)
                    : [holdings])
                .any(
                  (group) =>
                      group.isNotEmpty &&
                      (group.fold(0.0, (sum, holding) => sum + holding.target) -
                                  100)
                              .abs() >
                          0.000001,
                );

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
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
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
                if (buyOnly && autoFillCash != null && autoFillCash > 0.005)
                  ActionChip(
                    visualDensity: VisualDensity.compact,
                    avatar: Icon(
                      Icons.auto_awesome_rounded,
                      size: 14,
                      color: primaryColor,
                    ),
                    label: Text(
                      '${context.l10n.autoFillBuyOnly}: ${money(context, currency, autoFillCash)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    onPressed: () {
                      setState(() {
                        _amountController.text = editableNumber(
                          autoFillCash < 1e15
                              ? (autoFillCash * 100).ceilToDouble() / 100
                              : autoFillCash,
                        );
                      });
                    },
                  ),
                for (final preset in const ['100', '500', '1000'])
                  ActionChip(
                    visualDensity: VisualDensity.compact,
                    label: Text(
                      '+${money(context, currency, double.parse(preset))}',
                    ),
                    onPressed: () {
                      final current =
                          double.tryParse(_amountController.text) ?? 0;
                      final next = current + double.parse(preset);
                      setState(() {
                        _amountController.text = editableNumber(
                          next < 1e15
                              ? double.parse(next.toStringAsFixed(2))
                              : next,
                        );
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
              if (targetedItems.isEmpty) ...[
                for (final wallet in targetedWallets)
                  _AllocationTile(
                    name: wallet.name,
                    color: tailwindPalette(wallet.colorName).s500,
                    currentValue: wallet.totalValue,
                    delta: activeDeltas[wallet.id] ?? 0,
                    targetPercent: wallet.targetPercent,
                    currency: currency,
                  ),
              ],
              if (targetedItems.isNotEmpty)
                for (final item in targetedItems)
                  _AllocationTile(
                    name: item.name,
                    color: item.color,
                    currentValue: item.totalValue,
                    delta: activeDeltas[item.id] ?? 0,
                    units: quantityAfterTrade(
                      item.price,
                      0,
                      (activeDeltas[item.id] ?? 0).abs(),
                    ),
                    targetPercent: item.targetPercent,
                    currency: currency,
                  ),
            ],
            if (invalidTargets) Text(context.l10n.targetTotalWarning),
            if (unallocated >= 0.005 && holdings.isNotEmpty)
              Text(
                '${context.l10n.unallocatedCash}: ${money(context, currency, unallocated)}',
              ),
            if (unallocated <= -0.005)
              Text(
                '${context.l10n.additionalCash}: ${money(context, currency, -unallocated)}',
              ),
            if (invalidTrade) Text(context.l10n.tradeRequiresPrice),
            if (trades.isNotEmpty) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: backgroundDialogColor,
                  backgroundColor: primaryColor,
                ),
                icon: const Icon(Icons.check_rounded),
                label: Text(context.l10n.applyInvestment),
                onPressed:
                    _applying ||
                        !explicitDeposit ||
                        invalidTrade ||
                        unallocated < -0.000001
                    ? null
                    : () => _applyItemDeltas(state, actionableDeltas),
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

  Future<void> _applyItemDeltas(FullData state, Map<int, double> deltas) async {
    if (_applying) return;
    setState(() => _applying = true);
    try {
      final db = context.read<DataCubit>().db;
      if (deltas.values.any((delta) => delta <= -0.005)) {
        final accepted = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.l10n.applyInvestment),
            content: Text(context.l10n.confirmSales),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.l10n.dialogCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(context.l10n.applyInvestment),
              ),
            ],
          ),
        );
        if (!mounted || accepted != true) return;
      }
      await db.applyTrades(state.allItems, deltas);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) showErrorSnackbar(context, context.l10n.operationFailed);
    } finally {
      if (mounted) setState(() => _applying = false);
    }
  }
}

class const _AllocationTile({
  required final String name,
  required final Color color,
  required final double currentValue,
  required final double delta,
  required final double targetPercent,
  required final String currency,
  final double? units,
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
                  style: TextStyle(
                    fontFamily: 'Fira Sans',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${money(context, currency, currentValue)} • ${formatPercent(targetPercent, Localizations.localeOf(context).toString())}%',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Mono',
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            isHold
                ? '✓ ${context.l10n.hold}'
                : '${isBuy ? "↑ +" : "↓ "}${money(context, currency, delta)}'
                      '${units == null ? "" : "\n${formatQuantity(context, units!)}×"}',
            style: TextStyle(
              fontFamily: 'Fira Sans',
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
