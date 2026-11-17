// Cash Balancer: porcelain. One wash from warm to cool and back laid across the whole strip, soft glows, wide white
// curves, and a frosted tile on every other seam, half on each card. Everything is drawn in panorama coordinates,
// so the strip joins at every seam; colors come from theme.css (--paper, --warm, --cool).
import {panoramaGradient, panoramaLights, panoramaX} from './studio/shapes.js';

// SVG attributes can't read CSS variables, but style properties can.
const styled = svg => svg.replace(/stop-color="([^"]+)"/g, 'style="stop-color:$1"');

/** @type {import('screenshot-studio').Theme} */
export default {
  continuous: true,

  art(ctx) {
    const {W, H, slides} = ctx;
    const n = slides.length, u = Math.max(W, H), X = cards => panoramaX(ctx, cards);
    const wash = panoramaGradient(ctx, 'wash', ['var(--warm)', 'var(--paper)', 'var(--cool)', 'var(--paper)', 'var(--warm)', 'var(--cool)']);
    let body = `<rect width="${W}" height="${H}" fill="url(#wash)"/>`;
    // A glow per card, alternating warm high and cool low, spilling into the neighbours.
    const glows = Array.from({length: n + 1}, (_, k) => ({x: k + (k % 2 ? .75 : .25), y: k % 2 ? .85 : .2, r: .6, color: k % 2 ? 'var(--cool)' : 'var(--warm)', opacity: .7}));
    body += styled(panoramaLights(ctx, glows, {id: 'glow', each: false}));
    // Wide white curves rising from below the strip.
    const curve = (cx, cy, r) => `<circle cx="${cx}" cy="${cy}" r="${r}" fill="#fff" fill-opacity=".26"/>` +
      `<circle cx="${cx}" cy="${cy}" r="${r * 1.07}" fill="none" stroke="#fff" stroke-opacity=".6" stroke-width="${u * .003}"/>`;
    body += curve(X(n * .3), H * 1.55, W * 1.9) + curve(X(n * .78), H * 1.7, W * 1.6);
    // Frosted tiles on every other seam.
    const t = Math.min(W, H) * .16;
    for (let k = 1; k < n; k += 2) {
      const x = X(k), y = H * (k % 4 === 1 ? .62 : .72), rot = k % 4 === 1 ? -8 : 10;
      body += `<rect x="${x - t / 2}" y="${y - t / 2}" width="${t}" height="${t}" rx="${t * .22}" fill="#fff" fill-opacity=".35" stroke="#fff" stroke-opacity=".85" stroke-width="${t * .012}" transform="rotate(${rot} ${x} ${y})"/>`;
    }
    return `<defs>${styled(wash)}</defs>${body}`;
  },
};
