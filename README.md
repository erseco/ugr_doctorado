### **ugr_doctorado**

[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)  
[![GitHub License](https://img.shields.io/github/license/erseco/ugr_doctorado.svg)](https://github.com/erseco/ugr_doctorado/blob/master/LICENSE)

This repository contains all the material related to my PhD, including the thesis, papers, code, and bibliography.

---

## **Repository Structure**

- **[project/](project/):** Initial project, previous to thesis.  
- **[thesis/](thesis/):** Files for the thesis written in LaTeX and Markdown.  
- **[papers/](papers/):** Research papers and publications.  
  - **[00_sample/](papers/00_sample/):** Sample article.  
  - **[01_paper1/](papers/01_paper1/):** First research paper.  
- **[code/](code/):** Source code used in the project.  
- **[bibliography/](bibliography/):** Bibliographic files (e.g., BibTeX, references).  
- **[README.md](README.md):** This file.  

---

## **Generating Documentation**

To generate PDF files from the Markdown sources, use the provided `Makefile`. Simply execute:

```bash
make all
```

Ensure you have the required dependencies installed. You can install them on Debian/Ubuntu-based systems with:

Generated PDFs will be located in the `output/` directory.

---

## **PhD Project Overview / Visión general del proyecto doctoral**

### **Title / Título**
- *From Cathedral to Bazaar: Modernization of eXeLearning through DevOps, CI/CD and development best practices in an OSS educational project*  
- *De la catedral al bazar: Modernización de eXeLearning mediante DevOps, integración continua y buenas prácticas de desarrollo en un proyecto educativo de código abierto*

### **Author**
**Ernesto Serrano Collado** ([@erseco](https://github.com/erseco/))  

### **Director**
** Juan Julián Merelo Guervós ([@JJ](https://github.com/jj/))

### **Abstract (English)**
This PhD thesis takes [eXeLearning](https://github.com/exelearning/exelearning), an open-source authoring tool for creating and publishing educational resources, as a case study of software modernization.  
Originally developed in Python 2 and later reimplemented in PHP with Symfony, eXeLearning faces the paradox of Theseus: if all its technological components are replaced, is it still the same project?  
The research applies DevOps practices, Continuous Integration/Continuous Delivery (CI/CD), and automated quality tests to evaluate their impact on process performance, code maintainability, and sustainability of an open-source project in the educational field.  
The work combines action research and longitudinal repository analysis, aiming to generate empirical evidence transferable to other public software projects.

### **Resumen (Español)**
Esta tesis doctoral toma a [eXeLearning](https://github.com/exelearning/exelearning), una herramienta de autor de código abierto para crear y publicar recursos educativos, como caso de estudio de modernización de software.  
Desarrollado originalmente en Python 2 y posteriormente reimplementado en PHP con Symfony, eXeLearning enfrenta la paradoja de Teseo: si se reemplazan todos sus componentes tecnológicos, ¿sigue siendo el mismo proyecto?  
La investigación aplica prácticas DevOps, Integración y Entrega Continua (CI/CD) y pruebas de calidad automatizadas para evaluar su impacto en el rendimiento del proceso, la mantenibilidad del código y la sostenibilidad de un proyecto OSS en el ámbito educativo.  
El trabajo combina investigación-acción y análisis longitudinal del proyecto, con el objetivo de generar evidencia empírica transferible a otros proyectos de software público.

---

## **Licenses**

- **Thesis and Presentation:** Released under the **Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License**.  
  - [View License Details](https://creativecommons.org/licenses/by-nc-sa/4.0/)

- **Code:** Licensed under the **GNU General Public License Version 3**.  
  - [View License Details](https://www.gnu.org/licenses/gpl-3.0.html)

---

Feel free to contribute or open issues to report problems or suggest improvements.