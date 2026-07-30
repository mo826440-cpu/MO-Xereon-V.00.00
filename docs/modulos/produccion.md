# Módulo: Producción

## Objetivo

Planificar las solicitudes y registrar su ejecución real, manteniendo trazabilidad de cantidades elaboradas, dosificaciones por lote, consumibles, limpieza, stock y pendientes.

El módulo Producción contiene los submódulos:

- Solicitudes de Producción.
- Ejecución de Producción.

---

# Tablas involucradas

- solicitudes
- ejecuciones
- dosificaciones
- consumibles
- reservas
- sectores_equipos
- limpiezas_orden
- categorias
- productos
- versiones
- version_detalles
- version_consumibles
- ingredientes
- envases
- obleas
- otros
- usuarios

> La estructura de `solicitudes` se encuentra documentada en `01_estructura.md`.

---

# Submódulo: Solicitudes de Producción

# Descripción de la información

Cada solicitud registrará:

- Fecha de registro.
- Usuario creador.
- Orden de compra / OC-SAP.
- Categoría, producto, versión, envase y oblea.
- Cantidades cargadas: unidades, unidades por pallet, pallets y pesaje.
- Cantidades pendientes: unidades, pallets y pesaje.
- Fecha estimada y fecha de fin.
- Lote.
- Estado operativo.
- Descripción.

---

# Funcionalidades

- Crear una solicitud de producción.
- Editar una solicitud.
- Consultar solicitudes.
- Filtrar por categoría, producto, estado, fechas y lote.
- Ver el detalle de una solicitud.
- Actualizar cantidades pendientes y estado.
- Calcular automáticamente pallets, pesaje y pendientes.
- Agrupar visualmente el listado por mes.

---

# Pantallas

- Solicitudes de Producción.
- Nueva Solicitud.
- Editar Solicitud.
- Detalle de Solicitud.

---

# Listado principal

El listado deberá diferenciar claramente dos secciones horizontales:

## Sección CARGADO

| Fecha | Código | Producto | Versión | Unidades | Pallets | Pesaje (Kg) |
|---|---|---|---|---|---|---|
| 29/07/2026 | 23115 | ABQ FEED LOT AD NNP CON VIRGINIAMICINA Y CON AMBIFLUD | 01 | 1000 | 20 | 25.000 kg |
| 29/07/2026 | 23110 | ADQ LACTANCIA AR | 01 | 1000 | 20 | 25.000 kg |

## Sección PENDIENTES

| Un. pendientes | Pall. pendientes | Pesaje pendiente (Kg) | Fecha estimada | Fecha fin | Lote | Estado | Acciones |
|---|---|---|---|---|---|---|---|
| 500 | 10 | 12.500 kg | 30/07/2026 | - | GR-26210 | En curso | Ver detalles / Editar |
| 1.000 | 20 | 25.000 kg | 31/07/2026 | - | - | A coordinar | Ver detalles / Editar |

Ambas secciones forman parte de la misma fila de solicitud: la izquierda muestra lo cargado y la derecha lo pendiente.

### Separadores de mes

Cada vez que la columna `fecha_fin` detecte un cambio de mes entre dos filas consecutivas, deberá insertarse una fila intermedia destacada con el nombre del mes entrante.

Si una solicitud no tiene `fecha_fin`, se utilizará `fecha_estimada` para el ordenamiento y la detección de cambio de mes.

Ejemplo visual:

```text
... filas de mayo ...
-------------------- JUNIO --------------------
... filas de junio ...
-------------------- JULIO --------------------
... filas de julio ...
```

### Colores de fila según estado

| Estado | Color de fondo |
|---|---|
| A coordinar | Blanco |
| Próximo a iniciar | Naranja |
| En curso | Celeste |
| Pausado | Amarillo |
| Cancelado | Rojo |
| Finalizado | Verde |

### Acciones del listado

- **Ver detalles**
- **Editar**

---

# Formulario de alta / edición

## Campo 01 - Categoría

- Obligatorio.
- Debe listar las categorías cargadas.

## Campo 02 - Código

- Obligatorio.
- Debe listar los códigos de productos asociados a la categoría seleccionada.
- También podrá cargarse automáticamente al seleccionar el producto.

## Campo 03 - Producto

- Obligatorio.
- Debe listar los productos asociados a la categoría seleccionada.
- También podrá cargarse automáticamente al seleccionar el código.

Código y producto deben mantenerse sincronizados.

## Campo 04 - Versión

- Obligatorio.
- Debe listar únicamente las versiones asociadas al producto seleccionado.

## Campo 05 - Envase

- Obligatorio.
- Debe listar los envases asociados a la categoría seleccionada.

## Campo 06 - Oblea

