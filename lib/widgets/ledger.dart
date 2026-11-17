import 'package:material_ui/material_ui.dart';

import '../app/theme.dart';
import '../l10n/l10n.dart';
import '../util/numbers.dart';

/// A small uppercase mono caption that opens a section.
class const SectionLabel(final String text, {final Widget? trailing, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: context.ledger.muted),
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

/// The raised surface every group of rows sits on. A [Material], so the ink of
/// rows inside it shows on the card and stays within its corners.
class const LedgerCard({
  required final Widget child,
  final EdgeInsetsGeometry padding = EdgeInsets.zero,
  final Color? color,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Material(
    color: color ?? context.ledger.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: context.ledger.hairline),
    ),
    clipBehavior: Clip.antiAlias,
    child: Padding(padding: padding, child: child),
  );
}

typedef Segment = ({Object id, Color color, double value});

/// One stacked allocation bar; anything short of [total] stays empty track.
class const AllocationBar(
  final List<Segment> segments, {
  final double total = 100,
  final double height = 14,
  super.key,
}) extends StatelessWidget {
  static const double _gap = 2;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final visible = [
          for (final s in segments)
            if (s.value > 0) s,
        ];
        final sum = visible.fold<double>(0, (a, s) => a + s.value);
        final basis = sum > total ? sum : total;
        final usable =
            constraints.maxWidth - _gap * (visible.length - 1).clamp(0, 999);
        double left = 0;
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: context.ledger.sunken,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Stack(
            children: [
              for (final s in visible)
                () {
                  final width = basis <= 0 ? 0.0 : usable * s.value / basis;
                  final child = AnimatedPositioned(
                    key: ValueKey(s.id),
                    duration: const Duration(milliseconds: 520),
                    curve: Curves.easeOutCubic,
                    left: left,
                    width: width,
                    top: 0,
                    bottom: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 520),
                      color: s.color,
                    ),
                  );
                  left += width + _gap;
                  return child;
                }(),
            ],
          ),
        );
      },
    ),
  );
}

/// Labeled bars stacked on top of each other: now, target, after...
class const AllocationBars(
  final List<(String, List<Segment>)> rows, {
  final double height = 14,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final label = Theme.of(context).textTheme.labelSmall
        ?.copyWith(color: context.ledger.muted);
    return Column(
      spacing: 10,
      children: [
        for (final (name, segments) in rows)
          Row(
            children: [
              SizedBox(
                width: 64,
                child: Text(
                  name.toUpperCase(),
                  style: label,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
              Expanded(child: AllocationBar(segments, height: height)),
            ],
          ),
      ],
    );
  }
}

/// A segmented meter in the Material 3 track-gap style that always breaks at
/// [target]: below it, a pale stretch shows what is missing; above it, the
/// excess is split off and striped.
class const TargetMeter({
  required final double current,
  required final Color color,
  final double? target,
  super.key,
}) extends StatelessWidget {
  static const _duration = Duration(milliseconds: 520);

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(end: current.clamp(0.0, 1.0)),
    duration: _duration,
    curve: Curves.easeOutCubic,
    builder: (context, current, _) => TweenAnimationBuilder<double>(
      tween: Tween(end: (target ?? -1).clamp(-1.0, 1.0)),
      duration: _duration,
      curve: Curves.easeOutCubic,
      builder: (context, target, _) => SizedBox(
        height: 8,
        width: double.infinity,
        child: CustomPaint(
          painter: _MeterPainter(
            current: current,
            target: target < 0 ? null : target,
            color: color,
            track: context.ledger.sunken,
          ),
        ),
      ),
    ),
  );
}

enum _Fill { held, missing, excess, track }

class const _MeterPainter({
  required final double current,
  required final double? target,
  required final Color color,
  required final Color track,
}) extends CustomPainter {
  static const _gap = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final t = target;
    final segments = <(double, double, _Fill)>[
      if (t == null || (current - t).abs() * w < _gap) ...[
        (0, current, _Fill.held),
        (current, 1, _Fill.track),
      ] else if (current < t) ...[
        (0, current, _Fill.held),
        (current, t, _Fill.missing),
        (t, 1, _Fill.track),
      ] else ...[
        (0, t, _Fill.held),
        (t, current, _Fill.excess),
        (current, 1, _Fill.track),
      ],
    ];
    final radius = Radius.circular(size.height / 2);
    for (final (i, (from, to, fill)) in segments.indexed) {
      final left = from * w + (i == 0 ? 0 : _gap / 2);
      final right = to * w - (i == segments.length - 1 ? 0 : _gap / 2);
      if (right - left < size.height / 2) continue;
      final rrect = RRect.fromLTRBR(left, 0, right, size.height, radius);
      switch (fill) {
        case _Fill.held:
          canvas.drawRRect(rrect, Paint()..color = color);
        case _Fill.missing:
          canvas.drawRRect(
            rrect,
            Paint()..color = color.withValues(alpha: 0.3),
          );
        case _Fill.excess:
          _hatch(canvas, rrect);
        case _Fill.track:
          canvas.drawRRect(rrect, Paint()..color = track);
      }
    }
  }

  /// Diagonal stripes: held, but beyond the target.
  void _hatch(Canvas canvas, RRect rrect) {
    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawRRect(rrect, Paint()..color = color.withValues(alpha: 0.25));
    final stripe = Paint()
      ..color = color
      ..strokeWidth = 2.2;
    final h = rrect.height;
    for (var x = rrect.left - h; x < rrect.right + h; x += 5) {
      canvas.drawLine(Offset(x, h), Offset(x + h, 0), stripe);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_MeterPainter old) =>
      old.current != current ||
      old.target != target ||
      old.color != color ||
      old.track != track;
}

/// "Buy $316.00" (green), "Sell $685.00" (red) or "Hold" to land on target.
class const DeltaText({
  required final double delta,
  required final String currency,
  final double size = 13,
  final String? suffix,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.ledger;
    final hold = delta.abs() < 0.005;
    final text = hold
        ? context.l10n.hold
        : '${delta > 0 ? context.l10n.buy : context.l10n.sell} '
              '${money(context, currency, delta.abs())}';
    return Text(
      suffix == null ? text : '$text $suffix',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: figures(
        size,
        weight: FontWeight.w600,
        color: hold ? l.muted : (delta > 0 ? l.buy : l.sell),
      ),
    );
  }
}

/// The "→" between where something is and where it should be. Mono spaces are
/// a full glyph wide, so the breathing room is fixed instead.
InlineSpan towards(Ledger l) => TextSpan(
  children: [
    const WidgetSpan(child: SizedBox(width: 3)),
    TextSpan(
      text: '→',
      style: TextStyle(color: l.faint),
    ),
    const WidgetSpan(child: SizedBox(width: 3)),
  ],
);

/// "40.2% → 40%", or just the share when there is no target.
class const ShareText({
  required final double share,
  final double? targetPercent,
  final double size = 12.5,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final l = context.ledger;
    final now = '${share.toPercent(locale)}%';
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: now),
          if (targetPercent != null && targetPercent! >= 0) ...[
            towards(l),
            TextSpan(
              text: '${formatPercent(targetPercent!, locale)}%',
              style: TextStyle(color: l.ink, fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: figures(size, color: l.muted),
    );
  }
}

/// A large amount whose cents step back so the whole number reads first.
class const HeroAmount(final String text, {final double size = 40, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final match = RegExp(r'^(.*\d)([.,]\d{2})(\D*)$').firstMatch(text);
    final style = display(
      size,
      weight: FontWeight.w800,
      letterSpacing: -size * 0.03,
      color: context.ledger.ink,
    );
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: match == null
          ? Text(text, style: style)
          : Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: match.group(1)),
                  TextSpan(
                    text: match.group(2),
                    style: TextStyle(color: context.ledger.faint),
                  ),
                  TextSpan(text: match.group(3)),
                ],
              ),
              style: style,
            ),
    );
  }
}

