// Runs only on a disposable emulator: the studio clears app data for each profile.
export default {
  app: 'com.bernaferrari.cash_balancer',
  activity: '.MainActivity',
  animations: false,
  scenes: { light: {
    '01-portfolio': d => d.tap('Load sample portfolio'),
    '02-rebalance': async d => { await d.tap('Invest & Rebalance'); await d.tap(/\+\$500/); },
    '03-buy-only': d => d.tap(/Buy-only rebalancing.*/s),
    '04-assets': async d => { await d.launch(); await d.tap(/All items.*/s); },
    '05-wallet': async d => { await d.launch(); await d.tap(/Edit a Wallet\s+STOCKS.*/s); },
    '06-asset': async d => { await d.launch(); await d.tap(/S&P 500 ETF.*/s); await d.back(); },
    '07-portfolios': async d => { await d.launch(); await d.tap('Portfolio #1'); },
    '08-settings': async d => { await d.launch(); await d.tap('Settings'); },
  } },
};