- Se carga automáticamente según el producto seleccionado.
- Requiere que cada oblea tenga `id_producto`.
- Si existe una única oblea para el producto, se completa sola.
- Si existen varias, se listan solo las asociadas a ese producto.
- Si no existe ninguna, el campo puede quedar vacío.

## Campo 07 - Unidades

- Obligatorio.
- Se carga manualmente.
- Cantidad de unidades solicitadas.
- Debe ser mayor que 0.

## Campo 08 - Unidades/Pallets

- Obligatorio.
- Se carga manualmente.
- Cantidad de unidades apiladas por pallet.
- Debe ser mayor que 0.

## Campo 09 - Pallets

- Calculado automáticamente.
- Fórmula: `Unidades / Unidades por pallet`
- No se edita manualmente, salvo definición futura en contrario.
- Si la división no es exacta, el sistema deberá advertirlo.

## Campo 10 - Pesaje

- Calculado automáticamente.
- Fórmula: `Unidades * capacidad_kg del envase seleccionado`
- Resultado expresado en kilogramos.

## Campo 11 - Pallets pendientes

- Obligatorio.
- Se carga manualmente.
- Valor numérico mayor o igual a 0.
- Representa los pallets aún pendientes de elaborar.

## Campo 12 - Unidades pendientes

- Calculado automáticamente.
- Fórmula: `Pallets pendientes * Unidades por pallet`

## Campo 13 - Pesaje pendiente

- Calculado automáticamente.
- Fórmula: `Unidades pendientes * capacidad_kg del envase seleccionado`

## Campo 14 - Fecha estimada

- Opcional.
- Fecha estimada de finalización.

## Campo 15 - Fecha fin

- Opcional.
- Fecha real de finalización de la producción.

## Campo 16 - Lote

- Opcional.
- Carga manual del lote del producto.
- Ejemplo: `GR-26210`.

## Campo 17 - Estado

Valores posibles y reglas de visibilidad:

| Estado | Color | Condición para mostrarlo |
|---|---|---|
| A coordinar | Blanco | `pallets_pendientes > 0` |
| Próximo a iniciar | Naranja | `pallets_pendientes > 0` |
| En curso | Celeste | `pallets_pendientes > 0` |
| Pausado | Amarillo | `pallets_pendientes > 0` |
| Cancelado | Rojo | `pallets_pendientes > 0` |
| Finalizado | Verde | `pallets_pendientes = 0` |

Reglas adicionales:

- Al abrir el formulario vacío, el estado por defecto será **A coordinar**.
- Pueden existir varias solicitudes en estado **A coordinar**.
- No puede haber más de una solicitud en estado **Próximo a iniciar**.
- No puede haber más de una solicitud en estado **En curso**.
- Si se intenta guardar un segundo registro como Próximo a iniciar o En curso, el sistema deberá rechazarlo con un mensaje claro.

## Campo 18 - Descripción

- Opcional.
- Texto largo.

## Orden de compra

Aunque no forma parte de la numeración visual principal, el formulario deberá incluir `orden_compra` / OC-SAP como campo editable, porque integra el seguimiento operativo y aparece en la vista de trabajo.

Reglas:

- El campo es opcional u obligatorio según se defina operativamente; por defecto se recomienda cargarlo cuando exista OC.
- `orden_compra` **no es único**.
- Una misma orden de compra puede tener varias solicitudes asociadas.
- Cada solicitud mantiene su propio producto, versión, cantidades y pendientes.

Ejemplo:

```text
OC: 01-252526-02
  - Solicitud A: Producto 01 → 1000 unidades
  - Solicitud B: Producto 02 → 500 unidades
```

El listado deberá permitir filtrar o agrupar por orden de compra para ver todas las solicitudes vinculadas a una misma OC.

---

# Flujo del módulo

```text
Inicio

↓

Producción / Solicitudes

↓

Nueva Solicitud

↓

Seleccionar categoría, producto, versión, envase y oblea

↓

Cargar unidades, unidades/pallet y pallets pendientes

↓

Calcular pallets, pesaje y pendientes

↓

Definir fechas, lote y estado

↓

Validar exclusividad de estados y consistencia de pendientes

↓

Guardar solicitud

↓

Actualizar listado CARGADO / PENDIENTES
```

---

# Validaciones

## Relaciones

- La categoría debe existir.
- El producto debe pertenecer a la categoría seleccionada.
- La versión debe pertenecer al producto seleccionado.
- El envase debe pertenecer a la categoría seleccionada.
- La oblea, si existe, debe estar asociada al producto seleccionado.

## Cantidades

