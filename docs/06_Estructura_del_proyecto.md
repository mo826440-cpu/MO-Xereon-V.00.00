# Estructura del proyecto

Resumen breve de cómo organizar **MO-Xereon** desde la raíz hasta las subcarpetas de trabajo.

---

```text
MO-Xereon/
│
├── README.md
├── .gitignore
├── .env.example                 ← ejemplo de variables (sin secretos)
│
├── docs/                        ← documentación (ya existente)
│   ├── 00_proyecto.md
│   ├── 01_estructura.md
│   ├── 02_datos_iniciales.md
│   ├── 03_reglas_generales.md
│   ├── 04_resumen_estructura_db.md
│   ├── 05_Lenguajes_herramientas.md
│   ├── 06_Estructura_del_proyecto.md
│   └── modulos/
│       ├── login.md
│       ├── descarga_local.md
│       ├── usuarios.md
│       ├── empresas.md
│       ├── categorias.md
│       ├── calidad.md
│       ├── productos.md
│       ├── insumos.md
│       ├── produccion.md
│       ├── movimientos.md
│       ├── mantenimiento.md
│       ├── reportes.md
│       └── configuracion.md
│
├── backend/                     ← API Python (FastAPI)
│   ├── app/
│   │   ├── main.py
│   │   ├── core/                ← config, seguridad, DB session
│   │   ├── models/              ← SQLAlchemy
│   │   ├── schemas/             ← Pydantic
│   │   ├── api/                 ← routers por módulo
│   │   │   ├── auth/
│   │   │   ├── usuarios/
│   │   │   ├── empresas/
│   │   │   ├── categorias/
│   │   │   ├── calidad/
│   │   │   ├── productos/
│   │   │   ├── insumos/
│   │   │   ├── produccion/
│   │   │   ├── movimientos/
│   │   │   ├── mantenimiento/
│   │   │   ├── reportes/
│   │   │   └── configuracion/
│   │   └── services/            ← lógica de negocio
│   ├── alembic/                 ← migraciones
│   ├── alembic.ini
│   ├── requirements.txt
│   └── .env                     ← local, no versionar
│
├── frontend/                    ← React (Vite + TypeScript)
│   ├── src/
│   │   ├── main.tsx
│   │   ├── app/                 ← router, layout, providers
│   │   ├── pages/               ← una carpeta por pantalla/módulo
│   │   │   ├── login/
│   │   │   ├── inicio/
│   │   │   ├── usuarios/
│   │   │   ├── empresas/
│   │   │   ├── categorias/
│   │   │   ├── calidad/
│   │   │   ├── productos/
│   │   │   ├── insumos/
│   │   │   ├── produccion/
│   │   │   ├── movimientos/
│   │   │   ├── mantenimiento/
│   │   │   ├── reportes/
│   │   │   └── configuracion/
│   │   ├── components/          ← UI reutilizable
│   │   ├── services/            ← llamadas al API
│   │   ├── hooks/
│   │   ├── styles/
│   │   └── types/
│   ├── public/
│   ├── package.json
│   └── vite.config.ts
│
├── src-tauri/                   ← app de escritorio (Tauri)
│   ├── src/
│   ├── icons/
│   ├── tauri.conf.json
│   └── Cargo.toml
│
├── database/                    ← scripts SQL de apoyo (opcional)
│   ├── seeds/
│   └── scripts/
│
├── scripts/                     ← utilitarios (backup, setup local)
│
└── assets/                      ← imágenes / archivos estáticos de negocio
    └── uploads/                 ← runtime; ignorar en Git si es local
```

---

## Criterio rápido

| Carpeta | Responsabilidad |
|---|---|
| `docs/` | Qué y por qué (especificación) |
| `backend/` | API + BD + reglas |
| `frontend/` | Pantallas React |
| `src-tauri/` | Empaquetado escritorio |
| `database/` | SQL auxiliar / seeds |
| `scripts/` | Automatización local |
| `assets/` | Archivos e imágenes |

Una carpeta por módulo en `backend/app/api/` y en `frontend/src/pages/`, alineada a la documentación de `docs/modulos/`.
