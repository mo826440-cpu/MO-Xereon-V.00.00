# Módulo: Movimientos

## Objetivo

Registrar y consultar los movimientos de ingreso y egreso de insumos del depósito, actualizar automáticamente el stock disponible y mantener la trazabilidad completa de cada unidad de stock.

El módulo Movimientos contiene los submódulos:

- Movimientos / Ingredientes.
- Movimientos / Envases.
- Movimientos / Obleas.
- Movimientos / Otros.
- Movimientos / Productos.

---

# Tablas involucradas

- mov_ingredientes
- mov_ingrediente_comprobante_imagenes
- mov_ingrediente_imagenes
- mov_envases
- mov_envase_comprobante_imagenes
- mov_envase_imagenes
- mov_obleas
- mov_oblea_comprobante_imagenes
- mov_oblea_imagenes
- mov_otros
- mov_otro_comprobante_imagenes
- mov_otro_imagenes
- mov_productos
- mov_producto_comprobante_imagenes
- mov_producto_imagenes
- reservas
- categorias
- ingredientes
- envases
- obleas
- otros
- productos
- empresas
- usuarios

> La estructura de las tablas se encuentra documentada en `01_estructura.md`.

---

# Reservas de stock

La tabla `reservas` es la fuente de verdad del stock apartado por ejecuciones de producción en curso.

```text
stock_fisico     = ingresos - egresos
stock_disponible = stock_fisico - suma(reservas con estado = activa)
```

## Origen de las reservas

| Origen operativo | Qué genera en `reservas` |
|---|---|
| Fila real de `dosificaciones` | 1 reserva `ingrediente` + `lote` + kg |
| Fila de `consumibles` (envase) | 1 reserva `envase` + unidades |
| Fila de `consumibles` (oblea) | 1 reserva `oblea` + unidades |
| Fila de `consumibles` (otro) | 1 reserva `otro` + unidades |
| Fila `SIN STOCK DISP` | ninguna |

Los paneles de Producción (`dosificaciones`, `consumibles.cantidad_reservada`) son la vista operativa. La validación dura de disponibilidad debe consultar `reservas` con `estado = activa`.

## Ciclo de vida

1. Al confirmar dosificaciones o consumibles se crean filas `reservas` con `estado = activa`.
2. Solo las reservas activas restan del stock disponible.
3. Al recalcular o editar: marcar reservas de esa ejecución como `liberada` y recrear las nuevas en la misma transacción.
4. Al finalizar la ejecución: crear egresos en `mov_*`, marcar `estado = convertida` y guardar la FK correspondiente (`id_mov_ingrediente`, `id_mov_envase`, `id_mov_oblea` o `id_mov_otro`).
5. Ninguna reserva activa podrá dejar `stock_disponible < 0`.
6. Un egreso manual de Movimientos deberá validar contra `stock_fisico - reservas_activas`. Si existe cantidad bloqueada, el sistema podrá informarlo al usuario.
7. El historial es inmutable: no se eliminan filas al liberar o convertir.

Las reservas de consumibles se realizan por maestro (sin lote). El detalle de campos está en `01_estructura.md`. No existe pantalla de menú propia en la primera versión.

---

# Submódulo: Movimientos / Ingredientes

## Descripción

Este submódulo permitirá registrar y consultar todos los movimientos de ingreso y egreso de ingredientes del depósito. Cada movimiento actualizará automáticamente el stock disponible del lote correspondiente y mantendrá la trazabilidad completa de cada ingrediente, incluyendo proveedor, lote, comprobantes, imágenes y control de calidad.

## Descripción de la información

Cada movimiento registrará:

- Fecha de registro y usuario creador.
- Tipo de movimiento: Ingreso o Egreso.
- Categoría e ingrediente.
- Proveedor (empresa).
- Número de lote y fecha de vencimiento.
- Cantidad de unidades, capacidad unitaria (kg) y unidades por pallet.
- Cantidad de pallets calculada.
- Número de comprobante e imágenes asociadas (hasta 2).
- Control de calidad: Conforme / No Conforme.
- Descripción opcional e imágenes del ingrediente (hasta 5).

---

# Funcionalidades

- Crear un movimiento de ingrediente.
- Editar un movimiento cuando no afecte la consistencia del stock ni la trazabilidad posterior.
- Consultar movimientos.
- Filtrar y ordenar por fecha, movimiento, categoría, ingrediente, proveedor, lote y control de calidad.
- Ver el detalle completo del movimiento, incluyendo imágenes.
- Visualizar las imágenes del comprobante desde el listado.
- Eliminar un movimiento únicamente cuando la operación no afecte la consistencia del stock ni la trazabilidad de movimientos posteriores.
- Consultar indicadores mensuales de ingresos, egresos y alertas de stock mínimo.

---

# Pantallas

- Movimientos / Ingredientes.
- Nuevo Movimiento de Ingrediente.
- Editar Movimiento de Ingrediente.
- Detalle de Movimiento de Ingrediente.

---

# Indicadores

La pantalla principal deberá mostrar los siguientes indicadores:

| Indicador | Descripción |
|---|---|
| Stock bajo mínimo | Cantidad de ingredientes cuyo stock disponible (kg) está por debajo de `ingredientes.stock_minimo` |
| Mes en análisis | Mes/año seleccionado para los indicadores (por defecto el mes actual) |
| Ingresos del mes | Cantidad de movimientos con `movimiento = ingreso` registrados en el mes |
| Kg ingresados | Suma de kilogramos de los ingresos del mes |
| Egresos del mes | Cantidad de movimientos con `movimiento = egreso` registrados en el mes |
| Kg egresados | Suma de kilogramos de los egresos del mes |

```text
kilogramos_movimiento =
    cantidad_unidades * capacidad_unidad
```

Solo se considerarán ingredientes con `stock_minimo` definido (`IS NOT NULL`) para la alerta de stock bajo mínimo.

---

# Listado principal

| Fecha | Movimiento | Código | Ingrediente | Lote | Cantidad (kg) | Comprobante | Calidad | Acciones |
|---|---|---|---|---|---:|---|---|---|
| 30/07/2026 | Ingreso | MP-108 | Carbonato de calcio | L-28072026 | 28.000 | R-10016 + ícono | Conforme | Ver detalles / Editar / Eliminar |

## Comportamiento del listado

- Deberá permitir ordenar y filtrar por fecha, movimiento, categoría, ingrediente, proveedor, lote y control de calidad.
- La columna **Cantidad (kg)** mostrará siempre `cantidad_unidades * capacidad_unidad`, independientemente de que el registro se cargue por unidades.
- El ícono de la columna **Comprobante** permitirá visualizar las imágenes asociadas al movimiento.
- **Ver detalles** mostrará toda la información del registro, incluyendo imágenes del comprobante y del ingrediente.
- **Editar** y **Eliminar** respetarán las reglas de consistencia de stock y trazabilidad.

---

# Formulario de registro

## Campo 01 - Movimiento

- Lista desplegable obligatoria.
- Opciones:
  - Ingreso
  - Egreso
- El tipo de movimiento determinará si el stock del lote aumenta o disminuye.
- Valores almacenados: `ingreso` / `egreso`.

## Campo 02 - Categoría

- Lista desplegable obligatoria.
- Deberá mostrar todas las categorías registradas en `categorias`.
- Al seleccionar una categoría, el sistema filtrará automáticamente los ingredientes disponibles.

## Campo 03 - Código

- Lista desplegable con los códigos de los ingredientes pertenecientes a la categoría seleccionada.
- Solo ingredientes activos (`estado = true`).
- La selección de este campo deberá completar automáticamente el campo Ingrediente.

## Campo 04 - Ingrediente

- Lista desplegable con los nombres de los ingredientes pertenecientes a la categoría seleccionada.
- Solo ingredientes activos.
- La selección de este campo deberá completar automáticamente el campo Código.
- Los campos Código e Ingrediente deberán permanecer sincronizados en todo momento.

## Campo 05 - Proveedor

- Lista desplegable obligatoria.
- Deberá mostrar todas las empresas registradas en `empresas`.
- Se almacena como `id_empresa`.

## Campo 06 - Lote

- Campo de texto obligatorio para registrar el número de lote informado por el proveedor.
- Cada lote deberá ser único para un mismo ingrediente.
- En movimientos de **Ingreso**, si el lote aún no existe para el ingrediente, se crea como identidad lógica del stock.
- En movimientos de **Egreso**, el lote deberá existir previamente para el ingrediente y tener stock disponible suficiente.
- La identidad del lote es la combinación `(id_ingrediente, lote)`.

## Campo 07 - Fecha de Vencimiento

- Campo de tipo fecha.
- Obligatorio en ingresos.
- En egresos podrá heredarse del lote existente y mostrarse en solo lectura, o confirmarse según la interfaz.
- Destinado a registrar el vencimiento del lote.

## Campo 08 - Cantidad de Unidades

- Campo numérico obligatorio.
- Debe ser mayor que `0`.
- Registra la cantidad de unidades ingresadas o egresadas.

## Campo 09 - Capacidad Unitaria

- Campo numérico obligatorio.
- Debe ser mayor que `0`.
- Registra el peso de cada unidad expresado en kilogramos (kg/unidad).
- Se almacena como `capacidad_unidad`.

## Campo 10 - Unidades por Pallet

- Campo numérico obligatorio.
- Debe ser mayor que `0`.
- Registra la cantidad de unidades que conforman un pallet completo.
- Se almacena como `unidades_por_pallet`.

## Campo 11 - Cantidad de Pallets

- Campo calculado automáticamente. No editable.

```text
cantidad_pallets = cantidad_unidades / unidades_por_pallet
```

- Podrá contener decimales cuando exista un pallet incompleto.

## Campo 12 - Comprobante

- Campo de texto para registrar el número de remito, factura o comprobante asociado al movimiento.
- Junto al campo deberá mostrarse un ícono que permita cargar, de manera opcional, hasta **2** imágenes del comprobante.
- Las imágenes se almacenan en `mov_ingrediente_comprobante_imagenes`.

## Campo 13 - Control de Calidad

- Lista desplegable obligatoria.
- Opciones:
  - Conforme
  - No Conforme
- Valores almacenados: `conforme` / `no_conforme`.
- Identifica si el lote fue aprobado o rechazado durante la recepción.
- En egresos, el valor deberá coincidir con el control de calidad vigente del lote.

## Campo 14 - Descripción

- Campo opcional de texto largo para registrar observaciones del movimiento.
- Junto al campo deberá mostrarse un ícono que permita adjuntar hasta **5** imágenes del ingrediente recibido o despachado.
- Las imágenes se almacenan en `mov_ingrediente_imagenes`.

---

# Cálculo de stock

El stock no se almacena como valor fijo en el maestro de ingredientes. Se calcula a partir de los movimientos.

```text
kilogramos_movimiento =
    cantidad_unidades * capacidad_unidad

stock_lote_kg =
    suma(kilogramos de ingresos del lote)
    - suma(kilogramos de egresos del lote)

stock_ingrediente_kg =
    suma(stock_lote_kg de todos sus lotes)
```

Cuando existan ejecuciones de producción en curso:

```text
stock_disponible_lote_kg =
    stock_lote_kg
    - suma(reservas.cantidad
           WHERE tipo_recurso = 'ingrediente'
             AND id_ingrediente / lote correspondientes
             AND estado = 'activa')
```

Las reservas activas se materializan en la tabla `reservas` al confirmar dosificaciones. Ver sección **Reservas de stock**.

---

# Reglas de negocio

- Todo movimiento deberá generar automáticamente una actualización del stock del lote correspondiente (mediante el recálculo de ingresos y egresos).
- Los movimientos de **Ingreso** incrementarán el stock disponible.
- Los movimientos de **Egreso** disminuirán el stock disponible.
- No deberá permitirse registrar un egreso cuya cantidad (kg) supere el stock disponible del lote seleccionado.
- Los lotes con `control_calidad = no_conforme` no podrán utilizarse en procesos de producción ni ser considerados por el algoritmo FIFO.
- El cálculo del stock disponible deberá realizarse considerando todos los ingresos y egresos registrados para cada lote.
- El módulo de Producción deberá consumir automáticamente los lotes utilizando el criterio FIFO (First In, First Out), ordenando por fecha de primer ingreso del lote y luego por identificador.
- Todas las operaciones deberán mantener la trazabilidad completa del lote desde su ingreso hasta su consumo total.
- El lote es único por ingrediente: `UNIQUE (id_ingrediente, lote)` a nivel de identidad lógica. Varios movimientos pueden compartir el mismo lote.
- Antes de eliminar un movimiento, el sistema deberá verificar que dicha operación no afecte la consistencia del stock ni la trazabilidad de movimientos posteriores.
- Un ingreso no podrá eliminarse si existen egresos posteriores del mismo lote que quedarían sin cobertura.
- Un egreso no podrá eliminarse si ya fue consumido o referenciado por una ejecución de producción finalizada, cuando esa trazabilidad exista.
- Las cantidades se visualizan en kilogramos en listados e indicadores.
- Solo ingredientes activos podrán seleccionarse en nuevos movimientos.

---

# Validaciones

- `movimiento`: obligatorio (`ingreso` / `egreso`).
- `id_categoria`: obligatorio y existente.
- `id_ingrediente`: obligatorio, existente, activo y perteneciente a la categoría seleccionada.
- `id_empresa`: obligatorio y existente.
- `lote`: obligatorio, máximo 50 caracteres.
- En ingreso: si el lote ya existe para el ingrediente, el movimiento suma stock a ese lote; no podrá crearse otra identidad distinta con el mismo número.
- En egreso: el lote debe existir para el ingrediente.
- `fecha_vencimiento`: obligatoria en ingresos.
- `cantidad_unidades > 0`.
- `capacidad_unidad > 0`.
- `unidades_por_pallet > 0`.
- `cantidad_pallets` se calcula y no se edita manualmente.
- `control_calidad`: obligatorio (`conforme` / `no_conforme`).
- Egreso: `cantidad_unidades * capacidad_unidad <= stock_disponible_lote_kg`.
- Egreso: el lote no podrá estar `no_conforme` si el destino es producción; los egresos manuales de lotes no conformes solo se permitirán cuando el movimiento no alimente producción (por ejemplo, devolución o baja), documentado en la descripción.
- Hasta 2 imágenes de comprobante.
- Hasta 5 imágenes de ingrediente.
- Formatos de imagen permitidos: los mismos que en el resto del sistema (`png`, `jpg`, `webp`).
- `fecha_registro` y `creado_por` se asignan automáticamente.

---

# Flujo del módulo