- `cantidad_unidades > 0`
- `unidades_pallets > 0`
- `pallets_pendientes >= 0`
- `pallets_pendientes` no podrá superar `cantidad_pallets`
- Los campos calculados deberán recalcularse ante cualquier cambio de unidades, unidades/pallet, pallets pendientes o envase

## Estados

- Solo `finalizado` cuando `pallets_pendientes = 0`
- Los demás estados solo cuando `pallets_pendientes > 0`
- Exclusividad global para `proximo_a_iniciar` y `en_curso`

## Fechas

- `fecha_estimada` y `fecha_fin` opcionales
- Si ambas existen, `fecha_fin` no debería ser anterior a `fecha_registro` de forma inconsistente con el proceso

---

# Permisos del módulo

## Producción

- Ver el módulo.

## Solicitudes

- Ver solicitudes.
- Crear solicitudes.
- Editar solicitudes.
- Eliminar solicitudes.

---

# Reglas de negocio

- Cada solicitud pertenece a un producto, una versión, una categoría y un envase.
- La oblea se deriva preferentemente del producto.
- Una misma orden de compra puede asociarse a varias solicitudes, incluso de productos distintos.
- Lo cargado y lo pendiente se muestran juntos, pero con secciones visuales distintas.
- Los cálculos de pallets y pesaje dependen del envase y de las unidades.
- El color de la fila representa el estado operativo.
- Los separadores de mes se insertan al detectar cambio de mes en `fecha_fin` o, en su defecto, `fecha_estimada`.
- Preferir conservar el historial de solicitudes; la baja física solo si no hay dependencias posteriores.

---

# Relaciones

```text
categorias (1) → solicitudes (N)
productos (1) → solicitudes (N)
versiones (1) → solicitudes (N)
envases (1) → solicitudes (N)
obleas (1) → solicitudes (N)
usuarios (1) → solicitudes (N)
```

```text
solicitudes.id_categoria → categorias.id
solicitudes.id_producto → productos.id
solicitudes.id_version → versiones.id
solicitudes.id_envase → envases.id
solicitudes.id_oblea → obleas.id
solicitudes.creado_por → usuarios.id
```

---

# Cambio requerido en Obleas

Para soportar el Campo 06, la tabla `obleas` incorpora:

- `id_producto` (FK `productos.id`)

El formulario de Obleas deberá permitir asociar cada oblea a un producto.

---

# Submódulo: Ejecución de Producción

## Objetivo operativo

Registrar la elaboración parcial o total de una solicitud y dejar trazabilidad de:

- Cantidad de batches ejecutados.
- Unidades, pallets y kilogramos elaborados.
- Lotes de ingredientes asignados mediante FIFO.
- Consumibles programados, disponibles, reservados y faltantes.
- Limpieza y orden previos.
- Evaluación de limpieza final.
- Actualización de cantidades pendientes.

Una solicitud podrá tener varias ejecuciones finalizadas hasta completar su cantidad pendiente.

## Pantallas y paneles

- Ejecuciones de Producción.
- Nueva Ejecución / Ejecución en curso.
- Detalle de Ejecución.
- Panel de Dosificaciones.
- Panel de Consumibles.
- Panel de Limpieza y Orden.
- Administración de Sectores y Equipos.

---

## Indicadores

La pantalla principal mostrará un selector de mes. Por defecto se utilizará el mes actual.

| Indicador | Definición |
|---|---|
| Mes en análisis | Mes y año seleccionados, por ejemplo `Julio - 2026` |
| Solicitudes elaboradas | Cantidad distinta de solicitudes con al menos una ejecución finalizada en el mes |
| Solicitudes pendientes | Solicitudes no canceladas con `pesaje_pendiente > 0` cuya fecha de referencia pertenece al mes |
| Unidades elaboradas | Suma de `unidades_elaboradas` de ejecuciones finalizadas en el mes |
| Unidades pendientes | Suma del valor actual de `unidades_pendientes` de las solicitudes pendientes del mes |
| Kg elaborados | Suma de `kilogramos_elaborados` de ejecuciones finalizadas en el mes |
| Kg pendientes | Suma del valor actual de `pesaje_pendiente` de las solicitudes pendientes del mes |
| Ejecución en curso | Lote, pallets elaborados y pallets pendientes de la solicitud activa |

Para los indicadores de ejecución se utilizará `fecha_finalizacion`. Para ubicar solicitudes pendientes en un mes se utilizará `fecha_fin` y, si no existe, `fecha_estimada`.

Si no existe una ejecución activa, el último indicador mostrará `Sin ejecución en curso`.

Ejemplo:

```text
Lote GR26215 · 10 pallets elaborados · 10 pallets pendientes
```

---

## Listado principal de ejecuciones

