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
  String get exportBackup => 'Экспортировать все портфели';

  @override
  String get importBackup => 'Восстановить копию';

  @override
  String get total => 'Итого';

  @override
  String get unitPrice => 'Цена за единицу';

  @override
  String get unitPriceHelper =>
      'Умножьте цену за единицу на количество, чтобы получить общую стоимость.';

  @override
  String get defaultPortfolio => 'Портфель № 1';

  @override
  String get operationFailed =>
      'Не удалось сохранить изменения. Попробуйте ещё раз.';

  @override
  String get confirmSales =>
      'В плане есть продажи. Применить покупки и продажи к количеству активов?';

  @override
  String get targetTotalWarning => 'Сумма целевых долей не равна 100 %.';

  @override
  String get unallocatedCash => 'Нераспределённые средства';

  @override
  String get additionalCash => 'Нужны дополнительные средства';

  @override
  String get tradeRequiresPrice =>
      'Для применения сделок укажите положительную цену за единицу.';

  @override
  String get confirmDeleteContents => 'Всё содержимое также будет удалено.';

  @override
  String get deleted => 'Удалено';

  @override
  String get undo => 'Отменить';

  @override
  String get edit => 'Изменить';

  @override
  String get pageNotFound => 'Страница не найдена';

  @override
  String get goHome => 'На главную';

  @override
  String get chooseBackupFile => 'Выбрать файл JSON';

  @override
  String get pasteBackup => 'Вставить из буфера обмена';

  @override
  String get replace => 'Заменить';

  @override
  String get merge => 'Объединить';

  @override
  String get restoreExplanation =>
      'Объединение сохраняет данные и добавляет недостающие записи. Замена перезаписывает все портфели из полной копии или текущий портфель из старой копии.';

  @override
  String get backupRestored => 'Копия восстановлена';

  @override
  String get invalidBackup =>
      'Это недействительная резервная копия Cash Balancer.';

  @override
  String get sampleStocks => 'Акции';

  @override
  String get sampleCrypto => 'Криптовалюта';

  @override
  String get sampleCash => 'Наличные';

  @override
  String get sampleSavings => 'Высокодоходные сбережения';

  @override
  String get quickPrice => 'Обновить цену';
}
