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
  String get mainEmptySubtitle => '点击 + 添加钱包，即可在其中管理您的资产。';

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
  String get theAssetsName => '资产名称，例如储蓄或比特币。';

  @override
  String get pressToAdd => '点击 + 添加。';

  @override
  String get rightNow => '当前';

  @override
  String get isGoingToBe => '占比将为';

  @override
  String get howMuchTarget => '您希望该资产达到的目标百分比。';

  @override
  String get optional => '可选';

  @override
  String get totalAmount => '您持有的总金额。';

  @override
  String get value => '价值';

  @override
  String get move => '移动';

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
  String get dialogAssetValue => '价值';

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
  String get portfolioName => '目标名称';

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
  String get exportBackup => '导出 JSON';

  @override
  String get importBackup => '导入 JSON';
}