| Fecha | Orden de compra | Código | Producto | Versión | Unidades | Pallets | Pesaje (Kg) | Estado | Acciones |
|---|---|---|---|---|---:|---:|---:|---|---|
| 29/07/2026 | 01-20072026-01 | 23115 | ABQ FEED LOT AD NNP CON VIRGINIAMICINA Y CON AMBIFLUD | 01 | 500 | 10 | 12.500 kg | En curso | Ver dosificaciones / Ver detalles / Editar |

Los datos de orden de compra, código, producto y versión se obtienen de la solicitud asociada y no se duplican en `ejecuciones`.

### Acciones

- **Ver dosificaciones:** abre el panel en modo consulta o edición según permiso y estado.
- **Ver consumibles:** abre el panel de consumibles.
- **Ver detalles:** muestra todos los datos, checklist y trazabilidad.
- **Editar:** disponible únicamente para la ejecución en curso.

Las ejecuciones finalizadas son históricas y no podrán editarse ni eliminarse físicamente.

---

## Comportamiento al abrir el formulario

1. El sistema buscará una ejecución global en estado `en_curso`.
2. Si existe, abrirá esa ejecución con todos sus datos; no permitirá iniciar otra.
3. Si no existe, abrirá un formulario vacío.
4. Al guardar los campos básicos por primera vez se crea la ejecución `en_curso`.
5. Después de crearla se habilitan los paneles de dosificaciones, consumibles y limpieza.
6. La ejecución solo pasa a `finalizado` mediante la acción **Finalizar ejecución**.

La exclusividad deberá protegerse también con un índice único parcial en PostgreSQL para evitar dos altas simultáneas.

---

## Formulario principal

### Campo 01 - Solicitud

- Obligatorio.
- Listará solicitudes en estado:
  - Próximo a iniciar.
  - En curso.
  - Pausado.
- Deberá mostrar lote, orden de compra, código, producto, versión y kilogramos pendientes.
- Una vez generadas dosificaciones o consumibles, no podrá cambiarse sin confirmar la eliminación de esos cálculos y sus reservas.

### Campo 02 - Pesaje/Batch (kg)

- Obligatorio.
- Valor manual mayor que `0`.
- Representa la suma de macro y micronutrientes de cada batch.
- El sistema mostrará como referencia el pesaje teórico derivado de la versión.
- Si el valor manual difiere del teórico, mostrará una advertencia antes de continuar.
- Las dosificaciones se calcularán usando el valor confirmado por el usuario.

### Campo 03 - Cantidad de batches

- Obligatorio.
- Número entero mayor que `0`.
- Valor inicial:

```text
cantidad_batches_sugerida = FLOOR(
    solicitud.pesaje_pendiente / pesaje_batch
)
```

- Podrá modificarse manualmente.
- No podrá superar la cantidad sugerida.
- Validación obligatoria:

```text
cantidad_batches * pesaje_batch <= solicitud.pesaje_pendiente
```

- Si el pesaje pendiente no alcanza para un batch completo, el sistema impedirá crear la ejecución y mostrará la cantidad pendiente.

### Campo 04 - Dosificaciones

- Mostrará un ícono para abrir el panel.
- El panel se habilita después de guardar la ejecución en curso.
- Mostrará un indicador `Pendiente` o `Finalizado`.
- No permitirá finalizar la ejecución mientras `dosificaciones_finalizadas = false`.
- Si cambian la solicitud, el pesaje por batch o la cantidad de batches, el panel vuelve a `Pendiente` y debe recalcularse.

### Campo 05 - Consumibles

- Mostrará un ícono para abrir el panel.
- Cargará los consumibles asociados a la versión de la solicitud.
- Mostrará un indicador `Pendiente` o `Finalizado`.
- No permitirá finalizar la ejecución mientras `consumibles_finalizados = false`.
- Si cambian cantidades que afectan el cálculo, se invalidará el panel y se liberarán sus reservas anteriores.

### Campo 06 - Unidades elaboradas

- Automático y de solo lectura.

```text
unidades_elaboradas =
    (cantidad_batches * pesaje_batch)
    / envase.capacidad_kg
```

- Se calculará con hasta 4 decimales y no se redondeará silenciosamente.
- Para finalizar la ejecución deberá representar una cantidad entera de envases.

### Campo 07 - Pallets elaborados

- Automático y de solo lectura.

```text
pallets_elaborados =
    unidades_elaboradas
    / solicitud.unidades_pallets
```

- Puede ser decimal para representar un pallet parcial.

### Campo 08 - Kilogramos elaborados

- Automático y de solo lectura.

```text
kilogramos_elaborados =
    cantidad_batches * pesaje_batch
```

### Campo 09 - Limpieza previa

