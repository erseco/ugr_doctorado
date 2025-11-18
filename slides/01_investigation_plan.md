---
title: Plan de Investigación - eXeLearning
author: Ernesto Serrano
description: Defensa del plan de investigación
keywords: [DevOps, CI/CD, OSS, REA, Soft Computing]
header: Ernesto Serrano
footer: "Soft Computing · Universidad de Granada"

marp: true
theme: lorca
transition: cube

size: 16:9
lang: es-ES
math: mathjax
paginate: true

---

<!-- _class: title-academic -->

![bg left:50%](../images/ugr/UGR-MARCA-01-color.svg)

<div class="title">De la catedral al bazar</div>
<div class="subtitle">Metodología de modernización de sistemas obsoletos en comunidades abiertas. Estudio de caso: eXeLearning</div>
<div class="author">Ernesto Serrano</div>
<div class="date">Granada, 2025</div>
<div class="organization">Escuela Internacional de Posgrado</div>

<!--
NOTAS AL ORADOR:
- Presentarse brevemente.
- Frase de contexto: "Hoy presento el plan de investigación de mi tesis doctoral".
- Hook: "¿Qué pasa cuando un software educativo usado por miles de docentes entra en crisis tecnológica y organizativa?"
- Remarcar: no vengo a contar un proyecto ya hecho, sino una investigación que va a estudiar cómo modernizarlo.
- Duración total: 15-20 minutos aproximadamente
-->

---

<!-- _class: title -->
![bg opacity:0.3 grayscale:1](../images/slides/places/Dawn_Charles_V_Palace_Alhambra_Granada_Andalusia_Spain.jpg)

<!-- _backgroundColor: rgba(238, 238, 238, 0.91)  -->

# Programa de Doctorado en **TIC**

- Línea: **Soft Computing**
- Enfoque: **Metodología para modernizar software heredado**
- Director: **Juan Julián Merelo Guervós**

<!--
NOTAS AL ORADOR:
- Enlazar con la línea de Soft Computing: repositorios como sistemas complejos y autoorganizados.
- Aclarar que la tesis se orienta a desarrollar y validar una metodología general usando eXeLearning como caso de estudio.
- La decisión formal sobre modalidad (compendio o no) se ajustará a la normativa y a la producción científica final.
-->

---

<!-- _class: toc  -->

# Índice

