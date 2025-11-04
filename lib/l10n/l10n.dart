import 'package:flutter/widgets.dart';
import '../gen_l10n/app_localizations.dart';

export '../gen_l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
