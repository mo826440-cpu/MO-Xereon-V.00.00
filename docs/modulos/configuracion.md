# Módulo: Configuración

## Objetivo

Administrar parámetros generales del sistema que no justifican una pantalla propia por módulo, manteniendo valores centralizados, tipados y auditables.

Solo usuarios autorizados podrán modificar configuraciones. Los valores críticos afectarán comportamiento global (nombre de planta, umbrales por defecto, formatos, etc.).

---

# Tablas involucradas

- configuraciones
- usuarios

> La estructura de la tabla se encuentra documentada en `01_estructura.md`.

---

# Descripción de la información

Cada configuración registrará:

- Clave única.
- Valor.
- Tipo de dato.
- Descripción.
- Fecha de última actualización.
- Usuario que actualizó.

---

# Funcionalidades

- Consultar configuraciones.
- Editar el valor de una configuración existente.
- Buscar por clave o descripción.
- Agrupar visualmente por prefijo de clave (por ejemplo `planta.*`, `stock.*`, `ui.*`).
- No crear ni eliminar claves desde la interfaz en la versión inicial (las claves se siembran en datos iniciales / migraciones).

---

# Pantallas

- Configuración.
- Editar Configuración.

---

# Listado principal

| Grupo | Clave | Valor | Tipo | Actualizado | Acciones |
|---|---|---|---|---|---|
| planta | planta.nombre | Xereon | texto | 30/07/2026 | Editar |
| stock | stock.alerta_dias_vencimiento | 30 | numero | 30/07/2026 | Editar |

---

# Formulario de edición

## Clave

- Solo lectura.
- Identificador técnico estable.

## Tipo

- Solo lectura.
- Valores: `texto` / `numero` / `booleano` / `json`.

## Valor

- Editable.
- Debe respetar el tipo:
  - `texto`: cadena
  - `numero`: numérico válido
  - `booleano`: `true` / `false`
  - `json`: JSON válido

## Descripción

- Solo lectura en v1 (definida en el seed).
- Explica el efecto de la configuración.

---

# Claves iniciales sugeridas

```text
planta.nombre                  = Xereon          (texto)
planta.zona_horaria            = America/Argentina/Buenos_Aires (texto)
ui.filas_por_pagina            = 25                          (numero)
stock.alerta_dias_vencimiento  = 30                          (numero)
stock.mostrar_cero             = true                        (booleano)
reportes.max_filas_exportacion = 50000                       (numero)
produccion.permitir_una_en_curso = true                      (booleano)
```

Estas claves se cargarán en `02_datos_iniciales.md` / migración inicial. Podrán ampliarse sin cambiar el modelo.

---

# Reglas de negocio

- La clave es única y no se renombra desde la UI.
- En v1 no se permiten altas ni bajas de claves desde pantalla; solo edición de valor.
- Al guardar se actualizan `fecha_actualizacion` y `actualizado_por`.
- Los cambios de configuración aplican de inmediato a nuevas operaciones; no reescriben historial pasado.
- Configuraciones booleanas se almacenan como texto normalizado `true` / `false` o, preferentemente, el backend las castea según `tipo`.
- Solo el rol Admin (permiso Administrar) podrá modificar configuraciones.
- Dirección y demás roles no administran configuraciones críticas.

---

# Validaciones

- `clave`: existente.
- `valor`: obligatorio según tipo (salvo que se permita vacío explícitamente en la descripción).
- `tipo = numero`: valor parseable como número.
- `tipo = booleano`: valor `true` o `false`.
- `tipo = json`: JSON válido.
- `reportes.max_filas_exportacion` y similares: `> 0`.

---

# Flujo del módulo

```text
Inicio

↓

Configuración

↓

Listado agrupado

↓

Editar valor

↓

Validar tipo y permisos

↓

Guardar (fecha + usuario)
```

---

# Relaciones

```text
configuraciones.actualizado_por → usuarios.id
```

---

# Permisos

## Configuración

- Administrar

El permiso Administrar implica ver y editar valores.

---

# Mejoras futuras

- Alta/baja controlada de claves desde Admin avanzado.
- Historial de cambios por configuración.
- Configuraciones por sucursal / planta cuando el sistema sea multi-sede.
- Importación / exportación de set de configuraciones.
- Flags de funcionalidad (feature flags) tipados.

---

# Historial de cambios

## 2026-07-30

- Creación inicial del módulo Configuración.
- Definición de la tabla `configuraciones` clave-valor tipada.
- Definición del set inicial de claves operativas.

---

# Observaciones

- La estructura de la tabla se encuentra en `01_estructura.md`.
- Los valores iniciales se encuentran en `02_datos_iniciales.md`.
- Las reglas generales del sistema se encuentran en `03_reglas_generales.md`.
