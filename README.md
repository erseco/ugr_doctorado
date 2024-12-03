### **ugr_doctorado**

[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)  
[![GitHub License](https://img.shields.io/github/license/erseco/ugr_doctorado.svg)](https://github.com/erseco/ugr_doctorado/blob/master/LICENSE)

This repository contains all the material related to my PhD, including the thesis, papers, code, and bibliography.

---

## **Repository Structure**

- **[project/](project/):** General project-related files.  
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
make
```

Ensure you have the required dependencies installed. You can install them on Debian/Ubuntu-based systems with:

```bash
sudo apt-get -qq update && sudo apt-get install -y --no-install-recommends \
  texlive-fonts-recommended texlive-latex-extra texlive-fonts-extra dvipng \
  texlive-latex-recommended texlive-bibtex-extra biber
```

Generated PDFs will be located in the `output/` directory.

---

## **PhD Project Overview**

### **Topic: Moving Target Defense**  
**Author:** Ernesto Serrano Collado  
**Supervisor:** Juan Julián Merelo Guervós  

This thesis explores adaptive cybersecurity strategies under the concept of Moving Target Defense (MTD). The full abstract will be disclosed in future updates.

---

## **Licenses**

- **Thesis and Presentation:** Released under the **Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License**.  
  - [View License Details](https://creativecommons.org/licenses/by-nc-sa/4.0/)

- **Code:** Licensed under the **GNU General Public License Version 3**.  
  - [View License Details](https://www.gnu.org/licenses/gpl-3.0.html)

---

Feel free to contribute or open issues to report problems or suggest improvements.