#!/usr/bin/env node

/**
 * Generate a landing page for Marp slide decks.
 *
 * Usage: node generate-index.js <slidesDir> <outputFile>
 *  - slidesDir: Directory containing the rendered HTML / PDF slides
 *  - outputFile: Where the index.html should be written
 */

const fs = require('fs');
const path = require('path');

const [slidesDir, outputFile] = process.argv.slice(2);

if (!slidesDir || !outputFile) {
  console.error('Usage: node generate-index.js <slidesDir> <outputFile>');
  process.exit(1);
}

if (!fs.existsSync(slidesDir)) {
  console.error(`Slides directory not found: ${slidesDir}`);
  process.exit(1);
}

const ensureDir = (filepath) => {
  fs.mkdirSync(path.dirname(filepath), { recursive: true });
};

const readHtmlFiles = (dir) => {
  return fs
    .readdirSync(dir)
    .filter((file) => file.endsWith('.html') && file !== 'index.html');
};

const extractMeta = (html) => {
  const titleMatch = html.match(/<title>([^<]*)<\/title>/i);
  const ogTitleMatch = html.match(/<meta property="og:title" content="([^"]*)"/i);
  const descriptionMatch =
    html.match(/<meta name="description" content="([^"]*)"/i) ||
    html.match(/<meta property="og:description" content="([^"]*)"/i);

  return {
    title: (titleMatch && titleMatch[1]) || (ogTitleMatch && ogTitleMatch[1]) || 'Presentacion',
    description: (descriptionMatch && descriptionMatch[1]) || 'Presentacion generada con Marp',
  };
};

const escapeHtml = (value) =>
  value
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');

const formatDate = (date) =>
  new Intl.DateTimeFormat('es-ES', {
    year: 'numeric',
    month: 'short',
    day: '2-digit',
  }).format(date);

const cards = readHtmlFiles(slidesDir)
  .map((file) => {
    const absPath = path.join(slidesDir, file);
    const html = fs.readFileSync(absPath, 'utf8');
    const meta = extractMeta(html);
    const baseName = path.basename(file, '.html');
    const stat = fs.statSync(absPath);
    const pdfPath = path.join(path.dirname(absPath), `${baseName}.pdf`);
    const hasPdf = fs.existsSync(pdfPath);

    return {
      title: escapeHtml(meta.title),
      description: escapeHtml(meta.description),
      htmlLink: `slides/${file}`,
      pdfLink: hasPdf ? `slides/${baseName}.pdf` : null,
      updated: formatDate(stat.mtime),
    };
  })
  .sort((a, b) => a.title.localeCompare(b.title));

const heroTitle = 'Presentaciones del Doctorado';
const heroSubtitle =
  'Repositorio de materiales de apoyo para mi doctorado';
const authorName = 'Ernesto Serrano';
const githubUrl = 'https://github.com/erseco/ugr_doctorado/';

const cardsMarkup =
  cards.length > 0
    ? cards
        .map(
          (card) => `
            <article class="card">
          <header class="card-header">
            <p class="card-kicker">Presentacion</p>
            <h2>${card.title}</h2>
            <p class="meta">Actualizado: ${card.updated}</p>
          </header>
          <p class="summary">${card.description}</p>
          <div class="actions">
            <a class="button primary" href="${card.htmlLink}">Ver online</a>
            ${
              card.pdfLink
                ? `<a class="button secondary" href="${card.pdfLink}">Descargar PDF</a>`
                : ''
            }
          </div>
            </article>`
        )
        .join('\n')
    : `
        <div class="empty">
          <p>No se han encontrado presentaciones. Genera las diapositivas con <code>make slides</code>.</p>
        </div>`;

