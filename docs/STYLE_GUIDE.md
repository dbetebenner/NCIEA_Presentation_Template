# Style Guide — component reference

Copy-paste patterns for the template's styling vocabulary. Every class is
defined in the dataimago deck extension,
`_extensions/deck/deck.scss`. Live examples render in
`template.qmd`.

## Slide anatomy

Each `##` heading starts a new slide. The heading becomes the slide title (blue
underline). Body content follows in Markdown.

```markdown
## My slide title

- A bullet
- Another bullet
```

### Divider slides

```markdown
## Part II — The Argument {.center}

::: {.visually-hidden}
Section: the argument
:::
```

`{.center}` vertically centers the slide. The `.visually-hidden` block gives
screen-reader users a spoken landmark without showing anything on screen.

## Callout boxes

Four colors, four jobs. Use at most one or two per slide.

```markdown
::: {.key-insight}
**Blue — the workhorse.** The one thing you want remembered from this slide.
:::
```

```markdown
::: {.theorem-box}
::: {.theorem-box-title}
Definition (orange)
:::
Formal statements: definitions, theorems, claims you will defend.
:::
```

```markdown
::: {.key-insight-box}
::: {.key-insight-box-title}
Emphasis (violet)
:::
A second, visually distinct emphasis when one blue box isn't enough.
:::
```

```markdown
::: {.warning-box}
::: {.warning-box-title}
Caution (red)
:::
Risks, failure modes, cautions.
:::
```

## Columns

```markdown
::: {.columns}
::: {.column width="52%"}
Left content
:::
::: {.column width="44%"}
Right content
:::
:::
```

Add `.v-center-cols` to the slide heading (`## Title {.v-center-cols}`) to
vertically center the columns against each other.

## Stat callouts

```markdown
::: {.stat-callout}
::: {.stat-number}
966
:::
::: {.stat-label}
conditions tested
:::
:::
```

Wrap three of these in a `::: {.columns}` for a row of big numbers.

## Figures

Put files in `Figures/`. Reference them with Markdown image syntax:

```markdown
![Caption renders small and italic.](Figures/my-figure.svg){width="55%" fig-alt="Screen-reader description."}
```

- Figures are **click-to-enlarge** automatically (lightbox with Esc/close).
  Add `.no-modal` to an image to opt out; images inside links keep the link.
- Always provide `fig-alt` for accessibility.
- For side-by-side figures use a Quarto layout:
  `::: {#fig-two layout-ncol=2} ... :::`.

### Goodness-of-fit grids

Portrait GoF panels overflow the slide when one or two share a row. Give the
grid container `.gof-grid-compact` (caps each `figure img` at 63vh) or, for a
3-up row with a callout beneath, `.gof-grid-short` (caps at 620px on the 1080
canvas). The SGP decks pass it through their R helper:

```r
gof_grid(list(...), min_col = "280px", class = "gof-grid-short")
```

## Speaker notes

```markdown
::: {.notes}
Talking points for this slide. Press 'S' in the browser for the speaker view
(notes + timer). Notes never appear on the projected slide.
:::
```

## Inline emphasis and text sizes

```markdown
[blue text]{.accent}   [pink text]{.accent-pink}   [secondary]{.muted}
[bigger]{.larger}   [smaller]{.smaller}   [smallest]{.smallest}
```

Text colors are AA-safe on the slide surface: `.accent` uses accent-500
`#1f618d`, `.accent-pink` a darkened `#b0235f`. The brighter presentation-blue
`#3498DB` is reserved for rules, borders and washes (it fails AA as text).

Other utilities: `.kicker` (small uppercase label), `.claim` (one large
statement), `.quote-hero` (centered display quote), `.fine-print`,
`.illustrative-badge` (pill marking illustrative data), `.placeholder` (visible
draft marker), `.full-bleed-img` (image capped at 820px), `.conference-badge`.

## Links

Links in running text are accent-500 and underlined (color alone is not enough
against body text). Keyboard focus shows a forest-700 outline.

Per-slide font scaling: `## Dense slide {style="font-size: 0.9em;"}`.

## Math

MathML is the render method (fast, no runtime JS). Write LaTeX as usual:

```markdown
$$ C(u,v) = \Pr(U \le u,\, V \le v) $$
```

Noto Sans Math ships with the extension for consistent glyphs.

## Title-slide QR code

A QR code in the bottom-right of the title slide only. Put the anchor in the
deck's front matter; the extension's script moves it onto the slide canvas.

```yaml
format:
  deck-revealjs:
    include-after-body:
      - text: |
          <a id="deck-qr-src" class="deck-qr" hidden
             href="https://example.org/this-deck/" aria-label="Open this deck">
            <img src="Figures/qr-deck.svg" alt="QR code linking to this presentation">
          </a>
```

## Archive slides (image-only decks)

For decks rebuilt from slide images, make the image the slide background and
put the slide's extracted text in `.archive-text`. The heading and text are
visually hidden but reach screen readers and search.

```markdown
## Original slide title {.archive-slide background-image="slides/slide-07.png" background-size="contain"}

::: {.archive-text}
Text extracted from the slide image.
:::
```

Pandoc marks background-image slides `role="img"`, which would hide that text
from assistive technology; the extension removes the role on `.archive-slide`.
For other image-background slides, `background-alt="…"` becomes the slide's
accessible name. `.visually-hidden` / `.sr-only` hide any other block the same
way.

## Optional: computed output (QR codes, plots)

The template is R-free by default. To add computed content, include a code
chunk. Example — a QR code to a handout (requires R + the `qrcode` package):

````markdown
```{r}
#| include: false
library(qrcode)
generate_svg(qr_code("https://example.org/handout.pdf"),
             filename = "Figures/qr.svg", show = FALSE)
```

![Scan for the handout](Figures/qr.svg){width="18%" fig-alt="QR code to the handout PDF."}
````

Python chunks work the same way with `{python}`.

## Reveal.js keys during a talk

`S` speaker view · `F` fullscreen · `O` slide overview · `B` blackout ·
`Esc` exit · arrows / space to navigate · `?` for the full list.
