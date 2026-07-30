# Módulo: Insumos

## Objetivo

Administrar los insumos utilizados en la planta.

El módulo Insumos contiene los submódulos:

- Ingredientes.
- Envases.
- Obleas.
- Otros.

---

# Tablas involucradas

- ingredientes
- envases
- envase_imagenes
- obleas
- oblea_imagenes
- otros
- otro_imagenes
- categorias
- perfiles
- perfil_detalles
- criterios
- usuarios

> La estructura de las tablas se encuentra documentada en `01_estructura.md`.
> El comportamiento del perfil de calidad de ingredientes se encuentra documentado en `modulos/calidad.md`.

---

# Stock disponible

Todos los listados de insumos deberán mostrar una columna de **Stock disponible**.

| Entidad | Unidad de stock |
|---|---|
| Ingredientes | kg |
| Envases | unidades |
| Obleas | unidades |
| Otros | unidades |

El stock **no se carga manualmente** en el alta del insumo.

Se calculará a partir de los registros de **ingresos** y **egresos** de insumos, según la fórmula:

```text
stock = suma(ingresos) - suma(egresos)
```

Cuando existan ejecuciones de producción en curso:

```text
stock_disponible = stock - suma(reservas con estado = activa)
```

Las dosificaciones reservarán ingredientes por lote y los consumibles reservarán unidades. Esas reservas se materializan en la tabla `reservas`. Al finalizar la ejecución, las reservas activas se convertirán en egresos; al recalcularlas deberán liberarse y reemplazarse en una única transacción.

El detalle de ingresos y egresos de ingredientes se encuentra documentado en `modulos/movimientos.md`. El listado de ingredientes deberá calcular el stock disponible a partir de esos movimientos.

El stock es un valor calculado/consultable. No reemplaza el historial de movimientos.
---

# Submódulo: Ingredientes

## Descripción de la información

Cada ingrediente registrará:

- Fecha de registro.
- Usuario creador.
- Categoría.
- Código único.
- Nombre del ingrediente.
- Perfil de calidad opcional.
- Stock mínimo opcional (kg).
- Estado.
- Descripción.

## Funcionalidades

- Crear un ingrediente.
- Editar un ingrediente.
- Consultar ingredientes.
- Buscar por código, nombre o categoría.
- Filtrar por categoría y estado.
- Ver el detalle de un ingrediente.
- Ver el perfil de calidad del ingrediente.
- Activar o desactivar un ingrediente.
- Eliminar un ingrediente únicamente cuando no tenga relaciones históricas.

## Pantallas

- Ingredientes.
- Nuevo Ingrediente.
- Editar Ingrediente.
- Detalle de Ingrediente.
- Panel de perfil de calidad.

## Listado principal

| Categoría | Código | Ingrediente | Stock (kg) | Estado | Acciones |
|---|---|---|---|---|---|
| Premezcla | MP-108 | Carbonato | 1.250,00 | Activo | Ver perfil / Ver detalles / Editar |
| Sustituto lácteo | MP-125 | Suero de queso | 840,50 | Activo | Ver perfil / Ver detalles / Editar |

### Acciones del listado

- **Ver perfil:** muestra el panel con los criterios y límites del perfil asociado. Si el ingrediente no tiene perfil, deberá indicarlo.
- **Ver detalles:** muestra la ficha completa del ingrediente.
- **Editar:** abre el formulario de edición.

## Formulario de alta / edición

### Categoría

- Obligatorio.
- Debe listar las categorías precargadas.

### Código

- Obligatorio.
- Único.
- Se escribe o se genera en el alta.
- No deberá permitir códigos repetidos.
- La selección desde códigos existentes se utilizará en módulos operativos como Movimientos.

### Ingrediente

- Obligatorio.
- Se escribe en el alta.

### Perfil

- Obligatorio.
- Valores: Aplica / No aplica.
- Por defecto: **Aplica**.
- Si Aplica, deberá agregarse al menos un criterio con sus límites.
- Mensaje de error sugerido: `Falta agregar el perfil de calidad o seleccionarlo como No aplica.`
- Si No aplica, `id_perfil` quedará en `NULL`.

### Stock mínimo

