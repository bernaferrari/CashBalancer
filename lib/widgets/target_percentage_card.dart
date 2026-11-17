import '../util/numbers.dart';

import 'package:material_ui/material_ui.dart';

import '../app/theme.dart';
import '../l10n/l10n.dart';
import '../page_rebalance/rebalance_plan.dart';
import 'ledger.dart';
import 'expressive.dart';

/// The target editor shared by wallets and assets: a big percentage field,
/// quick picks (including none), and a bar showing how much of 100% is
/// already spoken for.
class const TargetPercentageCard({
  super.key,
  required final TextEditingController controller,
  required final Color color,
  required final ValueChanged<String> onFieldSubmitted,
  required final VoidCallback onChanged,
  final double allocatedOtherPercent = 0,
  final double? currentPercent,
}) extends StatelessWidget {
  static const _presets = [10.0, 25.0, 50.0];

  @override
  Widget build(BuildContext context) {
    final l = context.ledger;
    final locale = Localizations.localeOf(context).toString();
    final double remaining = (100.0 - allocatedOtherPercent).clamp(0.0, 100.0);
    final enteredTarget = double.tryParse(controller.text);
    final currentTarget = enteredTarget?.isFinite == true
        ? enteredTarget
        : null;
    final double totalTarget = allocatedOtherPercent + (currentTarget ?? 0);
    final isComplete = targetTotalIsComplete(totalTarget);
    final over = totalTarget > 100 && !isComplete;
    final rest = allocatedOtherPercent > 0 && remaining > targetTotalTolerance
        ? double.parse(remaining.toStringAsFixed(targetPercentagePrecision))
        : null;

    String precisePercent(double value) =>
        formatPercent(value, locale, fractionDigits: targetPercentagePrecision);

    Widget chip(String label, double? value, {IconData? icon}) =>
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 44),
          child: PresetChip(
            label: label,
            icon: icon,
            selected: value == null
                ? controller.text.isEmpty
                : currentTarget == value,
            onPressed: () {
              controller.text = editableNumber(value);
              onChanged();
            },
          ),
        );

    return LedgerCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        context.l10n.dialogAssetTarget,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        context.l10n.howMuchTarget,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: l.muted),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 116,
                child: TonalNumberField(
                  controller: controller,
                  label: context.l10n.dialogAssetTarget,
                  onChanged: onChanged,
                  onFieldSubmitted: onFieldSubmitted,
                  hint: '–',
                  suffix: '%',
                  decimalRange: targetPercentagePrecision,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    final num = double.tryParse(value);
                    if (num == null || !num.isFinite) {
                      return context.l10n.invalidValue;
                    }
                    if (num < 0 || num > 100) {
                      return context.l10n.targetMustBeBetween;
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 6,
            runSpacing: 6,
            children: [
              chip(context.l10n.noTarget, null),
              for (final preset in _presets)
                if (preset != rest) chip(precisePercent(preset), preset),
              if (rest != null)
                chip(
                  precisePercent(rest),
                  rest,
                  icon: Icons.pie_chart_outline_rounded,
                )
              else
                chip(precisePercent(100), 100),
            ],
          ),
          const SizedBox(height: 16),
          AllocationBar([
            (
              id: 'others',
              color: l.faint.withValues(alpha: 0.55),
              value: allocatedOtherPercent,
            ),
            (
              id: 'this',
              color: over ? l.sell : color,
              value: currentTarget ?? 0,
            ),
          ], height: 8),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.targetAssigned(
                    precisePercent(isComplete ? 100 : totalTarget),
                  ),
                  style: figures(
                    12,
                    weight: FontWeight.w500,
                    color: over ? l.sell : l.muted,
                  ),
                ),
              ),
              if (currentPercent != null)
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '${context.l10n.now.toUpperCase()}  '),
                      TextSpan(
                        text: formatPercent(currentPercent!, locale),
                        style: TextStyle(color: l.ink),
                      ),
                    ],
                  ),
                  style: figures(12, weight: FontWeight.w500, color: l.muted),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
