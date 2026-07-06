# Basic Sciences Quarterly — GitHub Pages setup (how-to)

This folder is your **GitHub Setup** kit: everything that should go live lives under **`public/`**, with **stable filenames** so internal links do not break each quarter.

---

## Folder location

Path (inside your newsletter project):

`Claude BS Newsletter / Basic-Sciences-Quarterly-GitHub-Setup`

---

## What each part does

| Path | Purpose |
|------|--------|
| **`public/`** | Only these files are published. Nothing else in this folder needs to be on the website. |
| **`public/index.html`** | Home page (must stay named **`index.html`**, all lowercase, or GitHub Pages shows 404 at the site root). |
| **`public/newsletter.html`** | Current quarterly newsletter (overwrite each issue). |
| **`public/publications.html`** | Current publication list (overwrite each issue). |
| **`public/faculty-metrics.html`** | Current faculty metrics page (overwrite each issue). |
| **`scripts/prepare-issue.sh`** | Copies your three final draft files into `public/` using those stable names. |
| **`.github/workflows/deploy-pages.yml`** | Builds GitHub Pages from **`public/`** only. |

Stable URLs on the site always look like:

- `…/index.html` (or the site root `/`)
- `…/newsletter.html`
- `…/publications.html`
- `…/faculty-metrics.html`

Inside your HTML, link to **`publications.html`** and **`faculty-metrics.html`** (not dated filenames), so buttons never 404 after you swap files.

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

1. **Finish** your three HTML files in your normal draft location (e.g. Claude BS Newsletter).

2. **Optional but recommended:** In those files, use links **`publications.html`** and **`faculty-metrics.html`** between the three pages. If you still use dated names (e.g. `publications-q2-2026-….html`), use the script’s rewrite step below.

3. **Run the prepare script** from this folder:

   ```bash
   cd "/Users/ajoo/Desktop/Claude/Claude BS Newsletter/Basic-Sciences-Quarterly-GitHub-Setup"
   ./scripts/prepare-issue.sh \
     "/path/to/your/final-newsletter.html" \
     "/path/to/your/final-publications.html" \
     "/path/to/your/final-faculty-metrics.html"
   ```

4. **If drafts use different internal filenames**, set **`BSQ_LINK_FIX`** once per issue (semicolon-separated `old.html:new.html` pairs):

   ```bash
   export BSQ_LINK_FIX="my-pubs-draft.html:publications.html;my-faculty-draft.html:faculty-metrics.html"
   ./scripts/prepare-issue.sh "/path/to/newsletter.html" "/path/to/pubs.html" "/path/to/faculty.html"
   ```

5. **Edit `public/index.html`** if you want the subtitle or card labels to mention the new quarter (optional).

6. **Commit and push** (Terminal or GitHub Desktop).

7. Wait for **Actions** to finish, then open the live site and do a **hard refresh** (e.g. **Cmd+Shift+R**).

8. **Before editing on another computer**, in GitHub Desktop: **Repository → Pull** (or **Fetch / Pull origin**).

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
