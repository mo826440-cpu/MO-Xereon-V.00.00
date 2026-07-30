# Módulo: Empresas

## Objetivo

Administrar los comercios o empresas vinculados con la operación de la planta y mantener centralizados sus datos de identificación, contacto y ubicación.

Este módulo permitirá que otros procesos del sistema utilicen una empresa registrada sin volver a cargar sus datos.

---

# Tablas involucradas

- empresas

> La estructura de la tabla se encuentra documentada en `01_estructura.md`.

---

# Descripción de la información

Cada empresa podrá registrar:

- Fecha de alta.
- Nombre del comercio.
- Persona responsable.
- Información de contacto.
- Dirección.
- Latitud y longitud.
- Observaciones.

---

# Funcionalidades

## Gestión de empresas

- Crear una empresa.
- Editar una empresa.
- Consultar empresas.
- Buscar empresas por comercio o responsable.
- Filtrar empresas.
- Ver el detalle de una empresa.
- Eliminar una empresa cuando no posea relaciones con otros registros.
- Consultar la ubicación mediante sus coordenadas.

---

# Pantallas

- Empresas.
- Nueva Empresa.
- Editar Empresa.
- Detalle de Empresa.

## Listado principal

El listado mostrará como mínimo:

- Fecha.
- Comercio.
- Responsable.
- Contacto.
- Dirección.
- Observación.

También deberá permitir buscar, ordenar y acceder a las acciones autorizadas para el usuario.

## Formulario

El formulario deberá contener:

- Comercio.
- Responsable.
- Contacto.
- Dirección.
- Latitud.
- Longitud.
- Observación.

La fecha se generará automáticamente al crear el registro y no deberá ser modificada manualmente.

---

# Flujo del módulo

```text
Inicio

↓

Empresas

↓

Listado y búsqueda

↓

Nuevo registro / Ver detalle / Editar / Eliminar

↓

Validación de datos y permisos

↓

Confirmación de la operación

↓

Actualización del listado
```

---

# Validaciones

## Fecha

- Obligatoria.
- Se genera automáticamente con la fecha y hora del servidor.

## Comercio

- Obligatorio.
- Máximo 100 caracteres.
- No permitir espacios al inicio o al final.
- No permitir un valor compuesto únicamente por espacios.

## Responsable

- Opcional.
- Máximo 100 caracteres.
- No permitir espacios al inicio o al final.

## Contacto

- Opcional.
- Máximo 100 caracteres.
- Puede contener un teléfono, correo electrónico u otro medio de contacto.
- Cuando tenga formato de correo electrónico, deberá validarse como tal.

## Dirección

- Opcional.
- Máximo 200 caracteres.
- No permitir espacios al inicio o al final.

## Coordenadas

- Latitud y longitud son opcionales.
- Si se informa una coordenada, la otra también será obligatoria.
- La latitud deberá estar entre -90 y 90.
- La longitud deberá estar entre -180 y 180.
- Se admitirán hasta 6 decimales.

## Observación

- Opcional.
- Máximo 2000 caracteres.

---

# Permisos del módulo

Las acciones disponibles dependerán del rol asignado al usuario.

Permisos disponibles:

- Ver empresas.
- Crear empresas.
- Editar empresas.
- Eliminar empresas.

La autorización deberá validarse tanto en la interfaz como en el backend.

---

# Reglas de negocio

- El nombre del comercio es obligatorio.
- La fecha de alta se asignará automáticamente.
- Las coordenadas deberán registrarse como un par completo.
- Antes de eliminar una empresa se deberá verificar que no esté relacionada con otros registros.
- Una empresa relacionada con productos, movimientos, producción u otros datos históricos no podrá eliminarse físicamente.
- Los datos de contacto no deberán interpretarse como un único tipo de comunicación.
- Los espacios al inicio y al final de los campos de texto se eliminarán antes de guardar.

---

# Eliminación

La eliminación física solo estará permitida cuando la empresa no tenga relaciones con otros registros y el usuario posea el permiso correspondiente.

Cuando el módulo se relacione con datos históricos, deberá incorporarse baja lógica mediante un campo `estado` antes de permitir su uso en producción.

---

# Relaciones

En la estructura actual, la tabla `empresas` no posee claves foráneas salientes.

Es referenciada por `mov_ingredientes.id_empresa`, `mov_envases.id_empresa`, `mov_obleas.id_empresa` y `mov_otros.id_empresa` como proveedor de los movimientos de insumos. Otras relaciones con productos, producción u otros módulos deberán documentarse al definirlas.

---

# Auditoría

Actualmente se registra la fecha de alta mediante el campo `fecha`.

Antes de implementar el módulo deberá decidirse si también se incorporarán:

- Usuario creador.
- Fecha de última modificación.
- Usuario que realizó la última modificación.

---

# Mejoras futuras

- Visualización de empresas en un mapa.
- Apertura de la ubicación en una aplicación de mapas.
- Separación de teléfonos y correos electrónicos en contactos estructurados.
- Registro de múltiples responsables por empresa.
- Historial de modificaciones.
- Importación y exportación de empresas.

---

# Historial de cambios

## 2026-07-30

- Vinculación de empresas como proveedores en `mov_ingredientes` (módulo Movimientos / Ingredientes).
- Vinculación de empresas como proveedores en `mov_envases` (módulo Movimientos / Envases).
- Vinculación de empresas como proveedores en `mov_obleas` (módulo Movimientos / Obleas).
- Vinculación de empresas como proveedores en `mov_otros` (módulo Movimientos / Otros).

## 2026-07-28

- Creación inicial de la especificación del módulo.
- Definición de estructura, pantallas, funcionalidades, validaciones, permisos y reglas de negocio.

---

# Observaciones

- La estructura de la tabla se encuentra en `01_estructura.md`.
- Los permisos iniciales se encuentran en `02_datos_iniciales.md`.
- Los movimientos de ingredientes, envases, obleas y otros que utilizan empresas como proveedores se encuentran en `modulos/movimientos.md`.
- Las reglas generales del sistema se encuentran en `03_reglas_generales.md`.
