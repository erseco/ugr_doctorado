---
marp: true
title: Ejemplo de Presentación con Marp
description: Una presentación básica con Marp
theme: default
paginate: true
---

<style>
/* Asegúrate de que cada sección tenga posición relativa */
section {
  position: relative;
}

/* Estilo para la marca de agua */
section::before {
  content: "BORRADOR";
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) rotate(-30deg);
  font-size: 5em;
  color: rgba(0, 0, 0, 0.1);
  z-index: 1; /* Debe estar detrás del contenido */
  pointer-events: none; /* No interferir con la interacción */
}
</style>

# ¡Bienvenidos a Marp! 🚀

Un ecosistema para presentaciones basado en **Markdown**.

---

## ¿Qué es Marp?

- Convierte archivos Markdown en presentaciones.
- Exporta a:
  - **HTML**
  - **PDF**
  - **Impresiones físicas**

---

## Ventajas de Marp

- **Simplicidad:** Usa solo Markdown.
- **Portabilidad:** Genera archivos PDF listos para compartir.
- **Edición visual:** Previsualización en editores como VS Code.

---

## ¡Gracias! 🎉

- [Marp GitHub](https://github.com/marp-team/marp)
- [Documentación oficial](https://marp.app)

---

## ¡Empieza ahora!

```bash
npm install -g @marp-team/marp-cli
marp presentation.md --pdf
```