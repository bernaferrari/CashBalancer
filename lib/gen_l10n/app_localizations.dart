import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart' show GlobalCupertinoLocalizations;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:intl/intl.dart' as intl;
import 'package:material_ui/material_ui.dart' show GlobalMaterialLocalizations;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash Balancer'**
  String get appTitle;

  /// No description provided for @mainEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first wallet.'**
  String get mainEmptyTitle;

  /// No description provided for @mainEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the + to add a wallet, where you\'ll be able to add your assets.'**
  String get mainEmptySubtitle;

  /// No description provided for @mainDialogValidator.
  ///
  /// In en, this message translates to:
  /// **'Please enter some text'**
  String get mainDialogValidator;

  /// No description provided for @addWallet.
  ///
  /// In en, this message translates to:
  /// **'Add Wallet'**
  String get addWallet;

  /// No description provided for @addAWallet.
  ///
  /// In en, this message translates to:
  /// **'Add a Wallet'**
  String get addAWallet;

  /// No description provided for @editWallet.
  ///
  /// In en, this message translates to:
  /// **'Edit a Wallet'**
  String get editWallet;

  /// No description provided for @allItems.
  ///
  /// In en, this message translates to:
  /// **'All items'**
  String get allItems;

  /// No description provided for @targetSettings.
  ///
  /// In en, this message translates to:
  /// **'Sum up to 100% in each wallet, instead of considering the sum of all wallets.'**
  String get targetSettings;

  /// No description provided for @theAssetsName.
  ///
  /// In en, this message translates to:
  /// **'The asset’s name, such as savings or bitcoin.'**
  String get theAssetsName;

  /// No description provided for @pressToAdd.
  ///
  /// In en, this message translates to:
  /// **'Press + to add.'**
  String get pressToAdd;

  /// No description provided for @rightNow.
  ///
  /// In en, this message translates to:
  /// **'Right now'**
  String get rightNow;

  /// No description provided for @isGoingToBe.
  ///
  /// In en, this message translates to:
  /// **'is going to be'**
  String get isGoingToBe;

  /// No description provided for @howMuchTarget.
  ///
  /// In en, this message translates to:
  /// **'How much percentage you want this to be.'**
  String get howMuchTarget;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'OPTIONAL'**
  String get optional;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'The total amount you own.'**
  String get totalAmount;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// Used on dialogs for moving items from one wallet into another
  ///
  /// In en, this message translates to:
  /// **'Move \"{itemName}\"'**
  String moveWallet(String itemName);

  /// No description provided for @addAsset.
  ///
  /// In en, this message translates to:
  /// **'Add an Asset'**
  String get addAsset;

  /// No description provided for @editAsset.
  ///
  /// In en, this message translates to:
  /// **'Edit an Asset'**
  String get editAsset;

  /// No description provided for @dialogAssetName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get dialogAssetName;

  /// No description provided for @dialogAssetValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get dialogAssetValue;

  /// No description provided for @dialogAssetTarget.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get dialogAssetTarget;

  /// No description provided for @dialogSave.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get dialogSave;

  /// No description provided for @dialogSaveAddMore.
  ///
  /// In en, this message translates to:
  /// **'SAVE AND ADD MORE'**
  String get dialogSaveAddMore;

  /// No description provided for @dialogCancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get dialogCancel;

  /// No description provided for @dialogDelete.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get dialogDelete;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencySymbol;

  /// No description provided for @relativeTarget.
  ///
  /// In en, this message translates to:
  /// **'Relative Target'**
  String get relativeTarget;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortBy0.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get sortBy0;

  /// No description provided for @sortBy1.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortBy1;

  /// No description provided for @pleaseEnterCurrency.
  ///
  /// In en, this message translates to:
  /// **'Please enter the currency (\$, €, etc.)'**
  String get pleaseEnterCurrency;

  /// No description provided for @invalidValue.
  ///
  /// In en, this message translates to:
  /// **'Invalid number format'**
  String get invalidValue;

  /// No description provided for @valueMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Value must be positive'**
  String get valueMustBePositive;

  /// No description provided for @targetMustBeBetween.
  ///
  /// In en, this message translates to:
  /// **'Target must be between 0 and 100'**
  String get targetMustBeBetween;

  /// No description provided for @designedDeveloped.
  ///
  /// In en, this message translates to:
  /// **'Designed & developed by Bernardo Ferrari.'**
  String get designedDeveloped;

  /// No description provided for @buyOnlyRebalance.
  ///
  /// In en, this message translates to:
  /// **'Buy-Only Rebalancing'**
  String get buyOnlyRebalance;

  /// No description provided for @buyOnlyRebalanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rebalance using only new cash without selling any overweight assets.'**
  String get buyOnlyRebalanceSubtitle;

  /// No description provided for @rebalanceCalculator.
  ///
  /// In en, this message translates to:
  /// **'Invest & Rebalance'**
  String get rebalanceCalculator;

  /// No description provided for @amountToInvest.
  ///
  /// In en, this message translates to:
  /// **'Amount to invest'**
  String get amountToInvest;

  /// No description provided for @autoFillBuyOnly.
  ///
  /// In en, this message translates to:
  /// **'Min. to balance without selling'**
  String get autoFillBuyOnly;

  /// No description provided for @applyInvestment.
  ///
  /// In en, this message translates to:
  /// **'APPLY TO PORTFOLIO'**
  String get applyInvestment;

  /// No description provided for @noTargetsSet.
  ///
  /// In en, this message translates to:
  /// **'Set target percentages on your wallets or assets to calculate how to distribute your investment.'**
  String get noTargetsSet;

  /// No description provided for @hold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get hold;

  /// No description provided for @portfolios.
  ///
  /// In en, this message translates to:
  /// **'Portfolios & Goals'**
  String get portfolios;

  /// No description provided for @newPortfolio.
  ///
  /// In en, this message translates to:
  /// **'New Portfolio / Goal'**
  String get newPortfolio;

  /// No description provided for @portfolioName.
  ///
  /// In en, this message translates to:
  /// **'Portfolio name'**
  String get portfolioName;

  /// No description provided for @themeAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get themeAuto;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @loadSamplePortfolio.
  ///
  /// In en, this message translates to:
  /// **'Load sample portfolio'**
  String get loadSamplePortfolio;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export JSON'**
  String get exportBackup;

  /// No description provided for @importBackup.
  ///
  /// In en, this message translates to:
  /// **'Import JSON'**
  String get importBackup;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
