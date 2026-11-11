// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Cash Balancer';

  @override
  String get mainEmptyTitle => 'Adicione a sua primeira carteira';

  @override
  String get mainEmptySubtitle =>
      'Toque no + para adicionar uma carteira, onde você vai poder adicionar os seus ativos.';

  @override
  String get mainDialogValidator => 'Por favor digite algo';

  @override
  String get addWallet => 'Adicionar Carteira';

  @override
  String get addAWallet => 'Adicionar uma Carteira';

  @override
  String get editWallet => 'Editar Carteira';

  @override
  String get allItems => 'Todos os itens';

  @override
  String get targetSettings =>
      'Somar até 100% em cada carteira, em vez de considerar a soma total de todas as carteiras.';

  @override
  String get theAssetsName => 'O nome do ativo, como poupança ou bitcoin.';

  @override
  String get pressToAdd => 'Toque no + para adicionar.';

  @override
  String get rightNow => 'Agora';

  @override
  String get isGoingToBe => 'será';

  @override
  String get howMuchTarget => 'A porcentagem alvo que você desejar.';

  @override
  String get optional => 'OPCIONAL';

  @override
  String get totalAmount => 'A quantia total que você possui.';

  @override
  String get value => 'Valor';

  @override
  String get move => 'Mover';

  @override
  String moveWallet(String itemName) {
    return 'Mover \"$itemName\"';
  }

  @override
  String get addAsset => 'Adicionar Ativo';

  @override
  String get editAsset => 'Editar Ativo';

  @override
  String get dialogAssetName => 'Nome';

  @override
  String get dialogAssetValue => 'Valor';

  @override
  String get dialogAssetTarget => 'Alvo';

  @override
  String get dialogSave => 'SALVAR';

  @override
  String get dialogSaveAddMore => 'SALVAR E ADICIONAR MAIS';

  @override
  String get dialogCancel => 'CANCELAR';

  @override
  String get dialogDelete => 'DELETAR';

  @override
  String get settings => 'Configurações';

  @override
  String get currencySymbol => 'Moeda';

  @override
  String get relativeTarget => 'Alvo relativo';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get sortBy0 => 'Valor';

  @override
  String get sortBy1 => 'Nome';

  @override
  String get pleaseEnterCurrency => 'Por favor digite uma moeda (\$, €, etc.)';

  @override
  String get invalidValue => 'Formato de número inválido';

  @override
  String get valueMustBePositive => 'O valor deve ser positivo';

  @override
  String get targetMustBeBetween => 'O alvo deve estar entre 0 e 100';

  @override
  String get designedDeveloped =>
      'Desenhado e desenvolvido por Bernardo Ferrari.';

  @override
  String get buyOnlyRebalance => 'Apenas Comprar (Sem Vendas)';

  @override
  String get buyOnlyRebalanceSubtitle =>
      'Rebalanceie usando apenas novos aportes, sem vender ativos acima do alvo.';

  @override
  String get rebalanceCalculator => 'Investir e Rebalancear';

  @override
  String get amountToInvest => 'Valor para investir';

  @override
  String get autoFillBuyOnly => 'Mín. para equilibrar sem vender';

  @override
  String get applyInvestment => 'APLICAR APORTE';

  @override
  String get noTargetsSet =>
      'Defina porcentagens alvo nas suas carteiras ou ativos para calcular a distribuição do aporte.';

  @override
  String get hold => 'Manter';

  @override
  String get portfolios => 'Portfólios e Objetivos';

  @override
  String get newPortfolio => 'Novo Portfólio / Objetivo';

  @override
  String get portfolioName => 'Nome do objetivo';

  @override
  String get themeAuto => 'Auto';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get quantity => 'Quantidade';

  @override
  String get loadSamplePortfolio => 'Carregar carteira de exemplo';

  @override
  String get language => 'Idioma';

  @override
  String get exportBackup => 'Exportar JSON';

  @override
  String get importBackup => 'Importar JSON';
}