- Checklist de sectores, equipos, vehículos y otros elementos activos.
- Permitirá seleccionar uno o varios registros.
- Mostrará un ícono para administrar `sectores_equipos`.
- El estado general será automático:
  - Con al menos un elemento marcado: `Realizado`.
  - Sin elementos marcados: `No realizado`.
- La ejecución en curso podrá guardarse sin selección, pero no podrá finalizarse.

### Campo 10 - Limpieza fin

- Obligatorio al finalizar.
- Valores:
  - Conforme.
  - No conforme.
- Si se selecciona `No conforme`, la descripción será obligatoria.

### Campo 11 - Estado

- Valores visibles:
  - En curso.
  - Finalizado.
- Es independiente del estado operativo de la solicitud.
- `En curso` permite guardar avances y reservas.
- `Finalizado` solo se asigna mediante la acción de cierre y después de validar toda la ejecución.

### Campo 12 - Descripción

- Opcional.
- Texto largo.
- Se vuelve obligatoria cuando Limpieza Fin sea `No conforme`.

---

## Panel de dosificaciones

### Carga y orden

El panel cargará todas las líneas de `version_detalles` de la versión seleccionada, ordenadas así:

1. Macronutrientes por `puesto`, desde 01.
2. Micronutrientes por `puesto`, desde 01.

La cantidad requerida por ingrediente será:

```text
kg_ingrediente_batch =
    ejecuciones.pesaje_batch
    * version_detalles.participacion / 100

kg_ingrediente_total =
    kg_ingrediente_batch
    * ejecuciones.cantidad_batches
```

### Tabla

| Tipo | Ingrediente | Lote | Kg totales | Batch inicio | Batch fin | Acciones |
|---|---|---|---:|---:|---:|---|
| Macronutriente | Carbonato de Calcio | SL-15072026-01 | 5.500 | 01 | 14 | Editar |
| Macronutriente | Carbonato de Calcio | SL-18072026-01 | 2.000 | 15 | 19 | Editar |
| Macronutriente | Carbonato de Calcio | SIN STOCK DISP | 3.500 | 20 | 30 | Editar |
| Macronutriente | Sal Entrefina | OB-25042026-01 | 1.200 | 01 | 30 | Editar |
| Macronutriente | Óxido de Mg | 252689.08.01.1 | 3.100 | 01 | 15 | Editar |
| Macronutriente | Óxido de Mg | 252689.08.01.8 | 3.100 | 16 | 30 | Editar |
| Micronutriente | Núcleo Feed Lot | EU26133 | 500 | 01 | 30 | Editar |

La fila `SIN STOCK DISP` tendrá fondo destacado, ícono de advertencia y texto accesible; el color no será el único medio para comunicar el faltante.

### Asignación FIFO

Para cada ingrediente:

1. Obtener sus lotes con saldo disponible y `control_calidad = conforme`.
2. Calcular el saldo de cada lote:

```text
stock_disponible_lote =
    ingresos_lote
    - egresos_lote
    - suma(reservas.cantidad
           WHERE tipo_recurso = 'ingrediente'
             AND id_ingrediente / lote correspondientes
             AND estado = 'activa'
             AND id_ejecucion <> ejecución actual)
```

3. Ordenar por fecha de primer ingreso ascendente y luego por identificador ascendente.
4. Asignar del lote más antiguo:

```text
kg_asignados = MIN(stock_disponible_lote, kg_pendientes_ingrediente)
```

5. Crear una fila de dosificación y continuar con el siguiente lote hasta cubrir la necesidad o agotar el stock.
6. Las filas reales quedan reservadas mientras la ejecución esté en curso: cada fila real materializa una fila en `reservas` con `estado = activa`.

La lectura de saldos y la creación de reservas deberán realizarse en una transacción con bloqueo de los registros de stock afectados.

### Cálculo del rango de batches

Para cada fila se utilizará el consumo acumulado del ingrediente:

```text
batch_inicio =
    FLOOR(kg_acumulados_antes / kg_ingrediente_batch) + 1

batch_fin =
    CEIL(
        (kg_acumulados_antes + kg_asignados)
        / kg_ingrediente_batch
    )
```

`batch_fin` nunca podrá superar `cantidad_batches`.

Si el cambio de lote coincide exactamente con el fin de un batch, el siguiente lote comienza en `batch_fin anterior + 1`. Si un lote se agota dentro de un batch, dos filas pueden incluir el mismo número de batch porque ambas participan en ese batch; el sistema deberá mostrar una advertencia de cambio parcial de lote.

### Faltante de stock

Cuando todos los lotes se agotan y todavía existe necesidad:

```text
kg_faltantes =
    kg_ingrediente_total
    - suma(kg_asignados_a_lotes_reales)
```

