// Generates the README header for Cash Balancer:
//   - assets/header.png (the rebalanced ledger)
//   - build/readme_frames/header/*.png -> assets/header.webp (the rebalance)
//   - assets/og.png and web/og.png (the 2:1 social preview)
//
// Run via `./tool/generate_assets.sh` (uses the app's bundled fonts).
//
// Visual language: an allocation ledger. The app's own stacked allocation bar
// appears twice, now and target, with each wallet flowing between them and a
// ledger that says exactly what to buy and sell.

import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const ui.Color _bg = ui.Color(0xFF131211);
const ui.Color _hairline = ui.Color(0xFF2A2826);
const ui.Color _cream = ui.Color(0xFFF4EFE6);
const ui.Color _muted = ui.Color(0xFF8E887F);
const ui.Color _buy = ui.Color(0xFF86EFAC);
const ui.Color _sell = ui.Color(0xFFFCA5A5);

const ui.Size _headerSize = ui.Size(760, 320);
const ui.Size _socialSize = ui.Size(640, 320);
const double _dpr = 2.0;

typedef _Wallet = ({String name, ui.Color color, double now, double target});

/// A $10,000 portfolio; percentages sum to 100 on both sides.
const List<_Wallet> _wallets = [
  (name: 'Stocks', color: ui.Color(0xFF2DD4BF), now: 48, target: 55),
  (name: 'Crypto', color: ui.Color(0xFFF59E0B), now: 32, target: 20),
  (name: 'Bonds', color: ui.Color(0xFF818CF8), now: 12, target: 15),
  (name: 'Cash', color: ui.Color(0xFFE7E1D6), now: 8, target: 10),
];
const double _portfolio = 10000;

typedef _Span = (String, ui.TextStyle);

ui.TextStyle _style(
  String family,
  double size,
  double weight,
  ui.Color color, {
  double letterSpacing = 0,
}) => ui.TextStyle(
  fontFamily: family,
  fontSize: size,
  color: color,
  letterSpacing: letterSpacing,
  fontWeight: ui.FontWeight.values[(weight / 100).round() - 1],
  fontVariations: [ui.FontVariation('wght', weight)],
  fontFeatures: const [ui.FontFeature.tabularFigures()],
);

ui.TextStyle _display(
  double size, {
  double weight = 900,
  ui.Color color = _cream,
}) => _style('Rubik', size, weight, color, letterSpacing: -size * 0.02);

ui.TextStyle _body(double size, {ui.Color color = _muted}) =>
    _style('Inter', size, 450, color);

ui.TextStyle _mono(
  double size, {
  ui.Color color = _muted,
  double weight = 400,
}) => _style(
  weight >= 600 ? 'PlexMonoSemiBold' : 'PlexMono',
  size,
  weight,
  color,
);

enum _Anchor { start, center, end }

void _text(
  ui.Canvas canvas,
  List<_Span> spans, {
  required double x,
  required double baseline,
  _Anchor anchor = _Anchor.start,
}) {
  final builder = ui.ParagraphBuilder(ui.ParagraphStyle());
  for (final (text, style) in spans) {
    builder
      ..pushStyle(style)
      ..addText(text)
      ..pop();
  }
  final paragraph = builder.build()
    ..layout(const ui.ParagraphConstraints(width: 2000));
  final width = paragraph.maxIntrinsicWidth;
  final dx = switch (anchor) {
    _Anchor.start => x,
    _Anchor.center => x - width / 2,
    _Anchor.end => x - width,
  };
  canvas.drawParagraph(
    paragraph,
    ui.Offset(dx, baseline - paragraph.alphabeticBaseline),
  );
  paragraph.dispose();
}

String _money(double value) {
  final digits = value.abs().round().toString();
  final grouped = digits.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  if (digits == '0') return '\$0';
  return '${value < 0 ? '−' : '+'}\$$grouped';
}

/// The app's stacked allocation bar: one rounded column split by wallet.
List<(double, double)> _paintStack(
  ui.Canvas canvas,
  ui.Rect rect,
  List<double> shares,
) {
  const gap = 3.0;
  final usable = rect.height - gap * (shares.length - 1);
  final spans = <(double, double)>[];
  canvas.save();
  canvas.clipRRect(
    ui.RRect.fromRectAndRadius(rect, ui.Radius.circular(rect.width / 2)),
  );
  var top = rect.top;
  for (var i = 0; i < shares.length; i++) {
    final height = usable * shares[i] / 100;
    canvas.drawRect(
      ui.Rect.fromLTWH(rect.left, top, rect.width, height),
      ui.Paint()..color = _wallets[i].color,
    );
    spans.add((top, top + height));
    top += height + gap;
  }
  canvas.restore();
  return spans;
}

