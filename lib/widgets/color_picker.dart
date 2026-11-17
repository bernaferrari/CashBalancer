import 'package:material_ui/material_ui.dart';

import '../util/wallet_colors.dart';

/// The wallet colors in two rows: a dozen hues far enough apart to tell
/// wallets apart at a glance in bars and legends.
class const ColorPicker(
  final String initialSelection,
  final ValueChanged<String> onChanged, {
  super.key,
}) extends StatelessWidget {
  static const _perRow = 6;

  @override
  Widget build(BuildContext context) {
    final selected = WalletColor.fromName(initialSelection);
    final colors = [
      ...WalletColor.offered,
      if (!WalletColor.offered.contains(selected)) selected,
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = (constraints.maxWidth / _perRow).floorToDouble().clamp(
          40.0,
          60.0,
        );
        return Center(
          child: SizedBox(
            width: size * _perRow,
            child: Wrap(
              children: [
                for (final color in colors)
                  AnimatedColorItem(
                    color: color,
                    size: size,
                    isSelected: color == selected,
                    onSelected: () => onChanged(color.name),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A rounded-square swatch that morphs into a circle when selected, the same
/// Expressive shape change as the preset chips.
class const AnimatedColorItem({
  required final WalletColor color,
  required final bool isSelected,
  final VoidCallback? onSelected,
  final double size = 48,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final swatch = (size - 10).clamp(32.0, 46.0);
    final onSwatch = color.scheme(Theme.of(context).brightness);
    return Semantics(
      label: color.name,
      selected: isSelected,
      button: true,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onSelected,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutBack,
              width: isSelected ? swatch : swatch - 6,
              height: isSelected ? swatch : swatch - 6,
              decoration: BoxDecoration(
                color: color.seed,
                borderRadius: BorderRadius.circular(
                  isSelected ? swatch / 2 : swatch * 0.28,
                ),
              ),
              child: AnimatedScale(
                scale: isSelected ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                child: Icon(
                  Icons.check_rounded,
                  size: swatch * 0.5,
                  color: onSwatch.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