```text
Inicio

↓

Movimientos / Ingredientes

↓

Indicadores + Listado filtrable

↓

Nuevo / Ver detalle / Editar / Eliminar

↓

Completar formulario
(categoría → código/ingrediente sincronizados)
(cálculo de pallets y kg)

↓

Validar stock, lote, calidad y permisos

↓

Guardar movimiento e imágenes

↓

Recalcular stock del lote / ingrediente

↓

Actualizar listado e indicadores
```

---

# Integración con Producción (FIFO)

Para cada ingrediente requerido en una ejecución:

1. Obtener lotes con `control_calidad = conforme` y saldo disponible.
2. Calcular:

```text
stock_disponible_lote_kg =
    suma(ingresos_kg)
    - suma(egresos_kg)
    - suma(reservas_activas)
```

3. Ordenar por fecha del primer ingreso del lote (ascendente) y luego por identificador.
4. Asignar del lote más antiguo hasta cubrir la necesidad.
5. Al finalizar la ejecución, convertir las reservas en egresos registrados en `mov_ingredientes` con `movimiento = egreso`, manteniendo proveedor, lote y trazabilidad.

Los lotes `no_conforme` se excluyen del paso 1.

---

# Relaciones

```text
mov_ingredientes.id_categoria → categorias.id
mov_ingredientes.id_ingrediente → ingredientes.id
mov_ingredientes.id_empresa → empresas.id
mov_ingredientes.creado_por → usuarios.id

mov_ingrediente_comprobante_imagenes.id_mov_ingrediente → mov_ingredientes.id
mov_ingrediente_imagenes.id_mov_ingrediente → mov_ingredientes.id
```

---

# Permisos

## Movimientos

- Ver
- Crear
- Editar
- Eliminar

## Mov. Ingredientes

- Ver
- Crear
- Editar
- Eliminar

La consulta de indicadores y la visualización de imágenes requieren permiso de Ver.

---

# Submódulo: Movimientos / Envases

## Descripción

Este submódulo permitirá registrar, consultar y administrar todos los movimientos de ingreso y egreso de envases del depósito. Cada movimiento actualizará automáticamente el stock disponible, mantendrá la trazabilidad completa del envase y almacenará la información relacionada con el proveedor, comprobantes, imágenes, control de calidad y observaciones.

## Descripción de la información

Cada movimiento registrará:

- Fecha de registro y usuario creador.
- Tipo de movimiento: Ingreso o Egreso.
- Categoría y envase.
- Proveedor (empresa), obligatorio en ingresos.
- Cantidad de unidades.
- Número de comprobante e imágenes asociadas (hasta 2).
- Control de calidad: Conforme / No Conforme.
- Descripción opcional e imágenes del estado de los envases (hasta 5).

---

# Funcionalidades (Envases)

- Crear un movimiento de envase.
- Editar un movimiento cuando no afecte la consistencia del stock ni la trazabilidad posterior.
- Consultar movimientos de envases.
- Filtrar y ordenar por fecha, movimiento, categoría, envase, proveedor y control de calidad.
- Ver el detalle completo del movimiento, incluyendo imágenes.
- Visualizar las imágenes del comprobante desde el listado.
- Visualizar las imágenes del envase mediante **Ver imágenes**.
- Eliminar un movimiento únicamente cuando la operación no afecte la consistencia del stock ni la trazabilidad de movimientos posteriores.
- Consultar indicadores mensuales de ingresos, egresos y alertas de stock mínimo.

---

# Pantallas (Envases)

- Movimientos / Envases.
- Nuevo Movimiento de Envase.
- Editar Movimiento de Envase.
- Detalle de Movimiento de Envase.

---

# Indicadores (Envases)

La pantalla principal deberá mostrar, como mínimo:

| Indicador | Descripción |
|---|---|
| Stock bajo mínimo | Cantidad de envases cuyo stock disponible (unidades) está por debajo de `envases.stock_minimo` |
| Mes en análisis | Mes/año seleccionado para los indicadores (por defecto el mes actual) |
| Ingresos del mes | Cantidad de movimientos con `movimiento = ingreso` registrados en el mes |
| Unidades ingresadas | Suma de `cantidad_unidades` de los ingresos del mes |
| Egresos del mes | Cantidad de movimientos con `movimiento = egreso` registrados en el mes |
| Unidades egresadas | Suma de `cantidad_unidades` de los egresos del mes |

Solo se considerarán envases con `stock_minimo` definido (`IS NOT NULL`) para la alerta de stock bajo mínimo.

---

# Listado principal (Envases)

| Fecha | Movimiento | Envase | Cantidad (Unidades) | Comprobante | Calidad | Acciones |
|---|---|---|---:|---|---|---|
| 30/07/2026 | Ingreso | ABQ Genérico Rojo | 2.000 | EN-253645-02 + ícono | Conforme | Ver imágenes / Ver detalles / Editar / Eliminar |

## Comportamiento del listado

- Deberá permitir ordenar, filtrar y buscar por fecha, movimiento, categoría, envase, proveedor y control de calidad.
- La columna **Cantidad (Unidades)** mostrará la cantidad total afectada por el movimiento.
- El ícono de la columna **Comprobante** permitirá visualizar las imágenes del documento.
- **Ver imágenes** permitirá visualizar las fotografías del envase asociadas al movimiento.
- **Ver detalles** mostrará toda la información registrada, incluyendo proveedor, comprobante, imágenes, control de calidad y observaciones.
- **Editar** y **Eliminar** respetarán las reglas de consistencia de stock y trazabilidad.

---

# Formulario de registro (Envases)

## Campo 01 - Movimiento

- Lista desplegable obligatoria.
- Opciones: Ingreso / Egreso.
- Valores almacenados: `ingreso` / `egreso`.
- Determina si el stock del envase se incrementa o se reduce.

## Campo 02 - Categoría

- Lista desplegable obligatoria.
- Deberá mostrar todas las categorías de `categorias`.
- Al seleccionar una categoría, el sistema filtrará automáticamente los envases disponibles.

## Campo 03 - Envase

- Lista desplegable obligatoria.
- Mostrará los envases activos pertenecientes a la categoría seleccionada.
- Se almacena como `id_envase`.

## Campo 04 - Proveedor

- Lista desplegable con las empresas de `empresas`.
- **Obligatorio** en movimientos de **Ingreso**.
- En **Egreso** podrá completarse automáticamente si corresponde o permanecer vacío (`id_empresa = NULL`).

## Campo 05 - Cantidad de Unidades

- Campo numérico obligatorio.
- Debe ser mayor que `0`.
- No se admitirán valores menores o iguales a cero.

## Campo 06 - Comprobante

- Campo de texto para el número de remito, factura o documento asociado.
- Ícono para adjuntar, de forma opcional, hasta **2** imágenes del comprobante.
- Las imágenes se almacenan en `mov_envase_comprobante_imagenes`.

## Campo 07 - Control de Calidad

- Lista desplegable obligatoria.
- Opciones: Conforme / No Conforme.
- Valores almacenados: `conforme` / `no_conforme`.
- Indica si los envases fueron aprobados o rechazados en la recepción o inspección.

## Campo 08 - Descripción

- Campo opcional de texto largo.
- Ícono para adjuntar hasta **5** imágenes del estado de los envases.
- Las imágenes se almacenan en `mov_envase_imagenes`.

---

# Cálculo de stock (Envases)

El stock no se almacena como valor fijo en el maestro de envases. Se calcula a partir de los movimientos.

