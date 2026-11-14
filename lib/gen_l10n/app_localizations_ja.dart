// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Cash Balancer';

  @override
  String get mainEmptyTitle => '最初のウォレットを追加しましょう。';

  @override
  String get mainEmptySubtitle => '＋をタップしてウォレットを作成し、資産を追加できます。';

  @override
  String get mainDialogValidator => 'テキストを入力してください';

  @override
  String get addWallet => 'ウォレット追加';

  @override
  String get addAWallet => 'ウォレットを追加';

  @override
  String get editWallet => 'ウォレットを編集';

  @override
  String get allItems => 'すべての資産';

  @override
  String get targetSettings => '全ウォレットの合計ではなく、各ウォレット内で100%になるように計算します。';

  @override
  String get theAssetsName => '貯金やビットコインなどの資産名。';

  @override
  String get pressToAdd => '＋を押して追加';

  @override
  String get rightNow => '現在';

  @override
  String get isGoingToBe => 'の割合は';

  @override
  String get howMuchTarget => '目標とする割合（%）を設定します。';

  @override
  String get optional => '任意';

  @override
  String get value => '評価額';

  @override
  String get move => '移動';

  @override
  String moveWallet(String itemName) {
    return '「$itemName」を移動';
  }

  @override
  String get addAsset => '資産を追加';

  @override
  String get editAsset => '資産を編集';

  @override
  String get dialogAssetName => '名前';

  @override
  String get dialogAssetTarget => '目標';

  @override
  String get dialogSave => '保存';

  @override
  String get dialogSaveAddMore => '保存して続けて追加';

  @override
  String get dialogCancel => 'キャンセル';

  @override
  String get dialogDelete => '削除';

  @override
  String get settings => '設定';

  @override
  String get currencySymbol => '通貨記号';

  @override
  String get relativeTarget => 'ウォレット内での相対目標';

  @override
  String get sortBy => '並び替え';

  @override
  String get sortBy0 => '金額順';

  @override
  String get sortBy1 => '名前順';

  @override
  String get pleaseEnterCurrency => '通貨記号を入力してください（¥, \$, € など）';

  @override
  String get invalidValue => '数値の形式が正しくありません';

  @override
  String get valueMustBePositive => '正の数値を入力してください';

  @override
  String get targetMustBeBetween => '目標は0〜100の間で入力してください';

  @override
  String get designedDeveloped => 'Designed & developed by Bernardo Ferrari.';

  @override
  String get buyOnlyRebalance => '買い増しのみのリバランス';

  @override
  String get buyOnlyRebalanceSubtitle => '資産を売却せず、追加資金の購入のみでリバランスを計算します。';

  @override
  String get rebalanceCalculator => '投資・リバランス計算';

  @override
  String get amountToInvest => '追加投資額';

  @override
  String get autoFillBuyOnly => '売却なしで均衡する最小額';

  @override
  String get applyInvestment => 'ポートフォリオに反映';

  @override
  String get noTargetsSet => '投資額の配分を計算するには、ウォレットまたは資産に目標割合を設定してください。';

  @override
  String get hold => '維持';

  @override
  String get portfolios => 'ポートフォリオと目標';

  @override
  String get newPortfolio => '新しいポートフォリオ / 目標';

  @override
  String get themeAuto => '自動';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get quantity => '数量';

  @override
  String get loadSamplePortfolio => 'サンプルポートフォリオを読み込む';

  @override
  String get language => '言語';

  @override
  String get exportBackup => 'すべてのポートフォリオをエクスポート';

  @override
  String get importBackup => 'バックアップを復元';

  @override
  String get total => '合計';

  @override
  String get unitPrice => '単価';

  @override
  String get unitPriceHelper => '1単位あたりの価格です。数量を掛けると合計額になります。';

  @override
  String get defaultPortfolio => 'ポートフォリオ #1';

  @override
  String get operationFailed => '変更を保存できませんでした。もう一度お試しください。';

  @override
  String get confirmSales => 'このプランには売却が含まれます。購入と売却を資産の数量に反映しますか？';

  @override
  String get targetTotalWarning => '目標の合計が100%ではありません。';

  @override
  String get unallocatedCash => '未配分の資金';

  @override
  String get additionalCash => '追加で必要な資金';

  @override
  String get tradeRequiresPrice => '取引を適用するには正の単価を設定してください。';

  @override
  String get confirmDeleteContents => '中身もすべて削除されます。';

  @override
  String get deleted => '削除しました';

  @override
  String get undo => '元に戻す';

  @override
  String get edit => '編集';

  @override
  String get pageNotFound => 'ページが見つかりません';

  @override
  String get goHome => 'ホームに戻る';

  @override
  String get chooseBackupFile => 'JSONファイルを選択';

  @override
  String get pasteBackup => 'クリップボードから貼り付け';

  @override
  String get replace => '置換';

  @override
  String get merge => '統合';

  @override
  String get restoreExplanation =>
      '統合では既存データを保持し、不足分を追加します。置換は完全バックアップなら全ポートフォリオ、旧形式なら現在のポートフォリオを上書きします。';

  @override
  String get backupRestored => 'バックアップを復元しました';

  @override
  String get invalidBackup => '有効なCash Balancerのバックアップではありません。';

  @override
  String get sampleStocks => '株式';

  @override
  String get sampleCrypto => '暗号資産';

  @override
  String get sampleCash => '現金';

  @override
  String get sampleSavings => '高金利預金';

  @override
  String get quickPrice => '価格を更新';

  @override
  String get walletsLabel => 'ウォレット';

  @override
  String get enterAmountToApply =>
      '取引を適用するには金額を入力してください。資金を追加せずにリバランスするには 0 を入力してください。';
}
