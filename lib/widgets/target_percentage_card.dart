import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../page_home/details_page.dart';
import 'dialog_screen_base.dart';

class const TargetPercentageCard({
  super.key,
  required final TextEditingController controller,
  required final Color primaryColor,
  required final Color primaryColorWeaker,
  required final ValueChanged<String> onFieldSubmitted,
  required final VoidCallback onChanged,
  final double allocatedOtherPercent = 0,
  final Widget? footer,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double remaining = (100.0 - allocatedOtherPercent).clamp(0.0, 100.0);
    final String remainingStr = formatPercent(remaining);
    final double currentTarget = double.tryParse(controller.text) ?? 0;
    final double totalTarget = allocatedOtherPercent + currentTarget;

    return Container(
      decoration: BoxDecoration(
        color: primaryColorWeaker.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.optional,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: primaryColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.howMuchTarget,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: controller,
                      onFieldSubmitted: onFieldSubmitted,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        final num = double.tryParse(value);
                        if (num == null) {
                          return context.l10n.invalidValue;
                        }
                        if (num < 0 || num > 100) {
                          return context.l10n.targetMustBeBetween;
                        }
                        return null;
                      },
                      textAlign: TextAlign.right,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => onChanged(),
                      inputFormatters: const <TextInputFormatter>[
                        DecimalTextInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        labelText: context.l10n.dialogAssetTarget,
                        hintText: '0',
                        filled: true,
                        fillColor: getInputFillColor(context),
                        suffixText: " %",
                        labelStyle: TextStyle(color: primaryColorWeaker),
                        border: getInputDecorationBorder(primaryColorWeaker),
                        focusedBorder:
                            getInputDecorationBorder(primaryColorWeaker),
                        enabledBorder:
                            getInputDecorationBorder(primaryColorWeaker),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              if (allocatedOtherPercent > 0 &&
                  remaining > 0 &&
                  remaining < 100 &&
                  !const ['10', '25', '50', '100'].contains(remainingStr))
                ActionChip(
                  visualDensity: VisualDensity.compact,
                  avatar: Icon(
                    Icons.pie_chart_outline_rounded,
                    size: 14,
                    color: primaryColor,
                  ),
                  label: Text('$remainingStr%'),
                  backgroundColor: controller.text.trim() == remainingStr
                      ? primaryColor.withValues(alpha: 0.25)
                      : null,
                  onPressed: () {
                    controller.text = remainingStr;
                    onChanged();
                  },
                ),
              for (final preset in const ['10', '25', '50', '100'])
                ActionChip(
                  visualDensity: VisualDensity.compact,
                  label: Text('$preset%'),
                  backgroundColor: controller.text.trim() == preset
                      ? primaryColor.withValues(alpha: 0.25)
                      : null,
                  onPressed: () {
                    controller.text = preset;
                    onChanged();
                  },
                ),
            ],
          ),
          if (allocatedOtherPercent > 0 || currentTarget > 0)
            Text(
              '${formatPercent(totalTarget)}% / 100%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: totalTarget > 100.01
                        ? Theme.of(context).colorScheme.error
                        : primaryColorWeaker,
                  ),
            ),
          ?footer,
        ],
      ),
    );
  }
}