- Opcional.
- Valor numérico en kilogramos (`stock_minimo`).
- Si se completa, deberá ser mayor o igual a `0`.
- Se utiliza en el indicador de stock bajo del módulo Movimientos / Ingredientes.
- Si queda vacío, el ingrediente no participará de esa alerta.

### Estado

- Obligatorio.
- Por defecto: **Activo**.

### Descripción

- Opcional.
- Campo de texto largo.

## Validaciones de ingredientes

- `codigo`: obligatorio, único, máximo 30 caracteres.
- `ingrediente`: obligatorio, máximo 100 caracteres.
- `id_categoria`: obligatorio y existente.
- Perfil Aplica: al menos una línea de detalle.
- Perfil No aplica: `id_perfil = NULL`.
- `stock_minimo`: opcional; si se informa, `>= 0`.
- `estado`: Activo / Inactivo.
- `fecha_registro` y `creado_por` se asignan automáticamente.

## Reglas de negocio de ingredientes

- El código es único en la tabla `ingredientes`.
- Cada ingrediente pertenece a una única categoría.
- Puede tener un perfil de calidad propio o no tenerlo.
- Solo ingredientes activos deberán seleccionarse en procesos operativos futuros.
- Preferir baja lógica mediante `estado = false`.
- El stock disponible se calcula desde `mov_ingredientes` según `modulos/movimientos.md`.
- `stock_minimo` no altera el stock; solo define el umbral de alerta.

## Relaciones de ingredientes

```text
ingredientes.id_categoria → categorias.id
ingredientes.id_perfil → perfiles.id
ingredientes.creado_por → usuarios.id
```

---

# Submódulo: Envases

## Descripción de la información

Cada envase registrará:

- Fecha de registro.
- Usuario creador.
- Categoría.
- Código único.
- Nombre del envase.
- Capacidad en kilogramos.
- Stock mínimo opcional (unidades).
- Estado.
- Hasta 4 imágenes.
- Descripción.

## Funcionalidades

- Crear un envase.
- Editar un envase.
- Consultar envases.
- Buscar por código o nombre.
- Filtrar por categoría y estado.
- Ver el detalle de un envase.
- Cargar, reemplazar, reordenar o eliminar imágenes.
- Activar o desactivar un envase.
- Eliminar un envase únicamente cuando no tenga relaciones históricas.

## Pantallas

- Envases.
- Nuevo Envase.
- Editar Envase.
- Detalle de Envase.

## Listado principal

| Código | Envase | Imagen | Stock (un.) | Estado | Acciones |
|---|---|---|---|---|---|
| ENV-001 | GENÉRICO-SUSTITUTO CLÁSICO CL | Vista previa de la primera imagen | 320 | Activo | Ver detalles / Editar |

La columna Imagen mostrará la miniatura de la imagen con `orden = 1`. Si el envase no tiene imágenes, deberá mostrarse un indicador de “Sin imagen”.

### Acciones del listado

- **Ver detalles:** muestra la ficha completa del envase, incluyendo todas las imágenes.
- **Editar:** abre el formulario de edición.

## Formulario de alta / edición

### Categoría

- Obligatorio.
- Debe listar las categorías precargadas.

### Código

- Obligatorio.
- Único.
- Se escribe o se genera en el alta.
- No deberá permitir códigos repetidos.
- Ejemplo: `ENV-001`.

### Envase

- Obligatorio.
- Nombre o descripción corta del envase.
- Ejemplo: `GENÉRICO-SUSTITUTO CLÁSICO CL`.

### Capacidad (kg)

- Obligatorio.
- Numérico.
- Debe ser mayor que 0.
- Se expresa en kilogramos.

### Stock mínimo

- Opcional.
- Valor numérico en unidades (`stock_minimo`).
- Si se completa, deberá ser mayor o igual a `0`.
- Se utiliza en el indicador de stock bajo del módulo Movimientos / Envases.
- Si queda vacío, el envase no participará de esa alerta.

### Estado

- Obligatorio.
- Por defecto: **Activo**.

### Imágenes

- Opcional.
- Hasta 4 imágenes por envase.
- Formatos permitidos:
  - `png`
  - `jpg` / `jpeg`
  - `webp`
