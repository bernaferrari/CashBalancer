// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Cash Balancer';

  @override
  String get mainEmptyTitle => 'Add your first wallet.';

  @override
  String get mainEmptySubtitle =>
      'Tap the + to add a wallet, where you\'ll be able to add your assets.';

  @override
  String get mainDialogValidator => 'Please enter some text';

  @override
  String get addWallet => 'Add Wallet';

  @override
  String get addAWallet => 'Add a Wallet';

  @override
  String get editWallet => 'Edit a Wallet';

  @override
  String get allItems => 'All items';

  @override
  String get targetSettings =>
      'Sum up to 100% in each wallet, instead of considering the sum of all wallets.';

  @override
  String get theAssetsName => 'The asset’s name, such as savings or bitcoin.';

  @override
  String get pressToAdd => 'Press + to add.';

  @override
  String get rightNow => 'Right now';

  @override
  String get isGoingToBe => 'is going to be';

  @override
  String get howMuchTarget => 'How much percentage you want this to be.';

  @override
  String get optional => 'OPTIONAL';

  @override
  String get value => 'Value';

  @override
  String get move => 'Move';

  @override
  String moveWallet(String itemName) {
    return 'Move \"$itemName\"';
  }

  @override
  String get addAsset => 'Add an Asset';

  @override
  String get editAsset => 'Edit an Asset';

  @override
  String get dialogAssetName => 'Name';

  @override
  String get dialogAssetTarget => 'Target';

  @override
  String get dialogSave => 'SAVE';

  @override
  String get dialogSaveAddMore => 'SAVE AND ADD MORE';

  @override
  String get dialogCancel => 'CANCEL';

  @override
  String get dialogDelete => 'DELETE';

  @override
  String get settings => 'Settings';

  @override
  String get currencySymbol => 'Currency';

  @override
  String get relativeTarget => 'Relative Target';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortBy0 => 'Value';

  @override
  String get sortBy1 => 'Name';

  @override
  String get pleaseEnterCurrency => 'Please enter the currency (\$, €, etc.)';

  @override
  String get invalidValue => 'Invalid number format';

  @override
  String get valueMustBePositive => 'Value must be positive';

  @override
  String get targetMustBeBetween => 'Target must be between 0 and 100';

  @override
  String get designedDeveloped => 'Designed & developed by Bernardo Ferrari.';

  @override
  String get buyOnlyRebalance => 'Buy-Only Rebalancing';

  @override
  String get buyOnlyRebalanceSubtitle =>
      'Rebalance using only new cash without selling any overweight assets.';

  @override
  String get rebalanceCalculator => 'Invest & Rebalance';

  @override
  String get amountToInvest => 'Amount to invest';

  @override
  String get autoFillBuyOnly => 'Min. to balance without selling';

  @override
  String get applyInvestment => 'APPLY TO PORTFOLIO';

  @override
  String get noTargetsSet =>
      'Set target percentages on your wallets or assets to calculate how to distribute your investment.';

  @override
  String get hold => 'Hold';

  @override
  String get portfolios => 'Portfolios & Goals';

  @override
  String get newPortfolio => 'New Portfolio / Goal';

  @override
  String get themeAuto => 'Auto';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get quantity => 'Quantity';

  @override
  String get loadSamplePortfolio => 'Load sample portfolio';

  @override
  String get language => 'Language';

  @override
  String get exportBackup => 'Export all portfolios';

  @override
  String get importBackup => 'Restore backup';

  @override
  String get total => 'Total';

  @override
  String get unitPrice => 'Unit price';

  @override
  String get unitPriceHelper =>
      'Price for one unit. Multiply by quantity to get the total.';

  @override
  String get defaultPortfolio => 'Portfolio #1';

  @override
  String get operationFailed => 'Couldn\'t save the change. Please try again.';

  @override
  String get confirmSales =>
      'This plan includes sales. Apply the buys and sales to your asset quantities?';

  @override
  String get targetTotalWarning => 'Targets don\'t add up to 100%.';

  @override
  String get unallocatedCash => 'Unallocated cash';

  @override
  String get additionalCash => 'Additional cash needed';

  @override
  String get tradeRequiresPrice =>
      'Set a positive unit price before applying these trades.';

  @override
  String get confirmDeleteContents =>
      'This also deletes everything it contains.';

  @override
  String get deleted => 'Deleted';

  @override
  String get undo => 'Undo';

  @override
  String get edit => 'Edit';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get goHome => 'Back to home';

  @override
  String get chooseBackupFile => 'Choose JSON file';

  @override
  String get pasteBackup => 'Paste from clipboard';

  @override
  String get replace => 'Replace';

  @override
  String get merge => 'Merge';

  @override
  String get restoreExplanation =>
      'Merge keeps existing data and adds missing entries. Replace overwrites all portfolios for a full backup, or the active portfolio for an older backup.';

  @override
  String get backupRestored => 'Backup restored';

  @override
  String get invalidBackup => 'This file isn\'t a valid Cash Balancer backup.';

  @override
  String get sampleStocks => 'Stocks';

  @override
  String get sampleCrypto => 'Crypto';

  @override
  String get sampleCash => 'Cash';

  @override
  String get sampleSavings => 'High-yield savings';

  @override
  String get quickPrice => 'Update price';
}
