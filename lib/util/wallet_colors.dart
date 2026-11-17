import 'dart:math';

import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:material_ui/material_ui.dart';

import '../database/data.dart';

final _schemes = <(WalletColor, Brightness), ColorScheme>{};

/// The colors a wallet can take, saved by name. Each is only a seed: every
/// tone on screen comes from a Material 3 scheme generated from it.
enum WalletColor(final Color seed) {
  rose(Color(0xFFF43F5E)),
  pink(Color(0xFFEC4899)),
  fuchsia(Color(0xFFD946EF)),
  purple(Color(0xFFA855F7)),
  violet(Color(0xFF8B5CF6)),
  indigo(Color(0xFF6366F1)),
  blue(Color(0xFF3B82F6)),
  sky(Color(0xFF0EA5E9)),
  cyan(Color(0xFF06B6D4)),
  teal(Color(0xFF14B8A6)),
  emerald(Color(0xFF10B981)),
  green(Color(0xFF22C55E)),
  lime(Color(0xFF84CC16)),
  yellow(Color(0xFFEAB308)),
  amber(Color(0xFFF59E0B)),
  orange(Color(0xFFF97316)),
  red(Color(0xFFEF4444)),
  stone(Color(0xFF78716C)),
  neutral(Color(0xFF737373)),
  zinc(Color(0xFF71717A)),
  gray(Color(0xFF6B7280)),
  slate(Color(0xFF64748B));

  static final Map<String, WalletColor> _byName = values.asNameMap();

  /// Resolves a saved color name, defaulting to [zinc].
  static WalletColor fromName(String name) => _byName[name] ?? zinc;

  /// The colors a new wallet can pick, in hue order. The rest stay valid for
  /// wallets saved with them.
  static const offered = [
    red,
    orange,
    amber,
    lime,
    emerald,
    teal,
    sky,
    indigo,
    violet,
    fuchsia,
    pink,
    slate,
  ];

  /// A random offered hue; gray reads as disabled on a fresh wallet.
  static WalletColor random([Random? rng]) {
    final chromatic = offered.where((color) => color != slate).toList();
    return chromatic[(rng ?? Random()).nextInt(chromatic.length)];
  }

  /// The wallet's Material 3 scheme. Fidelity keeps the wallet recognizable:
  /// its primary container is the seed itself.
  ColorScheme scheme(Brightness brightness) => _schemes.putIfAbsent(
    (this, brightness),
    () => ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    ),
  );

  /// The seed faded [step] times toward the background of [brightness].
  Color fade(int step, Brightness brightness) => step == 0
      ? seed
      : shade((brightness == Brightness.light ? 11 : -10) * step.toDouble());

  /// The seed at a lighter (positive) or darker HCT tone, same hue and chroma.
  Color shade(double toneShift) {
    final hct = Hct.fromInt(seed.toARGB32());
    return Color(
      Hct.from(
        hct.hue,
        hct.chroma,
        (hct.tone + toneShift).clamp(0, 100),
      ).toInt(),
    );
  }
}

extension ItemColorX on ItemData {
  /// The wallet color for the wallet's largest holdings, fading toward the
  /// background for smaller ones.
  Color colorIn(BuildContext context) =>
      WalletColor.fromName(colorName).fade(shade, Theme.of(context).brightness);
}

/// The seed color of the wallet color saved as [name].
Color walletSeed(String name) => WalletColor.fromName(name).seed;
