# Implementation Plan — Modern Triathlon

This document captures the build-out plan for the **run · bike · cocktails** spoof
website. It records what has been built (Phase 0–1), and proposes a roadmap for
future enhancements.

---

## Goals

1. Communicate one simple idea instantly: **modern triathlon = run → bike → cocktails**.
2. Lead with a **big central visual progression** using icons.
3. Explain that the format is a **challenge for the body** and a **reward for the mind**.
4. Look **elegant and sports-minded**.
5. Ship as **static HTML/CSS/JS, no framework**, hosted on **Cloudflare Pages**.

---

## Tech & constraints

| Decision            | Choice                          | Rationale                                            |
| ------------------- | ------------------------------- | ---------------------------------------------------- |
| Framework           | None                            | Required by the brief; keeps it fast and portable.   |
| Styling             | Hand-written CSS + custom props | Themeable design tokens, no build step.              |
| Icons               | Inline SVG                      | Crisp, recolorable, zero network requests.           |
| Fonts               | Inter via Google Fonts          | Clean, sporty, widely available; preconnected.       |
| JS                  | Vanilla, progressive            | Site works fully without it.                         |
| Hosting             | Cloudflare Pages                | Static, free, fast CDN, preview deploys.             |

---

## Phase 0 — Foundation ✅ (done)

- [x] Repo scaffold (index, about, assets) — pre-existing.
- [x] Design system in `assets/css/styles.css` (tokens, layout, components).
- [x] Themed SVG favicon.

## Phase 1 — Proposed front end ✅ (done)

- [x] **Homepage** (`index.html`)
  - [x] Sticky header with brand mark + responsive nav.
  - [x] Hero with gradient headline and clear value proposition.
  - [x] **Central `run → bike → cocktail` progression** with custom icons and animated connectors.
  - [x] Stats strip (3 disciplines · 0 cold swims · ∞ garnishes).
  - [x] "Challenge vs Reward" split (body vs mind).
  - [x] Benefits trio + "The Rules" format breakdown.
  - [x] CTA band + footer with disclaimer.
- [x] **About / Manifesto** page (`about/index.html`).
- [x] **404 page** (`404.html`), on-theme.
- [x] **JS enhancements** (`assets/js/main.js`): mobile nav, scroll-reveal, footer year.
- [x] **Docs**: `README.md` + this plan.

---

## Phase 2 — Polish & content (proposed)

- [ ] Add a real wordmark/logo lockup and social share (OG) image.
- [ ] "Cocktail of the Month" recipe card section (run-themed names: *The Negroni Sprint*).
- [ ] Photography or illustrated background textures for each leg.
- [ ] Light/dark theme toggle (currently dark-only by design).
- [ ] Subtle parallax or scroll-linked animation on the progression icons.

## Phase 3 — Interactivity (proposed)

- [ ] **"Build your triathlon" mini-configurator** — pick run distance, ride distance,
      and a signature cocktail; generate a shareable summary card.
- [ ] Animated SVG runner/cyclist along the progression line.
- [ ] Newsletter/"join the circuit" form (Cloudflare Pages Functions or a form provider).

## Phase 4 — Production hardening (proposed)

- [ ] Add `_headers` (security headers, caching) and `_redirects` for Cloudflare Pages.
- [ ] Generate `sitemap.xml` and `robots.txt`.
- [ ] Lighthouse pass (performance / a11y / SEO ≥ 95).
- [ ] Self-host fonts to drop the third-party request.
- [ ] Optional analytics (Cloudflare Web Analytics — privacy-friendly, no cookies).

---

## Information architecture

```
/                 Home — the pitch + progression + philosophy + rules + CTA
/about/           The Manifesto — story, body/mind rationale, format
/404              Friendly off-course page
```

Future candidates: `/recipes/`, `/events/`, `/join/`.

---

## Accessibility checklist

- [x] Semantic landmarks (`header`, `main`, `footer`, `section`, `article`).
- [x] Descriptive `alt`/`aria-label` and `aria-hidden` on decorative SVGs.
- [x] Keyboard-operable nav toggle with `aria-expanded`.
- [x] `prefers-reduced-motion` respected for all animations.
- [x] Sufficient color contrast on dark background.
- [ ] Full screen-reader pass (Phase 2).

---

## Definition of done (Phase 1)

A visitor lands on the homepage and, within seconds, understands that the modern
triathlon is **run → bike → cocktails**, sees the progression illustrated, reads why
it's both a challenge and a reward, and can navigate to a deeper About page — all on a
fast, responsive, framework-free site ready for Cloudflare Pages.