Se agregará una fila con:

- `lote = SIN STOCK DISP`.
- `pesaje = kg_faltantes`.
- `sin_stock = true`.
- Primer batch no abastecido como Batch Inicio.
- Último batch de la ejecución como Batch Fin.

La fila es una advertencia y no representa un lote físico ni una reserva.

### Edición y finalización del panel

- Una edición manual no podrá superar el saldo del lote.
- La suma de filas de cada ingrediente deberá coincidir con `kg_ingrediente_total`.
- No podrá omitirse ninguna línea de `version_detalles`.
- Cada `id_version_detalle` deberá pertenecer a la versión de la solicitud y coincidir con `id_ingrediente`.
- Toda desviación manual del orden FIFO requerirá una descripción.
- Finalizar el panel confirma que el plan fue revisado, incluso si existen advertencias.
- La ejecución principal no podrá finalizar mientras exista una fila `sin_stock = true`.

---

## Panel de consumibles

### Carga automática

El panel cargará todas las líneas de `version_consumibles`.

La cantidad programada dependerá de `base_calculo`:

```text
unidad: cantidad_base * unidades_elaboradas
pallet: cantidad_base * CEIL(pallets_elaborados)
batch:  cantidad_base * cantidad_batches
fijo:   cantidad_base
```

Para cada consumible:

```text
cantidad_reservada =
    MIN(cantidad_programada, cantidad_disponible)

cantidad_faltante =
    MAX(cantidad_programada - cantidad_reservada, 0)
```

### Cobertura por batch

Cuando existe disponibilidad:

```text
batch_inicio = 1

batch_fin = MIN(
    cantidad_batches,
    FLOOR(
        cantidad_reservada
        / cantidad_programada
        * cantidad_batches
    )
)
```

Si el stock cubre toda la necesidad, `batch_fin = cantidad_batches`. Si el resultado calculado es `0` porque el stock no permite completar un batch, ambos campos se almacenarán como `NULL` y se mostrarán como `-`.

### Tabla

| Consumible | Unidades programadas | Unidades disponibles | Unidades faltantes | Batch inicio | Batch fin | Acciones |
|---|---:|---:|---:|---:|---:|---|
| Obleas 23115 | 1.000 | 500 | 500 | 01 | 15 | Editar |
| Cartón base de pallet | 20 | 20 | 0 | 01 | 30 | Editar |
| Cartón tapa de pallet | 20 | 20 | 0 | 01 | 30 | Editar |

### Reglas

- Se generará una fila por cada consumible de la versión.
- Cada `id_version_consumible` deberá pertenecer a la versión de la solicitud.
- Las cantidades disponibles son una fotografía del momento de cálculo.
- Las cantidades reservadas reducen la disponibilidad para otras operaciones.
- El panel puede confirmarse con faltantes para conservar la planificación.
- La ejecución no podrá finalizar mientras exista `cantidad_faltante > 0`.
- Toda edición deberá conservar `cantidad_reservada <= cantidad_disponible`.

---

## Formulario de Sectores y Equipos

### Tipo

- Obligatorio.
- Valores:
  - Sector.
  - Equipo.
  - Vehículo.
  - Otro.

### Nombre

- Obligatorio.
- Máximo 150 caracteres.
- No podrá repetirse dentro del mismo tipo.

Ejemplos:

- Depósito de Materias Primas.
- Sala de Mezclado.
- Autoelevador 01.
- Balanza 02.
- Camión 03.

### Estado

- Activo por defecto.
- Solo los registros activos aparecen en nuevos checklists.

### Descripción

- Opcional.
- Texto largo.

Los registros con historial usarán baja lógica y no podrán eliminarse físicamente.

---

## Panel de Limpieza y Orden

### Checklist

- Mostrará todos los registros activos de `sectores_equipos`.
- Permitirá seleccionar uno o varios elementos.
- Se guardará una fila de `limpiezas_orden` por cada elemento mostrado, marcado o no marcado.
- El momento utilizado por el checklist principal será `previa`.

### Estado de la tarea

- Automático y de solo lectura.
- Al menos un elemento seleccionado: `Realizado`.
- Ningún elemento seleccionado: `No realizado`.

### Descripción

- Opcional por elemento.
- Permitirá registrar observaciones particulares.

El checklist puede quedar incompleto mientras la ejecución está en curso. Para finalizar deberá existir al menos un elemento marcado.

---

## Reservas y movimientos de stock

La tabla `reservas` es la fuente de verdad del stock apartado. Los paneles de dosificaciones y consumibles son la vista operativa.

