import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../util/wallet_colors.dart';

/// The "allocation ledger" roles every screen paints with.
class const Ledger({
  required final Color canvas,
  required final Color surface,
  required final Color sunken,
  required final Color hairline,
  required final Color ink,
  required final Color muted,
  required final Color faint,
  required final Color buy,
  required final Color sell,
}) extends ThemeExtension<Ledger> {
  /// The ledger roles read from a Material 3 [scheme]. Buy is the primary of
  /// a green scheme and sell the error role, both at the scheme's brightness.
  static Ledger of(ColorScheme scheme) => Ledger(
    canvas: scheme.surface,
    surface: scheme.surfaceContainer,
    sunken: scheme.surfaceContainerHighest,
    hairline: scheme.outlineVariant,
    ink: scheme.onSurface,
    muted: scheme.onSurfaceVariant,
    faint: scheme.outline,
    buy: WalletColor.green.scheme(scheme.brightness).primary,
    sell: scheme.error,
  );

  @override
  Ledger copyWith({Color? canvas, Color? surface}) => Ledger(
    canvas: canvas ?? this.canvas,
    surface: surface ?? this.surface,
    sunken: sunken,
    hairline: hairline,
    ink: ink,
    muted: muted,
    faint: faint,
    buy: buy,
    sell: sell,
  );

  @override
  Ledger lerp(Ledger? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return Ledger(
      canvas: mix(canvas, other.canvas),
      surface: mix(surface, other.surface),
      sunken: mix(sunken, other.sunken),
      hairline: mix(hairline, other.hairline),
      ink: mix(ink, other.ink),
      muted: mix(muted, other.muted),
      faint: mix(faint, other.faint),
      buy: mix(buy, other.buy),
      sell: mix(sell, other.sell),
    );
  }
}

extension LedgerContext on BuildContext {
  Ledger get ledger => Theme.of(this).extension<Ledger>()!;
}

const _tabular = [FontFeature.tabularFigures()];

/// IBM Plex Mono with tabular figures, used for every amount and percentage.
TextStyle figures(
  double size, {
  FontWeight weight = FontWeight.w400,
  Color? color,
}) => TextStyle(
  fontFamily: 'IBM Plex Mono',
  fontSize: size,
  fontWeight: weight,
  color: color,
  fontFeatures: _tabular,
);

/// Rubik headline style; variable weight needs an explicit `wght` axis.
TextStyle display(
  double size, {
  FontWeight weight = FontWeight.w700,
  Color? color,
  double letterSpacing = 0,
}) => TextStyle(
  fontFamily: 'Rubik',
  fontSize: size,
  fontWeight: weight,
  fontVariations: [FontVariation('wght', weight.value.toDouble())],
  color: color,
  letterSpacing: letterSpacing,
  fontFeatures: _tabular,
  height: 1.1,
);

TextStyle _inter(double size, FontWeight weight, {double? height}) => TextStyle(
  fontFamily: 'Inter',
  fontSize: size,
  fontWeight: weight,
  fontVariations: [FontVariation('wght', weight.value.toDouble())],
  height: height,
);

final _themes = <(Brightness, WalletColor?), ThemeData>{};

/// The app theme, generated from a Material 3 scheme. With a [colorName] (a
/// wallet's color) every surface and accent takes that wallet's tones; without
/// one the screen is a warm neutral with ink accents.
ThemeData buildTheme(Brightness brightness, {String? colorName}) {
  final wallet = colorName == null ? null : WalletColor.fromName(colorName);
  return _themes.putIfAbsent((
    brightness,
    wallet,
  ), () => _buildTheme(brightness, wallet));
}

