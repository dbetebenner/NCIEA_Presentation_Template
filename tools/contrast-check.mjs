#!/usr/bin/env node
// WCAG 2.x contrast check for the deck theme's text/background pairs.
// Usage: node tools/contrast-check.mjs   (exit 1 if any required pair fails)

const hex = (h) => {
  const s = h.replace('#', '');
  return [0, 2, 4].map((i) => parseInt(s.slice(i, i + 2), 16) / 255);
};

const lin = (c) => (c <= 0.04045 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4);

const luminance = (h) => {
  const [r, g, b] = hex(h).map(lin);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
};

const ratio = (a, b) => {
  const [hi, lo] = [luminance(a), luminance(b)].sort((x, y) => y - x);
  return (hi + 0.05) / (lo + 0.05);
};

// Alpha-composite an rgba wash over an opaque background (for tinted callouts).
const over = (fg, alpha, bg) => {
  const f = hex(fg);
  const b = hex(bg);
  return '#' + f.map((c, i) => Math.round((c * alpha + b[i] * (1 - alpha)) * 255)
    .toString(16).padStart(2, '0')).join('');
};

const PAGE = '#ededeb';

// [label, foreground, background, minimum, required?]
const pairs = [
  ['body text (ink) on stone-100', '#14140f', PAGE, 4.5, true],
  ['link (accent-500) on stone-100', '#1f618d', PAGE, 4.5, true],
  ['link hover (accent-600) on stone-100', '#154d6f', PAGE, 4.5, true],
  ['secondary text on stone-100', '#6a6a6a', PAGE, 4.5, true],
  ['accent-pink ink on stone-100', '#b0235f', PAGE, 4.5, true],
  ['focus ring (forest-700) on stone-100', '#434739', PAGE, 3.0, true],
  ['link vs body text (needs underline)', '#1f618d', '#14140f', 3.0, false],
  ['theorem title (copper-700) on its tinted bar', '#913d15', over('#e67e22', 0.18, PAGE), 4.5, true],
  ['violet title on its tinted bar', '#4a235a', over('#8e44ad', 0.18, PAGE), 4.5, true],
  ['warning title on its tinted bar', '#922b21', over('#c0392b', 0.18, PAGE), 4.5, true],
  ['key-insight strong (accent-500) on its wash', '#1f618d', over('#3498db', 0.08, PAGE), 4.5, true],
  ['violet-box strong on its wash', '#6c3483', over('#8e44ad', 0.10, PAGE), 4.5, true],
  ['illustrative badge text on its fill', '#7a5c33', over('#e67e22', 0.14, PAGE), 4.5, true],
  ['presentation-blue on stone-100 (decorative only)', '#3498DB', PAGE, 3.0, false],
  ['legacy secondary #7c7c7c on stone-100 (replaced)', '#7c7c7c', PAGE, 4.5, false],
  ['legacy pink #ff69b4 on stone-100 (replaced)', '#ff69b4', PAGE, 4.5, false],
];

let failed = false;
for (const [label, fg, bg, min, required] of pairs) {
  const r = ratio(fg, bg);
  const ok = r >= min;
  if (required && !ok) failed = true;
  const tag = ok ? 'pass' : required ? 'FAIL' : 'info';
  console.log(`${tag.padEnd(4)}  ${r.toFixed(2).padStart(5)}:1  (min ${min})  ${label}  ${fg} on ${bg}`);
}
process.exit(failed ? 1 : 0);
