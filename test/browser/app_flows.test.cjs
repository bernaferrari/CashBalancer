const assert = require('node:assert/strict');
const {createServer} = require('node:http');
const {createReadStream} = require('node:fs');
const {readFile, stat} = require('node:fs/promises');
const {resolve, extname, sep} = require('node:path');
const {after, before, test} = require('node:test');
const {chromium} = require('playwright-core');

const web = resolve(__dirname, '../../build/web');
let server;
let browser;
let origin;

before(async () => {
  await stat(resolve(web, 'index.html'));
  const types = {
    '.html': 'text/html', '.js': 'text/javascript', '.json': 'application/json',
    '.wasm': 'application/wasm', '.css': 'text/css', '.ttf': 'font/ttf',
  };
  server = createServer(async (request, response) => {
    const path = decodeURIComponent(new URL(request.url, 'http://localhost').pathname);
    const file = resolve(web, '.' + (path === '/' ? '/index.html' : path));
    const info = file.startsWith(web + sep) && await stat(file).catch(() => null);
    if (!info?.isFile()) {
      response.writeHead(404).end();
      return;
    }
    response.setHeader('Content-Type', types[extname(file)] || 'application/octet-stream');
    createReadStream(file).pipe(response);
  });
  await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
  origin = 'http://127.0.0.1:' + server.address().port;
  browser = await chromium.launch({channel: 'chrome'});
});

after(async () => {
  await browser?.close();
  server?.close();
});

const button = (page, name) => page.getByRole('button', {name, exact: true});
const total = (page, amount) => page.getByRole('heading', {name: amount});
const file = body => ({
  name: 'cash-balancer-backup.json', mimeType: 'application/json',
  buffer: Buffer.from(body),
});

async function withApp(t, run) {
  const page = await browser.newPage({acceptDownloads: true, locale: 'en-US'});
  t.after(() => page.close());
  page.setDefaultTimeout(15000);
  const exceptions = [];
  page.on('pageerror', error => exceptions.push(error.message));
  await page.goto(origin);
  await page.locator('flt-semantics-placeholder').evaluate(element => element.click());
  await button(page, 'Load sample portfolio').waitFor();
  try {
    await run(page);
  } catch (error) {
    t.diagnostic(await page.locator('body').ariaSnapshot().catch(() => 'Page unavailable'));
    throw error;
  }
  assert.deepEqual(exceptions, []);
}

async function settings(page) {
  await button(page, 'Settings').click();
  await page.getByRole('heading', {name: 'Settings', exact: true}).waitFor();
}

async function download(page) {
  const [result] = await Promise.all([
    page.waitForEvent('download'), button(page, 'Export all portfolios').click(),
  ]);
  return readFile(await result.path(), 'utf8');
}

async function selectBackup(page, json) {
  await button(page, 'Restore backup').click();
  const [picker] = await Promise.all([
    page.waitForEvent('filechooser'), button(page, 'Choose JSON file').click(),
  ]);
  await picker.setFiles(file(json));
}

async function recordDeletionMessages(page) {
  await page.evaluate(() => {
    const watched = /Page not found|Couldn't save the change/;
    window.deleteMessages = [];
    new MutationObserver(records => {
      for (const record of records) {
        const nodes = record.type === 'characterData'
          ? [record.target] : [...record.addedNodes, ...record.removedNodes];
        for (const node of nodes) {
          if (watched.test(node.textContent)) window.deleteMessages.push(node.textContent);
        }
      }
    }).observe(document.body, {subtree: true, childList: true, characterData: true});
  });
}