```text
stock_envase_unidades =
    suma(cantidad_unidades de ingresos)
    - suma(cantidad_unidades de egresos)

stock_disponible_produccion =
    suma(cantidad_unidades de ingresos conforme)
    - suma(cantidad_unidades de egresos)
```

Cuando existan ejecuciones de producción en curso:

```text
stock_disponible_envase =
    stock_disponible_produccion
    - suma(reservas_activas del envase)
```

Las reservas de consumibles se materializan en `reservas` (`tipo_recurso = envase`). Al finalizar la ejecución se convierten en egresos en `mov_envases`. Ver sección **Reservas de stock**.

---

# Reglas de negocio (Envases)

- Todo movimiento deberá actualizar automáticamente el stock disponible del envase correspondiente (mediante el recálculo de ingresos y egresos).
- Los movimientos de **Ingreso** incrementarán el stock disponible.
- Los movimientos de **Egreso** disminuirán el stock disponible.
- No deberá permitirse registrar un egreso cuya cantidad supere el stock disponible.
- Las unidades ingresadas con `control_calidad = no_conforme` no formarán parte del stock disponible para producción hasta su regularización o baja documentada.
- El stock disponible para producción se calculará como:

```text
stock_disponible_produccion =
    suma(ingresos conforme)
    - suma(egresos)
```

- El stock físico total (listado de insumos) considerará todos los ingresos y egresos, incluidos los no conformes aún no dados de baja.
- Todas las operaciones deberán conservar la trazabilidad completa del envase desde su ingreso hasta su consumo o baja definitiva.
- Cada movimiento deberá registrar automáticamente la fecha, hora y usuario responsable (`fecha_registro`, `creado_por`).
- Antes de eliminar un movimiento, el sistema deberá verificar que dicha operación no comprometa la consistencia del stock ni la trazabilidad de movimientos posteriores.
- Un ingreso no podrá eliminarse si existen egresos posteriores del mismo envase que quedarían sin cobertura.
- Solo envases activos podrán seleccionarse en nuevos movimientos.

---

# Validaciones (Envases)

- `movimiento`: obligatorio (`ingreso` / `egreso`).
- `id_categoria`: obligatorio y existente.
- `id_envase`: obligatorio, existente, activo y perteneciente a la categoría seleccionada.
- `id_empresa`: obligatorio en ingresos; opcional en egresos.
- `cantidad_unidades > 0`.
- `control_calidad`: obligatorio (`conforme` / `no_conforme`).
- Egreso: `cantidad_unidades <= stock_envase_unidades - reservas_activas` (stock físico disponible).
- Egreso destinado a producción: no podrá consumir unidades no conformes; deberá respetar `stock_disponible_produccion`.
- Hasta 2 imágenes de comprobante.
- Hasta 5 imágenes del envase.
- Formatos permitidos: `png`, `jpg`, `webp`.
- `fecha_registro` y `creado_por` se asignan automáticamente.

---

# Flujo del submódulo (Envases)

```text
Inicio

↓

Movimientos / Envases

↓

Indicadores + Listado filtrable

↓

Nuevo / Ver detalle / Ver imágenes / Editar / Eliminar

↓

Completar formulario
(categoría → envases filtrados)

↓

Validar stock, calidad y permisos

↓

Guardar movimiento e imágenes

↓

Recalcular stock del envase

↓

Actualizar listado e indicadores
```

---

# Integración con Producción (Envases)

Al finalizar una ejecución, las reservas de consumibles de tipo envase se convierten en egresos registrados en `mov_envases` con `movimiento = egreso`, conservando la trazabilidad del envase utilizado.

Los envases no conformes no podrán reservarse ni consumirse en producción hasta regularizar su estado.

---

# Relaciones (Envases)

```text
mov_envases.id_categoria → categorias.id
mov_envases.id_envase → envases.id
mov_envases.id_empresa → empresas.id
mov_envases.creado_por → usuarios.id

mov_envase_comprobante_imagenes.id_mov_envase → mov_envases.id
mov_envase_imagenes.id_mov_envase → mov_envases.id
```

---

# Permisos (Envases)

## Mov. Envases

- Ver
- Crear
- Editar
- Eliminar

La consulta de indicadores y la visualización de imágenes requieren permiso de Ver.

---

# Submódulo: Movimientos / Obleas

## Descripción

Este submódulo permitirá registrar y consultar todos los movimientos de ingreso y egreso de obleas del depósito. Cada movimiento actualizará automáticamente el stock disponible y mantendrá la trazabilidad completa de cada oblea, incluyendo proveedor, comprobantes, imágenes y control de calidad.

## Descripción de la información

Cada movimiento registrará:

- Fecha de registro y usuario creador.
- Tipo de movimiento: Ingreso o Egreso.
- Categoría y oblea.
- Proveedor (empresa).
- Cantidad de unidades.
- Número de comprobante e imágenes asociadas (hasta 2).
- Control de calidad: Conforme / No Conforme.
- Descripción opcional e imágenes de las obleas (hasta 5).

---

# Funcionalidades (Obleas)

- Crear un movimiento de oblea.
- Editar un movimiento cuando no afecte la consistencia del stock ni la trazabilidad posterior.
- Consultar movimientos de obleas.
- Filtrar y ordenar por fecha, movimiento, categoría, oblea, proveedor y control de calidad.
- Ver el detalle completo del movimiento, incluyendo imágenes.
- Visualizar las imágenes del comprobante desde el listado.
- Visualizar las imágenes de las obleas mediante **Ver imágenes**.
- Eliminar un movimiento únicamente cuando la operación no afecte la consistencia del stock ni la trazabilidad de movimientos posteriores.
- Consultar indicadores mensuales de ingresos, egresos y alertas de stock mínimo.

---

# Pantallas (Obleas)

- Movimientos / Obleas.
- Nuevo Movimiento de Oblea.
- Editar Movimiento de Oblea.
- Detalle de Movimiento de Oblea.

---

# Indicadores (Obleas)

La pantalla principal deberá mostrar, como mínimo:

| Indicador | Descripción |
|---|---|
| Stock bajo mínimo | Cantidad de obleas cuyo stock disponible (unidades) está por debajo de `obleas.stock_minimo` |
| Mes en análisis | Mes/año seleccionado para los indicadores (por defecto el mes actual) |
| Ingresos del mes | Cantidad de movimientos con `movimiento = ingreso` registrados en el mes |
| Unidades ingresadas | Suma de `cantidad_unidades` de los ingresos del mes |
| Egresos del mes | Cantidad de movimientos con `movimiento = egreso` registrados en el mes |
| Unidades egresadas | Suma de `cantidad_unidades` de los egresos del mes |

Solo se considerarán obleas con `stock_minimo` definido (`IS NOT NULL`) para la alerta de stock bajo mínimo.

---

# Listado principal (Obleas)

| Fecha | Movimiento | Oblea | Cantidad (Unidades) | Comprobante | Calidad | Acciones |
|---|---|---|---:|---|---|---|
| 30/07/2026 | Ingreso | ABQ FEED LOT AR | 2.000 | EN-253645-02 + ícono | Conforme | Ver imágenes / Ver detalles / Editar / Eliminar |

## Comportamiento del listado

