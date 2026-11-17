// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Cash Balancer';

  @override
  String get mainEmptyTitle => 'अपना पहला वॉलेट जोड़ें।';

  @override
  String get mainEmptySubtitle =>
      'अपनी संपत्तियों को वॉलेट में बाँटें, हर एक का लक्ष्य तय करें और देखें कि ठीक-ठीक क्या खरीदना या बेचना है।';

  @override
  String get mainDialogValidator => 'कृपया कुछ टेक्स्ट दर्ज करें';

  @override
  String get addWallet => 'वॉलेट जोड़ें';

  @override
  String get addAWallet => 'नया वॉलेट जोड़ें';

  @override
  String get editWallet => 'वॉलेट संपादित करें';

  @override
  String get allItems => 'सभी संपत्तियाँ';

  @override
  String get targetSettings =>
      'सभी वॉलेट के कुल योग के बजाय प्रत्येक वॉलेट में 100% तक जोड़ें।';

  @override
  String get assetNameHint => 'बचत, Bitcoin, AAPL…';

  @override
  String get walletNameHint => 'शेयर, क्रिप्टो, आपातकालीन फंड…';

  @override
  String get pressToAdd => 'जोड़ने के लिए + दबाएँ।';

  @override
  String get howMuchTarget => 'आप इसे कितने प्रतिशत लक्ष्य पर रखना चाहते हैं।';

  @override
  String get value => 'मूल्य';

  @override
  String get move => 'स्थानांतरित करें';

  @override
  String moveWallet(String itemName) {
    return '\"$itemName\" स्थानांतरित करें';
  }

  @override
  String get addAsset => 'संपत्ति जोड़ें';

  @override
  String get editAsset => 'संपत्ति संपादित करें';

  @override
  String get dialogAssetName => 'नाम';

  @override
  String get dialogAssetTarget => 'लक्ष्य';

  @override
  String get dialogSave => 'सहेजें';

  @override
  String get dialogSaveAddMore => 'सहेजें और अधिक जोड़ें';

  @override
  String get dialogCancel => 'रद्द करें';

  @override
  String get dialogDelete => 'हटाएँ';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get currencySymbol => 'मुद्रा';

  @override
  String get relativeTarget => 'सापेक्ष लक्ष्य';

  @override
  String get sortBy => 'क्रमबद्ध करें';

  @override
  String get sortBy0 => 'मूल्य';

  @override
  String get sortBy1 => 'नाम';

  @override
  String get pleaseEnterCurrency =>
      'कृपया मुद्रा चिह्न दर्ज करें (₹, \$, € आदि)';

  @override
  String get invalidValue => 'अमान्य संख्या प्रारूप';

  @override
  String get valueMustBePositive => 'मूल्य धनात्मक होना चाहिए';

  @override
  String get targetMustBeBetween => 'लक्ष्य 0 और 100 के बीच होना चाहिए';

  @override
  String get designedDeveloped => 'Bernardo Ferrari द्वारा डिज़ाइन और विकसित।';

  @override
  String get buyOnlyRebalance => 'केवल खरीद रीबैलेंसिंग';

  @override
  String get buyOnlyRebalanceSubtitle =>
      'किसी भी संपत्ति को बेचे बिना केवल नई नकदी से रीबैलेंस करें।';

  @override
  String get rebalanceCalculator => 'निवेश और रीबैलेंस';

  @override
  String get amountToInvest => 'निवेश करने की राशि';

  @override
  String get autoFillBuyOnly => 'बिना बेचे संतुलन के लिए न्यूनतम';

  @override
  String get applyInvestment => 'पोर्टफोलियो में लागू करें';

  @override
  String get noTargetsSet =>
      'निवेश वितरण की गणना करने के लिए अपने वॉलेट या संपत्तियों पर लक्ष्य प्रतिशत निर्धारित करें।';

  @override
  String get hold => 'होल्ड';

  @override
  String get portfolios => 'पोर्टफोलियो और लक्ष्य';

  @override
  String get newPortfolio => 'नया पोर्टफोलियो / लक्ष्य';

  @override
  String get themeAuto => 'ऑटो';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get quantity => 'मात्रा';

  @override
  String get loadSamplePortfolio => 'उदाहरण पोर्टफोलियो लोड करें';

  @override
  String get language => 'भाषा';

  @override
  String get exportBackup => 'सभी पोर्टफ़ोलियो निर्यात करें';

  @override
  String get importBackup => 'बैकअप बहाल करें';

  @override
  String get total => 'कुल';

  @override
  String get unitPrice => 'प्रति इकाई मूल्य';

  @override
  String get unitPriceHelper =>
      'कुल मूल्य के लिए एक इकाई की कीमत को मात्रा से गुणा करें।';

  @override
  String get defaultPortfolio => 'पोर्टफ़ोलियो #1';

  @override
  String get operationFailed => 'बदलाव सहेजा नहीं जा सका। फिर से कोशिश करें।';

  @override
  String get confirmSales =>
      'इस योजना में बिक्री शामिल है। क्या Cash Balancer में शेष और मात्रा अपडेट करें?';

  @override
  String get targetTotalWarning => 'लक्ष्यों का योग 100% नहीं है।';

  @override
  String get unallocatedCash => 'बिना आवंटन की नकदी';

  @override
  String get additionalCash => 'अतिरिक्त नकदी चाहिए';

  @override
  String get tradeRequiresPrice =>
      'लेन-देन लागू करने से पहले शून्य से अधिक इकाई मूल्य दर्ज करें।';

  @override
  String get confirmDeleteContents => 'इसकी सारी सामग्री भी हट जाएगी।';

  @override
  String deleted(String name) {
    return '$name हटा दिया गया';
  }

  @override
  String get undo => 'पहले जैसा करें';

  @override
  String get edit => 'संपादित करें';

  @override
  String get pageNotFound => 'पेज नहीं मिला';

  @override
  String get goHome => 'होम पर लौटें';

  @override
  String get chooseBackupFile => 'JSON फ़ाइल चुनें';

  @override
  String get pasteBackup => 'क्लिपबोर्ड से चिपकाएँ';

  @override
  String get replace => 'बदलें';

  @override
  String get merge => 'मिलाएँ';

  @override
  String get restoreExplanation =>
      'मिलाने पर मौजूदा डेटा रहता है और छूटी प्रविष्टियाँ जुड़ती हैं। बदलने पर पूर्ण बैकअप सभी पोर्टफ़ोलियो को और पुराना बैकअप सक्रिय पोर्टफ़ोलियो को बदल देता है।';

  @override
  String get backupRestored => 'बैकअप बहाल हो गया';

  @override
  String get invalidBackup => 'यह Cash Balancer की मान्य बैकअप फ़ाइल नहीं है।';

  @override
  String get sampleStocks => 'शेयर';

  @override
  String get sampleCrypto => 'क्रिप्टो';

  @override
  String get sampleCash => 'नकदी';

  @override
  String get sampleSavings => 'उच्च ब्याज वाली बचत';

  @override
  String get quickPrice => 'कीमत बदलें';

  @override
  String get walletsLabel => 'वॉलेट';

  @override
  String get enterAmountToApply =>
      'जो पहले से है उसी को पुनर्संतुलित करने के लिए खाली छोड़ें।';

  @override
  String get balanceOnly => 'नकद शेष के रूप में दर्ज करें';

  @override
  String get balance => 'शेष';

  @override
  String get updateBalance => 'शेष अपडेट करें';

  @override
  String mergePreview(int added, int kept) {
    return 'मिलाने पर $added रिकॉर्ड जुड़ेंगे और $kept मौजूदा रिकॉर्ड रहेंगे। मेल खाने वाले रिकॉर्ड के वर्तमान मान बने रहेंगे। पुराने बैकअप में पोर्टफ़ोलियो और वॉलेट के भीतर नाम से मिलान होता है।';
  }

  @override
  String get now => 'अभी';

  @override
  String get after => 'बाद में';

  @override
  String get buy => 'खरीदें';

  @override
  String get sell => 'बेचें';

  @override
  String get preferences => 'प्राथमिकताएँ';

  @override
  String get appearance => 'रूप';

  @override
  String get backup => 'बैकअप';

  @override
  String get sampleDescription => 'आज़माने के लिए स्टॉक, क्रिप्टो और नकद';

  @override
  String targetAssigned(String percent) {
    return '100% में से $percent तय';
  }

  @override
  String get useAmount => 'उपयोग करें';

  @override
  String get noTarget => 'कोई नहीं';

  @override
  String get balanceOnlySubtitle =>
      'बचत या नकद के लिए: केवल शेष राशि, कोई इकाई नहीं।';

  @override
  String get currentWallet => 'वर्तमान';
}