ThemeData _buildTheme(Brightness brightness, WalletColor? wallet) {
  final m3 =
      wallet?.scheme(brightness) ??
      ColorScheme.fromSeed(
        seedColor: WalletColor.amber.seed,
        brightness: brightness,
        dynamicSchemeVariant: DynamicSchemeVariant.neutral,
      );
  final l = Ledger.of(m3);
  final accent = wallet == null ? l.ink : m3.primary;
  final onAccent = wallet == null ? l.canvas : m3.onPrimary;
  final scheme = m3.copyWith(
    primary: accent,
    onPrimary: onAccent,
    surfaceTint: Colors.transparent,
  );

  final textTheme = TextTheme(
    displaySmall: display(38, weight: FontWeight.w800, letterSpacing: -1),
    headlineSmall: display(22, weight: FontWeight.w800, letterSpacing: -0.3),
    titleLarge: display(19, weight: FontWeight.w700, letterSpacing: -0.2),
    titleMedium: _inter(15, FontWeight.w600),
    titleSmall: _inter(13.5, FontWeight.w600),
    bodyLarge: _inter(15, FontWeight.w400, height: 1.4),
    bodyMedium: _inter(14, FontWeight.w400, height: 1.4),
    bodySmall: _inter(12.5, FontWeight.w400, height: 1.4),
    labelLarge: display(14, weight: FontWeight.w700, letterSpacing: 0.6),
    labelMedium: figures(12.5, weight: FontWeight.w500),
    labelSmall: figures(
      11,
      weight: FontWeight.w500,
    ).copyWith(letterSpacing: 1.1),
  ).apply(bodyColor: l.ink, displayColor: l.ink);

  final shape12 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  );
  final well = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide.none,
  );

  return ThemeData(
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: l.canvas,
    canvasColor: l.canvas,
    extensions: [l],
    textTheme: textTheme,
    typography: Typography.material2021(),
    visualDensity: VisualDensity.standard,
    applyElevationOverlayColor: false,
    splashFactory: InkSparkle.splashFactory,
    dividerTheme: DividerThemeData(color: l.hairline, thickness: 1, space: 1),
    iconTheme: IconThemeData(color: l.ink, size: 22),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      backgroundColor: Colors.transparent,
      foregroundColor: l.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: textTheme.titleLarge,
      iconTheme: IconThemeData(color: l.ink),
      actionsIconTheme: IconThemeData(color: l.muted),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: l.ink,
      foregroundColor: l.canvas,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 2,
      highlightElevation: 0,
      shape: const StadiumBorder(),
      extendedTextStyle: display(15, weight: FontWeight.w700),
      extendedPadding: const EdgeInsets.symmetric(horizontal: 22),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: l.canvas,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      titleTextStyle: textTheme.headlineSmall,
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: l.muted),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: l.canvas,
      modalBackgroundColor: l.canvas,
      surfaceTintColor: Colors.transparent,
      dragHandleColor: l.faint,
      elevation: 0,
      modalElevation: 0,
      constraints: const BoxConstraints(maxWidth: 640),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(52, 52),
        elevation: 0,
        backgroundColor: accent,
        foregroundColor: onAccent,
        shape: const StadiumBorder(),
        textStyle: textTheme.labelLarge,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 46),
        backgroundColor: accent,
        foregroundColor: onAccent,
        shape: const StadiumBorder(),
        textStyle: textTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: l.ink,
        backgroundColor: l.sunken,
        side: BorderSide.none,
        shape: const StadiumBorder(),
        textStyle: textTheme.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 46),
        foregroundColor: l.ink,
        shape: shape12,
        textStyle: textTheme.labelLarge,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: l.ink),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.error)
            ? Color.alphaBlend(l.sell.withValues(alpha: 0.12), l.sunken)
            : states.contains(WidgetState.focused)
            ? Color.alphaBlend(accent.withValues(alpha: 0.08), l.sunken)
            : l.sunken,
      ),
      hoverColor: Colors.transparent,
      contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      border: well,
      labelStyle: textTheme.bodyMedium?.copyWith(color: l.muted),
      floatingLabelStyle: WidgetStateTextStyle.resolveWith(
        (states) => _inter(13, FontWeight.w500).copyWith(
          color: states.contains(WidgetState.error) ? l.sell : l.muted,
        ),
      ),
      hintStyle: textTheme.bodyLarge?.copyWith(color: l.faint),
      helperStyle: textTheme.bodySmall?.copyWith(color: l.muted),
      prefixStyle: figures(15, color: l.muted),
      suffixStyle: figures(15, color: l.muted),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: l.sunken,
      selectedColor: accent,
      side: BorderSide.none,
      shape: const StadiumBorder(),
      labelStyle: figures(13, weight: FontWeight.w500, color: l.ink),
      secondaryLabelStyle: figures(
        13,
        weight: FontWeight.w500,
        color: onAccent,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      iconTheme: IconThemeData(color: l.ink, size: 15),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? onAccent : l.canvas,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? accent
            : l.faint.withValues(alpha: 0.45),
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      thumbIcon: const WidgetStatePropertyAll(null),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: l.ink,
      contentTextStyle: _inter(14, FontWeight.w500).copyWith(color: l.canvas),
      actionTextColor: WalletColor.green.scheme(brightness).inversePrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: l.ink,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: _inter(12, FontWeight.w500).copyWith(color: l.canvas),
      waitDuration: const Duration(milliseconds: 400),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: accent),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: accent,
      selectionColor: accent.withValues(alpha: 0.22),
      selectionHandleColor: accent,
    ),
  );
}
