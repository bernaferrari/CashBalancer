import 'dart:math' as math;

typedef Holding = ({int id, double value, double target});

/// Targets are percentages of the group total. A negative target is unset.
/// Cash with no remaining target gap is left unallocated.
Map<int, double> allocate(
  Iterable<Holding> holdings, {
  required double total,
  required double cash,
  required bool buyOnly,
}) {
  final deltas = {
    for (final h in holdings)
      if (h.target >= 0) h.id: (total + cash) * (h.target / 100) - h.value,
  };
  if (!buyOnly) return deltas;
  final gap = deltas.values.fold(0.0, (a, b) => a + math.max(0, b));
  final scale = gap > cash ? cash / gap : 1.0;
  return deltas.map((id, delta) => MapEntry(id, math.max(0, delta) * scale));
}

/// Splits a single deposit among wallets before computing local targets.
Map<int, double> allocateRelative(
  Map<int, ({double value, double weight, List<Holding> holdings})> wallets, {
  required double cash,
  required bool buyOnly,
}) {
  final walletTargets = [
    for (final entry in wallets.entries)
      (id: entry.key, value: entry.value.value, target: entry.value.weight),
  ];
  final walletTotal = walletTargets.fold(
    0.0,
    (sum, wallet) => sum + wallet.value,
  );
  final walletDeltas = allocate(
    walletTargets,
    total: walletTotal,
    cash: cash,
    buyOnly: buyOnly,
  );
  final eligible = wallets.values.where((wallet) => wallet.holdings.isNotEmpty);
  final eligibleTotal = eligible.fold(0.0, (sum, wallet) => sum + wallet.value);
  double walletCash(int id) {
    final wallet = wallets[id]!;
    if (walletDeltas.isNotEmpty) return walletDeltas[id] ?? 0;
    if (wallet.holdings.isEmpty) return 0;
    return eligibleTotal > 0
        ? cash * (wallet.value / eligibleTotal)
        : cash / eligible.length;
  }

  return {
    for (final entry in wallets.entries)
      ...allocate(
        entry.value.holdings,
        total: entry.value.value,
        cash: walletCash(entry.key),
        buyOnly: buyOnly,
      ),
  };
}

double? minimumBuyOnlyCash(Iterable<Holding> holdings, double total) {
  final targeted = holdings.where((h) => h.target >= 0);
  if (targeted.isEmpty) return null;
  var required = total;
  var targetSum = 0.0;
  for (final h in targeted) {
    targetSum += h.target;
    if (h.target == 0 && h.value > 0) return null;
    if (h.target > 0) required = math.max(required, h.value / (h.target / 100));
  }
  if (targetSum > 100.000001 || !required.isFinite) return null;
  final cash = required - total;
  final plan = allocate(targeted, total: total, cash: cash, buyOnly: false);
  final cost = plan.values.fold(0.0, (a, b) => a + math.max(0, b));
  return cost <= cash + 0.000001 ? cash : null;
}

double? quantityAfterTrade(double price, double value, double delta) =>
    price > 0 ? math.max(0, value + delta) / price : null;

bool targetsIncomplete(Iterable<double> values) {
  final targets = values.where((target) => target >= 0);
  return targets.isNotEmpty &&
      (targets.fold(0.0, (total, target) => total + target) - 100).abs() >
          0.000001;
}
