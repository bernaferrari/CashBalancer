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
  String get totalAmount => 'The total amount you own.';

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
  String get dialogAssetValue => 'Value';

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
}
