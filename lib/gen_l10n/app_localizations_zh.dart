// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Cash Balancer';

  @override
  String get mainEmptyTitle => '添加您的第一个钱包。';

  @override
  String get mainEmptySubtitle => '将资产分组到钱包中，为每个钱包设定目标，即可清楚看到该买入或卖出什么。';

  @override
  String get mainDialogValidator => '请输入内容';

  @override
  String get addWallet => '添加钱包';

  @override
  String get addAWallet => '添加一个钱包';

  @override
  String get editWallet => '编辑钱包';

  @override
  String get allItems => '所有资产';

  @override
  String get targetSettings => '在每个钱包内部合计达到 100%，而不是按所有钱包的总和计算。';

  @override
  String get assetNameHint => '储蓄, Bitcoin, AAPL…';

  @override
  String get walletNameHint => '股票、加密货币、应急资金…';

  @override
  String get pressToAdd => '点击 + 添加。';

  @override
  String get howMuchTarget => '您希望该资产达到的目标百分比。';

  @override
  String get value => '价值';

  @override
  String get move => '移动';

  @override
  String assetMoved(String itemName, String walletName) {
    return '已将 $itemName 移至 $walletName';
  }

  @override
  String moveWallet(String itemName) {
    return '移动“$itemName”';
  }

  @override
  String get addAsset => '添加资产';

  @override
  String get editAsset => '编辑资产';

  @override
  String get dialogAssetName => '名称';

  @override
  String get dialogAssetTarget => '目标';

  @override
  String get dialogSave => '保存';

  @override
  String get dialogSaveAddMore => '保存并继续添加';

  @override
  String get dialogCancel => '取消';

  @override
  String get dialogDelete => '删除';

  @override
  String get settings => '设置';

  @override
  String get currencySymbol => '货币符号';

  @override
  String get relativeTarget => '相对目标';

  @override
  String get sortBy => '排序方式';

  @override
  String get sortBy0 => '按价值';

  @override
  String get sortBy1 => '按名称';

  @override
  String get pleaseEnterCurrency => '请输入货币符号（¥、\$、€ 等）';

  @override
  String get invalidValue => '数字格式无效';

  @override
  String get valueMustBePositive => '数值必须为正数';

  @override
  String get targetMustBeBetween => '目标必须在 0 到 100 之间';

  @override
  String get designedDeveloped => '由 Bernardo Ferrari 设计与开发。';

  @override
  String get buyOnlyRebalance => '仅买入再平衡';

  @override
  String get buyOnlyRebalanceSubtitle => '仅使用新增资金买入进行再平衡，不卖出任何超配资产。';

  @override
  String get rebalanceCalculator => '投资与再平衡计算器';

  @override
  String get amountToInvest => '计划投资金额';

  @override
  String get autoFillBuyOnly => '不卖出实现平衡的最低金额';

  @override
  String get applyInvestment => '应用到投资组合';

  @override
  String get noTargetsSet => '请先为钱包或资产设置目标百分比，以计算新增资金的分配方案。';

  @override
  String get hold => '持有';

  @override
  String get portfolios => '投资组合与目标';

  @override
  String get newPortfolio => '新建投资组合 / 目标';

  @override
  String get themeAuto => '自动';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get quantity => '数量';

  @override
  String get loadSamplePortfolio => '加载示例投资组合';

  @override
  String get language => '语言';

  @override
  String get exportBackup => '导出所有投资组合';

  @override
  String get importBackup => '恢复备份';

  @override
  String get total => '总计';

  @override
  String get unitPrice => '单价';

  @override
  String get unitPriceHelper => '每单位的价格。乘以数量即可得到总值。';

  @override
  String get defaultPortfolio => '投资组合 #1';

  @override
  String get operationFailed => '无法保存更改，请重试。';

  @override
  String get confirmSales => '此方案包含卖出。要应用方案并更新 Cash Balancer 中的余额和数量吗？';

  @override
  String get targetTotalWarning => '目标比例之和不等于 100%。';

  @override
  String get unallocatedCash => '未分配资金';

  @override
  String get additionalCash => '还需资金';

  @override
  String get tradeRequiresPrice => '应用交易前，请设置大于零的单价。';

  @override
  String get confirmDeleteContents => '其中所有内容也会被删除。';

  @override
  String deleted(String name) {
    return '已删除 $name';
  }

  @override
  String get undo => '撤销';

  @override
  String get edit => '编辑';

  @override
  String get pageNotFound => '找不到页面';

  @override
  String get goHome => '返回首页';

  @override
  String get chooseBackupFile => '选择 JSON 文件';

  @override
  String get pasteBackup => '从剪贴板粘贴';

  @override
  String get replace => '替换';

  @override
  String get merge => '合并';

  @override
  String get restoreExplanation =>
      '合并会保留现有数据并补充缺失条目。替换会使用完整备份覆盖所有投资组合，或使用旧版备份覆盖当前投资组合。';

  @override
  String get backupRestored => '备份已恢复';

  @override
  String get invalidBackup => '此文件不是有效的 Cash Balancer 备份。';

  @override
  String get sampleStocks => '股票';

  @override
  String get sampleCrypto => '加密货币';

  @override
  String get sampleCash => '现金';

  @override
  String get sampleSavings => '高收益储蓄';

  @override
  String get quickPrice => '更新价格';

  @override
  String get walletsLabel => '钱包';

  @override
  String get enterAmountToApply => '留空则仅用现有资产进行再平衡。';

  @override
  String get balanceOnly => '按现金余额记录';

  @override
  String get balance => '余额';

  @override
  String get updateBalance => '更新余额';

  @override
  String mergePreview(int added, int kept) {
    return '合并会新增 $added 条记录并保留 $kept 条现有记录。匹配记录保留当前数值。旧版备份按投资组合和钱包中的名称匹配。';
  }

  @override
  String get now => '当前';

  @override
  String get after => '调整后';

  @override
  String get buy => '买入';

  @override
  String get sell => '卖出';

  @override
  String get preferences => '偏好设置';

  @override
  String get appearance => '外观';

  @override
  String get backup => '备份';

  @override
  String get sampleDescription => '用股票、加密货币和现金体验一下';

  @override
  String targetAssigned(String percent) {
    return '已分配 $percent / 100%';
  }

  @override
  String get amountEntered => '已填入金额';

  @override
  String get useAmount => '使用';

  @override
  String get noTarget => '无';

  @override
  String get balanceOnlySubtitle => '适用于储蓄或现金：只记余额，不计数量。';

  @override
  String get currentWallet => '当前';
}
