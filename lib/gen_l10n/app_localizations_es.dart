// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Cash Balancer';

  @override
  String get mainEmptyTitle => 'Añade tu primera cartera.';

  @override
  String get mainEmptySubtitle =>
      'Agrupa tus activos en carteras, define un objetivo para cada una y mira exactamente qué comprar o vender.';

  @override
  String get mainDialogValidator => 'Por favor ingresa algún texto';

  @override
  String get addWallet => 'Añadir Cartera';

  @override
  String get addAWallet => 'Añadir una Cartera';

  @override
  String get editWallet => 'Editar Cartera';

  @override
  String get allItems => 'Todos los activos';

  @override
  String get targetSettings =>
      'Sumar hasta el 100% en cada cartera, en lugar de considerar la suma de todas las carteras.';

  @override
  String get assetNameHint => 'Ahorros, Bitcoin, AAPL…';

  @override
  String get walletNameHint => 'Acciones, Cripto, Fondo de emergencia…';

  @override
  String get pressToAdd => 'Toca + para añadir.';

  @override
  String get howMuchTarget => 'Qué porcentaje objetivo deseas para esto.';

  @override
  String get value => 'Valor';

  @override
  String get move => 'Mover';

  @override
  String assetMoved(String itemName, String walletName) {
    return 'Se movió $itemName a $walletName';
  }

  @override
  String moveWallet(String itemName) {
    return 'Mover \"$itemName\"';
  }

  @override
  String get addAsset => 'Añadir un Activo';

  @override
  String get editAsset => 'Editar Activo';

  @override
  String get dialogAssetName => 'Nombre';

  @override
  String get dialogAssetTarget => 'Objetivo';

  @override
  String get dialogSave => 'Guardar';

  @override
  String get dialogSaveAddMore => 'Guardar y añadir más';

  @override
  String get dialogCancel => 'Cancelar';

  @override
  String get dialogDelete => 'Eliminar';

  @override
  String get settings => 'Ajustes';

  @override
  String get currencySymbol => 'Moneda';

  @override
  String get relativeTarget => 'Objetivo relativo';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get sortBy0 => 'Valor';

  @override
  String get sortBy1 => 'Nombre';

  @override
  String get pleaseEnterCurrency => 'Por favor ingresa la moneda (\$, €, etc.)';

  @override
  String get invalidValue => 'Formato de número inválido';

  @override
  String get valueMustBePositive => 'El valor debe ser positivo';

  @override
  String get targetMustBeBetween => 'El objetivo debe estar entre 0 y 100';

  @override
  String get designedDeveloped =>
      'Diseñado y desarrollado por Bernardo Ferrari.';

  @override
  String get buyOnlyRebalance => 'Rebalanceo Solo Compra';

  @override
  String get buyOnlyRebalanceSubtitle =>
      'Rebalancea usando solo dinero nuevo sin vender activos que superen su objetivo.';

  @override
  String get rebalanceCalculator => 'Invertir y Rebalancear';

  @override
  String get amountToInvest => 'Cantidad a invertir';

  @override
  String get autoFillBuyOnly => 'Mín. para equilibrar sin vender';

  @override
  String get applyInvestment => 'Aplicar a la cartera';

  @override
  String get noTargetsSet =>
      'Define porcentajes objetivo en tus carteras o activos para calcular cómo distribuir tu inversión.';

  @override
  String get hold => 'Mantener';

  @override
  String get portfolios => 'Carteras y Objetivos';

  @override
  String get newPortfolio => 'Nueva Cartera / Objetivo';

  @override
  String get themeAuto => 'Auto';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get quantity => 'Cantidad';

  @override
  String get loadSamplePortfolio => 'Cargar cartera de ejemplo';

  @override
  String get language => 'Idioma';

  @override
  String get exportBackup => 'Exportar todas las carteras';

  @override
  String get importBackup => 'Restaurar copia';

  @override
  String get total => 'Total';

  @override
  String get unitPrice => 'Precio unitario';

  @override
  String get unitPriceHelper =>
      'Precio de una unidad. Multiplícalo por la cantidad para obtener el total.';

  @override
  String get defaultPortfolio => 'Cartera #1';

  @override
  String get operationFailed =>
      'No se pudo guardar el cambio. Inténtalo de nuevo.';

  @override
  String get confirmSales =>
      'Este plan incluye ventas. ¿Aplicar el plan para actualizar los saldos y las cantidades en Cash Balancer?';

  @override
  String get targetTotalWarning => 'Los objetivos no suman el 100 %.';

  @override
  String get unallocatedCash => 'Efectivo sin asignar';

  @override
  String get additionalCash => 'Efectivo adicional necesario';

  @override
  String get tradeRequiresPrice =>
      'Indica un precio unitario positivo antes de aplicar estas operaciones.';

  @override
  String get confirmDeleteContents => 'También se eliminará todo su contenido.';

  @override
  String deleted(String name) {
    return 'Se eliminó $name';
  }

  @override
  String get undo => 'Deshacer';

  @override
  String get edit => 'Editar';

  @override
  String get pageNotFound => 'Página no encontrada';

  @override
  String get goHome => 'Volver al inicio';

  @override
  String get chooseBackupFile => 'Elegir archivo JSON';

  @override
  String get pasteBackup => 'Pegar del portapapeles';

  @override
  String get replace => 'Reemplazar';

  @override
  String get merge => 'Combinar';

  @override
  String get restoreExplanation =>
      'Combinar conserva los datos y añade las entradas que faltan. Reemplazar sobrescribe todas las carteras con una copia completa, o solo la activa con una copia antigua.';

  @override
  String get backupRestored => 'Copia restaurada';

  @override
  String get invalidBackup =>
      'El archivo no es una copia válida de Cash Balancer.';

  @override
  String get sampleStocks => 'Acciones';

  @override
  String get sampleCrypto => 'Criptomonedas';

  @override
  String get sampleCash => 'Efectivo';

  @override
  String get sampleSavings => 'Ahorro de alto rendimiento';

  @override
  String get quickPrice => 'Actualizar precio';

  @override
  String get walletsLabel => 'Carteras';

  @override
  String get enterAmountToApply =>
      'Déjalo vacío para rebalancear lo que ya tienes.';

  @override
  String get balanceOnly => 'Registrar como saldo en efectivo';

  @override
  String get balance => 'Saldo';

  @override
  String get updateBalance => 'Actualizar saldo';

  @override
  String mergePreview(int added, int kept) {
    return 'Combinar añade $added registros y conserva $kept existentes. Se conservan los valores actuales de los registros coincidentes. Las copias antiguas comparan nombres dentro de cada cartera y monedero.';
  }

  @override
  String get now => 'Ahora';

  @override
  String get after => 'Después';

  @override
  String get buy => 'Comprar';

  @override
  String get sell => 'Vender';

  @override
  String get preferences => 'Preferencias';

  @override
  String get appearance => 'Apariencia';

  @override
  String get backup => 'Copia de seguridad';

  @override
  String get sampleDescription => 'Acciones, cripto y efectivo para explorar';

  @override
  String targetAssigned(String percent) {
    return '$percent de 100% asignado';
  }

  @override
  String get amountEntered => 'Importe introducido';

  @override
  String get useAmount => 'Usar';

  @override
  String get noTarget => 'Ninguno';

  @override
  String get balanceOnlySubtitle =>
      'Para ahorros o efectivo: un solo saldo, sin unidades.';

  @override
  String get currentWallet => 'Actual';
}
