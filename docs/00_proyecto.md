# Proyecto

## Nombre

Xereon

---

## Descripción

Xereon es un sistema de gestión desarrollado para administrar y controlar los procesos productivos de una planta de elaboración.

El sistema permitirá centralizar la información de producción, insumos, productos, empresas, calidad, movimientos, mantenimiento, usuarios, reportes y demás procesos involucrados en la operación diaria.

El proyecto está diseñado para comenzar como una aplicación local, pero con una arquitectura preparada para funcionar posteriormente desde Internet sin necesidad de modificar la lógica del sistema.

---

# Objetivos

- Centralizar toda la información de producción.
- Eliminar registros manuales en planillas dispersas.
- Mejorar la trazabilidad de los procesos.
- Facilitar la obtención de indicadores.
- Reducir errores de carga.
- Automatizar procesos repetitivos.
- Permitir un crecimiento modular del sistema.

---

# Arquitectura

## Frontend

- React
- HTML
- CSS
- JavaScript (o TypeScript)

---

## Backend

- Python
- FastAPI

---

## Base de datos

- PostgreSQL

---

## ORM

- SQLAlchemy

---

## Migraciones

- Alembic

---

## Aplicación de escritorio

- Tauri

---

# Organización del proyecto

```text
MO-Xereon/

│
├── backend/
│
├── frontend/
│
├── docs/
│
├── database/
│
├── scripts/
│
├── assets/
│
└── README.md
```

---

# Documentación

```text
docs/

00_proyecto.md

01_estructura.md

02_datos_iniciales.md

03_reglas_generales.md

04_resumen_estructura_db.md

05_Lenguajes_herramientas.md

06_Estructura_del_proyecto.md

modulos/

    login.md

    usuarios.md

    empresas.md

    categorias.md

    calidad.md

    productos.md

    insumos.md

    produccion.md

    movimientos.md

    mantenimiento.md

    reportes.md

    configuracion.md
```

---

# Convenciones generales

## Base de datos

- Todas las tablas se nombran en plural.
- Todas las claves primarias se llaman `id`.
- Todas las claves foráneas comienzan con `id_`.
- Los nombres utilizan minúsculas y `_`.
- No se utilizan espacios, acentos ni caracteres especiales.
- Todas las fechas utilizan `TIMESTAMP`.
- Los estados de activación se almacenan como `BOOLEAN`.
- Los estados de flujo operativo utilizan valores de texto controlados mediante restricciones `CHECK`.
- Las contraseñas se almacenan únicamente como `password_hash`.

---

## Código

- Un archivo por componente.
- Una responsabilidad por archivo.
- Variables y funciones en inglés.
- Interfaces y textos visibles para el usuario en español.
- Código documentado cuando la lógica no sea evidente.

---

## Interfaz

- Diseño simple y limpio.
- Prioridad a la velocidad de uso.
- Navegación uniforme en todos los módulos.
- Colores y estilos consistentes.
- Compatible con resolución Full HD (1920×1080) como base.

---

# Principios de desarrollo

- Modular.
- Escalable.
- Fácil de mantener.
- Reutilizable.
- Seguro.
- Documentado.
- Orientado a productividad.

---

# Estructura de módulos

- Login
- Inicio
- Usuarios
- Empresas
- Categorías
- Calidad
  - Criterios
- Productos
  - Versiones
- Insumos
  - Ingredientes
  - Envases
  - Obleas
  - Otros
- Producción
  - Solicitudes
  - Ejecuciones
  - Sectores y Equipos
- Movimientos
  - Ingredientes
  - Envases
  - Obleas
  - Otros
  - Productos
- Mantenimiento
- Reportes
- Configuración

Los perfiles de calidad no poseen pantalla propia. Se crean y consultan desde los formularios de Productos, Ingredientes y Otros.

Cada módulo deberá contar con:

- Objetivo.
- Tablas involucradas.
- Relaciones.
- Reglas de negocio.
- Pantallas.
- Validaciones.
- Permisos.
- Flujo de trabajo.
- Historial de cambios.

---

# Control de versiones

Repositorio Git:

- Una única rama principal (`main`) para versiones estables.
- Rama `develop` para nuevas funcionalidades.
- Cada nueva funcionalidad se desarrolla en una rama independiente antes de integrarse.

---

# Criterios de calidad

Antes de incorporar una nueva funcionalidad deberá verificarse:

- La base de datos mantiene la integridad referencial.
- No existen consultas duplicadas innecesarias.
- La interfaz mantiene el mismo diseño que el resto del sistema.
- Todas las validaciones funcionan correctamente.
- Los permisos de usuario se respetan.
- No se almacenan contraseñas ni información sensible en texto plano.

---

# Objetivo a largo plazo

Desarrollar un sistema de gestión integral para la planta que permita administrar todos los procesos desde una única plataforma, con posibilidad de funcionar tanto de forma local como remota, manteniendo una única base de datos y una arquitectura escalable.

MO-Xereon/

docs/
│
├── 00_proyecto.md              ← Visión general del proyecto
├── 01_estructura.md            ← TODAS las tablas de la base de datos
├── 02_datos_iniciales.md       ← Registros iniciales de la BD
├── 03_reglas_generales.md      ← Reglas comunes a todo el sistema
├── 04_resumen_estructura_db.md ← Resumen rápido de tablas y columnas
├── 05_Lenguajes_herramientas.md ← Qué instalar en la PC para desarrollar
├── 06_Estructura_del_proyecto.md ← Árbol de carpetas del repositorio
│
└── modulos/
    ├── login.md                ← Documentación del Login y conexión a la BD
    ├── usuarios.md             ← Documentación del módulo Usuarios
    ├── empresas.md             ← Documentación del módulo Empresas
    ├── categorias.md           ← Documentación del módulo Categorías
    ├── calidad.md              ← Documentación de Calidad y Criterios
    ├── productos.md            ← Documentación de Productos / Versiones
    ├── insumos.md              ← Documentación de Insumos / Ingredientes / Envases / Obleas / Otros
    ├── produccion.md           ← Documentación de Producción / Solicitudes / Ejecuciones
    ├── movimientos.md          ← Documentación de Movimientos (Insumos y Productos)
    ├── mantenimiento.md        ← Documentación de Mantenimiento
    ├── reportes.md             ← Documentación de Reportes
    └── configuracion.md        ← Documentación de Configuración

