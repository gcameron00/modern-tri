# Modern Triathlon 🏃‍♂️ → 🚴‍♂️ → 🍸

> **The modern triathlon is run · bike · cocktails.**
> A tongue-in-cheek spoof endurance brand — a challenge for the body, a reward for the mind.

A small, fast, framework-free static website. It celebrates one very simple idea:
forget the swim, the *real* modern triathlon ends with a perfectly built cocktail.

The site centers on a big visual progression — **run → bike → cocktail** — backed by
copy explaining why the format is both a genuine physical challenge and a joyful reward.

---

## ✨ Features

- **Central progression theme** — animated `run → bike → cocktail` flow with custom inline SVG icons.
- **Elegant, sports-minded design** — dark "midnight" palette with three discipline accent colors (coral / teal / gold).
- **"Challenge & reward" narrative** — dedicated sections for the effort (body) and the celebration (mind).
- **Fully responsive** — single-column stack and slide-out mobile nav on small screens.
- **Accessible & resilient** — works with JavaScript disabled, honors `prefers-reduced-motion`, semantic HTML, ARIA labels.
- **Zero dependencies** — no framework, no build step. Just HTML, CSS, and a sprinkle of vanilla JS.

---

## 🗂 Project structure

```
modern-tri/
├── index.html              # Homepage — hero, progression, philosophy, rules, CTA
├── about/
│   └── index.html          # The Manifesto (About page)
├── 404.html                # Friendly themed not-found page
├── assets/
│   ├── css/
│   │   └── styles.css       # Full design system (CSS custom properties)
│   ├── js/
│   │   └── main.js          # Mobile nav, scroll-reveal, footer year
│   ├── favicon.svg          # Themed SVG favicon (browser tab)
│   ├── icon.svg             # Full-bleed maskable app-icon source
│   └── og-image.svg         # Open Graph / social-share image source (1200×630)
├── site.webmanifest        # PWA / "Add to Home Screen" manifest
├── scripts/
│   └── generate-icons.sh    # Rasterizes the SVGs → PNGs (apple-touch-icon, OG, …)
├── docs/
│   └── IMPLEMENTATION-PLAN.md  # Build-out plan & roadmap
├── README.md
└── .gitignore
```

---

## 🚀 Local development

No tooling required. Because everything is static, just serve the folder with any
static file server so that absolute paths (e.g. `/assets/...`) resolve correctly:

```bash
# Python 3
python3 -m http.server 8080

# or Node (no install)
npx serve .
```

Then open <http://localhost:8080>.

> Opening `index.html` directly via `file://` mostly works, but the root-relative
> links (`/about/`, `/assets/...`) are happier behind a real server.

---

## 🖼 Icons & social images

The favicon (`assets/favicon.svg`) is an SVG, which modern iOS/Safari shows in the
browser tab. But **iPhones can't use SVG for the home-screen icon or for
iMessage/social link previews** — those surfaces require real raster `.png` files.

The raster assets are produced from the SVG sources by a small generator script:

```bash
bash scripts/generate-icons.sh
```

It auto-detects any one of `rsvg-convert` (librsvg), `inkscape`, ImageMagick
(`magick`/`convert`), or `python3` + `cairosvg`, and writes:

| Output                         | Size      | Used for                                   |
| ------------------------------ | --------- | ------------------------------------------ |
| `assets/apple-touch-icon.png`  | 180×180   | iOS "Add to Home Screen" icon              |
| `assets/icon-192.png`          | 192×192   | PWA / Android manifest icon                |
| `assets/icon-512.png`          | 512×512   | PWA / Android manifest icon                |
| `assets/maskable-512.png`      | 512×512   | Maskable PWA icon                          |
| `assets/favicon-32.png`        | 32×32     | Classic raster favicon fallback            |
| `assets/favicon-180.png`       | 180×180   | Extra raster fallback                      |
| `assets/og-image.png`          | 1200×630  | Open Graph / Twitter / iMessage preview    |

The HTML in `index.html`, `about/index.html`, and `404.html` already references
these paths, so once you run the script and commit the generated PNGs, the icons
and share previews work everywhere — including on iPhones.

---

## ☁️ Deployment — Cloudflare Pages

This repo is designed to deploy to **Cloudflare Pages** with zero configuration.

1. In the Cloudflare dashboard: **Workers & Pages → Create → Pages → Connect to Git**.
2. Select this repository.
3. Build settings:
   - **Framework preset:** `None`
   - **Build command:** *(leave empty)*
   - **Build output directory:** `/` (the repository root)
4. Deploy. Cloudflare serves the static files directly and uses `404.html` for unknown routes.

Every push to the production branch triggers an automatic deploy; pull requests get
preview URLs.

---

## 🎨 Design tokens

The palette and spacing live as CSS custom properties at the top of
[`assets/css/styles.css`](assets/css/styles.css):

| Token         | Value     | Role                          |
| ------------- | --------- | ----------------------------- |
| `--navy-900`  | `#070b16` | Page background               |
| `--run`       | `#ff5a5f` | Discipline 1 — Run (coral)    |
| `--bike`      | `#28d0c8` | Discipline 2 — Bike (teal)    |
| `--cocktail`  | `#f5b942` | Discipline 3 — Cocktail (gold)|
| `--gold`      | `#f5b942` | Primary brand accent          |

Adjust these once and the whole theme follows.

---

## 📜 Disclaimer

Modern Triathlon is **satire** — a light-hearted spoof, not a real sanctioned event.
Please train sensibly, ride safely, and enjoy any cocktails responsibly (mocktails
welcome — the medal tastes the same).

---

## 🛣 Roadmap

See [`docs/IMPLEMENTATION-PLAN.md`](docs/IMPLEMENTATION-PLAN.md) for the phased build-out
plan and ideas for future enhancements.
