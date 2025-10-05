// generate.js

// Dependencies
const rawArgs = process.argv.slice(2);

const fs = require("fs").promises;
const path = require("path");
const yaml = require("js-yaml");
const PizZip = require("pizzip");
const Docxtemplater = require("docxtemplater");
const libre = require("libreoffice-convert");


// Citation.js
const { Cite, plugins } = require("@citation-js/core");
require("@citation-js/plugin-bibtex");
require("@citation-js/plugin-csl");


// Small promise wrapper around libreoffice-convert's callback API
function convertToPdf(buf) {
  return new Promise((resolve, reject) => {
    libre.convert(buf, ".pdf", undefined, (err, done) => {
      if (err) return reject(err);
      resolve(done);
    });
  });
}


/** Carga bib y devuelve referencias formateadas IEEE según un array de keys. */
async function buildReferencesFromBib({ bibPath, cslPath, keys }) {
  // Cargar CSL (IEEE). Si falla, usamos “ieee” interno de citation-js.
  let styleName = "local-ieee";
  try {
    const csl = await fs.readFile(cslPath, "utf8");
    plugins.config.get("@csl").templates.add(styleName, csl);
  } catch {
    styleName = "ieee"; // fallback
  }

  // Cargar .bib completo
  const bibSource = await fs.readFile(bibPath, "utf8");
  const all = new Cite(bibSource); // parsea todo el .bib

  // Indexar por id
  const byId = new Map(all.data.map(entry => [entry.id, entry]));

  // Seleccionar en el orden pedido
  const selected = keys
    .map(k => byId.get(k))
    .filter(Boolean);

  // Avisos por keys no encontradas (solo consola)
  const missing = keys.filter(k => !byId.has(k));
  if (missing.length) {
    console.warn("⚠️  Keys no encontradas en .bib:", missing.join(", "));
  }

  // Formatear bibliografía en texto plano (IEEE ya numera)
  const formatted = new Cite(selected).format("bibliography", {
    template: styleName,
    format: "text"
  }).split("\n") // cada línea es una entrada formateada
    .filter(line => line.trim().length);

  // Si el estilo ya numera (p.ej., IEEE), no anteponer [n]
  const numericRe = /^\s*(\[\d+\]|\d+[.)])/;
  const styleAlreadyNumbers = formatted.every(line => numericRe.test(line));
  const items = styleAlreadyNumbers
    ? formatted
    : formatted.map((txt, i) => `[${i + 1}] ${txt}`);

  // Para iteraciones en docxtemplater
  const arrayForDocx = items.map(text => ({ text }));

  return {
    references_formatted: arrayForDocx,              // [{text: "..."}]
    references_block: items.join("\n"),              // string entero por si prefieres un bloque
    references: items.join("\n")                    // alias solicitado: cadena final "references"
  };
}



async function generate() {
  // Parse very small CLI: --key value
  const argv = {};
  for (let i = 0; i < rawArgs.length; i++) {
    const a = rawArgs[i];
    if (a.startsWith("--")) {
      const key = a.slice(2);
      const val = rawArgs[i + 1] && !rawArgs[i + 1].startsWith("--") ? rawArgs[++i] : true;
      argv[key] = val;
    }
  }

  const outdir = argv.outdir || path.join(__dirname, "..", "output", "project");
  const template = argv.template || path.join(__dirname, "project_template.docx");

  await fs.mkdir(outdir, { recursive: true });

  const docxPath = path.join(outdir, "project.docx");
  const pdfPath = path.join(outdir, "project.pdf");




  // Load data first (used to compute references)
  const data = yaml.load(await fs.readFile(path.join(__dirname, "data.yaml"), "utf8"));

  // ----- Bibliografía desde .bib si hay "references_keys" -----
  const bibPath = argv.bib || path.join(__dirname, "..", "bibliography", "references.bib");
  const cslPath = argv.csl || path.join(__dirname, "..", "bibliography", "ieee.csl");

  if (Array.isArray(data.references_keys) && data.references_keys.length) {
    try {
      const { references_formatted, references_block, references } = await buildReferencesFromBib({
        bibPath, cslPath, keys: data.references_keys
      });
      // Estos campos quedan disponibles para la plantilla
      data.references_formatted = references_formatted; // para bucles {#references_formatted}{text}{/references_formatted}
      data.references_block = references_block;         // bloque completo
      data.references = references;                     // alias pedido
    } catch (e) {
      console.warn("⚠️  No se pudieron procesar las referencias del .bib:", e.message);
    }
  }

  // Load the DOCX template as binary string (required by PizZip)
  const content = await fs.readFile(template, "binary");
  const zip = new PizZip(content);
  const doc = new Docxtemplater(zip, { paragraphLoop: true, linebreaks: true });
  // Render with data (including references)
  doc.render(data);

  // Save DOCX
  const docxBuf = doc.getZip().generate({ type: "nodebuffer" });
  await fs.writeFile(docxPath, docxBuf);
  console.log("✅ DOCX generated:", docxPath);

  // Convert DOCX → PDF
  const pdfBuf = await convertToPdf(docxBuf);
  await fs.writeFile(pdfPath, pdfBuf);
  console.log("✅ PDF generated:", pdfPath);

}

// Run
generate().catch(err => {
  console.error("❌ Error:", err);
});
