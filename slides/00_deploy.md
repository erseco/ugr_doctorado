---
title: Despliegue de eXeLearning con Docker y Ansible
tags: presentacion

marp: true
theme: lorca
transition: cube

size: 16:9
lang: es-ES
math: mathjax
paginate: true
---

# Despliegue de eXeLearning

Cómo pasar de código a instancia lista para usar

<p align="center">
  <img src="https://logos-world.net/wp-content/uploads/2021/02/Docker-Logo-700x394.png" alt="Docker" width="180">
  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/PHP-logo.svg/711px-PHP-logo.svg.png" alt="PHP" width="150">
  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Nginx_logo.svg/512px-Nginx_logo.svg.png" alt="Nginx" width="200">
  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Ansible_logo.svg/256px-Ansible_logo.svg.png" alt="Ansible" width="140">
</p>

---

# Objetivos de la sesión

- Entender **qué necesita eXeLearning** para funcionar.
- Ver la **arquitectura** del contenedor
- Revisar las **opciones de configuración** más importantes (`.env`).
- Ver cómo desplegar:
  - Con `docker run`
  - Con `docker compose` usando los ejemplos de `doc/deploy`
  - Con `ansible` para despliegues reproducibles.

---

# Requisitos básicos

- Un servidor Linux (por ejemplo, Ubuntu 24.04) con:
  - **Docker** instalado
  - Acceso a Internet para descargar las imágenes.

> Idea clave: toda la aplicación vive en contenedores, no instalamos PHP ni Nginx en el sistema directamente.

---

# Arquitectura de la instancia

<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/PHP-logo.svg/711px-PHP-logo.svg.png" alt="PHP" width="130">
  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Nginx_logo.svg/512px-Nginx_logo.svg.png" alt="Nginx" width="160">
  <img src="https://logos-world.net/wp-content/uploads/2021/02/Docker-Logo-700x394.png" alt="Docker" width="150">
</p>

- Contenedor único basado en **Alpine Linux**:
  - **Nginx** para estáticos / proxy frontal.
  - **PHP 8.4-FPM** para ejecutar Symfony.
  - **Mercure** para tiempo real.
- Configuración controlada mediante **variables de entorno**.
- Datos y base de datos en volúmenes persistentes.

---

# Imágenes Docker y *registries*

- Imágenes oficiales publicadas de forma automática en:
  - **Docker Hub**
  - **GitHub Container Registry (ghcr.io)**
- Dos líneas principales:
  - **Versión estable**  
    - Tag `latest`  
    - Generada cuando se crea un **tag** en el repositorio.
  - **Versión de desarrollo**  
    - Tag `main`  
    - Generada desde la rama principal de desarrollo.

> En producción se recomienda usar siempre tags de versión concretos o **latest**.

---

# Bases de datos soportadas

<p align="center">
  <img src="https://logospng.org/download/sqlite/sqlite-512.png" alt="SQLite" width="120">
</p>

- Soporte de base de datos mediante Doctrine:
  - **SQLite**
    - Muy cómoda para desarrollo y pruebas.
  - **MariaDB / MySQL**
    - Pensada para producción clásica.
  - **PostgreSQL**
    - Alternativa para entornos que ya usan Postgres.
- La selección se hace con la variable `DB_DRIVER` y el resto de variables de conexión.

---

# Ficheros **.env** y **.env.dist**

- En el repositorio hay un archivo **`.env.dist`**:
  - Plantilla de variables de entorno de la aplicación.


- Para desplegar:
  1. Copiar **.env.dist** a **.env**
  2. Ajustar los valores para el entorno concreto.


---

# Variables clave (1/3) – Núcleo

Bloque Symfony / entorno:

- `APP_ENV=prod`

  - Entorno de ejecución (`prod`, `dev`, `test`).
  - `APP_DEBUG=0`

  - 1 para activar mensajes de depuración.
  - `APP_SECRET=CHANGE_THIS_TO_A_SECRET`

  - Clave secreta para firmas internas.
  - Es obligatorio cambiarla en producción.
  - `APP_PORT=8080`

  - Puerto externo donde exponer el contenedor.


Rutas:

- `BASE_PATH=`

  - Vacío: instalación en la raíz del dominio.
  - Ejemplos: `/exelearning`, `/web/exelearning`.

---

# Variables clave (2/3) – Autenticación

Métodos de acceso:

- `APP_AUTH_METHODS=password,cas,openid,guest`

  - Lista separada por comas:

    - `password` → usuario / contraseña local.
    - `cas` → servidor CAS.
    - `openid` → OpenID Connect.
    - `guest` → acceso como invitado (usuario temporal).

---

# Variables clave (3/3) – Ficheros, cuotas y tamaño de subida

Directorios:

- `FILES_DIR="/mnt/data/"`
- `CACHE_DIR=""`
- `LOG_DIR=""`

Cuotas y límites:

- `USER_STORAGE_MAX_DISK_SPACE=1024`

- Máximo por usuario (MB).
- `FILE_UPLOAD_MAX_SIZE=256`

- Límite de subida de archivos (MB).

---

# Puesta en marcha rápida con Docker

Para probar eXeLearning de forma muy rápida:

```bash
docker run --pull always -p 8081:8080 exelearning/exelearning:main
```

- `--pull always` garantiza que usamos la imagen más reciente.
- El contenedor escucha en el **8080 interno** y lo exponemos en el **8081 del host**.
- Después de arrancar:

```text
http://localhost:8081
```

- Ideal para:

  - Hacer una prueba local.
  - Validar que la configuración básica funciona.

---

# Despliegue con Docker Compose

En el repositorio, carpeta **`doc/deploy`**:

- Varios ejemplos de `docker-compose.yml` ya preparados:

  - Diferentes bases de datos.
  - Volúmenes mapeados.
  - Servicios auxiliares (por ejemplo, Watchtower).

Pasos típicos:

```bash
cp doc/deploy/docker-compose.mariadb.yml docker-compose.yml
cp .env.dist .env
vim .env
docker compose up -d
```

---

# Despliegue automatizado con Ansible

Componentes principales:

- **Playbook Ansible**: `playbook-exelearning-ubuntu.yaml`
- **Plantilla de entorno**: `.env.j2`
- **Makefile** con comandos abreviados:

  - `make deploy-remote`
  - `make up` (con Multipass para entorno de pruebas)


1. Prepara un servidor Ubuntu (24.04) con Docker.
2. Copia **docker-compose.yml**
3. Genera el `.env` a partir de **.env.j2**.
4. Arranca los servicios con **docker compose**.


---

# Ejemplos de uso de Ansible

Despliegue en maquina virtual local (multipass):

```bash
make up
```


Despliegue remoto simple:

```bash
make deploy-remote
```

O si prefieren a mano
```bash
ansible-playbook -i "192.168.1.100," -u ubuntu  playbook-exelearning-ubuntu.yaml
```

---

# Recursos y documentación

http://exelearning.github.io/exelearning

 

Carpeta **`doc/deploy`** del repositorio:

