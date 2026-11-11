// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Cash Balancer';

  @override
  String get mainEmptyTitle => 'Добавьте свой первый кошелёк.';

  @override
  String get mainEmptySubtitle =>
      'Нажмите +, чтобы создать кошелёк и добавить в него свои активы.';

  @override
  String get mainDialogValidator => 'Пожалуйста, введите текст';

  @override
  String get addWallet => 'Добавить кошелёк';

  @override
  String get addAWallet => 'Новый кошелёк';

  @override
  String get editWallet => 'Изменить кошелёк';

  @override
  String get allItems => 'Все активы';

  @override
  String get targetSettings =>
      'Считать 100% внутри каждого кошелька отдельно, а не от общей суммы всех кошельков.';

  @override
  String get theAssetsName =>
      'Название актива, например сбережения или биткоин.';

  @override
  String get pressToAdd => 'Нажмите +, чтобы добавить.';

  @override
  String get rightNow => 'Сейчас';

  @override
  String get isGoingToBe => 'составит';

  @override
  String get howMuchTarget => 'Желаемая целевая доля в процентах.';

  @override
  String get optional => 'ОПЦИОНАЛЬНО';

  @override
  String get totalAmount => 'Общая сумма, которой вы владеете.';

  @override
  String get value => 'Сумма';

  @override
  String get move => 'Переместить';

  @override
  String moveWallet(String itemName) {
    return 'Переместить «$itemName»';
  }

  @override
  String get addAsset => 'Добавить актив';

  @override
  String get editAsset => 'Изменить актив';

  @override
  String get dialogAssetName => 'Название';

  @override
  String get dialogAssetValue => 'Сумма';

  @override
  String get dialogAssetTarget => 'Цель';

  @override
  String get dialogSave => 'СОХРАНИТЬ';

  @override
  String get dialogSaveAddMore => 'СОХРАНИТЬ И ДОБАВИТЬ ЕЩЁ';

  @override
  String get dialogCancel => 'ОТМЕНА';

  @override
  String get dialogDelete => 'УДАЛИТЬ';

  @override
  String get settings => 'Настройки';

  @override
  String get currencySymbol => 'Валюта';

  @override
  String get relativeTarget => 'Относительная цель';

  @override
  String get sortBy => 'Сортировка';

  @override
  String get sortBy0 => 'По сумме';

  @override
  String get sortBy1 => 'По имени';

  @override
  String get pleaseEnterCurrency => 'Введите символ валюты (₽, \$, € и т. д.)';

  @override
  String get invalidValue => 'Неверный формат числа';

  @override
  String get valueMustBePositive => 'Значение должно быть положительным';

  @override
  String get targetMustBeBetween => 'Цель должна быть от 0 до 100';

  @override
  String get designedDeveloped => 'Дизайн и разработка: Bernardo Ferrari.';

  @override
  String get buyOnlyRebalance => 'Ребалансировка только покупкой';

  @override
  String get buyOnlyRebalanceSubtitle =>
      'Ребалансируйте портфель только за счёт новых вложений, без продажи активов.';

  @override
  String get rebalanceCalculator => 'Инвестиции и ребалансировка';

  @override
  String get amountToInvest => 'Сумма для инвестирования';

  @override
  String get autoFillBuyOnly => 'Мин. для баланса без продаж';

  @override
  String get applyInvestment => 'ПРИМЕНИТЬ К ПОРТФЕЛЮ';

  @override
  String get noTargetsSet =>
      'Укажите целевые проценты для кошельков или активов, чтобы рассчитать распределение средств.';

  @override
  String get hold => 'Держать';

  @override
  String get portfolios => 'Портфели и цели';

  @override
  String get newPortfolio => 'Новый портфель / цель';

  @override
  String get portfolioName => 'Название портфеля';

  @override
  String get themeAuto => 'Авто';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get quantity => 'Количество';

  @override
  String get loadSamplePortfolio => 'Загрузить пример портфеля';

  @override
  String get language => 'Язык';

  @override
  String get exportBackup => 'Экспорт JSON';

  @override
  String get importBackup => 'Импорт JSON';
}
