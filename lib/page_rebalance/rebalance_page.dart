import 'package:material_ui/material_ui.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../app/theme.dart';
import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../l10n/l10n.dart';
import '../util/numbers.dart';
import '../util/wallet_colors.dart';
import '../widgets/dialog_screen_base.dart';
import '../widgets/ledger.dart';
import '../widgets/expressive.dart';
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

        final l = context.ledger;
        final currency = state.settings.currencySymbol;
        final buyOnly = state.settings.buyOnly;
        final rxPrefs = RxSharedPreferences.getInstance();

        final parsedDeposit = double.tryParse(_amountController.text);
        final explicitDeposit =
            _amountController.text.isEmpty ||
            (parsedDeposit != null &&
                parsedDeposit.isFinite &&
                parsedDeposit >= 0 &&
                (state.totalValue + parsedDeposit).isFinite);
        final deposit = parsedDeposit != null && explicitDeposit
            ? parsedDeposit
            : 0.0;
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
              !item.isBalance &&
              !(quantityAfterTrade(
                    item.price,
                    item.totalValue,
                    activeDeltas[item.id]!,
                  )?.isFinite ??
                  false),
        );
        final walletTargetsIncomplete =
            (relative || targetedItems.isEmpty) &&
            targetsIncomplete(walletHoldings.map((wallet) => wallet.target));
        final assetTargetsIncomplete =
            !relative &&
            targetedItems.isNotEmpty &&
            targetsIncomplete(itemHoldings.map((item) => item.target));
        final walletsWithIncompleteAssetTargets = [
          if (relative)
            for (final entry in groups.entries)
              if (targetsIncomplete(
                entry.value.holdings.map((item) => item.target),
              ))
                state.walletsMap[entry.key]!.name,
        ];

        List<Segment> percentages(List<Segment> raw) {
          final sum = raw.fold<double>(
            0,
            (a, s) => a + s.value.clamp(0, 1e300),
          );
          return [
            for (final s in raw)
              (
                id: s.id,
                color: s.color,
                value: sum <= 0 ? 0 : s.value.clamp(0, 1e300) / sum * 100,
              ),
          ];
        }

        final byItem = targetedItems.isNotEmpty;
        final nowSegments = percentages([
          if (byItem)
            for (final item in state.allItems)
              (
                id: item.id,
                color: item.colorIn(context),
                value: item.totalValue,
              )
          else
            for (final wallet in state.walletsMap.values)
              (
                id: wallet.id,
                color: walletSeed(wallet.colorName),
                value: wallet.totalValue,
              ),
        ]);
        final afterSegments = percentages([
          if (byItem)
            for (final item in state.allItems)
              (
                id: item.id,
                color: item.colorIn(context),
                value: item.totalValue + (actionableDeltas[item.id] ?? 0),
              )
          else
            for (final wallet in state.walletsMap.values)
              (
                id: wallet.id,
                color: walletSeed(wallet.colorName),
                value: wallet.totalValue + (actionableDeltas[wallet.id] ?? 0),
              ),
        ]);

        final notices = [
          if (walletTargetsIncomplete)
            '${context.l10n.walletsLabel}: ${context.l10n.targetTotalWarning}',
          if (assetTargetsIncomplete)
            '${context.l10n.allItems}: ${context.l10n.targetTotalWarning}',
          for (final name in walletsWithIncompleteAssetTargets)
            '$name • ${context.l10n.allItems}: ${context.l10n.targetTotalWarning}',
          if (unallocated >= 0.005 && holdings.isNotEmpty)
            '${context.l10n.unallocatedCash}: ${money(context, currency, unallocated)}',
          if (unallocated <= -0.005)
            '${context.l10n.additionalCash}: ${money(context, currency, -unallocated)}',
          if (invalidTrade) context.l10n.tradeRequiresPrice,
        ];

        final rows = [
          if (!byItem)
            for (final wallet in targetedWallets)
              _AllocationTile(
                name: wallet.name,
                color: walletSeed(wallet.colorName),
                share: state.totalValue > 0
                    ? wallet.totalValue / state.totalValue
                    : 0,
                delta: activeDeltas[wallet.id] ?? 0,
                targetPercent: wallet.targetPercent,
                currency: currency,
                onTap: () =>
                    Beamer.of(context)
                        .beamToNamed('/rebalance/editWallet/${wallet.id}'),
              )
          else
            for (final item in targetedItems)
              _AllocationTile(
                name: item.name,
                color: item.colorIn(context),
                share: () {
                  final base = relative
                      ? state.walletsMap[item.walletId]?.totalValue ?? 0
                      : state.totalValue;
                  return base > 0 ? item.totalValue / base : 0.0;
                }(),
                delta: activeDeltas[item.id] ?? 0,
                quantity: item.quantity,
                units: item.isBalance
                    ? null
                    : quantityAfterTrade(
                        item.price,
                        0,
                        (activeDeltas[item.id] ?? 0).abs(),
                      ),
                targetPercent: item.targetPercent,
                currency: currency,
                onTap: () =>
                    Beamer.of(context)
                        .beamToNamed('/rebalance/editItem/${item.id}'),
              ),
        ];

        return DialogScreenBase(
          appBarTitle: context.l10n.rebalanceCalculator,
          bottom: [
            if (trades.isNotEmpty)
              ElevatedButton.icon(
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
          children: [
            LedgerCard(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.l10n.amountToInvest,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (targetedItems.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.enterAmountToApply,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: l.muted),
                    ),
                  ],
                  const SizedBox(height: 14),
                  TonalNumberField(
                    controller: _amountController,
                    label: context.l10n.amountToInvest,
                    onChanged: () => setState(() {}),
                    prefix: currency,
                    size: 28,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    spacing: 6,
                    children: [
                      for (final preset in const [100.0, 500.0, 1000.0])
                        Expanded(
                          child: PresetChip(
                            label:
                                '+${money(context, currency, preset, decimalDigits: 0)}',
                            onPressed: () {
                              final current =
                                  double.tryParse(_amountController.text) ?? 0;
                              final next = current + preset;
                              setState(() {
                                _amountController.text = editableNumber(
                                  next < 1e15
                                      ? double.parse(next.toStringAsFixed(2))
                                      : next,
                                );
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            LedgerCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SwitchListTile(
                    contentPadding: const EdgeInsets.fromLTRB(18, 6, 14, 8),
                    title: Text(
                      context.l10n.buyOnlyRebalance,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        context.l10n.buyOnlyRebalanceSubtitle,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: l.muted),
                      ),
                    ),
                    value: buyOnly,
                    onChanged: (val) async {
                      await rxPrefs.setBool('buyOnly', val);
                    },
                  ),
                  _Reveal(
                    child:
                        buyOnly && autoFillCash != null && autoFillCash > 0.005
                        ? _MinimumCashSuggestion(
                            amount: autoFillCash,
                            currency: currency,
                            applied:
                                parsedDeposit != null &&
                                (parsedDeposit - autoFillCash).abs() < 0.01,
                            onUse: () => setState(() {
                              _amountController.text = editableNumber(
                                autoFillCash < 1e15
                                    ? (autoFillCash * 100).ceilToDouble() / 100
                                    : autoFillCash,
                              );
                            }),
                          )
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (targetedItems.isEmpty && targetedWallets.isEmpty)
              LedgerCard(
                padding: const EdgeInsets.all(20),
                child: Text(
                  context.l10n.noTargetsSet,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: l.muted),
                ),
              )
            else ...[
              SegmentedColumn(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                    child: AllocationBars([
                      (context.l10n.now, nowSegments),
                      (context.l10n.after, afterSegments),
                    ], height: 12),
                  ),
                  ...rows,
                ],
              ),
            ],
            for (final notice in notices)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: l.muted,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        notice,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: l.muted),
                      ),
                    ),
                  ],
                ),
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
  required final double share,
  required final double delta,
  required final double targetPercent,
  required final String currency,
  required final VoidCallback onTap,
  final double quantity = 0,
  final double? units,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.ledger;

    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(),
        alignment: Alignment.centerLeft,
      ),
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 13, 16, 13),
        child: Row(
          children: [
            AssetMark(color: color, sell: delta <= -0.005),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(color: l.ink),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  ShareText(share: share, targetPercent: targetPercent),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DeltaText(delta: delta, currency: currency, size: 14),
                if (units != null && delta.abs() >= 0.005) ...[
                  const SizedBox(height: 3),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '${_quantity(context, quantity)}×'),
                        towards(l),
                        TextSpan(
                          text:
                              '${_quantity(context, quantity + (delta > 0 ? units! : -units!))}×',
                          style: TextStyle(color: l.ink),
                        ),
                      ],
                    ),
                    style: figures(12, color: l.muted),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _quantity(BuildContext context, double value) =>
    formatQuantity(context, value, digits: value.abs() >= 1 ? 3 : 4);