- Tamaño máximo sugerido por imagen: 2 MB.
- La primera imagen cargada o la marcada con orden 1 será la vista previa del listado.
- Deberá permitirse:
  - agregar imágenes hasta completar el máximo
  - eliminar una imagen
  - reemplazar una imagen
  - reordenar las imágenes

### Descripción

- Opcional.
- Campo de texto largo.

## Flujo del submódulo

```text
Inicio

↓

Insumos / Envases

↓

Nuevo Envase

↓

Completar categoría, código, nombre, capacidad, estado y descripción

↓

Cargar hasta 4 imágenes

↓

Validación de datos, código único e imágenes

↓

Guardar envase e imágenes

↓

Actualización del listado
```

## Validaciones de envases

### Categoría

- Obligatoria.
- Debe existir en `categorias`.

### Código

- Obligatorio.
- Único.
- Máximo 30 caracteres.
- No permitir espacios al inicio o al final.
- La validación de duplicados deberá ignorar mayúsculas y minúsculas.

### Envase

- Obligatorio.
- Máximo 150 caracteres.
- No permitir espacios al inicio o al final.

### Capacidad

- Obligatoria.
- Numérica.
- Mayor que 0.
- Hasta 4 decimales.

### Stock mínimo

- Opcional.
- Si se informa, `>= 0`.

### Estado

- Obligatorio.
- `true` → Activo.
- `false` → Inactivo.
- Valor inicial en alta: Activo.

### Imágenes

- Máximo 4 por envase.
- Solo formatos `png`, `jpg`, `jpeg` y `webp`.
- Tamaño máximo por archivo: 2 MB.
- El orden deberá estar entre 1 y 4.
- No podrá haber dos imágenes con el mismo orden para el mismo envase.
- Si se elimina la imagen de orden 1 y existen otras, deberá reasignarse el orden para mantener una vista previa válida.

### Descripción

- Opcional.
- Máximo 2000 caracteres.

### Fecha y usuario

- `fecha_registro` se genera automáticamente.
- `creado_por` se asigna con el usuario autenticado.

## Reglas de negocio de envases

- El código es único en la tabla `envases`.
- Cada envase pertenece a una única categoría.
- La capacidad siempre se expresa en kilogramos.
- Las imágenes se almacenan fuera de la base de datos; en la BD solo se guarda la referencia.
- La vista previa del listado utiliza la imagen de orden 1.
- Solo envases activos deberán seleccionarse en procesos operativos futuros.
- Preferir baja lógica mediante `estado = false`.
- Antes de guardar se eliminarán los espacios al inicio y al final de los campos de texto.
- El stock disponible se calcula desde `mov_envases` según `modulos/movimientos.md`.
- `stock_minimo` no altera el stock; solo define el umbral de alerta.

## Eliminación de envases

Se deberá preferir la baja lógica mediante `estado = false`.

La eliminación física solo estará permitida cuando:

- El envase no tenga relaciones con otros registros.
- El usuario posea permiso de eliminar.

Si se elimina físicamente un envase, también deberán eliminarse:

- sus registros en `envase_imagenes`
- los archivos de imagen asociados en el almacenamiento

## Relaciones de envases

```text
categorias (1)
    ↓
envases (N)

usuarios (1)
    ↓
envases (N)

envases (1)
    ↓
envase_imagenes (0..4)
```

```text
envases.id_categoria → categorias.id
envases.creado_por → usuarios.id
envase_imagenes.id_envase → envases.id
```

---

# Submódulo: Obleas

## Descripción de la información

Cada oblea registrará:

- Fecha de registro.
- Usuario creador.
- Categoría.
- Producto asociado.
- Código único.
- Nombre de la oblea.
- Stock mínimo opcional (unidades).
- Estado.
- Hasta 2 imágenes.
- Descripción.

## Funcionalidades

- Crear una oblea.
- Editar una oblea.
- Consultar obleas.
- Buscar por código o nombre.
- Filtrar por categoría y estado.
- Ver el detalle de una oblea.
- Cargar, reemplazar, reordenar o eliminar imágenes.
- Activar o desactivar una oblea.
- Eliminar una oblea únicamente cuando no tenga relaciones históricas.