for (const wallet of [false, true]) {
  test(`delete and Undo ${wallet ? 'a wallet' : 'an asset'}`, t => withApp(t, async page => {
    await button(page, 'Load sample portfolio').click();
    await total(page, /10,460/).waitFor();
    const editor = wallet ? 'Edit a Wallet' : 'Edit an Asset';
    // The first wallet and the first asset both belong to Stocks.
    if (wallet) {
      const stocks = page.getByRole('group', {name: /^STOCKS/});
      await button(stocks, 'Edit a Wallet').click();
    } else {
      await page.getByRole('button', {name: /^S&P 500 ETF/}).click();
    }
    await page.getByRole('heading', {name: editor}).waitFor();
    await recordDeletionMessages(page);
    await button(page, 'Delete').click();
    if (wallet) await page.getByRole('alertdialog').getByRole('button', {name: 'Delete'}).click();
    await total(page, wallet ? /4,500/ : /6,260/).waitFor();
    await button(page, 'Undo').click();
    await total(page, /10,460/).waitFor();
    await button(page, 'Undo').waitFor({state: 'hidden'});
    assert.deepEqual(await page.evaluate(() => window.deleteMessages), []);
  }));
}

test('backup preview keeps the edited price and malformed files keep the portfolio intact', t => withApp(t, async page => {
  await button(page, 'Load sample portfolio').click();
  await total(page, /10,460/).waitFor();
  await settings(page);
  const backup = await download(page);
  await button(page, 'Back').click();
  await total(page, /10,460/).waitFor();
  await button(page, 'Update price').first().click();
  await page.getByRole('textbox', {name: 'Unit price'}).fill('5000');
  await button(page, 'Save').click();
  await total(page, /11,260/).waitFor();
  await settings(page);
  await selectBackup(page, backup);
  await page.getByText(/Merge adds 0 records and keeps 9 existing records/).waitFor({state: 'attached'});
  await button(page, 'Merge').click();
  await page.getByText('Backup restored').first().waitFor({state: 'attached'});
  const merged = JSON.parse(await download(page));
  const stocks = merged.portfolios[0].wallets.find(wallet => wallet.name === 'Stocks');
  assert.equal(stocks.items.find(item => item.name === 'S&P 500 ETF').price, 5000);
  assert.equal(merged.portfolios[0].wallets.length, 3);
  await selectBackup(page, '{broken');
  await page.getByText(/valid Cash Balancer backup/).first().waitFor({state: 'attached'});
  assert.deepEqual(JSON.parse(await download(page)), merged);
  await button(page, 'Back').click();
  await total(page, /11,260/).waitFor();
}));

test('cancel a sale, then apply it without changing a one-share holding’s unit price', t => withApp(t, async page => {
  await settings(page);
  await selectBackup(page, JSON.stringify({
    version: 1,
    wallets: [{name: 'Trading', colorName: 'sky', targetPercent: 100, items: [
      {name: 'One share', price: 300, quantity: 1, targetPercent: 50, isBalance: false},
      {name: 'Cash', price: 100, quantity: 1, targetPercent: 50, isBalance: true},
    ]}],
  }));
  await button(page, 'Merge').click();
  await button(page, 'Back').click();
  await total(page, /400\.00/).waitFor();
  await button(page, 'Invest & Rebalance').click();
  await button(page, '+$100').click();
  const confirm = page.getByRole('alertdialog');
  await button(page, 'Apply to portfolio').click();
  await button(confirm, 'Cancel').click();
  await confirm.waitFor({state: 'hidden'});
  await button(page, 'Back').click();
  await total(page, /400\.00/).waitFor();
  await page.getByRole('button', {name: /One share.*300\.00/}).waitFor();
  await page.getByRole('button', {name: /^Cash.*100\.00/}).waitFor();

  await button(page, 'Invest & Rebalance').click();
  await button(page, '+$100').click();
  await button(page, 'Apply to portfolio').click();
  await button(confirm, 'Apply to portfolio').click();
  await total(page, /500\.00/).waitFor();
  await settings(page);
  const saved = JSON.parse(await download(page)).portfolios[0].wallets[0].items;
  const share = saved.find(item => item.name === 'One share');
  const cash = saved.find(item => item.name === 'Cash');
  assert.equal(share.price, 300);
  assert.ok(Math.abs(share.quantity - 5 / 6) < 1e-10);
  assert.equal(cash.price, 250);
  assert.equal(cash.quantity, 1);
}));
