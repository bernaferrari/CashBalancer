// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Cash Balancer';

  @override
  String get mainEmptyTitle => '첫 번째 지갑을 추가하세요.';

  @override
  String get mainEmptySubtitle => '+ 버튼을 눌러 지갑을 만들고 자산을 추가해 보세요.';

  @override
  String get mainDialogValidator => '텍스트를 입력해 주세요';

  @override
  String get addWallet => '지갑 추가';

  @override
  String get addAWallet => '새 지갑 추가';

  @override
  String get editWallet => '지갑 편집';

  @override
  String get allItems => '모든 자산';

  @override
  String get targetSettings => '전체 지갑 합계가 아닌 각 지갑 내부에서 합계가 100%가 되도록 계산합니다.';

  @override
  String get theAssetsName => '예금이나 비트코인 같은 자산 이름입니다.';

  @override
  String get pressToAdd => '+ 버튼을 눌러 추가하세요.';

  @override
  String get rightNow => '현재';

  @override
  String get isGoingToBe => '예상 비중:';

  @override
  String get howMuchTarget => '원하는 목표 비중(%)을 설정하세요.';

  @override
  String get optional => '선택사항';

  @override
  String get totalAmount => '보유 중인 총 금액입니다.';

  @override
  String get value => '금액';

  @override
  String get move => '이동';

  @override
  String moveWallet(String itemName) {
    return '\"$itemName\" 이동';
  }

  @override
  String get addAsset => '자산 추가';

  @override
  String get editAsset => '자산 편집';

  @override
  String get dialogAssetName => '이름';

  @override
  String get dialogAssetValue => '금액';

  @override
  String get dialogAssetTarget => '목표';

  @override
  String get dialogSave => '저장';

  @override
  String get dialogSaveAddMore => '저장 후 계속 추가';

  @override
  String get dialogCancel => '취소';

  @override
  String get dialogDelete => '삭제';

  @override
  String get settings => '설정';

  @override
  String get currencySymbol => '통화 기호';

  @override
  String get relativeTarget => '상대적 목표 비중';

  @override
  String get sortBy => '정렬 기준';

  @override
  String get sortBy0 => '금액순';

  @override
  String get sortBy1 => '이름순';

  @override
  String get pleaseEnterCurrency => '통화 기호를 입력하세요 (₩, \$, € 등)';

  @override
  String get invalidValue => '유효하지 않은 숫자 형식입니다';

  @override
  String get valueMustBePositive => '값은 0 이상이어야 합니다';

  @override
  String get targetMustBeBetween => '목표 비중은 0에서 100 사이여야 합니다';

  @override
  String get designedDeveloped => 'Designed & developed by Bernardo Ferrari.';

  @override
  String get buyOnlyRebalance => '매수 전용 리밸런싱';

  @override
  String get buyOnlyRebalanceSubtitle => '초과 자산을 매도하지 않고 신규 투자금 매수만으로 리밸런싱합니다.';

  @override
  String get rebalanceCalculator => '투자 및 리밸런싱 계산기';

  @override
  String get amountToInvest => '투자할 금액';

  @override
  String get autoFillBuyOnly => '매도 없이 균형을 맞추는 최소 금액';

  @override
  String get applyInvestment => '포트폴리오에 반영';

  @override
  String get noTargetsSet => '투자금 배분을 계산하려면 지갑이나 자산에 목표 비중을 설정하세요.';

  @override
  String get hold => '유지';

  @override
  String get portfolios => '포트폴리오 및 목표';

  @override
  String get newPortfolio => '새 포트폴리오 / 목표';

  @override
  String get portfolioName => '포트폴리오 이름';

  @override
  String get themeAuto => '자동';

  @override
  String get themeLight => '라이트';

  @override
  String get themeDark => '다크';

  @override
  String get quantity => '수량';

  @override
  String get loadSamplePortfolio => '샘플 포트폴리오 불러오기';

  @override
  String get language => '언어';

  @override
  String get exportBackup => 'JSON 내보내기';

  @override
  String get importBackup => 'JSON 가져오기';
}