/// Grows and fades [child] in, and folds it away when it becomes null, so the
/// content below slides instead of jumping.
class const _Reveal({final Widget? child}) extends StatelessWidget {
  static const _duration = Duration(milliseconds: 260);

  @override
  Widget build(BuildContext context) => AnimatedSize(
    duration: _duration,
    curve: Curves.easeOutCubic,
    alignment: Alignment.topCenter,
    child: AnimatedSwitcher(
      duration: _duration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.topCenter,
        children: [...previous, ?current],
      ),
      child: child ?? const SizedBox(width: double.infinity),
    ),
  );
}

/// The least new cash that reaches every target without a single sale.
class const _MinimumCashSuggestion({
  required final double amount,
  required final String currency,
  required final bool applied,
  required final VoidCallback onUse,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.ledger;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 180);
    return Container(
      key: const ValueKey('minimum-cash'),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
      decoration: BoxDecoration(
        color: l.sunken,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: l.surface, shape: BoxShape.circle),
            child: Icon(Icons.auto_awesome_rounded, size: 17, color: l.ink),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  context.l10n.autoFillBuyOnly,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: l.muted),
                ),
                Text(
                  money(context, currency, amount),
                  style: figures(15, weight: FontWeight.w600, color: l.ink),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                opacity: applied ? 0 : 1,
                duration: duration,
                child: ExcludeSemantics(
                  excluding: applied,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 38),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                    ),
                    onPressed: applied ? null : onUse,
                    child: Text(context.l10n.useAmount),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: applied ? 1 : 0,
                duration: duration,
                alwaysIncludeSemantics: true,
                child: IgnorePointer(
                  child: ExcludeSemantics(
                    excluding: !applied,
                    child: Semantics(
                      label: context.l10n.amountEntered,
                      liveRegion: true,
                      child: Icon(Icons.check_rounded, color: l.buy, size: 22),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
