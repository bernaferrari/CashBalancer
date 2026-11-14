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
  String get exportBackup => 'Exportar todos os portfólios';

  @override
  String get importBackup => 'Restaurar backup';

  @override
  String get total => 'Total';

  @override
  String get unitPrice => 'Preço unitário';

  @override
  String get unitPriceHelper =>
      'Preço de uma unidade. Multiplique pela quantidade para obter o total.';

  @override
  String get defaultPortfolio => 'Portfólio #1';

  @override
  String get operationFailed => 'Não foi possível salvar. Tente novamente.';

  @override
  String get confirmSales =>
      'Este plano inclui vendas. Aplicar as compras e vendas às quantidades dos ativos?';

  @override
  String get targetTotalWarning => 'As metas não somam 100%.';

  @override
  String get unallocatedCash => 'Saldo não alocado';

  @override
  String get additionalCash => 'Saldo adicional necessário';

  @override
  String get tradeRequiresPrice =>
      'Defina um preço unitário positivo antes de aplicar as operações.';

  @override
  String get confirmDeleteContents => 'Isso também exclui todo o conteúdo.';

  @override
  String get deleted => 'Excluído';

  @override
  String get undo => 'Desfazer';

  @override
  String get edit => 'Editar';

  @override
  String get pageNotFound => 'Página não encontrada';

  @override
  String get goHome => 'Voltar ao início';

  @override
  String get chooseBackupFile => 'Selecionar arquivo JSON';

  @override
  String get pasteBackup => 'Colar da área de transferência';

  @override
  String get replace => 'Substituir';

  @override
  String get merge => 'Mesclar';

  @override
  String get restoreExplanation =>
      'Mesclar mantém os dados e adiciona os registros que faltam. Substituir sobrescreve todos os portfólios em um backup completo, ou apenas o ativo em um backup antigo.';

  @override
  String get backupRestored => 'Backup restaurado';

  @override
  String get invalidBackup =>
      'Este arquivo não é um backup válido do Cash Balancer.';

  @override
  String get sampleStocks => 'Ações';

  @override
  String get sampleCrypto => 'Cripto';

  @override
  String get sampleCash => 'Dinheiro';

  @override
  String get sampleSavings => 'Poupança de alto rendimento';

  @override
  String get quickPrice => 'Atualizar preço';

  @override
  String get walletsLabel => 'Carteiras';

  @override
  String get enterAmountToApply =>
      'Digite um valor para aplicar as operações. Digite 0 para rebalancear sem adicionar dinheiro.';
}