/// The Cash Balancer motif: two allocation columns and the flow between them.
class const BalanceIllustration({final double height = 168, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SizedBox(
    width: height * 0.82,
    height: height,
    child: CustomPaint(
      painter: _BalancePainter(
        track: context.ledger.sunken,
        cream: context.ledger.faint,
      ),
    ),
  );
}

class const _BalancePainter({
  required final Color track,
  required final Color cream,
}) extends CustomPainter {
  static const _now = [0.48, 0.32, 0.12, 0.08];
  static const _target = [0.55, 0.20, 0.15, 0.10];
  static const _colors = [
    Color(0xFF2DD4BF),
    Color(0xFFF59E0B),
    Color(0xFF818CF8),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final barW = size.width * 0.22;
    const gap = 3.0;
    final h = size.height;
    final usable = h - gap * 3;
    final colors = [..._colors, cream];

    List<(double, double)> spans(List<double> parts) {
      double y = 0;
      return [
        for (final p in parts)
          () {
            final span = (y, y + usable * p);
            y += usable * p + gap;
            return span;
          }(),
      ];
    }

    final left = spans(_now);
    final right = spans(_target);
    final x0 = barW;
    final x1 = size.width - barW;
    for (var i = 0; i < 4; i++) {
      final (a0, a1) = left[i];
      final (b0, b1) = right[i];
      final mid = (x0 + x1) / 2;
      final path = Path()
        ..moveTo(x0, a0)
        ..cubicTo(mid, a0, mid, b0, x1, b0)
        ..lineTo(x1, b1)
        ..cubicTo(mid, b1, mid, a1, x0, a1)
        ..close();
      canvas.drawPath(path, Paint()..color = colors[i].withValues(alpha: 0.22));
    }

    void bar(double x, List<(double, double)> spans) {
      canvas.save();
      canvas.clipRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, 0, barW, h),
          Radius.circular(barW / 2),
        ),
      );
      for (var i = 0; i < 4; i++) {
        final (y0, y1) = spans[i];
        canvas.drawRect(
          Rect.fromLTRB(x, y0, x + barW, y1),
          Paint()..color = colors[i],
        );
      }
      canvas.restore();
    }

    bar(0, left);
    bar(x1, right);
  }

  @override
  bool shouldRepaint(_BalancePainter old) =>
      old.track != track || old.cream != cream;
}
