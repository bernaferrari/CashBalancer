// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Cash Balancer';

  @override
  String get mainEmptyTitle => 'Ajoutez votre premier portefeuille.';

  @override
  String get mainEmptySubtitle =>
      'Appuyez sur + pour ajouter un portefeuille où vous pourrez enregistrer vos actifs.';

  @override
  String get mainDialogValidator => 'Veuillez saisir du texte';

  @override
  String get addWallet => 'Ajouter Portefeuille';

  @override
  String get addAWallet => 'Ajouter un Portefeuille';

  @override
  String get editWallet => 'Modifier le Portefeuille';

  @override
  String get allItems => 'Tous les actifs';

  @override
  String get targetSettings =>
      'Totaliser 100 % dans chaque portefeuille, au lieu de considérer la somme de tous les portefeuilles.';

  @override
  String get theAssetsName => 'Le nom de l\'actif, comme épargne ou bitcoin.';

  @override
  String get pressToAdd => 'Appuyez sur + pour ajouter.';

  @override
  String get rightNow => 'Actuellement';

  @override
  String get isGoingToBe => 'sera';

  @override
  String get howMuchTarget => 'Le pourcentage cible souhaité.';

  @override
  String get optional => 'OPTIONNEL';

  @override
  String get value => 'Valeur';

  @override
  String get move => 'Déplacer';

  @override
  String moveWallet(String itemName) {
    return 'Déplacer \"$itemName\"';
  }

  @override
  String get addAsset => 'Ajouter un Actif';

  @override
  String get editAsset => 'Modifier l\'Actif';

  @override
  String get dialogAssetName => 'Nom';

  @override
  String get dialogAssetTarget => 'Cible';

  @override
  String get dialogSave => 'ENREGISTRER';

  @override
  String get dialogSaveAddMore => 'ENREGISTRER ET AJOUTER PLUS';

  @override
  String get dialogCancel => 'ANNULER';

  @override
  String get dialogDelete => 'SUPPRIMER';

  @override
  String get settings => 'Paramètres';

  @override
  String get currencySymbol => 'Devise';

  @override
  String get relativeTarget => 'Cible relative';

  @override
  String get sortBy => 'Trier par';

  @override
  String get sortBy0 => 'Valeur';

  @override
  String get sortBy1 => 'Nom';

  @override
  String get pleaseEnterCurrency => 'Veuillez saisir la devise (\$, €, etc.)';

  @override
  String get invalidValue => 'Format numérique invalide';

  @override
  String get valueMustBePositive => 'La valeur doit être positive';

  @override
  String get targetMustBeBetween =>
      'La cible doit être comprise entre 0 et 100';

  @override
  String get designedDeveloped => 'Conçu et développé par Bernardo Ferrari.';

  @override
  String get buyOnlyRebalance => 'Rééquilibrage par Achat Seul';

  @override
  String get buyOnlyRebalanceSubtitle =>
      'Rééquilibrez uniquement avec du nouvel argent, sans vendre d\'actifs.';

  @override
  String get rebalanceCalculator => 'Investir et Rééquilibrer';

  @override
  String get amountToInvest => 'Montant à investir';

  @override
  String get autoFillBuyOnly => 'Min. pour équilibrer sans vendre';

  @override
  String get applyInvestment => 'APPLIQUER AU PORTEFEUILLE';

  @override
  String get noTargetsSet =>
      'Définissez des pourcentages cibles sur vos portefeuilles ou actifs pour calculer la répartition.';

  @override
  String get hold => 'Conserver';

  @override
  String get portfolios => 'Portefeuilles et Objectifs';

  @override
  String get newPortfolio => 'Nouveau Portefeuille / Objectif';

  @override
  String get themeAuto => 'Auto';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get quantity => 'Quantité';

  @override
  String get loadSamplePortfolio => 'Charger un portefeuille d\'exemple';

  @override
  String get language => 'Langue';

  @override
  String get exportBackup => 'Exporter tous les portefeuilles';

  @override
  String get importBackup => 'Restaurer une sauvegarde';

  @override
  String get total => 'Total';

  @override
  String get unitPrice => 'Prix unitaire';

  @override
  String get unitPriceHelper =>
      'Prix d’une unité. Multipliez-le par la quantité pour obtenir le total.';

  @override
  String get defaultPortfolio => 'Portefeuille n° 1';

  @override
  String get operationFailed =>
      'Impossible d’enregistrer la modification. Réessayez.';

  @override
  String get confirmSales =>
      'Ce plan comprend des ventes. Appliquer les achats et ventes aux quantités d’actifs ?';

  @override
  String get targetTotalWarning =>
      'La somme des objectifs n’est pas égale à 100 %.';

  @override
  String get unallocatedCash => 'Liquidités non affectées';

  @override
  String get additionalCash => 'Liquidités supplémentaires nécessaires';

  @override
  String get tradeRequiresPrice =>
      'Saisissez un prix unitaire positif avant d’appliquer ces opérations.';

  @override
  String get confirmDeleteContents =>
      'Tout son contenu sera également supprimé.';

  @override
  String get deleted => 'Supprimé';

  @override
  String get undo => 'Annuler';

  @override
  String get edit => 'Modifier';

  @override
  String get pageNotFound => 'Page introuvable';

  @override
  String get goHome => 'Retour à l’accueil';

  @override
  String get chooseBackupFile => 'Choisir un fichier JSON';

  @override
  String get pasteBackup => 'Coller depuis le presse-papiers';

  @override
  String get replace => 'Remplacer';

  @override
  String get merge => 'Fusionner';

  @override
  String get restoreExplanation =>
      'Fusionner conserve les données et ajoute les entrées manquantes. Remplacer écrase tous les portefeuilles lors d’une restauration complète, ou le portefeuille actif pour une ancienne sauvegarde.';

  @override
  String get backupRestored => 'Sauvegarde restaurée';

  @override
  String get invalidBackup =>
      'Ce fichier n’est pas une sauvegarde Cash Balancer valide.';

  @override
  String get sampleStocks => 'Actions';

  @override
  String get sampleCrypto => 'Cryptomonnaies';

  @override
  String get sampleCash => 'Liquidités';

  @override
  String get sampleSavings => 'Épargne à haut rendement';

  @override
  String get quickPrice => 'Mettre à jour le prix';
}