- Deberá permitir ordenar y filtrar por fecha, movimiento, categoría, oblea, proveedor y control de calidad.
- La columna **Cantidad (Unidades)** mostrará la cantidad total afectada por el movimiento.
- El ícono de la columna **Comprobante** permitirá visualizar las imágenes del documento.
- **Ver imágenes** permitirá visualizar las fotografías de las obleas asociadas al movimiento.
- **Ver detalles** mostrará toda la información del registro, incluyendo imágenes de las obleas y del comprobante.
- **Editar** y **Eliminar** respetarán las reglas de consistencia de stock y trazabilidad.

---

# Formulario de registro (Obleas)

## Campo 01 - Movimiento

- Lista desplegable obligatoria.
- Opciones: Ingreso / Egreso.
- Valores almacenados: `ingreso` / `egreso`.
- Determina si el stock de la oblea aumenta o disminuye.

## Campo 02 - Categoría

- Lista desplegable obligatoria.
- Deberá mostrar todas las categorías de `categorias`.
- Al seleccionar una categoría, el sistema filtrará automáticamente las obleas disponibles.

## Campo 03 - Oblea

- Lista desplegable obligatoria.
- Mostrará las obleas activas pertenecientes a la categoría seleccionada.
- Se almacena como `id_oblea`.

## Campo 04 - Proveedor

- Lista desplegable obligatoria.
- Deberá mostrar todas las empresas de `empresas`.
- Se almacena como `id_empresa`.

## Campo 05 - Cantidad de Unidades

- Campo numérico obligatorio.
- Debe ser mayor que `0`.

## Campo 06 - Comprobante

- Campo de texto para el número de remito, factura o comprobante asociado.
- Ícono para adjuntar, de forma opcional, hasta **2** imágenes del comprobante.
- Las imágenes se almacenan en `mov_oblea_comprobante_imagenes`.

## Campo 07 - Control de Calidad

- Lista desplegable obligatoria.
- Opciones: Conforme / No Conforme.
- Valores almacenados: `conforme` / `no_conforme`.
- Identifica si las obleas fueron aprobadas o rechazadas durante la recepción.

## Campo 08 - Descripción

- Campo opcional de texto largo.
- Ícono para adjuntar hasta **5** imágenes de las obleas recibidas o despachadas.
- Las imágenes se almacenan en `mov_oblea_imagenes`.

---

# Cálculo de stock (Obleas)

El stock no se almacena como valor fijo en el maestro de obleas. Se calcula a partir de los movimientos.

```text
stock_oblea_unidades =
    suma(cantidad_unidades de ingresos)
    - suma(cantidad_unidades de egresos)

stock_disponible_produccion =
    suma(cantidad_unidades de ingresos conforme)
    - suma(cantidad_unidades de egresos)
```

Cuando existan ejecuciones de producción en curso:

```text
stock_disponible_oblea =
    stock_disponible_produccion
    - suma(reservas_activas de la oblea)
```

Las reservas de consumibles se materializan en `reservas` (`tipo_recurso = oblea`). Al finalizar la ejecución se convierten en egresos en `mov_obleas`. Ver sección **Reservas de stock**.

---

# Reglas de negocio (Obleas)

- Todo movimiento deberá generar automáticamente una actualización del stock correspondiente.
- Los movimientos de **Ingreso** incrementarán el stock disponible.
- Los movimientos de **Egreso** disminuirán el stock disponible.
- No deberá permitirse registrar un egreso cuya cantidad supere el stock disponible de la oblea seleccionada.
- Las unidades ingresadas con `control_calidad = no_conforme` no formarán parte del stock disponible para producción hasta su regularización o baja documentada.
- El stock físico total (listado de insumos) considerará todos los ingresos y egresos, incluidos los no conformes aún no dados de baja.
- El cálculo del stock disponible deberá realizarse considerando todos los ingresos y egresos registrados para cada oblea.
- Todas las operaciones deberán mantener la trazabilidad completa de las obleas desde su ingreso hasta su consumo total.
- Cada movimiento deberá registrar automáticamente la fecha, hora y usuario responsable (`fecha_registro`, `creado_por`).
- Antes de eliminar un movimiento, el sistema deberá verificar que dicha operación no afecte la consistencia del stock ni la trazabilidad de movimientos posteriores.
- Un ingreso no podrá eliminarse si existen egresos posteriores de la misma oblea que quedarían sin cobertura.
- Solo obleas activas podrán seleccionarse en nuevos movimientos.

---

# Validaciones (Obleas)

- `movimiento`: obligatorio (`ingreso` / `egreso`).
- `id_categoria`: obligatorio y existente.
- `id_oblea`: obligatorio, existente, activo y perteneciente a la categoría seleccionada.
- `id_empresa`: obligatorio y existente.
- `cantidad_unidades > 0`.
- `control_calidad`: obligatorio (`conforme` / `no_conforme`).
- Egreso: `cantidad_unidades <= stock_oblea_unidades - reservas_activas` (stock físico disponible).
- Egreso destinado a producción: no podrá consumir unidades no conformes; deberá respetar `stock_disponible_produccion`.
- Hasta 2 imágenes de comprobante.
- Hasta 5 imágenes de oblea.
- Formatos permitidos: `png`, `jpg`, `webp`.
- `fecha_registro` y `creado_por` se asignan automáticamente.

---

# Flujo del submódulo (Obleas)

```text
Inicio

↓

Movimientos / Obleas

↓

Indicadores + Listado filtrable

↓

Nuevo / Ver detalle / Ver imágenes / Editar / Eliminar

↓

Completar formulario
(categoría → obleas filtradas)

↓

Validar stock, calidad y permisos

↓

Guardar movimiento e imágenes

↓

Recalcular stock de la oblea

↓

Actualizar listado e indicadores
```

---

# Integración con Producción (Obleas)

Al finalizar una ejecución, las reservas de consumibles de tipo oblea se convierten en egresos registrados en `mov_obleas` con `movimiento = egreso`, conservando la trazabilidad de la oblea utilizada.

Las obleas no conformes no podrán reservarse ni consumirse en producción hasta regularizar su estado.

---

# Relaciones (Obleas)

```text
mov_obleas.id_categoria → categorias.id
mov_obleas.id_oblea → obleas.id
mov_obleas.id_empresa → empresas.id
mov_obleas.creado_por → usuarios.id

mov_oblea_comprobante_imagenes.id_mov_oblea → mov_obleas.id
mov_oblea_imagenes.id_mov_oblea → mov_obleas.id
```

---

# Permisos (Obleas)

## Mov. Obleas

- Ver
- Crear
- Editar
- Eliminar

La consulta de indicadores y la visualización de imágenes requieren permiso de Ver.

---

# Submódulo: Movimientos / Otros

## Descripción

Este submódulo permitirá registrar y consultar todos los movimientos de ingreso y egreso de otros insumos del depósito. Cada movimiento actualizará automáticamente el stock disponible y mantendrá la trazabilidad completa de cada registro, incluyendo proveedor, comprobantes, imágenes y control de calidad.

## Descripción de la información

Cada movimiento registrará:

- Fecha de registro y usuario creador.
- Tipo de movimiento: Ingreso o Egreso.
- Otro insumo.
- Proveedor (empresa).
- Cantidad de unidades.
- Número de comprobante e imágenes asociadas (hasta 2).
- Control de calidad: Conforme / No Conforme.
- Descripción opcional e imágenes del insumo (hasta 5).

---

# Funcionalidades (Otros)

