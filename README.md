# Quarto Presentation Template

The one home of the presentation theme for Damian Betebenner's Quarto +
Reveal.js decks. The theme ships as a Quarto format extension, **dataimago
deck** (`_extensions/deck/`), built on the
[`@dataimago/css`](https://www.npmjs.com/package/@dataimago/css) design tokens.
The repository is also a starter template: `template.qmd` demonstrates every
component.

## Start a new deck

```bash
quarto use template dbetebenner/Quarto_Presentation_Template
```

Run it in an empty directory (in a non-empty one Quarto asks for a new directory
name). It copies `template.qmd` (renamed to `<directory>.qmd`), `Figures/`,
`docs/STYLE_GUIDE.md`, `render.sh` and `preview.sh`, and installs the extension
at `_extensions/dbetebenner/deck/`.
Fill in the `{{…}}` placeholders in the front matter and write your slides.

```bash
./preview.sh my_talk.qmd     # live preview, re-renders on save
./render.sh  my_talk.qmd     # → my_talk.html, one self-contained file
```

Working from a clone of this repository instead, `new-presentation.sh` fills
the placeholders for you:

```bash
./new-presentation.sh my_talk -t "My Talk Title" -s "Subtitle" -v "NCIEA Staff Retreat"
```

## Move an existing deck onto the extension

From the deck's directory:

```bash
quarto add dbetebenner/Quarto_Presentation_Template
```

Then, in the deck's front matter:

```yaml
format:
  deck-revealjs:
    embed-resources: true
    theme: [styles/custom.scss]     # only if the deck has its own rules
```

and delete what the extension now provides: the `theme:` line pointing at
`styles/presentation-theme.scss`, the Google Fonts or `styles/fonts.css`
include, the Noto Sans Math `@font-face` / preload block, and the
`<script src="styles/presentation-figure-modal.js">` /
`presentation-title-qr.js` includes. Keep deck-specific HTML such as the
`#deck-qr-src` anchor. Deck-only rules (D3 scenes, one-off layouts) move into
`styles/custom.scss`.

A deck's own `theme:`, `css:` and `include-after-body:` entries are appended to
the extension's, so `styles/custom.scss` layers on top: it can override any theme
variable (`$link-color`, `$presentation-font-size-root`, …; they are all
`!default`) in its `scss:defaults` section, and use the `$di-*` tokens in its
`scss:rules` section.

### Which format id to use

Quarto installs an extension under the GitHub owner it came from, so `quarto add`
and `quarto use template` put this one at `_extensions/dbetebenner/deck/`. The
owner-free id `deck-revealjs` resolves there, in this repository
(`_extensions/deck/`), and in any vendored copy, which is why the template uses
it. An owner-qualified id resolves only where the folder matches:
`dataimago/deck-revealjs` needs the extension at `_extensions/dataimago/deck/`,
the layout used when it is vendored by hand (the hub site, the image archive
decks).

The extension sits one level deep here (`_extensions/deck/`, not
`_extensions/<owner>/deck/`) because `quarto use template` only finds
extensions at that depth; an owner folder makes it install nothing.

## Update

```bash
quarto update extension dbetebenner/Quarto_Presentation_Template
```

Re-render afterwards. A vendored copy is updated by replacing its
`_extensions/dataimago/deck/` with this repository's `_extensions/deck/`.

## Provenance: the generated-from stamp

`_extension.yml` carries `generated-from: "@dataimago/css@0.1.0-alpha.18"`, and
`tokens.scss` opens with the same stamp. The token values (stone-100 page
`#ededeb`, ink `#14140f`, accent-500 `#1f618d`, forest-700 `#434739`, …) are
copied by hand from that package version, limited to what the deck uses. When
`@dataimago/css` changes a token the deck uses, copy the new value into
`tokens.scss`, bump both stamps and the extension `version`, and run
`node tools/contrast-check.mjs`.

## What the extension contains

```
_extensions/deck/
├── _extension.yml      # format: deck-revealjs (1920×1080, MathML, fade, slide numbers)
├── tokens.scss         # @dataimago/css token subset (stamped)
├── deck.scss           # the theme: scss:defaults + scss:rules
├── fonts.css           # @font-face for the local woff2 files (no CDN)
├── deck-scripts.html   # figure lightbox, title-slide QR, reduced motion, archive-slide a11y
└── fonts/              # Josefin Sans 300–700, Noto Sans 400/600, Noto Sans Mono 400,
                        # Noto Sans Math 400 — SIL OFL 1.1, see fonts/OFL.txt
```

`embed-resources` is left to each deck. With it, fonts, CSS and scripts are
inlined into one HTML file; without it, Quarto links them from the extension
directory (and copies them into `site_libs/` in a website project). Either way
the output makes no font CDN requests.

The fonts are plain CSS rather than SCSS because Quarto moves the compiled theme
into `<deck>_files/`, which would break relative font URLs. `tokens.scss` is a
separate theme layer listed after `deck.scss` because Quarto emits later layers'
`scss:defaults` first.

## Design intent

- **One theme home.** Decks no longer carry their own copies of the theme;
  they install or update the extension.
- **A small, disciplined vocabulary.** Three callout colors (blue insight,
  orange definition, violet emphasis) plus a red caution box, stat callouts,
  and columns. Constraint is the point.
- **Accessible by default.** AA-contrast text and links, underlined links, a
  visible focus ring, reduced-motion support, screen-reader landmarks on divider
  slides, a focus-trapped figure lightbox, `fig-alt` prompts, and `.archive-slide`
  text equivalents for image-only slides. `node tools/contrast-check.mjs`
  reports the ratios.
- **Offline-safe.** Local fonts only; MathML math.

## Repository layout

```
├── _extensions/deck/             # the extension (above)
├── template.qmd                  # showcase skeleton — every component, live
├── new-presentation.sh           # scaffold a deck from a clone (fills placeholders)
├── render.sh / preview.sh        # build / live-preview a deck
├── Figures/                      # figures (SVG/PNG)
├── docs/STYLE_GUIDE.md           # component reference
├── examples/                     # optional rendered reference decks
└── tools/contrast-check.mjs      # WCAG contrast of the theme's text pairs
```

`.quartoignore` keeps `new-presentation.sh`, `examples/` and `tools/` out of
decks created with `quarto use template`.

## Requirements

- [Quarto](https://quarto.org/docs/get-started/) ≥ 1.8.
- `python3`, only for `new-presentation.sh`.
- R is not required. Add an R or Python chunk if a deck needs computed output
  (see the Style Guide).

## Conventions

Class names are an API; keep them stable: `::KEY-INSIGHT::`, `::THEOREM-BOX::`,
`::KEY-INSIGHT-BOX::`, `::WARNING-BOX::`, `::STAT-CALLOUT::`,
`::CONFERENCE-BADGE::`, `::DECK-QR::`, `::GOF-GRID-COMPACT::`,
`::GOF-GRID-SHORT::`, `::ARCHIVE-SLIDE::`, `::ARCHIVE-TEXT::`. Add new shared
components to `deck.scss` rather than styling inline, so every deck benefits.