- El stock físico continúa calculándose como ingresos menos egresos.
- El stock disponible para nuevas operaciones descuenta `reservas` con `estado = activa`.
- Cada fila real de `dosificaciones` genera una reserva `tipo_recurso = ingrediente` (kg + lote).
- Cada fila de `consumibles` con cantidad reservada genera una reserva `envase` / `oblea` / `otro` (unidades, por maestro).
- `consumibles.cantidad_reservada` puede mantenerse como denormalización de lectura; la validación dura consulta `reservas`.
- Las filas `SIN STOCK DISP` nunca generan reservas.
- Al recalcular o reemplazar una fila: marcar reservas anteriores de esa ejecución como `liberada` y recrear las nuevas en la misma transacción.
- Al finalizar la ejecución, las reservas activas se convierten en egresos (`mov_ingredientes`, `mov_envases`, `mov_obleas`, `mov_otros`), pasan a `estado = convertida` y guardan la FK del egreso correspondiente.
- Si la transacción de finalización falla, no deberá actualizarse parcialmente el stock, las reservas, la solicitud ni la ejecución.
- El historial de reservas es inmutable.

El detalle de ingresos, egresos, lotes y la tabla `reservas` se documenta en `modulos/movimientos.md` y `01_estructura.md`. Los lotes con control de calidad `no_conforme` se excluyen del FIFO.

---

## Finalización de la ejecución

La acción **Finalizar ejecución** deberá validar:

- Solicitud válida y con kilogramos pendientes suficientes.
- `cantidad_batches * pesaje_batch <= pesaje_pendiente`.
- Unidades elaboradas enteras.
- Dosificaciones confirmadas.
- Ninguna dosificación con `sin_stock = true`.
- Consumibles confirmados.
- Ningún consumible con cantidad faltante.
- Al menos un elemento de limpieza previa marcado.
- Limpieza final seleccionada.
- Descripción obligatoria cuando la limpieza final sea No conforme.

Si todas las validaciones se cumplen, una única transacción deberá:

1. Convertir reservas activas en egresos (`mov_ingredientes`, `mov_envases`, `mov_obleas`, `mov_otros` según `tipo_recurso`), marcarlas `convertida` y guardar `id_mov_*`.
2. Generar un ingreso de producto terminado en `mov_productos` con el lote de la solicitud, las unidades elaboradas, la capacidad del envase y las unidades por pallet de la solicitud.
3. Actualizar los pendientes de la solicitud:

```text
unidades_pendientes =
    MAX(unidades_pendientes - unidades_elaboradas, 0)

pallets_pendientes =
    unidades_pendientes / unidades_pallets

pesaje_pendiente =
    unidades_pendientes * envase.capacidad_kg
```

4. Si `unidades_pendientes = 0`, asignar a la solicitud:
   - `estado = finalizado`.
   - `fecha_fin = fecha actual`.
5. Si quedan pendientes, conservar el estado operativo actual de la solicitud.
6. Asignar a la ejecución:
   - `estado = finalizado`.
   - `fecha_finalizacion = fecha y hora actual`.
   - `finalizado_por = usuario autenticado`.

El estado de la ejecución no copia el estado de la solicitud. La única sincronización automática es el cierre de la solicitud cuando sus pendientes llegan a cero.

---

## Recalculo y edición

Mientras la ejecución esté en curso:

- Cambiar `pesaje_batch` o `cantidad_batches` recalcula kilogramos, unidades y pallets.
- Cualquier cambio que afecte cantidades invalida dosificaciones y consumibles.
- Antes de recalcular se liberan las reservas anteriores.
- Los paneles vuelven a estado `Pendiente`.
- Cambiar la solicitud requiere confirmación y elimina todos los subregistros de la ejecución en curso.
- Una ejecución finalizada es inmutable.

---

## Validaciones y mensajes

Mensajes sugeridos:

- `Ya existe una ejecución en curso. Debe finalizarla antes de iniciar otra.`
- `La cantidad de batches supera los kilogramos pendientes de la solicitud.`
- `Los kilogramos pendientes no alcanzan para completar un batch.`
- `Debe finalizar el registro de dosificaciones.`
- `Existen ingredientes sin stock disponible.`
- `Debe finalizar el registro de consumibles.`
- `Existen consumibles con stock insuficiente.`
- `Debe registrar al menos una tarea de limpieza previa.`
- `Debe indicar el resultado de la limpieza final.`
- `Las unidades elaboradas deben representar una cantidad entera de envases.`

Todas las validaciones se ejecutarán en frontend y backend. Las de stock, concurrencia y finalización se confirmarán nuevamente dentro de la transacción del backend.

---

## Permisos de Ejecuciones