- Crear un movimiento de otro insumo.
- Editar un movimiento cuando no afecte la consistencia del stock ni la trazabilidad posterior.
- Consultar movimientos de otros.
- Filtrar y ordenar por fecha, movimiento, categoría, otro y control de calidad.
- Ver el detalle completo del movimiento, incluyendo imágenes.
- Visualizar las imágenes del comprobante desde el listado.
- Visualizar las imágenes del insumo mediante **Ver imágenes**.
- Eliminar un movimiento únicamente cuando la operación no afecte la consistencia del stock ni la trazabilidad de movimientos posteriores.
- Consultar indicadores mensuales de ingresos, egresos y alertas de stock mínimo.

---

# Pantallas (Otros)

- Movimientos / Otros.
- Nuevo Movimiento de Otro.
- Editar Movimiento de Otro.
- Detalle de Movimiento de Otro.

---

# Indicadores (Otros)

La pantalla principal deberá mostrar, como mínimo:

| Indicador | Descripción |
|---|---|
| Stock bajo mínimo | Cantidad de otros insumos cuyo stock disponible (unidades) está por debajo de `otros.stock_minimo` |
| Mes en análisis | Mes/año seleccionado para los indicadores (por defecto el mes actual) |
| Ingresos del mes | Cantidad de movimientos con `movimiento = ingreso` registrados en el mes |
| Unidades ingresadas | Suma de `cantidad_unidades` de los ingresos del mes |
| Egresos del mes | Cantidad de movimientos con `movimiento = egreso` registrados en el mes |
| Unidades egresadas | Suma de `cantidad_unidades` de los egresos del mes |

Solo se considerarán registros con `stock_minimo` definido (`IS NOT NULL`) para la alerta de stock bajo mínimo.

---

# Listado principal (Otros)

| Fecha | Movimiento | Otro | Cantidad (Unidades) | Comprobante | Calidad | Acciones |
|---|---|---|---:|---|---|---|
| 30/07/2026 | Ingreso | Bobina Papel Creppe | 30 | EN-253645-02 + ícono | Conforme | Ver imágenes / Ver detalles / Editar / Eliminar |

## Comportamiento del listado

- Deberá permitir ordenar y filtrar por fecha, movimiento, categoría, otro y control de calidad.
- El filtro por categoría se resolverá mediante `otros.id_categoria`.
- La columna **Cantidad (Unidades)** mostrará la cantidad total afectada por el movimiento.
- El ícono de la columna **Comprobante** permitirá visualizar las imágenes del documento.
- **Ver imágenes** permitirá visualizar las fotografías del insumo asociadas al movimiento.
- **Ver detalles** mostrará toda la información del registro, incluyendo imágenes del insumo y del comprobante.
- **Editar** y **Eliminar** respetarán las reglas de consistencia de stock y trazabilidad.

---

# Formulario de registro (Otros)

## Campo 01 - Movimiento

- Lista desplegable obligatoria.
- Opciones: Ingreso / Egreso.
- Valores almacenados: `ingreso` / `egreso`.
- Determina si el stock del otro insumo aumenta o disminuye.

## Campo 02 - Otro

- Lista desplegable obligatoria.
- Mostrará los nombres de los registros activos de la tabla `otros` (`insumo`).
- Se almacena como `id_otro`.

## Campo 03 - Proveedor

- Lista desplegable obligatoria.
- Deberá mostrar todas las empresas de `empresas`.
- Se almacena como `id_empresa`.

## Campo 04 - Cantidad de Unidades

- Campo numérico obligatorio.
- Debe ser mayor que `0`.

## Campo 05 - Comprobante

- Campo de texto para el número de remito, factura o comprobante asociado.
- Ícono para adjuntar, de forma opcional, hasta **2** imágenes del comprobante.
- Las imágenes se almacenan en `mov_otro_comprobante_imagenes`.

## Campo 06 - Control de Calidad

- Lista desplegable obligatoria.
- Opciones: Conforme / No Conforme.
- Valores almacenados: `conforme` / `no_conforme`.
- Identifica si el insumo fue aprobado o rechazado durante la recepción.

## Campo 07 - Descripción

- Campo opcional de texto largo.
- Ícono para adjuntar hasta **5** imágenes del insumo recibido o despachado.
- Las imágenes se almacenan en `mov_otro_imagenes`.

---

# Cálculo de stock (Otros)

El stock no se almacena como valor fijo en el maestro de otros. Se calcula a partir de los movimientos.

```text
stock_otro_unidades =
    suma(cantidad_unidades de ingresos)
    - suma(cantidad_unidades de egresos)

stock_disponible_produccion =
    suma(cantidad_unidades de ingresos conforme)
    - suma(cantidad_unidades de egresos)
```

Cuando existan ejecuciones de producción en curso:

```text
stock_disponible_otro =
    stock_disponible_produccion
    - suma(reservas_activas del otro)
```

Las reservas de consumibles se materializan en `reservas` (`tipo_recurso = otro`). Al finalizar la ejecución se convierten en egresos en `mov_otros`. Ver sección **Reservas de stock**.

---

# Reglas de negocio (Otros)

- Todo movimiento deberá generar automáticamente una actualización del stock correspondiente.
- Los movimientos de **Ingreso** incrementarán el stock disponible.
- Los movimientos de **Egreso** disminuirán el stock disponible.
- No deberá permitirse registrar un egreso cuya cantidad supere el stock disponible del otro seleccionado.
- Las unidades ingresadas con `control_calidad = no_conforme` no formarán parte del stock disponible para producción hasta su regularización o baja documentada.
- El stock físico total (listado de insumos) considerará todos los ingresos y egresos, incluidos los no conformes aún no dados de baja.
- El cálculo del stock disponible deberá realizarse considerando todos los ingresos y egresos registrados para cada otro.
- Todas las operaciones deberán mantener la trazabilidad completa desde su ingreso hasta su consumo total.
- Cada movimiento deberá registrar automáticamente la fecha, hora y usuario responsable (`fecha_registro`, `creado_por`).
- Antes de eliminar un movimiento, el sistema deberá verificar que dicha operación no afecte la consistencia del stock ni la trazabilidad de movimientos posteriores.
- Un ingreso no podrá eliminarse si existen egresos posteriores del mismo otro que quedarían sin cobertura.
- Solo registros activos de `otros` podrán seleccionarse en nuevos movimientos.

---

# Validaciones (Otros)

- `movimiento`: obligatorio (`ingreso` / `egreso`).
- `id_otro`: obligatorio, existente y activo.
- `id_empresa`: obligatorio y existente.
- `cantidad_unidades > 0`.
- `control_calidad`: obligatorio (`conforme` / `no_conforme`).
- Egreso: `cantidad_unidades <= stock_otro_unidades - reservas_activas` (stock físico disponible).
- Egreso destinado a producción: no podrá consumir unidades no conformes; deberá respetar `stock_disponible_produccion`.
- Hasta 2 imágenes de comprobante.
- Hasta 5 imágenes del insumo.
- Formatos permitidos: `png`, `jpg`, `webp`.
- `fecha_registro` y `creado_por` se asignan automáticamente.

---

# Flujo del submódulo (Otros)

```text
Inicio

↓

Movimientos / Otros

↓

Indicadores + Listado filtrable

↓

Nuevo / Ver detalle / Ver imágenes / Editar / Eliminar

↓

Completar formulario

↓

Validar stock, calidad y permisos

↓

Guardar movimiento e imágenes

↓

Recalcular stock del otro

↓

Actualizar listado e indicadores
```

---

# Integración con Producción (Otros)