## Pantallas

- Obleas.
- Nueva Oblea.
- Editar Oblea.
- Detalle de Oblea.

## Listado principal

| Código | Oblea | Imagen | Stock (un.) | Estado | Acciones |
|---|---|---|---|---|---|
| OB-001 | 23115 - ABQ FEED LOT CON VIRGINIAMICINA Y CON AMBIFLUD | Vista previa de la primera imagen | 150 | Activo | Ver detalles / Editar |

La columna Imagen mostrará la miniatura de la imagen con `orden = 1`. Si la oblea no tiene imágenes, deberá mostrarse un indicador de “Sin imagen”.

### Acciones del listado

- **Ver detalles:** muestra la ficha completa de la oblea, incluyendo todas las imágenes.
- **Editar:** abre el formulario de edición.

## Formulario de alta / edición

### Categoría

- Obligatorio.
- Debe listar las categorías precargadas.

### Código

- Obligatorio.
- Único.
- Se escribe o se genera en el alta.
- No deberá permitir códigos repetidos.
- Ejemplo: `OB-001`.

### Producto

- Opcional en el alta general, pero recomendado.
- Debe listar productos existentes.
- Permite que Solicitudes de Producción autocompleten la oblea al seleccionar un producto.
- Si un producto tiene una sola oblea asociada, esa oblea se cargará automáticamente en la solicitud.

### Oblea

- Obligatorio.
- Nombre o descripción de la oblea.
- Ejemplo: `23115 - ABQ FEED LOT CON VIRGINIAMICINA Y CON AMBIFLUD`.

### Stock mínimo

- Opcional.
- Valor numérico en unidades (`stock_minimo`).
- Si se completa, deberá ser mayor o igual a `0`.
- Se utiliza en el indicador de stock bajo del módulo Movimientos / Obleas.
- Si queda vacío, la oblea no participará de esa alerta.

### Estado

- Obligatorio.
- Por defecto: **Activo**.

### Imágenes

- Opcional.
- Hasta 2 imágenes por oblea.
- Formatos permitidos:
  - `png`
  - `jpg` / `jpeg`
  - `webp`
- Tamaño máximo sugerido por imagen: 2 MB.
- La primera imagen cargada o la marcada con orden 1 será la vista previa del listado.
- Deberá permitirse:
  - agregar imágenes hasta completar el máximo
  - eliminar una imagen
  - reemplazar una imagen
  - reordenar las imágenes

### Descripción

- Opcional.
- Campo de texto largo.

## Flujo del submódulo

```text
Inicio

↓

Insumos / Obleas

↓

Nueva Oblea

↓

Completar categoría, código, nombre, estado y descripción

↓

Cargar hasta 2 imágenes

↓

Validación de datos, código único e imágenes

↓

Guardar oblea e imágenes

↓

Actualización del listado
```

## Validaciones de obleas

### Categoría

- Obligatoria.
- Debe existir en `categorias`.

### Código

- Obligatorio.
- Único.
- Máximo 30 caracteres.
- No permitir espacios al inicio o al final.
- La validación de duplicados deberá ignorar mayúsculas y minúsculas.

### Oblea

- Obligatoria.
- Máximo 200 caracteres.
- No permitir espacios al inicio o al final.

### Stock mínimo

- Opcional.
- Si se informa, `>= 0`.

### Estado

- Obligatorio.
- `true` → Activo.
- `false` → Inactivo.
- Valor inicial en alta: Activo.

### Imágenes

- Máximo 2 por oblea.
- Solo formatos `png`, `jpg`, `jpeg` y `webp`.
- Tamaño máximo por archivo: 2 MB.
- El orden deberá estar entre 1 y 2.
- No podrá haber dos imágenes con el mismo orden para la misma oblea.
- Si se elimina la imagen de orden 1 y existe otra, deberá reasignarse el orden para mantener una vista previa válida.

### Descripción

- Opcional.
- Máximo 2000 caracteres.

### Fecha y usuario

- `fecha_registro` se genera automáticamente.
- `creado_por` se asigna con el usuario autenticado.

## Reglas de negocio de obleas

