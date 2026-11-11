// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Cash Balancer';

  @override
  String get mainEmptyTitle => 'İlk cüzdanınızı ekleyin.';

  @override
  String get mainEmptySubtitle =>
      'Varlıklarınızı ekleyebileceğiniz bir cüzdan oluşturmak için + düğmesine dokunun.';

  @override
  String get mainDialogValidator => 'Lütfen bir metin girin';

  @override
  String get addWallet => 'Cüzdan Ekle';

  @override
  String get addAWallet => 'Bir Cüzdan Ekle';

  @override
  String get editWallet => 'Cüzdanı Düzenle';

  @override
  String get allItems => 'Tüm varlıklar';

  @override
  String get targetSettings =>
      'Tüm cüzdanların toplamı yerine her cüzdanın kendi içinde %100\'e ulaşmasını hesapla.';

  @override
  String get theAssetsName => 'Birikim veya bitcoin gibi varlık adı.';

  @override
  String get pressToAdd => 'Eklemek için + düğmesine basın.';

  @override
  String get rightNow => 'Şu anda';

  @override
  String get isGoingToBe => 'oranı:';

  @override
  String get howMuchTarget => 'Olmasını istediğiniz hedef yüzde.';

  @override
  String get optional => 'İSTEĞE BAĞLI';

  @override
  String get totalAmount => 'Sahip olduğunuz toplam tutar.';

  @override
  String get value => 'Değer';

  @override
  String get move => 'Taşı';

  @override
  String moveWallet(String itemName) {
    return '\"$itemName\" öğesini taşı';
  }

  @override
  String get addAsset => 'Varlık Ekle';

  @override
  String get editAsset => 'Varlığı Düzenle';

  @override
  String get dialogAssetName => 'Ad';

  @override
  String get dialogAssetValue => 'Değer';

  @override
  String get dialogAssetTarget => 'Hedef';

  @override
  String get dialogSave => 'KAYDET';

  @override
  String get dialogSaveAddMore => 'KAYDET VE DAHA FAZLA EKLE';

  @override
  String get dialogCancel => 'İPTAL';

  @override
  String get dialogDelete => 'SİL';

  @override
  String get settings => 'Ayarlar';

  @override
  String get currencySymbol => 'Para Birimi';

  @override
  String get relativeTarget => 'Göreli Hedef';

  @override
  String get sortBy => 'Sırala';

  @override
  String get sortBy0 => 'Değer';

  @override
  String get sortBy1 => 'Ad';

  @override
  String get pleaseEnterCurrency => 'Lütfen para birimini girin (₺, \$, € vb.)';

  @override
  String get invalidValue => 'Geçersiz sayı biçimi';

  @override
  String get valueMustBePositive => 'Değer pozitif olmalıdır';

  @override
  String get targetMustBeBetween => 'Hedef 0 ile 100 arasında olmalıdır';

  @override
  String get designedDeveloped =>
      'Bernardo Ferrari tarafından tasarlandı ve geliştirildi.';

  @override
  String get buyOnlyRebalance => 'Yalnızca Alım ile Dengeleme';

  @override
  String get buyOnlyRebalanceSubtitle =>
      'Hiçbir varlığı satmadan yalnızca yeni nakit alımıyla portföyü dengeleyin.';

  @override
  String get rebalanceCalculator => 'Yatırım Yap ve Dengele';

  @override
  String get amountToInvest => 'Yatırılacak tutar';

  @override
  String get autoFillBuyOnly => 'Satış yapmadan dengelemek için min.';

  @override
  String get applyInvestment => 'PORTFÖYE UYGULA';

  @override
  String get noTargetsSet =>
      'Yatırımınızın nasıl dağıtılacağını hesaplamak için cüzdan veya varlıklarınıza hedef yüzde belirleyin.';

  @override
  String get hold => 'Tut';

  @override
  String get portfolios => 'Portföyler ve Hedefler';

  @override
  String get newPortfolio => 'Yeni Portföy / Hedef';

  @override
  String get portfolioName => 'Portföy adı';

  @override
  String get themeAuto => 'Otomatik';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get quantity => 'Miktar';

  @override
  String get loadSamplePortfolio => 'Örnek portföy yükle';

  @override
  String get language => 'Dil';

  @override
  String get exportBackup => 'JSON Dışa Aktar';

  @override
  String get importBackup => 'JSON İçe Aktar';
}
