// node render.js <scene.json> <out.png> [views] [cols]  — serves this dir + scene, screenshots the sheet
const { chromium } = require('playwright');
const http = require('http'), fs = require('fs'), path = require('path');
const [scenePath, out, views = '0,35,180', cols = '3'] = process.argv.slice(2);
const root = __dirname;
const srv = http.createServer((req, res) => {
  const u = decodeURIComponent(req.url.split('?')[0]);
  const f = u === '/scene.json' ? path.resolve(scenePath) : path.join(root, u);
  if (!fs.existsSync(f)) { res.writeHead(404); return res.end(); }
  res.writeHead(200, { 'Content-Type': f.endsWith('.js') ? 'text/javascript' : f.endsWith('.html') ? 'text/html' : 'application/json' });
  fs.createReadStream(f).pipe(res);
}).listen(0, async () => {
  const b = await chromium.launch({ args: ['--use-gl=angle', '--use-angle=swiftshader', '--enable-unsafe-swiftshader'] });
  const p = await b.newPage();
  p.on('console', m => console.log('page:', m.text())); p.on('pageerror', e => console.log('err:', e.message));
  await p.goto(`http://localhost:${srv.address().port}/render.html?views=${views}&cols=${cols}`);
  await p.waitForFunction(() => document.title === 'done', null, { timeout: 120000 });
  await (await p.$('#sheet')).screenshot({ path: out });
  await b.close(); srv.close();
});
