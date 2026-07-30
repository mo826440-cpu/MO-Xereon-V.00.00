# Módulo: Mantenimiento

## Objetivo

Registrar, programar y consultar las tareas de mantenimiento preventivo, correctivo y de calibración asociadas a los sectores, equipos, vehículos y otros elementos de la planta.

El módulo reutiliza el catálogo `sectores_equipos` ya utilizado en Producción para limpieza y orden, evitando duplicar maestros.

---

# Tablas involucradas

- mantenimientos
- mantenimiento_imagenes
- sectores_equipos
- usuarios

> La estructura de las tablas se encuentra documentada en `01_estructura.md`.

---

# Descripción de la información

Cada mantenimiento registrará:

- Fecha de registro y usuario creador.
- Sector / equipo vinculado.
- Tipo: Preventivo / Correctivo / Calibración / Otro.
- Fechas programada y de realización.
- Estado del flujo.
- Responsable o técnico asignado.
- Descripción del trabajo y observaciones.
- Hasta 4 imágenes de evidencia.

---

# Funcionalidades

- Crear un mantenimiento.
- Editar un mantenimiento mientras no esté finalizado (salvo observaciones posteriores).
- Consultar mantenimientos.
- Filtrar por fecha, tipo, estado, sector/equipo y responsable.
- Ver el detalle completo, incluyendo imágenes.
- Cancelar un mantenimiento programado o en curso.
- Finalizar un mantenimiento registrando la fecha de realización.
- Consultar indicadores del mes y alertas de vencidos.

---

# Pantallas

- Mantenimiento.
- Nuevo Mantenimiento.
- Editar Mantenimiento.
- Detalle de Mantenimiento.

---

# Indicadores

| Indicador | Descripción |
|---|---|
| Vencidos | Cantidad con `estado = programado` y `fecha_programada < hoy` |
| Programados | Cantidad con `estado = programado` |
| En curso | Cantidad con `estado = en_curso` |
| Finalizados del mes | Cantidad finalizada en el mes en análisis |
| Mes en análisis | Mes/año seleccionado (por defecto el actual) |

---

# Listado principal

| Fecha prog. | Tipo | Sector / Equipo | Responsable | Estado | Acciones |
|---|---|---|---|---|---|
| 30/07/2026 | Preventivo | Mezcladora 01 | Juan Pérez | Programado | Ver detalles / Editar / Finalizar / Cancelar |

## Comportamiento del listado

- Ordenar y filtrar por fecha programada, tipo, sector/equipo, responsable y estado.
- Resaltar visualmente los registros vencidos.
- **Finalizar** solo disponible para `programado` o `en_curso`.
- **Cancelar** solo disponible para `programado` o `en_curso`.
- Un registro `finalizado` o `cancelado` no se elimina; se conserva por historial.

---

# Formulario

## Campo 01 - Sector / Equipo

- Lista desplegable obligatoria.
- Debe listar registros activos de `sectores_equipos`.
- Mostrar tipo + nombre (por ejemplo `Equipo · Mezcladora 01`).

## Campo 02 - Tipo

- Lista desplegable obligatoria.
- Opciones:
  - Preventivo
  - Correctivo
  - Calibración
  - Otro
- Valores: `preventivo` / `correctivo` / `calibracion` / `otro`.

## Campo 03 - Fecha programada

- Fecha obligatoria.
- Fecha planificada para realizar el trabajo.

## Campo 04 - Fecha de realización

- Fecha opcional en el alta.
- Obligatoria al finalizar.
- Debe ser mayor o igual a la fecha de registro del trabajo (día calendario).

## Campo 05 - Estado

- Obligatorio.
- Valores:
  - `programado` (default en alta)
  - `en_curso`
  - `finalizado`
  - `cancelado`
- El paso a `finalizado` o `cancelado` se realiza por acciones dedicadas.

## Campo 06 - Responsable

- Texto obligatorio (nombre del técnico o área responsable).
- Máximo 150 caracteres.
- En una mejora futura podrá vincularse a `usuarios`.

## Campo 07 - Descripción

- Texto largo obligatorio.
- Detalle del trabajo a realizar o realizado.

## Campo 08 - Observación

- Texto largo opcional.

## Campo 09 - Imágenes

- Opcional.
- Hasta 4 imágenes de evidencia.
- Formatos: `png`, `jpg`, `webp`.
- Se almacenan en `mantenimiento_imagenes`.

---

# Reglas de negocio

- Todo mantenimiento pertenece a un único registro de `sectores_equipos`.
- Solo sectores/equipos activos podrán seleccionarse en altas nuevas.
- Un mantenimiento `finalizado` no podrá editarse en campos estructurales; solo podrá consultarse.
- Un mantenimiento `cancelado` no podrá reactivarse; deberá crearse uno nuevo si corresponde.
- Al finalizar, `fecha_realizacion` es obligatoria y el estado pasa a `finalizado`.
- Preferir conservación histórica; no eliminar físicamente registros finalizados o cancelados.
- `fecha_registro` y `creado_por` se asignan automáticamente.

---

# Validaciones

- `id_sector_equipo`: obligatorio, existente y preferentemente activo.
- `tipo`: obligatorio.
- `fecha_programada`: obligatoria.
- `estado`: obligatorio y controlado por `CHECK`.
- `responsable`: obligatorio, máximo 150 caracteres.
- `descripcion`: obligatoria.
- `fecha_realizacion`: obligatoria si `estado = finalizado`.
- Hasta 4 imágenes.

---

# Flujo del módulo

```text
Inicio

↓

Mantenimiento

↓

Indicadores + Listado

↓

Nuevo / Ver / Editar / Finalizar / Cancelar

↓

Validar datos y permisos

↓

Guardar

↓

Actualizar listado e indicadores
```

---

# Relaciones

```text
mantenimientos.id_sector_equipo → sectores_equipos.id
mantenimientos.creado_por → usuarios.id
mantenimiento_imagenes.id_mantenimiento → mantenimientos.id
```

---

# Permisos

## Mantenimiento

- Ver
- Crear
- Editar
- Eliminar

Finalizar y Cancelar requieren permiso de Editar.

---

# Mejoras futuras

- Vinculación de `responsable` a un usuario del sistema.
- Planes de mantenimiento recurrentes (frecuencia).
- Alertas automáticas de vencimiento.
- Asociación con costos o proveedores (`empresas`).
- Bloqueo de equipos en mantenimiento dentro de Producción.

---

# Historial de cambios

## 2026-07-30

- Creación inicial del módulo Mantenimiento.
- Definición de tablas `mantenimientos` y `mantenimiento_imagenes`.
- Vinculación con el catálogo `sectores_equipos`.

---

# Observaciones

- La estructura de las tablas se encuentra en `01_estructura.md`.
- El catálogo de sectores y equipos se administra desde Producción (`modulos/produccion.md`).
- Las reglas generales del sistema se encuentran en `03_reglas_generales.md`.
