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
  String get totalAmount => 'La cantidad total que posees.';

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
  String get dialogAssetValue => 'Valor';

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
  String get portfolioName => 'Nombre del objetivo';

  @override
  String get themeAuto => 'Auto';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';
}
