// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Cash Balancer';

  @override
  String get mainEmptyTitle => 'Aggiungi il tuo primo portafoglio.';

  @override
  String get mainEmptySubtitle =>
      'Raggruppa i tuoi asset in portafogli, assegna a ciascuno un obiettivo e scopri esattamente cosa comprare o vendere.';

  @override
  String get mainDialogValidator => 'Inserisci del testo';

  @override
  String get addWallet => 'Aggiungi Portafoglio';

  @override
  String get addAWallet => 'Aggiungi un Portafoglio';

  @override
  String get editWallet => 'Modifica Portafoglio';

  @override
  String get allItems => 'Tutti gli elementi';

  @override
  String get targetSettings =>
      'Somma fino al 100% in ogni portafoglio, invece di considerare la somma di tutti i portafogli.';

  @override
  String get assetNameHint => 'Risparmi, Bitcoin, AAPL…';

  @override
  String get walletNameHint => 'Azioni, Cripto, Fondo emergenze…';

  @override
  String get pressToAdd => 'Tocca + per aggiungere.';

  @override
  String get howMuchTarget => 'La percentuale obiettivo desiderata.';

  @override
  String get value => 'Valore';

  @override
  String get move => 'Sposta';

  @override
  String assetMoved(String itemName, String walletName) {
    return '$itemName è stato spostato in $walletName';
  }

  @override
  String moveWallet(String itemName) {
    return 'Sposta \"$itemName\"';
  }

  @override
  String get addAsset => 'Aggiungi un Asset';

  @override
  String get editAsset => 'Modifica Asset';

  @override
  String get dialogAssetName => 'Nome';

  @override
  String get dialogAssetTarget => 'Obiettivo';

  @override
  String get dialogSave => 'Salva';

  @override
  String get dialogSaveAddMore => 'Salva e aggiungi altro';

  @override
  String get dialogCancel => 'Annulla';

  @override
  String get dialogDelete => 'Elimina';

  @override
  String get settings => 'Impostazioni';

  @override
  String get currencySymbol => 'Valuta';

  @override
  String get relativeTarget => 'Obiettivo relativo';

  @override
  String get sortBy => 'Ordina per';

  @override
  String get sortBy0 => 'Valore';

  @override
  String get sortBy1 => 'Nome';

  @override
  String get pleaseEnterCurrency => 'Inserisci la valuta (\$, €, ecc.)';

  @override
  String get invalidValue => 'Formato numerico non valido';

  @override
  String get valueMustBePositive => 'Il valore deve essere positivo';

  @override
  String get targetMustBeBetween => 'L\'obiettivo deve essere tra 0 e 100';

  @override
  String get designedDeveloped =>
      'Progettato e sviluppato da Bernardo Ferrari.';

  @override
  String get buyOnlyRebalance => 'Ribilanciamento Solo Acquisto';

  @override
  String get buyOnlyRebalanceSubtitle =>
      'Ribilancia usando solo nuova liquidità senza vendere gli asset sopra l\'obiettivo.';

  @override
  String get rebalanceCalculator => 'Investi e Ribilancia';

  @override
  String get amountToInvest => 'Importo da investire';

  @override
  String get autoFillBuyOnly => 'Min. per bilanciare senza vendere';

  @override
  String get applyInvestment => 'Applica al portafoglio';

  @override
  String get noTargetsSet =>
      'Imposta percentuali obiettivo sui portafogli o asset per calcolare come distribuire l\'investimento.';

  @override
  String get hold => 'Mantieni';

  @override
  String get portfolios => 'Portafogli e Obiettivi';

  @override
  String get newPortfolio => 'Nuovo Portafoglio / Obiettivo';

  @override
  String get themeAuto => 'Auto';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get quantity => 'Quantità';

  @override
  String get loadSamplePortfolio => 'Carica portafoglio di esempio';

  @override
  String get language => 'Lingua';

  @override
  String get exportBackup => 'Esporta tutti i portafogli';

  @override
  String get importBackup => 'Ripristina backup';

  @override
  String get total => 'Totale';

  @override
  String get unitPrice => 'Prezzo unitario';

  @override
  String get unitPriceHelper =>
      'Prezzo di una unità. Moltiplicalo per la quantità per ottenere il totale.';

  @override
  String get defaultPortfolio => 'Portafoglio n. 1';

  @override
  String get operationFailed => 'Impossibile salvare la modifica. Riprova.';

  @override
  String get confirmSales =>
      'Questo piano include vendite. Applicare il piano per aggiornare saldi e quantità in Cash Balancer?';

  @override
  String get targetTotalWarning => 'Gli obiettivi non sommano al 100%.';

  @override
  String get unallocatedCash => 'Liquidità non assegnata';

  @override
  String get additionalCash => 'Liquidità aggiuntiva necessaria';

  @override
  String get tradeRequiresPrice =>
      'Imposta un prezzo unitario positivo prima di applicare le operazioni.';

  @override
  String get confirmDeleteContents =>
      'Verrà eliminato anche tutto il contenuto.';

  @override
  String deleted(String name) {
    return '$name è stato eliminato';
  }

  @override
  String get undo => 'Annulla';

  @override
  String get edit => 'Modifica';

  @override
  String get pageNotFound => 'Pagina non trovata';

  @override
  String get goHome => 'Torna alla home';

  @override
  String get chooseBackupFile => 'Scegli file JSON';

  @override
  String get pasteBackup => 'Incolla dagli appunti';

  @override
  String get replace => 'Sostituisci';

  @override
  String get merge => 'Unisci';

  @override
  String get restoreExplanation =>
      'Unisci mantiene i dati e aggiunge le voci mancanti. Sostituisci sovrascrive tutti i portafogli per un backup completo, o quello attivo per un vecchio backup.';

  @override
  String get backupRestored => 'Backup ripristinato';

  @override
  String get invalidBackup =>
      'Il file non è un backup valido di Cash Balancer.';

  @override
  String get sampleStocks => 'Azioni';

  @override
  String get sampleCrypto => 'Criptovalute';

  @override
  String get sampleCash => 'Liquidità';

  @override
  String get sampleSavings => 'Risparmio ad alto rendimento';

  @override
  String get quickPrice => 'Aggiorna il prezzo';

  @override
  String get walletsLabel => 'Portafogli';

  @override
  String get enterAmountToApply =>
      'Lascia vuoto per ribilanciare ciò che hai già.';

  @override
  String get balanceOnly => 'Registra come saldo in contanti';

  @override
  String get balance => 'Saldo';

  @override
  String get updateBalance => 'Aggiorna saldo';

  @override
  String mergePreview(int added, int kept) {
    return 'Unisci aggiunge $added voci e ne mantiene $kept. I valori correnti delle voci corrispondenti vengono conservati. I backup meno recenti usano i nomi nei portafogli.';
  }

  @override
  String get now => 'Ora';

  @override
  String get after => 'Dopo';

  @override
  String get buy => 'Compra';

  @override
  String get sell => 'Vendi';

  @override
  String get preferences => 'Preferenze';

  @override
  String get appearance => 'Aspetto';

  @override
  String get backup => 'Backup';

  @override
  String get sampleDescription => 'Azioni, cripto e liquidità da esplorare';

  @override
  String targetAssigned(String percent) {
    return '$percent su 100% assegnato';
  }

  @override
  String get amountEntered => 'Importo inserito';

  @override
  String get useAmount => 'Usa';

  @override
  String get noTarget => 'Nessuno';

  @override
  String get balanceOnlySubtitle =>
      'Per risparmi o contanti: un unico saldo, senza unità.';

  @override
  String get currentWallet => 'Attuale';
}