Al finalizar una ejecución, las reservas de consumibles de tipo otro se convierten en egresos registrados en `mov_otros` con `movimiento = egreso`, conservando la trazabilidad del insumo utilizado.

Los otros no conformes no podrán reservarse ni consumirse en producción hasta regularizar su estado.

---

# Relaciones (Otros)

```text
mov_otros.id_otro → otros.id
mov_otros.id_empresa → empresas.id
mov_otros.creado_por → usuarios.id

mov_otro_comprobante_imagenes.id_mov_otro → mov_otros.id
mov_otro_imagenes.id_mov_otro → mov_otros.id
```

---

# Permisos (Otros)

## Mov. Otros

- Ver
- Crear
- Editar
- Eliminar

La consulta de indicadores y la visualización de imágenes requieren permiso de Ver.

---

# Submódulo: Movimientos / Productos

## Descripción

Este submódulo permitirá registrar y consultar todos los movimientos de ingreso y egreso de productos del depósito. Cada movimiento actualizará automáticamente el stock disponible (unidades y kilogramos) y mantendrá la trazabilidad completa de cada producto, incluyendo lote, comprobantes, imágenes y control de calidad.

## Sugerencias aplicadas al modelo

Respecto del borrador inicial se aplicaron estas decisiones:

- Nombres de campos alineados al resto del sistema: `capacidad_unidad`, `unidades_por_pallet`, `cantidad_pallets`, `cantidad_pesaje`, `creado_por`.
- Imágenes en tablas hijas (`mov_producto_comprobante_imagenes`, `mov_producto_imagenes`), no FK únicas en el movimiento.
- Campo **Lote** obligatorio en el formulario (estaba en la tabla y el listado, pero no en el formulario del borrador).
- Código y Producto sincronizados, igual que en Ingredientes.
- `cantidad_pallets` y `cantidad_pesaje` calculados y almacenados.
- Sin `id_empresa`: el producto terminado proviene principalmente de producción interna; un egreso comercial no requiere proveedor.
- `stock_minimo_unidades` y `stock_minimo_kg` en el maestro `productos`.
- Indicadores mensuales también en kilogramos, además de unidades.
- Al finalizar una ejecución de producción se genera un ingreso automático en `mov_productos` con el lote de la solicitud.

## Descripción de la información

Cada movimiento registrará:

- Fecha de registro y usuario creador.
- Tipo de movimiento: Ingreso o Egreso.
- Categoría y producto (código y nombre sincronizados).
- Número de lote.
- Cantidad de unidades, capacidad unitaria (kg) y unidades por pallet.
- Cantidad de pallets y pesaje (kg) calculados.
- Número de comprobante e imágenes asociadas (hasta 2).
- Control de calidad: Conforme / No Conforme.
- Descripción opcional e imágenes del producto (hasta 5).

---

# Funcionalidades (Productos)

- Crear un movimiento de producto.
- Editar un movimiento cuando no afecte la consistencia del stock ni la trazabilidad posterior.
- Consultar movimientos de productos.
- Filtrar y ordenar por fecha, movimiento, categoría, producto, lote y control de calidad.
- Ver el detalle completo del movimiento, incluyendo imágenes.
- Visualizar las imágenes del comprobante desde el listado.
- Visualizar las imágenes del producto mediante **Ver imágenes**.
- Eliminar un movimiento únicamente cuando la operación no afecte la consistencia del stock ni la trazabilidad de movimientos posteriores.
- Consultar indicadores mensuales de ingresos, egresos y alertas de stock mínimo.

---

# Pantallas (Productos)

- Movimientos / Productos.
- Nuevo Movimiento de Producto.
- Editar Movimiento de Producto.
- Detalle de Movimiento de Producto.

---

# Indicadores (Productos)

| Indicador | Descripción |
|---|---|
| Stock bajo mínimo | Cantidad de productos con stock disponible bajo `stock_minimo_unidades` y/o `stock_minimo_kg` (cuando estén definidos) |
| Mes en análisis | Mes/año seleccionado (por defecto el mes actual) |
| Ingresos del mes | Cantidad de movimientos `ingreso` del mes |
| Unidades ingresadas | Suma de `cantidad_unidades` de ingresos del mes |
| Kg ingresados | Suma de `cantidad_pesaje` de ingresos del mes |
| Egresos del mes | Cantidad de movimientos `egreso` del mes |
| Unidades egresadas | Suma de `cantidad_unidades` de egresos del mes |
| Kg egresados | Suma de `cantidad_pesaje` de egresos del mes |

---

# Listado principal (Productos)

| Fecha | Movimiento | Código | Producto | Lote | Cantidad (un.) | Pallets | Total (kg) | Comprobante | Calidad | Acciones |
|---|---|---|---|---|---:|---:|---:|---|---|---|
| 30/07/2026 | Ingreso | 16-023136 | ABQ FEED LOT AR | GR26208 | 300 | 6 | 7.500 | 512 + ícono | Conforme | Ver imágenes / Ver detalles / Editar / Eliminar |

En el ejemplo: `Pallets = 300 / 50` y `Total (kg) = 300 * 25`.

## Comportamiento del listado

- Ordenar y filtrar por fecha, movimiento, categoría, producto, lote y control de calidad.
- **Cantidad (un.)**, **Pallets** y **Total (kg)** se muestran siempre; el stock maestro se calcula en unidades y kilogramos.
- El ícono de **Comprobante** muestra las imágenes del documento.
- **Ver imágenes** muestra las fotografías del producto.
- **Ver detalles** muestra toda la información del registro.
- **Editar** y **Eliminar** respetan consistencia de stock y trazabilidad.

---

# Formulario de registro (Productos)

## Campo 01 - Movimiento

- Obligatorio. Opciones: Ingreso / Egreso.
- Valores: `ingreso` / `egreso`.

## Campo 02 - Categoría

- Obligatoria. Lista de `categorias`.
- Filtra los productos disponibles.

## Campo 03 - Código

- Lista de códigos de productos activos de la categoría.
- Al seleccionar, completa automáticamente el Producto.
- Debe permanecer sincronizado con el campo Producto.

## Campo 04 - Producto

- Lista de nombres de productos activos de la categoría.
- Al seleccionar, completa automáticamente el Código.
- Debe permanecer sincronizado con el campo Código.

## Campo 05 - Lote

- Texto obligatorio.
- Identidad lógica: `(id_producto, lote)`.
- En **Ingreso**, si el lote no existe se crea; si existe, el movimiento suma stock a ese lote.
- En **Egreso**, el lote debe existir y tener stock disponible suficiente.

## Campo 06 - Cantidad de Unidades

- Numérico obligatorio. Debe ser `> 0`.

## Campo 07 - Capacidad Unitaria

- Numérico obligatorio. Debe ser `> 0`.
- Kilogramos por unidad (`capacidad_unidad`).

## Campo 08 - Unidades por Pallet

- Numérico obligatorio. Debe ser `> 0`.
- Se almacena como `unidades_por_pallet`.

## Campo 09 - Cantidad de Pallets

- Calculado, no editable:

```text
cantidad_pallets = cantidad_unidades / unidades_por_pallet
```

- Puede contener decimales.

## Campo 10 - Cantidad Pesaje (kg)

- Calculado, no editable:

```text
cantidad_pesaje = cantidad_unidades * capacidad_unidad
```

## Campo 11 - Comprobante

