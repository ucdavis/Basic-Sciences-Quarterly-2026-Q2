# Basic Sciences Quarterly — GitHub Pages setup (how-to)

This folder is your **GitHub Setup** kit: everything that should go live lives under **`public/`**, with **stable filenames** so internal links do not break each quarter.

---

## Folder location

Path (inside your newsletter project):

`Claude BS Newsletter / Basic-Sciences-Quarterly-GitHub-Setup`

---

## What each part does

**One repo holds every quarter, forever.** Each quarter gets its own permanent subfolder under `public/` — e.g. `public/2026-q2/`, `public/2026-q3/` — so old issues stay live at the same URL after a new quarter is published, and nothing gets overwritten by mistake.

| Path | Purpose |
|------|--------|
| **`public/`** | Only these files are published. Nothing else in this folder needs to be on the website. |
| **`public/index.html`** | Home page, with a link section per quarter. Must stay named **`index.html`**, all lowercase, or GitHub Pages shows 404 at the site root. |
| **`public/2026-q2/newsletter.html`** | That quarter's newsletter (never overwritten — each quarter gets a new subfolder). |
| **`public/2026-q2/publications.html`** | That quarter's publication list. |
| **`public/2026-q2/faculty-metrics.html`** | That quarter's faculty metrics page. |
| **`scripts/prepare-issue.sh`** | Copies your three final draft files into `public/<quarter>/` using those stable names. |
| **`.github/workflows/deploy-pages.yml`** | Builds GitHub Pages from **`public/`** only (this doesn't change quarter to quarter). |

Stable URLs on the site always look like:

- `…/index.html` (or the site root `/`)
- `…/2026-q2/newsletter.html`
- `…/2026-q2/publications.html`
- `…/2026-q2/faculty-metrics.html`

Inside your HTML, link to **`publications.html`** and **`faculty-metrics.html`** as plain filenames with no folder in front (not dated filenames). Because each quarter's three pages sit together in the same subfolder, those plain relative links keep working without any changes.

---

## First-time connection to GitHub

You can use this folder as **its own repository**, or copy **`public/`** and **`.github/workflows/`** into an existing repo (for example `Basic-Sciences-Quarterly-2026-Q1`).

### Option A — This folder is the whole repo (simple)

1. Open **Terminal** and run:

   ```bash
   cd "/Users/ajoo/Desktop/Claude/Claude BS Newsletter/Basic-Sciences-Quarterly-GitHub-Setup"
   git init
   git branch -M main
   git remote add origin https://github.com/YOUR_USER/YOUR_REPO.git
   git add public .github
   git commit -m "Initial GitHub Pages site from public/"
   git push -u origin main
   ```

2. On GitHub: **Settings → Pages → Build and deployment → Source: GitHub Actions**.

3. Confirm the **Actions** workflow **Deploy Pages** succeeds. Your site URL will look like  
   `https://YOUR_USER.github.io/YOUR_REPO/`

### Option B — GitHub Desktop

1. **File → Add Local Repository** (or **New Repository** and choose this folder).
2. Publish to GitHub if prompted.
3. Same **Pages** setting: **GitHub Actions**.

### Option B — Merge into an existing site repo

1. Copy **`public/`** and **`.github/workflows/deploy-pages.yml`** into that repo’s root.
2. Remove or disable any old workflow that uploaded the **entire** repository root, so you do not publish drafts twice.
3. In **`deploy-pages.yml`**, the artifact path must stay **`public`** (relative to that repo’s root).

---

## Every new quarter (checklist)

1. **Finish** your three HTML files in your normal draft location (e.g. Claude BS Newsletter), and promote them to that quarter's "Locked Finals" versions once they're confirmed correct.

2. **Optional but recommended:** In those files, use links **`publications.html`** and **`faculty-metrics.html`** between the three pages (no folder in front). If you still use dated names (e.g. `publications-q3-2026-….html`), use the script's rewrite step below.

3. **Pick this quarter's folder name** — the pattern is `<year>-q<quarter>`, e.g. `2026-q3`.

4. **Run the prepare script** from this folder, with the quarter folder name as the first argument:

   ```bash
   cd "/Users/ajoo/Desktop/Claude/Claude BS Newsletter/Basic-Sciences-Quarterly-GitHub-Setup"
   ./scripts/prepare-issue.sh 2026-q3 \
     "/path/to/your/final-newsletter.html" \
     "/path/to/your/final-publications.html" \
     "/path/to/your/final-faculty-metrics.html"
   ```

   This creates `public/2026-q3/` with the three stable filenames inside — it never touches or overwrites a previous quarter's folder.

5. **If drafts use different internal filenames**, set **`BSQ_LINK_FIX`** once per issue (semicolon-separated `old.html:new.html` pairs):

   ```bash
   export BSQ_LINK_FIX="my-pubs-draft.html:publications.html;my-faculty-draft.html:faculty-metrics.html"
   ./scripts/prepare-issue.sh 2026-q3 "/path/to/newsletter.html" "/path/to/pubs.html" "/path/to/faculty.html"
   ```

6. **Edit `public/index.html`** to add a new card section for the new quarter — copy the existing `<h2 class="quarter">` block and its three `<li>` cards, then change the heading text and the three `href` values to point at the new `<quarter>/...` folder. Relabel the previous quarter's heading (drop "(current issue)").

7. **Commit and push** (Terminal or GitHub Desktop).

8. Wait for **Actions** to finish, then open the live site and do a **hard refresh** (e.g. **Cmd+Shift+R**). Confirm both the new quarter's pages AND the previous quarter's pages still load.

9. **Before editing on another computer**, in GitHub Desktop: **Repository → Pull** (or **Fetch / Pull origin**).

---

## Rules that avoid common mistakes

- **`index.html`** must be **all lowercase**. `Index.html` can 404 on the site root.
- **Pages source** must be **GitHub Actions** if you use this workflow (not “Deploy from a branch” unless you match that layout on purpose).
- **Only `public/`** is deployed; keep drafts and Word exports outside `public/`.
- **Pull before you edit** if you might have changed the repo on GitHub or another machine.

---

## Troubleshooting

| Problem | What to check |
|--------|----------------|
| **404 at site root** | `public/index.html` exists, lowercase name, latest push deployed. |
| **404 on a linked page** | Link `href` matches a file that actually exists in **`public/`** (same spelling and case). |
| **Old content in browser** | Hard refresh; wait 1–2 minutes after deploy; try a private window. |
| **Workflow does not run** | Repo **Settings → Actions** allows workflows; default branch is **`main`** (or add **`master`** to the workflow `on.push.branches` list). |

---

## Renaming this folder

If you move or rename **`Basic-Sciences-Quarterly-GitHub-Setup`**, the scripts still work as long as you run **`prepare-issue.sh`** from inside this directory (it finds **`public/`** relative to the script). Update any bookmarks or GitHub Desktop “local path” to the new location.
