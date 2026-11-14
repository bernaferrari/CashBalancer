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
      'Toca el + para añadir una cartera, donde podrás agregar tus activos.';

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
  String get theAssetsName => 'El nombre del activo, como ahorros o bitcoin.';

  @override
  String get pressToAdd => 'Toca + para añadir.';

  @override
  String get rightNow => 'Ahora mismo';

  @override
  String get isGoingToBe => 'será';

  @override
  String get howMuchTarget => 'Qué porcentaje objetivo deseas para esto.';

  @override
  String get optional => 'OPCIONAL';

  @override
  String get value => 'Valor';

  @override
  String get move => 'Mover';

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
  String get dialogSave => 'GUARDAR';

  @override
  String get dialogSaveAddMore => 'GUARDAR Y AÑADIR MÁS';

  @override
  String get dialogCancel => 'CANCELAR';

  @override
  String get dialogDelete => 'ELIMINAR';

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
  String get applyInvestment => 'APLICAR A LA CARTERA';

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
      'Este plan incluye ventas. ¿Aplicar las compras y ventas a las cantidades de los activos?';

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
  String get deleted => 'Eliminado';

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
}
