// Captures every screen of a running Cash Balancer web build for design review.
//
//   node test/browser/screens.cjs [origin] [outDir]
//
// Defaults to http://127.0.0.1:8123 (a `flutter run -d web-server` session) and
// build/screens. Each run starts from an empty browser profile, loads the
// sample portfolio, and walks the routes in phone light, phone dark and desktop.
const {mkdir} = require('node:fs/promises');
const {resolve} = require('node:path');
const {chromium} = require('playwright-core');

const origin = process.argv[2] || 'http://127.0.0.1:8123';
const out = resolve(process.argv[3] || 'build/screens');
const only = process.env.SCREENS ? process.env.SCREENS.split(',') : null;

const button = (page, name) => page.getByRole('button', {name, exact: true});

async function settle(page, ms = 700) {
  await page.waitForTimeout(ms);
}

async function go(page, route) {
  await page.evaluate(r => { window.location.hash = r; }, route);
  await settle(page, 900);
}

async function capture(page, prefix, name) {
  if (only && !only.includes(name)) return;
  await page.mouse.move(1, 1);
  await page.screenshot({path: `${out}/${prefix}-${name}.png`});
}

async function scrollCapture(page, prefix, name, dy) {
  if (only && !only.includes(name)) return;
  const {width, height} = page.viewportSize();
  await page.mouse.move(width / 2, height / 2);
  await page.mouse.wheel(0, dy);
  await settle(page, 600);
  await page.mouse.move(1, 1);
  await page.screenshot({path: `${out}/${prefix}-${name}.png`});
  await page.mouse.wheel(0, -dy * 3);
  await settle(page, 400);
}

async function run(browser, prefix, options) {
  const context = await browser.newContext({locale: 'en-US', ...options});
  const page = await context.newPage();
  page.setDefaultTimeout(20000);
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  await page.goto(origin);
  await page.locator('flt-semantics-placeholder').evaluate(el => el.click());
  await button(page, 'Load sample portfolio').waitFor();
  await settle(page);
  await capture(page, prefix, '00-empty');

  await button(page, 'Load sample portfolio').click();
  await button(page, 'Load sample portfolio').waitFor({state: 'hidden'});
  await settle(page, 1500);
  await capture(page, prefix, '01-home');
  await scrollCapture(page, prefix, '02-home-scrolled', 700);

  await page.getByRole('button', {name: /Portfolio #1/}).first().click();
  await settle(page);
  await capture(page, prefix, '03-portfolios');
  await page.keyboard.press('Escape');
  await settle(page);

  for (const [name, route] of [
    ['04-analysis', '/analysis'],
    ['05-rebalance', '/rebalance'],
    ['06-settings', '/settings'],
    ['07-add-wallet', '/addWallet/1'],
    ['08-edit-wallet', '/editWallet/1'],
    ['09-add-item', '/addItem/1'],
    ['10-edit-item', '/editItem/1'],
    ['11-move-item', '/moveItem/1'],
  ]) {
    await go(page, route);
    await capture(page, prefix, name);
    if (name === '05-rebalance' || name === '06-settings') {
      await scrollCapture(page, prefix, `${name}-scrolled`, 700);
    }
    await go(page, '/');
  }

  await button(page, 'Update price').first().click();
  await settle(page);
  await capture(page, prefix, '12-quick-price');
  await page.keyboard.press('Escape');
  await settle(page);

  await context.close();
  if (errors.length) console.log(prefix, 'page errors:', errors);
}

(async () => {
  await mkdir(out, {recursive: true});
  const browser = await chromium.launch({channel: 'chrome'});
  try {
    const phone = {viewport: {width: 390, height: 844}, deviceScaleFactor: 2};
    const variants = (process.env.VARIANTS || 'light,dark,desktop').split(',');
    if (variants.includes('light')) await run(browser, 'phone-light', {...phone, colorScheme: 'light'});
    if (variants.includes('dark')) await run(browser, 'phone-dark', {...phone, colorScheme: 'dark'});
    if (variants.includes('desktop')) {
      await run(browser, 'desktop', {
        viewport: {width: 1280, height: 820}, deviceScaleFactor: 1, colorScheme: 'light',
      });
    }
  } finally {
    await browser.close();
  }
  console.log('saved to', out);
})();
