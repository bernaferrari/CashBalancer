// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Cash Balancer';

  @override
  String get mainEmptyTitle => 'Füge dein erstes Wallet hinzu.';

  @override
  String get mainEmptySubtitle =>
      'Tippe auf +, um ein Wallet hinzuzufügen, in dem du deine Anlagen verwalten kannst.';

  @override
  String get mainDialogValidator => 'Bitte gib einen Text ein';

  @override
  String get addWallet => 'Wallet hinzufügen';

  @override
  String get addAWallet => 'Ein Wallet hinzufügen';

  @override
  String get editWallet => 'Wallet bearbeiten';

  @override
  String get allItems => 'Alle Positionen';

  @override
  String get targetSettings =>
      'In jedem Wallet auf 100 % summieren, anstatt die Summe aller Wallets zu berücksichtigen.';

  @override
  String get theAssetsName =>
      'Der Name der Anlage, z. B. Ersparnisse oder Bitcoin.';

  @override
  String get pressToAdd => 'Tippe auf +, um hinzuzufügen.';

  @override
  String get rightNow => 'Aktuell';

  @override
  String get isGoingToBe => 'wird sein';

  @override
  String get howMuchTarget => 'Welchen Zielprozentsatz du anstrebst.';

  @override
  String get optional => 'OPTIONAL';

  @override
  String get totalAmount => 'Der Gesamtbetrag, den du besitzt.';

  @override
  String get value => 'Wert';

  @override
  String get move => 'Verschieben';

  @override
  String moveWallet(String itemName) {
    return '\"$itemName\" verschieben';
  }

  @override
  String get addAsset => 'Anlage hinzufügen';

  @override
  String get editAsset => 'Anlage bearbeiten';

  @override
  String get dialogAssetName => 'Name';

  @override
  String get dialogAssetValue => 'Wert';

  @override
  String get dialogAssetTarget => 'Ziel';

  @override
  String get dialogSave => 'SPEICHERN';

  @override
  String get dialogSaveAddMore => 'SPEICHERN UND WEITERE HINZUFÜGEN';

  @override
  String get dialogCancel => 'ABBRECHEN';

  @override
  String get dialogDelete => 'LÖSCHEN';

  @override
  String get settings => 'Einstellungen';

  @override
  String get currencySymbol => 'Währung';

  @override
  String get relativeTarget => 'Relatives Ziel';

  @override
  String get sortBy => 'Sortieren nach';

  @override
  String get sortBy0 => 'Wert';

  @override
  String get sortBy1 => 'Name';

  @override
  String get pleaseEnterCurrency => 'Bitte gib die Währung ein (\$, €, usw.)';

  @override
  String get invalidValue => 'Ungültiges Zahlenformat';

  @override
  String get valueMustBePositive => 'Der Wert muss positiv sein';

  @override
  String get targetMustBeBetween => 'Das Ziel muss zwischen 0 und 100 liegen';

  @override
  String get designedDeveloped =>
      'Entworfen & entwickelt von Bernardo Ferrari.';

  @override
  String get buyOnlyRebalance => 'Nur-Kauf-Rebalancing';

  @override
  String get buyOnlyRebalanceSubtitle =>
      'Rebalanciere nur mit frischem Kapital, ohne übergewichtete Anlagen zu verkaufen.';

  @override
  String get rebalanceCalculator => 'Investieren & Rebalancieren';

  @override
  String get amountToInvest => 'Investitionsbetrag';

  @override
  String get autoFillBuyOnly => 'Min. zum Ausgleich ohne Verkauf';

  @override
  String get applyInvestment => 'AUF PORTFOLIO ANWENDEN';

  @override
  String get noTargetsSet =>
      'Lege Zielprozentsätze für deine Wallets oder Anlagen fest, um die Verteilung zu berechnen.';

  @override
  String get hold => 'Halten';

  @override
  String get portfolios => 'Portfolios & Ziele';

  @override
  String get newPortfolio => 'Neues Portfolio / Ziel';

  @override
  String get portfolioName => 'Name des Ziels';

  @override
  String get themeAuto => 'Auto';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get quantity => 'Menge';

  @override
  String get loadSamplePortfolio => 'Beispiel-Portfolio laden';

  @override
  String get language => 'Sprache';

  @override
  String get exportBackup => 'JSON exportieren';

  @override
  String get importBackup => 'JSON importieren';
}