const template = `<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${heroTitle}</title>
  <meta name="description" content="${escapeHtml(heroSubtitle)}">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Fira+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <style>
    :root {
      color-scheme: only light;
      --color-primary: #d53044;
      --color-primary-dark: #b12536;
      --color-secondary: #006a85;
      --color-secondary-dark: #00536a;
      --color-dark: #002b36;
      --color-ink: #121619;
      --color-muted: #5d616d;
      --color-surface: #ffffff;
      --color-surface-alt: #f1f3f8;
      --color-border: rgba(0, 42, 52, 0.12);
      --shadow-soft: 0 18px 42px rgba(0, 0, 0, 0.14);
      --shadow-card: 0 16px 34px rgba(0, 0, 0, 0.12);
      --max-width: 1180px;
    }

    :root {
      --icon-github: url("data:image/svg+xml;utf8,<svg fill='white' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'><path d='M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.01.08-2.1 0 0 .67-.21 2.2.82a7.56 7.56 0 0 1 4.01 0c1.53-1.03 2.2-.82 2.2-.82.44 1.09.16 1.9.08 2.1.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.19 0 .21.15.46.55.38A8.01 8.01 0 0 0 16 8c0-4.42-3.58-8-8-8'/></svg>");
    }


    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      font-family: 'Fira Sans', system-ui, -apple-system, 'Segoe UI', sans-serif;
      background: var(--color-surface-alt);
      color: var(--color-ink);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      line-height: 1.6;
    }

    a {
      color: inherit;
      text-decoration: none;
    }

    main {
      width: min(100%, var(--max-width));
      margin: 0 auto 3.5rem;
      padding: 4rem 1.5rem 0;
      flex: 1;
    }

    header.hero {
      background: linear-gradient(140deg, rgba(213, 48, 68, 0.96) 0%, rgba(0, 106, 133, 0.92) 60%, rgba(0, 43, 54, 0.94) 100%);
      color: #ffffff;
      border-radius: 28px;
      padding: 3.5rem clamp(1.5rem, 4vw, 3.5rem);
      margin-bottom: 3.25rem;
      box-shadow: var(--shadow-soft);
      position: relative;
      overflow: hidden;
    }

    header.hero h1 {
      font-size: clamp(2.25rem, 5vw, 3.3rem);
      font-weight: 700;
      margin: 0 0 0.75rem;
      letter-spacing: 0.5px;
    }

    header.hero p {
      margin: 0 0 1rem;
      font-size: 1.06rem;
      color: rgba(255, 255, 255, 0.85);
    }

    .hero-content {
      display: flex;
      gap: clamp(1.5rem, 4vw, 3.5rem);
      align-items: center;
      flex-wrap: wrap;
    }

    .hero-logo {
      width: clamp(120px, 18vw, 200px);
      filter: drop-shadow(0 10px 20px rgba(0, 0, 0, 0.2));
    }

    .hero-text {
      flex: 1 1 320px;
    }

    .hero-kicker {
      text-transform: uppercase;
      letter-spacing: 0.18em;
      font-size: 0.78rem;
      font-weight: 600;
      color: rgba(255, 255, 255, 0.7);
      margin: 0 0 1rem;
    }

    .hero-meta {
      display: flex;
      gap: 0.75rem;
      font-size: 0.98rem;
      align-items: center;
      flex-wrap: wrap;
      color: rgba(255, 255, 255, 0.75);
    }

    .hero-meta a {
      display: inline-flex;
      align-items: center;
      gap: 0.45rem;
      color: #ffffff;
      font-weight: 600;
      opacity: 0.88;
      transition: opacity 0.2s ease;
    }

    .hero-meta a:hover {
      opacity: 1;
    }

    .hero-actions {
      display: flex;
      gap: 0.9rem;
      flex-wrap: wrap;
      margin-top: 2rem;
    }

    .hero-actions .button.primary {
      background: #ffffff;
      color: var(--color-primary);
      box-shadow: 0 18px 36px rgba(0, 0, 0, 0.18);
    }

    .hero-actions .button.primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 20px 42px rgba(0, 0, 0, 0.22);
    }

    .hero-actions .button.secondary {
      border: 1px solid rgba(255, 255, 255, 0.5);
      color: #ffffff;
      background: rgba(255, 255, 255, 0.08);
    }

    section.collection {
      margin-bottom: 3.5rem;
    }

    section.collection header {
      margin-bottom: 1.4rem;
    }

    section.collection h2 {
      font-size: 1.75rem;
      margin: 0;
      color: var(--color-dark);
    }

    section.collection p {
      margin: 0.45rem 0 0;
      color: var(--color-muted);
    }

    .grid {
      display: grid;
      gap: 1.75rem;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    }

    .card {
      background: var(--color-surface);
      border-radius: 22px;
      padding: 2.1rem;
      display: flex;
      flex-direction: column;
      gap: 1.4rem;
      box-shadow: var(--shadow-card);
      border: 1px solid rgba(213, 48, 68, 0.12);
      position: relative;
      overflow: hidden;
      transition: transform 0.18s ease, box-shadow 0.18s ease;
    }

    .card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 6px;
      background: linear-gradient(90deg, rgba(213, 48, 68, 0.85) 0%, rgba(0, 106, 133, 0.85) 60%, rgba(0, 43, 54, 0.75) 100%);
      pointer-events: none;
    }

    .card:hover {
      transform: translateY(-6px);
      box-shadow: 0 20px 44px rgba(0, 0, 0, 0.18);
    }

    .card-header {
      display: flex;
      flex-direction: column;
      gap: 0.3rem;
    }

    .card-kicker {
      text-transform: uppercase;
      letter-spacing: 0.16em;
      font-size: 0.75rem;
      color: var(--color-secondary);
      font-weight: 600;
    }

    .card h2 {
      margin: 0;
      font-size: 1.32rem;
      color: var(--color-primary);
      letter-spacing: 0.3px;
    }

    .card .meta {
      font-size: 0.92rem;
      color: var(--color-muted);
      margin: 0.25rem 0 0;
    }

    .card .summary {
      margin: 0;
      line-height: 1.6;
      color: var(--color-ink);
    }

    .actions {
      display: flex;
      gap: 0.9rem;
      flex-wrap: wrap;
      margin-top: auto;
    }

    .button {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 0.7rem 1.25rem;
      border-radius: 999px;
      font-weight: 600;
      font-size: 0.94rem;
      transition: transform 0.15s ease, box-shadow 0.15s ease, background 0.15s ease, color 0.15s ease;
    }

    .button.primary {
      background: var(--color-primary);
      color: #ffffff;
      box-shadow: 0 12px 26px rgba(213, 48, 68, 0.28);
    }

    .button.primary:hover {
      transform: translateY(-3px);
      box-shadow: 0 16px 34px rgba(213, 48, 68, 0.36);
      background: var(--color-primary-dark);
    }

    .button.secondary {
      background: transparent;
      border: 1px solid var(--color-secondary);
      color: var(--color-secondary);
    }

    .button.secondary:hover {
      transform: translateY(-3px);
      background: rgba(0, 106, 133, 0.08);
      color: var(--color-secondary-dark);
    }

footer {
  background: var(--color-primary);
  color: #ffffff;
  text-align: center;
  padding: 1.8rem 1rem;
  font-size: 0.9rem;
  position: relative;
  margin-top: auto;
}

footer .footer-links {
  display: flex;
  justify-content: center;
  gap: 1.2rem;
  flex-wrap: wrap;
  margin-top: 0.6rem;
}

footer a {
  color: #ffffff;
  font-weight: 600;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  transition: opacity 0.2s ease, transform 0.2s ease;
}

footer a:hover {
  opacity: 0.9;
  transform: translateY(-2px);
}

.github-link::before {
  content: '';
  display: inline-block;
  width: 18px;
  height: 18px;
  background: no-repeat center / contain var(--icon-github);
  transition: transform 0.2s ease;
}



footer .github-link:hover::before {
  transform: rotate(-10deg) scale(1.1);
}

    code {
      background: rgba(0, 43, 54, 0.08);
      padding: 0.2rem 0.4rem;
      border-radius: 6px;
      font-size: 0.95rem;
    }

    .empty {
      background: rgba(213, 48, 68, 0.08);
      border-radius: 18px;
      padding: 3rem;
      text-align: center;
      border: 1px dashed rgba(213, 48, 68, 0.35);
      color: var(--color-primary);
    }

    @media (max-width: 720px) {
      header.hero {
        padding: 2.75rem 1.5rem;
      }

      .hero-actions {
        flex-direction: column;
        align-items: stretch;
      }
    }

.github-link {
  display: inline-flex;
  align-items: center;
  gap: 0.45rem;
  color: #ffffff;
  font-weight: 600;
  opacity: 0.88;
  transition: opacity 0.2s ease, transform 0.2s ease;
  text-decoration: none;
  position: relative;
}

.github-link:hover {
  opacity: 1;
  transform: translateY(-2px);
}

.github-link:hover::before {
  transform: rotate(-10deg) scale(1.1);
}


  </style>
</head>
<body>
  <main>
    <header class="hero">
      <div class="hero-content">
        <img class="hero-logo" src="images/ugr/UGR-MARCA-01-color.svg" alt="Universidad de Granada">
        <div class="hero-text">
          <p class="hero-kicker">${escapeHtml(heroSubtitle)}</p>
          <div class="hero-meta">
            <span>Autor: ${escapeHtml(authorName)}</span>
            <a href="${githubUrl}" rel="noopener" class="github-link">Repositorio en GitHub</a>
          </div>
        </div>
      </div>
    </header>

    <section class="collection">
      <header>
        <h2>Presentaciones disponibles</h2>
        <p>Selecciona una presentación para verla online o descargar su PDF asociado.</p>
      </header>
      <div class="grid">
        ${cardsMarkup}
      </div>
    </section>
  </main>
<footer>
  <div>Made with ❤️ from a remote island</div>
  <div class="footer-links">
    <a href="${githubUrl}" rel="noopener" class="github-link">
      Repositorio on GitHub
    </a>
  </div>
  <div>© ${new Date().getFullYear()} Ernesto Serrano</div>
</footer>

</body>
</html>`;

ensureDir(outputFile);
fs.writeFileSync(outputFile, template.trim());

console.log(`Index generado en ${outputFile}`);
