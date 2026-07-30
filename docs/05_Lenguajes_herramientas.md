# Lenguajes y herramientas a instalar

Resumen de lo necesario en la PC (Windows) para comenzar la implementación de **Xereon**.

Arquitectura del proyecto:

| Capa | Tecnología |
|---|---|
| Frontend | React + HTML + CSS + JavaScript/TypeScript |
| Backend | Python + FastAPI |
| ORM / migraciones | SQLAlchemy + Alembic |
| Base de datos | PostgreSQL |
| Escritorio | Tauri |
| Control de versiones | Git |

---

# 1. Obligatorio para empezar

## 1.1 Git

- **Para qué:** control de versiones del repositorio.
- **Instalar:** [https://git-scm.com/download/win](https://git-scm.com/download/win)
- **Verificar:**

```text
git --version
```

---

## 1.2 Python (backend)

- **Para qué:** FastAPI, SQLAlchemy, Alembic y lógica del servidor.
- **Versión recomendada:** Python **3.11** o **3.12** (64 bit).
- **Instalar:** [https://www.python.org/downloads/](https://www.python.org/downloads/)
- En el instalador, marcar **“Add python.exe to PATH”**.
- **Verificar:**

```text
python --version
pip --version
```

### Entorno virtual (recomendado)

No hace falta instalarlo aparte; viene con Python:

```text
python -m venv .venv
.venv\Scripts\activate
```

### Paquetes Python del proyecto (se instalan después, dentro del venv)

No son “programas de Windows”, pero serán dependencias del backend:

- `fastapi`
- `uvicorn`
- `sqlalchemy`
- `alembic`
- `psycopg2-binary` (o `psycopg`)
- `python-dotenv`
- `passlib` / `bcrypt` (hash de contraseñas)
- `pydantic`
- `python-jose` o equivalente (tokens de sesión), según se defina en Login

Ejemplo orientativo:

```text
pip install fastapi uvicorn sqlalchemy alembic psycopg2-binary python-dotenv passlib bcrypt pydantic
```

La lista definitiva quedará en `backend/requirements.txt` cuando se cree el proyecto.

---

## 1.3 Node.js (frontend)

- **Para qué:** React, herramientas de build y dependencia de Tauri.
- **Versión recomendada:** Node.js **LTS** (20.x o superior LTS).
- **Instalar:** [https://nodejs.org/](https://nodejs.org/)
- Incluye `npm`.
- **Verificar:**

```text
node --version
npm --version
```

### Opcional pero útil

- **pnpm** o **yarn** (gestores de paquetes alternativos a npm).

```text
npm install -g pnpm
```

### Paquetes frontend (después, en la carpeta del frontend)

- React + Vite (recomendado para iniciar)
- TypeScript (recomendado)
- React Router
- Cliente HTTP (`fetch` o `axios`)

Ejemplo orientativo al crear el proyecto:

```text
npm create vite@latest frontend -- --template react-ts
```

---

## 1.4 PostgreSQL (base de datos)

- **Para qué:** motor de datos `Xereon_Produccion`.
- **Versión recomendada:** PostgreSQL **16** o **15**.
- **Instalar:** [https://www.postgresql.org/download/windows/](https://www.postgresql.org/download/windows/)
- Durante la instalación anotar:
  - usuario `postgres` y su contraseña
  - puerto (por defecto `5432`)
- **Herramienta gráfica incluida:** pgAdmin (suele venir en el instalador).
- **Verificar** (en consola, si `psql` quedó en el PATH):

```text
psql --version
```

### Al comenzar el desarrollo

1. Crear la base `Xereon_Produccion`.
2. Crear un usuario de aplicación (por ejemplo `xereon_app`) con permisos sobre esa base.
3. Guardar host/puerto/usuario/contraseña en un `.env` del backend (no versionar el `.env`).

---

## 1.5 Editor / IDE

Ya estás usando **Cursor** (suficiente).

Alternativas válidas:

- Visual Studio Code
- PyCharm / WebStorm (opcionales)

Extensiones útiles en Cursor/VS Code:

- Python
- Pylance
- ESLint / Prettier
- Tailwind o soporte CSS (si se usa)
- PostgreSQL / SQL

---

# 2. Necesario para la app de escritorio (Tauri)

Tauri empaqueta el frontend como aplicación de escritorio. Para compilarlo en Windows hace falta:

## 2.1 Rust

- **Para qué:** runtime/compilación de Tauri.
- **Instalar:** [https://rustup.rs/](https://rustup.rs/)
- **Verificar:**

```text
rustc --version
cargo --version
```

## 2.2 Microsoft C++ Build Tools

- **Para qué:** compilar dependencias nativas de Tauri en Windows.
- **Instalar:** “Build Tools for Visual Studio” con workload **Desktop development with C++**.
- Enlace orientativo: [https://visualstudio.microsoft.com/visual-cpp-build-tools/](https://visualstudio.microsoft.com/visual-cpp-build-tools/)

## 2.3 WebView2

- En Windows 10/11 modernos suele estar instalado.
- Si falta: Runtime de Microsoft Edge WebView2.

## 2.4 CLI de Tauri (después, con Node)

```text
npm install -D @tauri-apps/cli
```

> Si al inicio solo vas a desarrollar frontend web + backend + PostgreSQL, puedes **postergar Rust / Build Tools / Tauri** y sumarlos cuando armes el ejecutable de escritorio.

---

# 3. Recomendado (no bloquea el primer día)

| Herramienta | Para qué |
|---|---|
| **DBeaver** o **pgAdmin** | Explorar tablas y probar consultas SQL |
| **Postman** o **Insomnia** | Probar endpoints del API (Login, CRUD) |
| **Windows Terminal** | Consola más cómoda |
| **7-Zip** | Empaquetados / archivos |
| **GitHub Desktop** (opcional) | Si preferís Git con interfaz |

---

# 4. Orden sugerido de instalación

1. Git  
2. Python 3.11/3.12 + PATH  
3. Node.js LTS  
4. PostgreSQL + pgAdmin  
5. Cursor (ya instalado)  
6. Crear carpeta `backend` + venv + dependencias Python  
7. Crear carpeta `frontend` con Vite + React  
8. Crear base `Xereon_Produccion` y `.env`  
9. (Más adelante) Rust + C++ Build Tools + Tauri  

---

# 5. Checklist rápida

Marcá cuando esté listo:

```text
[ ] Git
[ ] Python 3.11+  (python --version)
[ ] pip           (pip --version)
[ ] Node.js LTS   (node --version)
[ ] npm           (npm --version)
[ ] PostgreSQL    (servicio en ejecución, puerto 5432)
[ ] pgAdmin o DBeaver
[ ] Cursor / VS Code
[ ] (Opcional ahora) Rust + cargo
[ ] (Opcional ahora) C++ Build Tools
[ ] (Opcional ahora) WebView2
```

---

# 6. Qué NO hace falta instalar al inicio

- Servidor Linux / Docker (opcional; no es requisito del diseño actual).
- Nginx / IIS (solo si más adelante publicás en red).
- Android Studio / Xcode (no es app móvil).
- Licencias de bases comerciales (Oracle, SQL Server, etc.): el motor es PostgreSQL.

---

# 7. Verificación mínima antes de codear

Con estas tres pruebas ya podés arrancar:

```text
python --version
node --version
psql --version
```

Y que el servicio PostgreSQL esté corriendo en Windows (Servicios → postgresql-x64-…).

---

# Observaciones

- Las versiones exactas de librerías (FastAPI, React, Tauri, etc.) se fijarán en `requirements.txt` / `package.json` al crear los proyectos.
- La arquitectura general está en `docs/00_proyecto.md`.
- El flujo Login ↔ API ↔ PostgreSQL está en `docs/modulos/login.md`.
