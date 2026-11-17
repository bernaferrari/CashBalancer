import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
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
  /// **'Group your assets into wallets, give each a target, and see exactly what to buy or sell.'**
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
  /// **'Asset targets add up to 100% inside each wallet, not across the whole portfolio.'**
  String get targetSettings;

  /// No description provided for @assetNameHint.
  ///
  /// In en, this message translates to:
  /// **'Savings, Bitcoin, AAPL…'**
  String get assetNameHint;

  /// No description provided for @walletNameHint.
  ///
  /// In en, this message translates to:
  /// **'Stocks, Crypto, Emergency fund…'**
  String get walletNameHint;

  /// No description provided for @pressToAdd.
  ///
  /// In en, this message translates to:
  /// **'No assets yet. Tap + to add one.'**
  String get pressToAdd;

  /// No description provided for @howMuchTarget.
  ///
  /// In en, this message translates to:
  /// **'The share it should have.'**
  String get howMuchTarget;

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

  /// No description provided for @dialogAssetTarget.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get dialogAssetTarget;

  /// No description provided for @dialogSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get dialogSave;

  /// No description provided for @dialogSaveAddMore.
  ///
  /// In en, this message translates to:
  /// **'Save and add more'**
  String get dialogSaveAddMore;

  /// No description provided for @dialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancel;

  /// No description provided for @dialogDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
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
  /// **'Targets per wallet'**
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
  /// **'Buy-only rebalancing'**
  String get buyOnlyRebalance;

  /// No description provided for @buyOnlyRebalanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Only add money. Nothing gets sold.'**
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
  /// **'Apply to portfolio'**
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
  /// **'Portfolios & goals'**
  String get portfolios;

  /// No description provided for @newPortfolio.
  ///
  /// In en, this message translates to:
  /// **'New portfolio or goal'**
  String get newPortfolio;

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
  /// **'Export all portfolios'**
  String get exportBackup;

  /// No description provided for @importBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get importBackup;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @unitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit price'**
  String get unitPrice;

  /// No description provided for @unitPriceHelper.
  ///
  /// In en, this message translates to:
  /// **'Price for one unit. Multiply by quantity to get the total.'**
  String get unitPriceHelper;

  /// No description provided for @defaultPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio #1'**
  String get defaultPortfolio;

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the change. Please try again.'**
  String get operationFailed;

  /// No description provided for @confirmSales.
  ///
  /// In en, this message translates to:
  /// **'This plan includes sales. Apply the plan to update your balances and quantities? This records changes in Cash Balancer.'**
  String get confirmSales;

  /// No description provided for @targetTotalWarning.
  ///
  /// In en, this message translates to:
  /// **'Targets don\'t add up to 100%.'**
  String get targetTotalWarning;

  /// No description provided for @unallocatedCash.
  ///
  /// In en, this message translates to:
  /// **'Unallocated cash'**
  String get unallocatedCash;

  /// No description provided for @additionalCash.
  ///
  /// In en, this message translates to:
  /// **'Additional cash needed'**
  String get additionalCash;

  /// No description provided for @tradeRequiresPrice.
  ///
  /// In en, this message translates to:
  /// **'Set a positive unit price before applying these trades.'**
  String get tradeRequiresPrice;

  /// No description provided for @confirmDeleteContents.
  ///
  /// In en, this message translates to:
  /// **'This also deletes everything it contains.'**
  String get confirmDeleteContents;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get goHome;

  /// No description provided for @chooseBackupFile.
  ///
  /// In en, this message translates to:
  /// **'Choose JSON file'**
  String get chooseBackupFile;

  /// No description provided for @pasteBackup.
  ///
  /// In en, this message translates to:
  /// **'Paste from clipboard'**
  String get pasteBackup;

  /// No description provided for @replace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replace;

  /// No description provided for @merge.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get merge;

  /// No description provided for @restoreExplanation.
  ///
  /// In en, this message translates to:
  /// **'Merge keeps existing data and adds missing entries. Replace overwrites all portfolios for a full backup, or the active portfolio for an older backup.'**
  String get restoreExplanation;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get backupRestored;

  /// No description provided for @invalidBackup.
  ///
  /// In en, this message translates to:
  /// **'This file isn\'t a valid Cash Balancer backup.'**
  String get invalidBackup;

  /// No description provided for @sampleStocks.
  ///
  /// In en, this message translates to:
  /// **'Stocks'**
  String get sampleStocks;

  /// No description provided for @sampleCrypto.
  ///
  /// In en, this message translates to:
  /// **'Crypto'**
  String get sampleCrypto;

  /// No description provided for @sampleCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get sampleCash;

  /// No description provided for @sampleSavings.
  ///
  /// In en, this message translates to:
  /// **'High-yield savings'**
  String get sampleSavings;

  /// No description provided for @quickPrice.
  ///
  /// In en, this message translates to:
  /// **'Update price'**
  String get quickPrice;

  /// No description provided for @walletsLabel.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get walletsLabel;

  /// No description provided for @enterAmountToApply.
  ///
  /// In en, this message translates to:
  /// **'Leave it empty to rebalance what you have.'**
  String get enterAmountToApply;

  /// No description provided for @balanceOnly.
  ///
  /// In en, this message translates to:
  /// **'Track as a cash balance'**
  String get balanceOnly;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @updateBalance.
  ///
  /// In en, this message translates to:
  /// **'Update balance'**
  String get updateBalance;

  /// No description provided for @mergePreview.
  ///
  /// In en, this message translates to:
  /// **'Merge adds {added} records and keeps {kept} existing records. When records match, your current values are kept. Older backups match by name within each portfolio and wallet.'**
  String mergePreview(int added, int kept);

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @after.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get after;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @sampleDescription.
  ///
  /// In en, this message translates to:
  /// **'Stocks, crypto and cash'**
  String get sampleDescription;

  /// No description provided for @targetAssigned.
  ///
  /// In en, this message translates to:
  /// **'{percent} of 100% assigned'**
  String targetAssigned(String percent);

  /// No description provided for @useAmount.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get useAmount;

  /// No description provided for @noTarget.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noTarget;

  /// No description provided for @balanceOnlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'For savings or cash: a single balance, no units.'**
  String get balanceOnlySubtitle;

  /// No description provided for @currentWallet.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentWallet;
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
