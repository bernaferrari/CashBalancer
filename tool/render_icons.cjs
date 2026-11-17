// Renders the SVG masters in assets/icon to 1024px PNGs in build/icon.
//   cd test/browser && node ../../tool/render_icons.cjs
const {chromium} = require('playwright-core');
const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname, '..');
const src = path.join(root, 'assets/icon');
const out = path.join(root, 'build/icon');
const uri = name =>
  'data:image/svg+xml;base64,' + fs.readFileSync(path.join(src, name)).toString('base64');

// macOS draws icons as given: an 824pt rounded square on a 1024 canvas,
// with Apple's soft drop shadow.
const macos = `<div style="position:absolute;left:100px;top:100px;width:824px;height:824px;
  border-radius:185px;overflow:hidden;box-shadow:0 10px 18px rgba(0,0,0,.28)">
  <img src="${uri('app_icon.svg')}" width="824" height="824"></div>`;

(async () => {
  fs.mkdirSync(out, {recursive: true});
  const browser = await chromium.launch({channel: 'chrome'});
  const page = await (await browser.newContext({viewport: {width: 1024, height: 1024}})).newPage();
  const shoot = async (html, name) => {
    await page.setContent(`<body style="margin:0;background:transparent">${html}</body>`);
    await page.waitForTimeout(150);
    await page.screenshot({path: path.join(out, name), omitBackground: true});
  };
  for (const f of fs.readdirSync(src).filter(f => f.endsWith('.svg'))) {
    await shoot(`<img src="${uri(f)}" width="1024" height="1024">`, f.replace('.svg', '.png'));
  }
  await shoot(macos, 'macos.png');
  await browser.close();
})();