void _paintHeader(ui.Canvas canvas, double progress, ui.Size size) {
  double towards(_Wallet w) => w.now + (w.target - w.now) * progress;

  final social = size == _socialSize;
  final bounds = ui.Offset.zero & size;
  if (social) {
    canvas.drawRect(bounds, ui.Paint()..color = _bg);
  } else {
    final sheet = ui.RRect.fromRectAndRadius(
      bounds,
      const ui.Radius.circular(22),
    ).deflate(0.5);
    canvas.drawRRect(sheet, ui.Paint()..color = _bg);
    canvas.drawRRect(
      sheet,
      ui.Paint()
        ..style = ui.PaintingStyle.stroke
        ..color = _hairline,
    );
  }

  // Wordmark column.
  final left = social ? 28.0 : 40.0;
  final wordmarkSize = social ? 50.0 : 58.0;
  _text(
    canvas,
    [('ASSET ALLOCATION CALCULATOR', _mono(10, weight: 400))],
    x: left,
    baseline: 56,
  );
  _text(canvas, [('CASH', _display(wordmarkSize))], x: left - 3, baseline: 116);
  _text(
    canvas,
    [('BALANCER', _display(wordmarkSize))],
    x: left - 3,
    baseline: 170,
  );
  _text(
    canvas,
    [('Say what you want to hold.', _body(15, color: _cream))],
    x: left,
    baseline: 212,
  );
  _text(
    canvas,
    [('It tells you what to buy and sell.', _body(15))],
    x: left,
    baseline: 234,
  );
  _text(
    canvas,
    [
      ('Try it on the web ', _mono(11, color: _buy, weight: 600)),
      ('↗', _mono(11, color: _buy, weight: 600)),
    ],
    x: left,
    baseline: 276,
  );

  // Now → target.
  const barTop = 64.0;
  const barBottom = 276.0;
  const barWidth = 22.0;
  final ledgerRight = size.width - left;
  final ledgerLeft = ledgerRight - (social ? 152 : 174);
  final targetLeft = ledgerLeft - (social ? 23 : 38) - barWidth;
  final nowLeft = targetLeft - (social ? 90 : 106);
  final nowBar = ui.Rect.fromLTRB(
    nowLeft,
    barTop,
    nowLeft + barWidth,
    barBottom,
  );
  final targetBar = ui.Rect.fromLTRB(
    targetLeft,
    barTop,
    targetLeft + barWidth,
    barBottom,
  );
  _text(
    canvas,
    [('NOW', _mono(10))],
    x: nowBar.center.dx,
    baseline: barTop - 14,
    anchor: _Anchor.center,
  );
  _text(
    canvas,
    [('TARGET', _mono(10))],
    x: targetBar.center.dx,
    baseline: barTop - 14,
    anchor: _Anchor.center,
  );

  final nowSpans = _paintStack(canvas, nowBar, [
    for (final w in _wallets) w.now,
  ]);
  final targetSpans = _paintStack(canvas, targetBar, [
    for (final w in _wallets) towards(w),
  ]);
  final reveal = (progress * 1.6).clamp(0.0, 1.0);
  canvas.save();
  canvas.clipRRect(
    ui.RRect.fromLTRBR(
      nowBar.right,
      barTop,
      nowBar.right + 4 + (targetBar.left - nowBar.right - 8) * reveal,
      barBottom,
      const ui.Radius.circular(8),
    ),
  );
  canvas.clipRRect(
    ui.RRect.fromLTRBR(
      nowBar.right + 4,
      barTop,
      targetBar.left - 4,
      barBottom,
      const ui.Radius.circular(8),
    ),
  );
  for (var i = 0; i < _wallets.length; i++) {
    final (a0, a1) = nowSpans[i];
    final (b0, b1) = targetSpans[i];
    final x0 = nowBar.right + 4;
    final x1 = targetBar.left - 4;
    final mid = (x0 + x1) / 2;
    final flow = ui.Path()
      ..moveTo(x0, a0)
      ..cubicTo(mid, a0, mid, b0, x1, b0)
      ..lineTo(x1, b1)
      ..cubicTo(mid, b1, mid, a1, x0, a1)
      ..close();
    final color = _wallets[i].color;
    canvas.drawPath(
      flow,
      ui.Paint()
        ..shader = ui.Gradient.linear(
          ui.Offset(x0, 0),
          ui.Offset(x1, 0),
          [
            color.withValues(alpha: 0.42),
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.42),
          ],
          [0, 0.5, 1],
        ),
    );
  }
  canvas.restore();

  // Ledger.
  const rowHeight = 53.0;
  for (var i = 0; i < _wallets.length; i++) {
    final wallet = _wallets[i];
    final top = barTop + i * rowHeight;
    if (i > 0) {
      canvas.drawLine(
        ui.Offset(ledgerLeft, top - 6),
        ui.Offset(ledgerRight, top - 6),
        ui.Paint()..color = _hairline,
      );
    }
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(
        ui.Rect.fromLTWH(ledgerLeft, top + 3, 4, 34),
        const ui.Radius.circular(2),
      ),
      ui.Paint()..color = wallet.color,
    );
    _text(
      canvas,
      [(wallet.name.toUpperCase(), _display(14, weight: 800))],
      x: ledgerLeft + 14,
      baseline: top + 17,
    );
    _text(
      canvas,
      [
        ('${wallet.now.round()}%', _mono(11)),
        ('  →  ', _mono(11)),
        ('${towards(wallet).round()}%', _mono(11, color: _cream, weight: 600)),
      ],
      x: ledgerLeft + 14,
      baseline: top + 35,
    );
    final finalDelta = (wallet.target - wallet.now) / 100 * _portfolio;
    final delta =
        ((towards(wallet) - wallet.now) / 100 * _portfolio / 10).round() * 10.0;
    final color = (finalDelta >= 0 ? _buy : _sell).withValues(
      alpha: 0.35 + 0.65 * progress,
    );
    _text(
      canvas,
      [(_money(delta), _mono(12.5, color: color, weight: 600))],
      x: ledgerRight,
      baseline: top + 17,
      anchor: _Anchor.end,
    );
    _text(
      canvas,
      [
        (
          finalDelta >= 0 ? 'BUY' : 'SELL',
          _mono(9.5, color: _muted.withValues(alpha: progress)),
        ),
      ],
      x: ledgerRight,
      baseline: top + 35,
      anchor: _Anchor.end,
    );
  }
}