- El código es único en la tabla `obleas`.
- Cada oblea pertenece a una única categoría.
- Las imágenes se almacenan fuera de la base de datos; en la BD solo se guarda la referencia.
- La vista previa del listado utiliza la imagen de orden 1.
- Solo obleas activas deberán seleccionarse en procesos operativos futuros.
- Preferir baja lógica mediante `estado = false`.
- Antes de guardar se eliminarán los espacios al inicio y al final de los campos de texto.
- El stock disponible se calcula desde `mov_obleas` según `modulos/movimientos.md`.
- `stock_minimo` no altera el stock; solo define el umbral de alerta.

## Eliminación de obleas

Se deberá preferir la baja lógica mediante `estado = false`.

La eliminación física solo estará permitida cuando:

- La oblea no tenga relaciones con otros registros.
- El usuario posea permiso de eliminar.

Si se elimina físicamente una oblea, también deberán eliminarse:

- sus registros en `oblea_imagenes`
- los archivos de imagen asociados en el almacenamiento

## Relaciones de obleas

```text
categorias (1)
    ↓
obleas (N)

productos (1)
    ↓
obleas (N)

usuarios (1)
    ↓
obleas (N)

obleas (1)
    ↓
oblea_imagenes (0..2)
```

```text
obleas.id_categoria → categorias.id
obleas.id_producto → productos.id
obleas.creado_por → usuarios.id
oblea_imagenes.id_oblea → obleas.id
```

---

# Submódulo: Otros

## Descripción de la información

Cada registro de otros insumos registrará:

- Fecha de registro.
- Usuario creador.
- Categoría.
- Código único.
- Nombre del insumo.
- Perfil de calidad opcional.
- Stock mínimo opcional (unidades).
- Estado.
- Hasta 4 imágenes.
- Descripción.

## Funcionalidades

- Crear un insumo.
- Editar un insumo.
- Consultar otros insumos.
- Buscar por código o nombre.
- Filtrar por categoría y estado.
- Ver el detalle de un insumo.
- Ver el perfil de calidad del insumo.
- Cargar, reemplazar, reordenar o eliminar imágenes.
- Activar o desactivar un insumo.
- Eliminar un insumo únicamente cuando no tenga relaciones históricas.

## Pantallas

- Otros.
- Nuevo Insumo.
- Editar Insumo.
- Detalle de Insumo.
- Panel de perfil de calidad.

## Listado principal

| Código | Insumo | Imagen | Stock (un.) | Estado | Acciones |
|---|---|---|---|---|---|
| OT-001 | Bobina de film | Vista previa de la primera imagen | 45 | Activo | Ver perfil / Ver detalles / Editar |

La columna Imagen mostrará la miniatura de la imagen con `orden = 1`. Si el registro no tiene imágenes, deberá mostrarse un indicador de “Sin imagen”.

### Acciones del listado

- **Ver perfil:** muestra el panel con los criterios y límites del perfil asociado. Si el insumo no tiene perfil, deberá indicarlo.
- **Ver detalles:** muestra la ficha completa del insumo, incluyendo todas las imágenes.
- **Editar:** abre el formulario de edición.

## Formulario de alta / edición

### Categoría

- Obligatorio.
- Debe listar las categorías precargadas.

### Código

- Obligatorio.
- Único.
- Se escribe o se genera en el alta.
- No deberá permitir códigos repetidos.
- Ejemplo: `OT-001`.

### Insumo

- Obligatorio.
- Nombre del insumo.
- Ejemplo: `Bobina de film`.

### Perfil

- Obligatorio.
- Valores: Aplica / No aplica.
- Por defecto: **Aplica**.
- Si Aplica, deberá agregarse al menos un criterio con sus límites.
- Mensaje de error sugerido: `Falta agregar el perfil de calidad o seleccionarlo como No aplica.`
- Si No aplica, `id_perfil` quedará en `NULL`.

Al optar por **Aplica**, el formulario deberá mostrar un ícono o botón para agregar criterios desde el catálogo de Calidad.

### Stock mínimo