0. [Título y contexto](#1)
1. [Introducción y estado del arte](#4)
2. [Problema y marco teórico](#9)
3. [Hipótesis y objetivos](#12)
4. [Metodología y plan de trabajo](#17)
5. [Impacto esperado](#21)
6. [Conclusiones](#23)


<!--
NOTAS AL ORADOR:
- Se sigue la estructura de la rúbrica:
  1) Estado del arte e introducción del caso.
  2) Formulación del problema enmarcado teóricamente.
  3) Hipótesis y objetivos de investigación.
  4) Metodología y plan temporal.
  5) Impacto y conclusiones.
-->

---

<!-- _class: chapter -->

# 1. Introducción y estado del arte

## De la catedral al bazar

<!--
NOTAS AL ORADOR:
- Situar brevemente qué es eXeLearning y por qué es relevante en educación.
- Enlazar con la transición "de la catedral al bazar" como cambio de modelo organizativo.
- Situar brevemente el problema general: modernización de sistemas heredados en comunidades abiertas.
-->

---

# El reto: de la catedral al bazar en sistemas heredados

**El fenómeno** (Raymond, 1999; Capiluppi & Michlmayr, 2007)
Transición de modelos centralizados ("catedral") a modelos distribuidos y autoorganizados ("bazar") en proyectos de software libre.

**Problema típico** (Tsanas, 2024; Li et al., 2020; Ma et al., 2022)
Migrar sistemas heredados sin detener el servicio, usando patrones como *Strangler Fig*, manteniendo la coherencia funcional.

**Perspectiva de sistemas complejos** (Merelo et al., 2017; Merelo, 2015)
Repositorios y comunidades de desarrollo como sistemas autoorganizados.

**Caso de estudio: eXeLearning**
Proyecto educativo de código abierto en situación crítica de modernización, que se utilizará como laboratorio para aplicar y evaluar estas ideas.

<!--
NOTAS AL ORADOR:
- Enfatizar: primero el marco general y trabajos previos, después el caso.
-->

---

# ¿Qué es **eXeLearning**?

<div class="multicolumn vcenter">
<div>

#### Herramienta de autor de código abierto para crear **Recursos Educativos Abiertos** (REA)

- **Origen:** Nueva Zelanda (2007), luego España (INTEF, CEDEC)
- **Usuarios:** Miles de docentes en administraciones educativas
- **Función:** Crear contenido interactivo sin conocimientos técnicos
- **Formatos:** SCORM, HTML5, ePub, **elp**

</div>
<div>

![h:350px center drop-shadow:4px,5px,15px,#010101](../images/slides/exelearning/screenshot00c.png)
<figcaption>Interfaz de eXeLearning: creación de REA.</figcaption>

</div>
</div>

<!--
NOTAS AL ORADOR:
- Subrayar que es software crítico en muchas administraciones educativas.
- REA = recursos abiertos, reutilizables, accesibles
- Conectar con el estado del conocimiento: eXe aparece en la literatura sobre REA y herramientas de autor.
- Si buscamos en buscadores:
  - Google Scholar: 7860 resultados
  - Web of Science: 130 resultados
  - Dialnet: 101 resultados
  - DigiBug: 21 resultados
-->

---

# De la **catedral** al **bazar**

<div class="multicolumn vcenter"><div>

### Modelo "Catedral"

- Desarrollo centralizado
- Equipo reducido y estable
- Financiación institucional
- Control jerárquico

</div><div>

### Modelo "Bazar"

- Desarrollo distribuido
- Comunidad de voluntarios
- Colaboración interadministrativa
- Autoorganización

</div></div>

> **Pregunta de fondo:** ¿Cómo estructurar el “bazar” para garantizar la continuidad y calidad de proyectos *heredados*?

<!--
NOTAS AL ORADOR:
- Transición FORZOSA de catedral a bazar, no planificada
- El bazar tiene ventajas (resiliencia, diversidad) pero también riesgos (fragmentación, falta de dirección)
- Referenciar brevemente la literatura sobre modelos de desarrollo OSS (Raymond, Capiluppi & Michlmayr).
- Introducir que la tesis se sitúa en este contexto: un proyecto educativo de software libre en transición crítica.
-->

---

# La **doble crisis** del proyecto

<div class="multicolumn"><div>

<div class="callout danger">

### Crisis tecnológica

- Base de código en **Python 2** (fin de vida en 2020)
- Limitaciones para mantener y extender la herramienta
- Riesgo de abandono si no se moderniza

</div>

</div><div>

<div class="callout warning">

### Crisis organizativa

- Licitación 2021 (MEFP + CCAA) → entrega fallida
- Código incompleto, errores graves, arquitectura poco clara
- Desvinculación de socios institucionales

</div>

</div></div>

<!--
NOTAS AL ORADOR:
- Doble golpe: tecnología Y gobernanza
- Python 2 EOL = sin soporte, sin seguridad, sin futuro
- El intento institucional de modernización fracasó estrepitosamente
- Crisis de confianza: ¿quién continúa el proyecto?
- Relacionar esta situación con trabajos previos sobre fracaso en modernización de software legado y retos de gobernanza en OSS.
- No dramatizar; presentar la crisis como punto de partida para una investigación.
- Presentar esta doble crisis como motivación del caso de estudio, no como la tesis entera.
-->


---

<!-- _class: chapter -->

# 2. Problema y marco teórico

## Un caso de modernización en transición crítica



---

# Formulación del problema

> eXeLearning se encuentra en una transición desde un modelo institucional centralizado (catedral) a un modelo comunitario distribuido (bazar), en pleno proceso de modernización técnica.

- **Necesidad técnica:** migrar desde una base de código obsoleta a una plataforma mantenible y extensible.
- **Necesidad organizativa:** coordinar contribuciones de una comunidad distribuida, con diferentes niveles de experiencia.
- **Problema científico:** falta evidencia sobre cómo prácticas tipo DevOps influyen en la modernización de proyectos educativos en este tipo de transición.

<!--
NOTAS AL ORADOR:
- Dejar claro que la tesis no asume que DevOps funcione por defecto: se propone estudiarlo empíricamente.
- Conectar con la rúbrica: de la revisión del estado del conocimiento se deriva un problema bien definido.

- NOTA: el problema está formulado como cuestión abierta, no como solución ya encontrada 
-->

---


# Marco teórico

<div class="multicolumn vcenter"><div>

### Paradoja de Teseo

Necesidad de pruebas de regresión que aseguren la **identidad funcional** durante la sustitución gradual de componentes.

### Strangler Fig Pattern

Migración incremental: **rodear el legado** con componentes nuevos y sustituirlo de forma progresiva.

</div><div>

### Soft Computing

Repositorios como **sistemas complejos autoorganizados**: patrones de actividad, criticidad y autoorganización.

### DevOps como mecanismo de estabilización

Prácticas de integración continua y automatización como posible forma de organizar el "bazar".

</div></div>

<!--
NOTAS AL ORADOR:
- Mostrar que el problema se apoya en marcos conceptuales claros: filosofía de identidad, patrones de migración, sistemas complejos y prácticas DevOps.
- Enfatizar que DevOps aquí no se presenta como solución dada, sino como objeto de estudio: queremos analizar su efecto en este contexto.

¿y Soft Computing dónde está exactamente?” Podemos usar tecnicas como: clustering de contribuciones, análisis de series temporales, quizá modelos predictivos ligeros sobre métricas.

-->

---
<!-- _class: chapter -->

# 3. Hipótesis y objetivos

## DevOps como objeto de estudio

---

# Hipótesis de trabajo

> ¿Se puede reducir el tiempo de desarrollo, aumentar la frecuencia de entregas y mitigar los problemas técnicos acumulados en un proyecto de código abierto adoptando una **metodología inspirada en prácticas DevOps**?

<!--
NOTAS AL ORADOR:
- Insistir en el carácter contrastable de las hipótesis: cada una se puede validar o refutar con métricas.
- Evitar el tono de "ya lo hemos conseguido"; hablar siempre en futuro y condicional.
-->

---

# Hipótesis específicas

- **H1 – Proceso**  
  La implantación de un proceso de integración continua y entregas frecuentes reducirá el tiempo de ciclo y aumentará la regularidad de versiones estables.

- **H2 – Calidad**  
  El uso sistemático de pruebas automatizadas, revisión por pares y análisis de código reducirá defectos y facilitará el mantenimiento.

- **H3 – Evolución segura**  
  La refactorización guiada por pruebas permitirá sustituir componentes heredados con menor riesgo, favoreciendo una modernización progresiva.


---

# Objetivo general

> Desarrollar y validar una **metodología de modernización** aplicada al caso de eXeLearning, y cuantificar su impactacto en la reducción de la deuda técnica y la estabilidad del ciclo de vida del software.

<!--
NOTAS AL ORADOR:
- Explicar que eXeLearning es el laboratorio donde se prueba la metodología, pero el objetivo es generalizable a proyectos similares.
-->

---

# Objetivos específicos

<div class="multicolumn"><div>

<div class="callout note">

**O1 – Diagnosticar**

- Establecer métricas de proceso, producto y DX que describan el estado inicial del proyecto y su comunidad.

</div>

</div><div>

<div class="callout info">

**O2 – Proponer**

- Diseñar e implantar en el caso de estudio una metodología de modernización basada en prácticas DevOps orientada a mejorar dichas métricas.

</div>

</div><div>

<div class="callout tip">

**O3 – Evaluar**

- Evaluar la evolución de las métricas y extraer pautas aplicables a proyectos con características similares.

</div>

</div></div>

<!--
NOTAS AL ORADOR:

O1 – Diagnosticar
 - Definir y calcular un conjunto de métricas de proceso (p. ej. tiempo de ciclo, frecuencia de versiones) y de producto (p. ej. defectos, complejidad, cobertura de pruebas) que describan el estado inicial.
 - Caracterizar también la comunidad y la *developer experience* (DX) mediante datos del repositorio y cuestionarios breves.

O2 – Proponer e implantar
 - Diseñar una metodología de modernización inspirada en prácticas DevOps que especifique qué cambios de proceso se introducen y qué métricas se pretende mejorar.
 - Implantar dicha metodología en el caso de estudio, incluyendo automatización parcial, pruebas y revisión colaborativa.

O3 – Evaluar
 - Analizar la evolución de las métricas de proceso, producto y DX tras la intervención, comparándolas con la línea base.
 - Extraer pautas y condiciones de aplicabilidad para otros proyectos de características similares.
-->


---

<!-- _class: chapter -->

# 4. Metodología y plan de trabajo

## De la formulación al diseño experimental

---

# Metodología

Enfoque mixto, con combinación de análisis cuantitativo de repositorios y evaluación cualitativa mediante entrevistas y encuestas.

1. **Revisión bibliográfica:** Estado del arte sobre modernización de software *legacy*, patrones como *Strangler Fig*, métricas de calidad, DevOps, DX.

2. **Diagnóstico inicial:** Análisis de código, commits, releases y problemas técnicos acumulados.

3. **Diseño e implantación de la metodología:** Arquitectura, procesos de integración continua, test, análisis estático y participación de la comunidad.

4. **Evaluación:** Comparativa de métricas pre/post intervención y análisis cualitativo (encuestas).

5. **Producción científica**: Resultados → artículos → transferencia

<!--
NOTAS AL ORADOR:
- Recalcar alineación con la rúbrica: metodología adecuada a los objetivos, con ventajas y limitaciones explícitas.
- Mencionar brevemente que no se tratan datos personales sensibles, por lo que los aspectos éticos se centran en transparencia de procesos y licencias de software libre.

1. **Revisión bibliográfica**
   - Modernización de software legado, DevOps en OSS, métricas de calidad y productividad.
   - Posicionamiento de eXeLearning en el ecosistema de herramientas de autor y REA.

2. **Diagnóstico inicial**
   - Análisis del repositorio: actividad, releases, incidencias.
   - Métricas de código: complejidad, módulos críticos, problemas acumulados.

3. **Diseño e implantación de la metodología**
   - Definición de arquitectura de migración y procesos automáticos.
   - Introducción de pruebas, análisis estático y flujos de colaboración.
   - IMPORTANTE: Siguiendo el rigor científico, no aplicaremos cambios masivos al sistema crítico desde el día 1. 
      Primero aislaremos un módulo (piloto) para validar 
      que nuestras métricas de control funcionan, y solo entonces escalaremos

4. **Evaluación**
   - Comparación pre/post de métricas de proceso y calidad.
   - Entrevistas y encuestas a desarrolladores y usuarios.

5. **Producción científica**
   - Artículos que recojan el diagnóstico, la metodología propuesta y los resultados de la evaluación.



-->

---


# Planificación temporal (3 años)

<div style="margin: 0 150px; width: 100%;">


| Actividad | Año 1 | Año 2 | Año 3 |
| :------ | :----: | :----: | :----: |
| **Revisión y marco teórico**  | X | X |  |
| **Diagnóstico inicial** | X |  |  |
| **Diseño de la metodología** | X | X |  |
| **Implantación y ajuste** |  | X | X |
| **Evaluación y validación** | Eval. inicial | Eval. intermedia | Validación final|
| **Transferencia de resultados** |   |   | X |
| **Artículos y memoria de tesis** | Art. 1 | Art. 2 | Art. 3 + memoria |

</div>

<!--
NOTAS AL ORADOR:
- Resumir en una frase:
  * Año 1: marco teórico y diagnóstico.
  * Año 2: diseño e implantación de la metodología.
  * Año 3: evaluación, transferencia y redacción final.
- No entrar al detalle de cada celda, la tabla ya transmite estructura y factibilidad.
-->

---

# Medios y financiación

<div class="multicolumn vcenter"><div>

### Recursos disponibles

- Repositorio público de eXeLearning.
- Infraestructura para control de versiones e integración continua.
- Comunidad de desarrolladores y usuarios activos.

</div><div>

### Financiación

- Recursos propios vinculados al rol profesional.
- Ausencia de costes adicionales significativos.
- Apoyo institucional al proyecto.

</div></div>

<!--
NOTAS AL ORADOR:
- Destacar que el plan es factible con los medios ya disponibles.
-->

---

<!-- _class: chapter -->

# 5. Impacto esperado

## Más allá de eXeLearning

---

# Resultados esperados

**En el ámbito científico**

- Caracterización de un caso real de modernización de software educativo.
- **Metodología de modernización validada** en un contexto de comunidad distribuida.
- Evidencia empírica sobre el impacto de prácticas DevOps en proceso y producto.

**En el ámbito tecnológico**

- Continuidad y mejora de eXeLearning como herramienta para creación de REA.
- Documentación y guías transferibles a otros proyectos de software educativo.

<!--
NOTAS AL ORADOR:
- Subrayar que la “metodología validada” es la aportación central a la comunidad científica.
- El caso eXeLearning ofrece además un beneficio directo a la comunidad educativa.
-->

---

<!-- _class: chapter -->

# 6. Conclusiones

## De la catedral al bazar, con método

---

# Conclusiones

Esta tesis propone **trascender la ingeniería para hacer ciencia**:

- Estudiar la modernización de eXeLearning como **caso de transición crítica** de un modelo "catedral" a un "bazar" comunitario.
- Formular y contrastar **hipótesis claras** sobre el papel de una metodología DevOps en esa transición.
- Desarrollar y validar una **metodología de modernización** que pueda reutilizarse en proyectos similares.

<!--
NOTAS AL ORADOR:
- Cerrar con la idea de que eXeLearning es el laboratorio donde se prueba una metodología de interés general.
- Dejar claro que el éxito de la tesis no es solo “que eXe funcione mejor”, sino que haya una contribución científica sobre cómo lograrlo.
- Cerrar recalcando la aportación científica: metodología + evidencia, más allá de un único proyecto.
-->

---

<!-- _class: title -->
![bg opacity:0.3 grayscale:1](../images/slides/places/Dawn_Charles_V_Palace_Alhambra_Granada_Andalusia_Spain.jpg)

<!-- _backgroundColor: rgba(238, 238, 238, 0.91)  -->

# Muchas gracias

### ¿Preguntas o comentarios?

<!--
NOTAS AL ORADOR:
- Anticipar preguntas típicas:
  * ¿Qué métricas concretas se usarán?
  * ¿Cómo se aislará el efecto de DevOps de otros factores?
  * ¿Qué ocurre si la comunidad no adopta la metodología?
-->

---

<!-- _class: "references" -->

# Bibliografía

<div class="multicolumn"><div>

1. **Raymond, E. S. (1999).** *The cathedral and the bazaar.* O'Reilly.
2. **Capiluppi, A. et al. (2007).** *The cathedral and the bazaar: A study of the open source development model.*
3. **Tsanas, J. P. S. (2024).** *Using the Strangler Fig Pattern on a monolithic game server.*
4. **Merelo, J. J. et al. (2017).** *Self-organized criticality in software repositories.*

</div><div>

5. **Li, J. et al. (2020).** *Microservice architecture: A case study of a legacy system.*
6. **Aguado-Moralejo, R. et al. (2021).** *eXeLearning, una herramienta de autor para la creación de Recursos Educativos Abiertos.*
7. **Ministerio de Educación y Formación Profesional (2021).** *Resolución de la Secretaría de Estado de Educación.*

</div></div>

---

<!-- _class: white-slide -->

<div class="vcenter">

![bg h:60%](../images/ugr/UGR-MARCA-01-monocromo.svg)

</div>
