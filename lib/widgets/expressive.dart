import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../app/theme.dart';
import 'dialog_screen_base.dart';

/// A big number in the theme's tonal well. [label] is announced, not drawn:
/// the surrounding card names it.
class const TonalNumberField({
  super.key,
  required final TextEditingController controller,
  required final String label,
  required final VoidCallback onChanged,
  final ValueChanged<String>? onFieldSubmitted,
  final FormFieldValidator<String>? validator,
  final String hint = '0',
  final String? prefix,
  final String? suffix,
  final double size = 24,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.ledger;
    Widget? affix(String? text, EdgeInsets padding) => text == null
        ? null
        : Padding(
            padding: padding,
            child: Text(text, style: figures(size * 0.72, color: l.muted)),
          );
    const affixConstraints = BoxConstraints();
    return Semantics(
      label: label,
      child: TextFormField(
        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        textAlign: TextAlign.right,
        style: figures(size, weight: FontWeight.w600),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (_) => onChanged(),
        inputFormatters: const <TextInputFormatter>[
          DecimalTextInputFormatter(),
        ],
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: figures(size, color: l.faint),
          prefixIcon: affix(prefix, const EdgeInsets.only(left: 16, right: 8)),
          prefixIconConstraints: affixConstraints,
          suffixIcon: affix(suffix, const EdgeInsets.only(left: 4, right: 14)),
          suffixIconConstraints: affixConstraints,
          contentPadding: EdgeInsets.fromLTRB(
            12,
            size * 0.55,
            suffix == null ? 16 : 0,
            size * 0.55,
          ),
          errorMaxLines: 3,
        ),
      ),
    );
  }
}

/// How long Expressive shapes take to morph between resting and selected.
const shapeMorph = Duration(milliseconds: 320);

/// A one-tap value next to a [TonalNumberField]. Material 3 Expressive: a
/// tonal rounded square at rest that morphs into a primary pill when it
/// matches the field.
class const PresetChip({
  super.key,
  required final String label,
  required final VoidCallback onPressed,
  final bool selected = false,
  final IconData? icon,
}) extends StatelessWidget {
  static const double height = 38;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = context.ledger;
    return Semantics(
      selected: selected,
      button: true,
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: selected ? 1 : 0),
        duration: shapeMorph,
        curve: Curves.easeOutBack,
        builder: (context, t, _) {
          final colorT = t.clamp(0.0, 1.0);
          final foreground = Color.lerp(l.ink, scheme.onPrimary, colorT)!;
          return Material(
            color: Color.lerp(l.sunken, scheme.primary, colorT),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                (10 + (height / 2 - 10) * t).clamp(4.0, height / 2),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              child: SizedBox(
                height: height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                      if (icon != null) Icon(icon, size: 14, color: foreground),
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: figures(
                            13,
                            weight: FontWeight.w600,
                            color: foreground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Material 3 Expressive connected button group: segments a hair apart with
/// tight inner corners; the selected one morphs into a pill.
class const ConnectedButtonGroup<T>({
  super.key,
  required final List<(T value, String label, IconData? icon)> segments,
  required final T selected,
  required final ValueChanged<T> onSelected,
  final double height = 44,
  final bool expand = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = context.ledger;
    final outer = height / 2;
    const inner = 6.0;
    Widget segment(int i) {
      final (value, label, icon) = segments[i];
      final isSelected = value == selected;
      final first = i == 0;
      final last = i == segments.length - 1;
      final child = TweenAnimationBuilder<double>(
        tween: Tween(end: isSelected ? 1 : 0),
        duration: shapeMorph,
        curve: Curves.easeOutBack,
        builder: (context, t, _) {
          final colorT = t.clamp(0.0, 1.0);
          final foreground = Color.lerp(l.ink, scheme.onPrimary, colorT)!;
          Radius corner(bool edge) => Radius.circular(
            (edge ? outer : inner + (outer - inner) * t).clamp(2.0, outer),
          );
          return Semantics(
            selected: isSelected,
            button: true,
            child: Material(
              color: Color.lerp(l.sunken, scheme.primary, colorT),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  left: corner(first),
                  right: corner(last),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => onSelected(value),
                child: SizedBox(
                  height: height,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 6,
                      children: [
                        if (icon != null)
                          Icon(icon, size: 18, color: foreground),
                        Flexible(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(color: foreground),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
      return expand ? Expanded(child: child) : child;
    }

    return Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      spacing: 2,
      children: [for (var i = 0; i < segments.length; i++) segment(i)],
    );
  }
}