- Opcional.
- Valor numérico en unidades (`stock_minimo`).
- Si se completa, deberá ser mayor o igual a `0`.
- Se utiliza en el indicador de stock bajo del módulo Movimientos / Otros.
- Si queda vacío, el registro no participará de esa alerta.

### Estado

- Obligatorio.
- Por defecto: **Activo**.

### Imágenes

- Opcional.
- Hasta 4 imágenes por registro.
- Formatos permitidos:
  - `png`
  - `jpg` / `jpeg`
  - `webp`
- Tamaño máximo sugerido por imagen: 2 MB.
- La primera imagen cargada o la marcada con orden 1 será la vista previa del listado.
- Deberá permitirse:
  - agregar imágenes hasta completar el máximo
  - eliminar una imagen
  - reemplazar una imagen
  - reordenar las imágenes

### Descripción

- Opcional.
- Campo de texto largo.

## Panel de perfil

Cuando Perfil = Aplica, el panel mostrará:

| Criterio | Un. medida | Min | Max | Acciones |
|---|---|---|---|---|
| Proteína | % | 10 | Null | Ver / Editar / Eliminar |
| Humedad | % | Null | 3 | Ver / Editar / Eliminar |

Al agregar una línea:

- Se listan criterios activos.
- La unidad de medida se completa automáticamente desde el criterio.
- Se informan mínimo, máximo o ambos.
- Al menos uno de los dos límites es obligatorio.

## Flujo del submódulo

```text
Inicio

↓

Insumos / Otros

↓

Nuevo Insumo

↓

Completar categoría, código, nombre, estado y descripción

↓

Definir Perfil = Aplica / No aplica

↓

Si Aplica: agregar uno o más criterios con límites

↓

Cargar hasta 4 imágenes

↓

Validación de datos, código único, perfil e imágenes

↓

Guardar insumo, perfil e imágenes

↓

Actualización del listado
```

## Validaciones de otros insumos

### Categoría

- Obligatoria.
- Debe existir en `categorias`.

### Código

- Obligatorio.
- Único.
- Máximo 30 caracteres.
- No permitir espacios al inicio o al final.
- La validación de duplicados deberá ignorar mayúsculas y minúsculas.

### Insumo

- Obligatorio.
- Máximo 150 caracteres.
- No permitir espacios al inicio o al final.

### Perfil

- Obligatorio elegir Aplica o No aplica.
- Si Aplica:
  - Debe existir al menos una línea en `perfil_detalles`.
  - Cada línea debe usar un criterio activo.
  - No puede repetirse el mismo criterio dentro del perfil.
  - Debe informarse al menos `limite_min` o `limite_max`.
  - Si ambos límites existen, mínimo ≤ máximo.
- Si No aplica:
  - `id_perfil` = NULL.
  - No deben cargarse líneas de perfil.

### Stock mínimo

- Opcional.
- Si se informa, `>= 0`.

### Estado

- Obligatorio.
- `true` → Activo.
- `false` → Inactivo.
- Valor inicial en alta: Activo.

### Imágenes

- Máximo 4 por registro.
- Solo formatos `png`, `jpg`, `jpeg` y `webp`.
- Tamaño máximo por archivo: 2 MB.
- El orden deberá estar entre 1 y 4.
- No podrá haber dos imágenes con el mismo orden para el mismo registro.
- Si se elimina la imagen de orden 1 y existen otras, deberá reasignarse el orden para mantener una vista previa válida.

### Descripción

- Opcional.
- Máximo 2000 caracteres.

### Fecha y usuario

- `fecha_registro` se genera automáticamente.
- `creado_por` se asigna con el usuario autenticado.

## Reglas de negocio de otros insumos

- El código es único en la tabla `otros`.
- Cada registro pertenece a una única categoría.
- Puede tener un perfil de calidad propio o no tenerlo.
- El perfil se crea desde el mismo formulario del insumo.
- La unidad de medida de cada línea del perfil proviene del criterio.
- Las imágenes se almacenan fuera de la base de datos; en la BD solo se guarda la referencia.
- La vista previa del listado utiliza la imagen de orden 1.
- Solo registros activos deberán seleccionarse en procesos operativos futuros.
- Preferir baja lógica mediante `estado = false`.
- Antes de guardar se eliminarán los espacios al inicio y al final de los campos de texto.
- El stock disponible se calcula desde `mov_otros` según `modulos/movimientos.md`.
- `stock_minimo` no altera el stock; solo define el umbral de alerta.

