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
  String get exportBackup => 'Tüm portföyleri dışa aktar';

  @override
  String get importBackup => 'Yedeği geri yükle';

  @override
  String get total => 'Toplam';

  @override
  String get unitPrice => 'Birim fiyat';

  @override
  String get unitPriceHelper =>
      'Bir birimin fiyatı. Toplamı bulmak için miktarla çarpın.';

  @override
  String get defaultPortfolio => 'Portföy #1';

  @override
  String get operationFailed => 'Değişiklik kaydedilemedi. Tekrar deneyin.';

  @override
  String get confirmSales =>
      'Bu plan satış içeriyor. Alış ve satışlar varlık miktarlarına uygulansın mı?';

  @override
  String get targetTotalWarning => 'Hedeflerin toplamı %100 değil.';

  @override
  String get unallocatedCash => 'Ayrılmamış nakit';

  @override
  String get additionalCash => 'Gereken ek nakit';

  @override
  String get tradeRequiresPrice =>
      'İşlemleri uygulamadan önce pozitif birim fiyat girin.';

  @override
  String get confirmDeleteContents => 'İçindeki her şey de silinecek.';

  @override
  String get deleted => 'Silindi';

  @override
  String get undo => 'Geri al';

  @override
  String get edit => 'Düzenle';

  @override
  String get pageNotFound => 'Sayfa bulunamadı';

  @override
  String get goHome => 'Ana sayfaya dön';

  @override
  String get chooseBackupFile => 'JSON dosyası seç';

  @override
  String get pasteBackup => 'Panodan yapıştır';

  @override
  String get replace => 'Değiştir';

  @override
  String get merge => 'Birleştir';

  @override
  String get restoreExplanation =>
      'Birleştirme mevcut verileri korur ve eksik kayıtları ekler. Değiştirme tam yedekte tüm portföylerin, eski yedekte etkin portföyün üzerine yazar.';

  @override
  String get backupRestored => 'Yedek geri yüklendi';

  @override
  String get invalidBackup =>
      'Bu dosya geçerli bir Cash Balancer yedeği değil.';

  @override
  String get sampleStocks => 'Hisseler';

  @override
  String get sampleCrypto => 'Kripto';

  @override
  String get sampleCash => 'Nakit';

  @override
  String get sampleSavings => 'Yüksek getirili tasarruf';

  @override
  String get quickPrice => 'Fiyatı güncelle';

  @override
  String get walletsLabel => 'Cüzdanlar';

  @override
  String get enterAmountToApply =>
      'İşlemleri uygulamak için bir tutar girin. Nakit eklemeden dengelemek için 0 girin.';
}