Future<void> _loadFonts() async {
  Future<void> load(String family, String file) async {
    final font = File('assets/fonts/$file');
    final loader = FontLoader(family)
      ..addFont(Future.value(ByteData.sublistView(font.readAsBytesSync())));
    await loader.load();
  }

  await load('Rubik', 'Rubik[wght].ttf');
  await load('Inter', 'Inter[opsz,wght].ttf');
  await load('PlexMono', 'IBMPlexMono-Regular.ttf');
  await load('PlexMonoSemiBold', 'IBMPlexMono-SemiBold.ttf');
}

double _ease(double x) {
  final t = x.clamp(0.0, 1.0);
  return t < 0.5 ? 4 * t * t * t : 1 - math.pow(-2 * t + 2, 3) / 2;
}

/// Holds the current allocation, rebalances, holds the ledger, rewinds.
double _progressAt(int frame) {
  if (frame < 24) return 0;
  if (frame < 84) return _ease((frame - 24) / 60);
  if (frame < 132) return 1;
  return 1 - _ease((frame - 132) / 18);
}

const int _frames = 150;

Future<void> _render(
  double progress,
  String path, {
  ui.Size size = _headerSize,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder)..scale(_dpr, _dpr);
  _paintHeader(canvas, progress, size);
  final picture = recorder.endRecording();
  final image = await picture.toImage(
    (size.width * _dpr).round(),
    (size.height * _dpr).round(),
  );
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  File(path)
    ..parent.createSync(recursive: true)
    ..writeAsBytesSync(bytes!.buffer.asUint8List());
  image.dispose();
  picture.dispose();
}

void main() {
  test('render Cash Balancer README header', () async {
    await _loadFonts();
    await _render(1, 'assets/header.png');
    await _render(1, 'assets/og.png', size: _socialSize);
    File('assets/og.png').copySync('web/og.png');
    for (var frame = 0; frame < _frames; frame++) {
      final name = frame.toString().padLeft(4, '0');
      await _render(
        _progressAt(frame),
        'build/readme_frames/header/frame_$name.png',
      );
    }
  }, timeout: Timeout.none);
}