## Eliminación de otros insumos

Se deberá preferir la baja lógica mediante `estado = false`.

La eliminación física solo estará permitida cuando:

- El registro no tenga relaciones con otros registros.
- El usuario posea permiso de eliminar.

Si se elimina físicamente un registro, también deberán eliminarse:

- su `perfil` y `perfil_detalles`, siempre que no formen parte de un historial de controles
- sus registros en `otro_imagenes`
- los archivos de imagen asociados en el almacenamiento

## Relaciones de otros insumos

```text
categorias (1)
    ↓
otros (N)

perfiles (1)
    ↓
otros (N)            ← id_perfil nullable

usuarios (1)
    ↓
otros (N)

otros (1)
    ↓
otro_imagenes (0..4)
```

```text
otros.id_categoria → categorias.id
otros.id_perfil → perfiles.id
otros.creado_por → usuarios.id
otro_imagenes.id_otro → otros.id
```

---

# Permisos del módulo

## Insumos

- Ver el módulo.

## Ingredientes

- Ver ingredientes.
- Crear ingredientes.
- Editar ingredientes.
- Eliminar ingredientes.

## Envases

- Ver envases.
- Crear envases.
- Editar envases.
- Eliminar envases.

## Obleas

- Ver obleas.
- Crear obleas.
- Editar obleas.
- Eliminar obleas.

## Otros

- Ver otros insumos.
- Crear otros insumos.
- Editar otros insumos.
- Eliminar otros insumos.

La gestión del perfil de calidad en Ingredientes y Otros se autoriza junto con crear o editar esos registros, porque el panel forma parte del mismo formulario.

---

# Auditoría

Los submódulos registran:

- Fecha de registro.
- Usuario creador.

Antes de implementar podrá decidirse si también se incorporan:

- Fecha de última modificación.
- Usuario que realizó la última modificación.

---

# Mejoras futuras

- Generación automática de códigos por categoría o tipo de insumo.
- Importación masiva de ingredientes, envases, obleas y otros insumos.
- Historial de cambios.
- Asociación con proveedores o empresas.
- Unidad de compra adicional al stock disponible.
- Galería ampliada o visualización a tamaño completo de imágenes.
- Copia de perfil desde otro registro.
- Detalle de movimientos que componen el stock (enlace directo desde el listado de ingredientes).

---

# Historial de cambios

## 2026-07-30

- Incorporación de `stock_minimo` en ingredientes para alertas de Movimientos.
- Vinculación del cálculo de stock de ingredientes con `modulos/movimientos.md`.
- Incorporación de `stock_minimo` en envases para alertas de Movimientos / Envases.
- Vinculación del cálculo de stock de envases con `modulos/movimientos.md`.
- Incorporación de `stock_minimo` en obleas para alertas de Movimientos / Obleas.
- Vinculación del cálculo de stock de obleas con `modulos/movimientos.md`.
- Incorporación de `stock_minimo` en otros para alertas de Movimientos / Otros.
- Vinculación del cálculo de stock de otros con `modulos/movimientos.md`.

## 2026-07-29

- Creación inicial del submódulo Ingredientes.
- Incorporación del submódulo Envases.
- Incorporación del submódulo Obleas.
- Incorporación del submódulo Otros.
- Incorporación de `id_producto` en Obleas para vincularlas con Solicitudes de Producción.
- Incorporación de columna Stock disponible en listados de insumos.
- Definición de estructuras, perfiles, imágenes, listados, formularios, validaciones, permisos y reglas de negocio.

---

# Observaciones

- La estructura de las tablas se encuentra en `01_estructura.md`.
- Las categorías iniciales se encuentran en `02_datos_iniciales.md`.
- El modelo de criterios y perfiles se encuentra en `modulos/calidad.md`.
- Los movimientos de stock de ingredientes, envases, obleas y otros se encuentran en `modulos/movimientos.md`.
- Las reglas generales del sistema se encuentran en `03_reglas_generales.md`.