- Ver ejecuciones.
- Crear ejecución.
- Editar ejecución en curso.
- Ver y editar dosificaciones.
- Ver y editar consumibles.
- Finalizar ejecución.
- Ver detalle histórico.

## Permisos de Sectores y Equipos

- Ver sectores y equipos.
- Crear sectores y equipos.
- Editar sectores y equipos.
- Desactivar sectores y equipos.

---

## Flujo de ejecución

```text
Abrir Producción / Ejecuciones

↓

¿Existe una ejecución en curso?

├─ Sí → Recuperar y continuar la ejecución
└─ No → Mostrar formulario vacío

↓

Seleccionar solicitud y definir pesaje/batch y batches

↓

Guardar ejecución en curso

↓

Generar y confirmar dosificaciones FIFO

↓

Generar y confirmar consumibles

↓

Registrar limpieza previa y limpieza final

↓

Validar stock, cantidades y formularios dependientes

↓

Finalizar en una transacción

↓

Generar egresos y actualizar pendientes de la solicitud
```

---

## Relaciones de Ejecución

```text
solicitudes (1) → ejecuciones (N)
ejecuciones (1) → dosificaciones (N)
ejecuciones (1) → consumibles (N)
ejecuciones (1) → reservas (N)
ejecuciones (1) → limpiezas_orden (N)
version_detalles (1) → dosificaciones (N)
version_consumibles (1) → consumibles (N)
sectores_equipos (1) → limpiezas_orden (N)
```

```text
ejecuciones.id_solicitud → solicitudes.id
dosificaciones.id_ejecucion → ejecuciones.id
dosificaciones.id_version_detalle → version_detalles.id
dosificaciones.id_ingrediente → ingredientes.id
consumibles.id_ejecucion → ejecuciones.id
consumibles.id_version_consumible → version_consumibles.id
reservas.id_ejecucion → ejecuciones.id
reservas.id_dosificacion → dosificaciones.id
reservas.id_consumible → consumibles.id
limpiezas_orden.id_ejecucion → ejecuciones.id
limpiezas_orden.id_sector_equipo → sectores_equipos.id
```

---

# Mejoras futuras

- Anulación administrativa de una ejecución en curso con liberación auditada de reservas.
- Historial de cambios de estado.
- Bloqueo de edición en solicitudes finalizadas.
- Indicadores de capacidad diaria.
- Exportación del tablero CARGADO / PENDIENTES.
- Notificaciones al pasar a Próximo a iniciar o En curso.

---

# Historial de cambios

## 2026-07-30

- Incorporación del submódulo Ejecución de Producción.
- Definición de ejecuciones parciales, cálculos y actualización automática de pendientes.
- Incorporación de dosificaciones FIFO por lote y advertencias `SIN STOCK DISP`.
- Incorporación de consumibles por versión, reservas y cálculo de cobertura por batch.
- Incorporación de sectores, equipos y checklist de limpieza y orden.
- Definición de exclusividad global para la ejecución en curso y cierre transaccional.
- Vinculación del FIFO de ingredientes con `modulos/movimientos.md` y exclusión de lotes `no_conforme`.
- Ingreso automático de producto terminado en `mov_productos` al finalizar una ejecución.
- Formalización de la tabla `reservas` como fuente de verdad del stock apartado.

## 2026-07-29

- Creación inicial del módulo Solicitudes de Producción.
- Definición de cálculos, estados con colores, listado CARGADO/PENDIENTES y separadores de mes.
- Incorporación de `id_producto` en obleas para autocompletado.
- Definición de que una misma orden de compra puede tener múltiples solicitudes asociadas.

---

# Observaciones

- La estructura de las tablas se encuentra en `01_estructura.md`.
- Productos y versiones se encuentran en `modulos/productos.md`.
- Envases y obleas se encuentran en `modulos/insumos.md`.
- Los consumibles configurables por versión se encuentran en `modulos/productos.md`.
- La asignación FIFO de ingredientes utiliza los lotes e ingresos documentados en `modulos/movimientos.md`.
- El consumo de envases genera egresos en `mov_envases` documentados en `modulos/movimientos.md`.
- El consumo de obleas genera egresos en `mov_obleas` documentados en `modulos/movimientos.md`.
- El consumo de otros insumos genera egresos en `mov_otros` documentados en `modulos/movimientos.md`.
- El ingreso de producto terminado al finalizar una ejecución se registra en `mov_productos` documentado en `modulos/movimientos.md`.
- El catálogo `sectores_equipos` también se utiliza en el módulo Mantenimiento (`modulos/mantenimiento.md`).
- Las reservas de stock se documentan en `01_estructura.md` y `modulos/movimientos.md`.
- Las reglas generales del sistema se encuentran en `03_reglas_generales.md`.
