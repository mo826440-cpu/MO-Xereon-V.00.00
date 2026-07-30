# Módulo: Categorías

## Objetivo

Administrar un catálogo centralizado de categorías para clasificar y organizar información del sistema.

Las categorías se utilizarán para clasificar productos, insumos e ingredientes. Cada relación concreta deberá definirse al documentar esos módulos.

---

# Tablas involucradas

- categorias

> La estructura de la tabla se encuentra documentada en `01_estructura.md`.

---

# Descripción de la información

Cada categoría registrará:

- Identificador.
- Nombre de la categoría.
- Descripción.

---

# Datos iniciales

El sistema deberá crear las siguientes categorías durante la instalación:

```text
1  Sustituto Lácteo
2  Premezcla
```

La descripción es opcional y quedará vacía inicialmente.

---

# Funcionalidades

## Gestión de categorías

- Crear una categoría.
- Editar una categoría.
- Consultar categorías.
- Buscar categorías por nombre o descripción.
- Ver el detalle de una categoría.
- Eliminar una categoría cuando no esté relacionada con otros registros.

---

# Pantallas

- Categorías.
- Nueva Categoría.
- Editar Categoría.
- Detalle de Categoría.

## Listado principal

El listado mostrará como mínimo:

- Categoría.
- Descripción.
- Acciones disponibles.

También deberá permitir buscar, ordenar y acceder a las acciones autorizadas para el usuario.

## Formulario

El formulario deberá contener:

- Categoría.
- Descripción.

---

# Flujo del módulo

```text
Inicio

↓

Categorías

↓

Listado y búsqueda

↓

Nuevo registro / Ver detalle / Editar / Eliminar

↓

Validación de datos, duplicados y permisos

↓

Confirmación de la operación

↓

Actualización del listado
```

---

# Validaciones

## Categoría

- Obligatoria.
- Única.
- Máximo 100 caracteres.
- No permitir espacios al inicio o al final.
- No permitir un valor compuesto únicamente por espacios.
- La validación de duplicados deberá ignorar diferencias entre mayúsculas y minúsculas.

## Descripción

- Opcional.
- Máximo 2000 caracteres.
- No permitir espacios al inicio o al final.

---

# Permisos del módulo

Las acciones disponibles dependerán del rol asignado al usuario.

Permisos disponibles:

- Ver categorías.
- Crear categorías.
- Editar categorías.
- Eliminar categorías.

La autorización deberá validarse tanto en la interfaz como en el backend.

---

# Reglas de negocio

- El nombre de la categoría es obligatorio y único.
- Antes de guardar se eliminarán los espacios al inicio y al final.
- No podrán existir categorías que solo se diferencien por mayúsculas o minúsculas.
- Antes de eliminar una categoría se deberá verificar que no esté relacionada con otros registros.
- Una categoría utilizada por productos, insumos, ingredientes u otros datos no podrá eliminarse físicamente.
- La modificación del nombre de una categoría no deberá afectar las relaciones existentes, que se realizarán mediante su identificador.

---

# Eliminación

La eliminación física solo estará permitida cuando la categoría no tenga relaciones con otros registros y el usuario posea el permiso correspondiente.

Si las categorías deben conservarse como parte del historial, deberá incorporarse baja lógica mediante un campo `estado` antes de implementar el módulo en producción.

---

# Relaciones

En la estructura actual, la tabla `categorias` no posee claves foráneas ni está referenciada por otras tablas.

Se prevé que otras entidades puedan incorporar una relación:

```text
productos.id_categoria
ingredientes.id_categoria
envases.id_categoria
obleas.id_categoria
otros.id_categoria
    ↓
categorias.id
```

Las relaciones de productos, ingredientes, envases, obleas y otros ya están documentadas en `01_estructura.md` y en sus módulos correspondientes.

---

# Auditoría

La tabla de ejemplo no contiene campos de auditoría.

Antes de implementar el módulo deberá decidirse si se incorporarán:

- Fecha de creación.
- Usuario creador.
- Fecha de última modificación.
- Usuario que realizó la última modificación.

---

# Mejoras futuras

- Categorías jerárquicas mediante una categoría padre.
- Orden personalizado para listados.
- Colores o iconos identificativos.
- Baja lógica mediante estado Activo/Inactivo.
- Historial de modificaciones.
- Exportación del catálogo.

---

# Historial de cambios

## 2026-07-28

- Creación inicial de la especificación del módulo.
- Definición de estructura, pantallas, funcionalidades, validaciones, permisos y reglas de negocio.
- Incorporación de las categorías iniciales Sustituto Lácteo y Premezcla.
- Definición de su uso en Productos, Insumos e Ingredientes.

---

# Observaciones

- La estructura de la tabla se encuentra en `01_estructura.md`.
- Los permisos iniciales se encuentran en `02_datos_iniciales.md`.
- Las reglas generales del sistema se encuentran en `03_reglas_generales.md`.