- Texto opcional (remito, factura u otro).
- Hasta **2** imágenes en `mov_producto_comprobante_imagenes`.

## Campo 12 - Control de Calidad

- Obligatorio: Conforme / No Conforme.
- Valores: `conforme` / `no_conforme`.

## Campo 13 - Descripción

- Texto largo opcional.
- Hasta **5** imágenes en `mov_producto_imagenes`.

---

# Cálculo de stock (Productos)

```text
stock_unidades =
    suma(cantidad_unidades de ingresos)
    - suma(cantidad_unidades de egresos)

stock_kg =
    suma(cantidad_pesaje de ingresos)
    - suma(cantidad_pesaje de egresos)

stock_lote_unidades / stock_lote_kg =
    mismos cálculos filtrados por (id_producto, lote)

stock_disponible_produccion_o_despacho =
    suma(movimientos conforme)
    - suma(egresos)
```

Las unidades/kg de ingresos `no_conforme` no forman parte del stock disponible para despacho o procesos posteriores hasta su regularización o baja.

---

# Reglas de negocio (Productos)

- Todo movimiento actualiza automáticamente el stock del producto y del lote.
- Ingresos incrementan; egresos disminuyen.
- Un egreso no podrá superar el stock disponible del lote seleccionado.
- Lotes o saldos `no_conforme` no podrán despacharse ni utilizarse en procesos posteriores.
- El stock maestro se calcula con todos los movimientos; el disponible para uso operativo excluye no conformes pendientes.
- Trazabilidad completa del lote desde el ingreso hasta el consumo/despacho total.
- Código y Producto siempre sincronizados.
- Antes de eliminar, verificar consistencia de stock y trazabilidad posterior.
- Un ingreso no podrá eliminarse si existen egresos posteriores del mismo lote sin cobertura.
- Solo productos activos podrán seleccionarse en nuevos movimientos.
- Al finalizar una ejecución de producción, el sistema generará (o confirmará) un ingreso en `mov_productos` con el producto, lote y cantidades elaboradas de la solicitud/ejecución.

---

# Validaciones (Productos)

- `movimiento`: obligatorio (`ingreso` / `egreso`).
- `id_categoria`: obligatorio y existente.
- `id_producto`: obligatorio, activo y de la categoría seleccionada.
- `lote`: obligatorio, máximo 50 caracteres.
- `cantidad_unidades > 0`, `capacidad_unidad > 0`, `unidades_por_pallet > 0`.
- `cantidad_pallets` y `cantidad_pesaje` calculados.
- `control_calidad`: obligatorio.
- Egreso: no superar stock del lote (unidades y kg coherentes con la capacidad del movimiento).
- Hasta 2 imágenes de comprobante y 5 del producto.
- Formatos: `png`, `jpg`, `webp`.
- `fecha_registro` y `creado_por` automáticos.

---

# Flujo del submódulo (Productos)

```text
Inicio

↓

Movimientos / Productos

↓

Indicadores + Listado filtrable

↓

Nuevo / Ver detalle / Ver imágenes / Editar / Eliminar

↓

Completar formulario
(categoría → código/producto sincronizados)
(cálculo de pallets y pesaje)

↓

Validar stock, lote, calidad y permisos

↓

Guardar movimiento e imágenes

↓

Recalcular stock del producto / lote

↓

Actualizar listado e indicadores
```

---

# Integración con Producción (Productos)

Al finalizar una ejecución:

1. Se generan egresos de ingredientes, envases, obleas y otros según reservas.
2. Se genera un **ingreso** en `mov_productos` con:
   - `id_producto` de la solicitud
   - `lote` de la solicitud
   - `cantidad_unidades` elaboradas
   - `capacidad_unidad` tomada del envase de la solicitud (`capacidad_kg`)
   - `unidades_por_pallet` de la solicitud
   - `control_calidad = conforme` (salvo que el proceso de calidad indique lo contrario)
3. `cantidad_pallets` y `cantidad_pesaje` se calculan con las fórmulas del módulo.

Los egresos manuales de producto (despacho, baja, etc.) se registran desde este submódulo.

---

# Relaciones (Productos)

```text
mov_productos.id_categoria → categorias.id
mov_productos.id_producto → productos.id
mov_productos.creado_por → usuarios.id

mov_producto_comprobante_imagenes.id_mov_producto → mov_productos.id
mov_producto_imagenes.id_mov_producto → mov_productos.id
```

---

# Permisos (Productos)

## Mov. Productos

- Ver
- Crear
- Editar
- Eliminar

---

# Auditoría

Cada movimiento registra:

- Fecha de registro.
- Usuario creador.

Antes de implementar podrá decidirse si también se incorporan:

- Fecha de última modificación.
- Usuario que realizó la última modificación.

---

# Mejoras futuras

- Selección asistida de lote en egresos (lista de lotes con saldo).
- Alertas de vencimiento próximo (si se incorpora fecha de vencimiento al producto terminado).
- Impresión / exportación de comprobantes de movimiento.
- Vinculación explícita del ingreso automático de producción (`id_ejecucion` / `id_solicitud`).
- Regularización guiada de unidades no conformes.
- Pantalla de supervisión de reservas activas.

---

# Historial de cambios

## 2026-07-30

- Creación inicial del módulo Movimientos.
- Documentación del submódulo Movimientos / Ingredientes.
- Definición de tablas `mov_ingredientes`, `mov_ingrediente_comprobante_imagenes` y `mov_ingrediente_imagenes`.
- Definición de indicadores, listado, formulario, validaciones, FIFO y reglas de stock.
- Documentación del submódulo Movimientos / Envases.
- Definición de tablas `mov_envases`, `mov_envase_comprobante_imagenes` y `mov_envase_imagenes`.
- Incorporación de indicadores, listado, formulario y reglas de stock por unidades.
- Documentación del submódulo Movimientos / Obleas.
- Definición de tablas `mov_obleas`, `mov_oblea_comprobante_imagenes` y `mov_oblea_imagenes`.
- Documentación del submódulo Movimientos / Otros.
- Definición de tablas `mov_otros`, `mov_otro_comprobante_imagenes` y `mov_otro_imagenes`.
- Documentación del submódulo Movimientos / Productos.
- Definición de tablas `mov_productos`, `mov_producto_comprobante_imagenes` y `mov_producto_imagenes`.
- Incorporación de ingreso automático de producto al finalizar ejecuciones.
- Definición de la tabla `reservas` como fuente de verdad del stock apartado por ejecuciones en curso.

---

# Observaciones

- La estructura de las tablas se encuentra en `01_estructura.md`.
- Los maestros de ingredientes, envases, obleas y otros se encuentran en `modulos/insumos.md`.
- El maestro de productos se encuentra en `modulos/productos.md`.
- Las empresas proveedoras se encuentran en `modulos/empresas.md` (aplican a movimientos de insumos).
- El consumo desde producción y el ingreso de producto terminado se encuentran en `modulos/produccion.md`.
- Las reglas generales de stock se encuentran en `03_reglas_generales.md`.
- Las imágenes siguen el mismo patrón de almacenamiento que el resto del sistema (tabla hija con `ruta_archivo`, `orden` y límite máximo).
- A diferencia de ingredientes/envases/obleas, `mov_otros` no guarda `id_categoria` en el movimiento.
- `mov_productos` no utiliza `id_empresa`.
- La tabla `reservas` descuenta stock disponible mientras una ejecución está en curso; al finalizar se convierte en egreso.
