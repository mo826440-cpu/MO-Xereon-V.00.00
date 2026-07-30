# Módulo: Productos

## Objetivo

Administrar los productos elaborados o comercializados por la planta, sus perfiles de calidad y las versiones de receta con participación de ingredientes y consumibles.

El módulo Productos contiene los submódulos:

- Productos.
- Versiones.

---

# Tablas involucradas

- productos
- versiones
- version_detalles
- version_consumibles
- categorias
- perfiles
- perfil_detalles
- criterios
- ingredientes
- envases
- obleas
- otros
- usuarios

> La estructura de las tablas se encuentra documentada en `01_estructura.md`.
> El comportamiento del perfil de calidad se encuentra documentado en `modulos/calidad.md`.

---

# Stock disponible

El listado de productos deberá mostrar el **stock disponible** en dos unidades:

| Medida | Descripción |
|---|---|
| Unidades | Cantidad de envases/unidades de producto disponibles |
| kg | Equivalente en kilogramos |

El stock **no se carga manualmente** en el alta del producto.

Se calculará a partir de los registros de **ingresos** y **egresos** de productos, según la fórmula:

```text
stock_unidades = suma(ingresos_unidades) - suma(egresos_unidades)
stock_kg = suma(ingresos_kg) - suma(egresos_kg)
```

El detalle de ingresos y egresos se encuentra documentado en `modulos/movimientos.md` (submódulo Movimientos / Productos). El listado deberá calcular ambos stocks a partir de `mov_productos`.

El stock es un valor calculado/consultable. No reemplaza el historial de movimientos.

---

# Submódulo: Productos

## Descripción de la información

Cada producto registrará:

- Fecha de registro.
- Usuario creador.
- Categoría.
- Código único.
- Nombre del producto.
- Perfil de calidad opcional.
- Stock mínimo opcional (unidades y kg).
- Estado.
- Descripción.

## Funcionalidades

- Crear un producto.
- Editar un producto.
- Consultar productos.
- Buscar por código, nombre o categoría.
- Filtrar por categoría y estado.
- Ver el detalle de un producto.
- Ver el perfil de calidad del producto.
- Activar o desactivar un producto.
- Eliminar un producto únicamente cuando no tenga relaciones históricas.

## Pantallas

- Productos.
- Nuevo Producto.
- Editar Producto.
- Detalle de Producto.
- Panel de perfil de calidad.

## Listado principal

| Código | Producto | Stock (un.) | Stock (kg) | Estado | Acciones |
|---|---|---|---|---|---|
| 23115 | ABQ FEED LOT AD NNP CON VIRGINIAMICINA Y CON AMBIFLUD | 120 | 3.000,00 | Activo | Ver perfil / Ver detalles / Editar |

### Acciones del listado

- **Ver perfil:** muestra el panel con los criterios y límites del perfil asociado.
- **Ver detalles:** muestra la ficha completa del producto.
- **Editar:** abre el formulario de edición.

## Formulario de alta / edición

### Categoría

- Obligatorio.
- Debe listar las categorías precargadas.

### Código

- Obligatorio.
- Único.
- Se escribe o se genera en el alta.
- Ejemplo: `23115`.

### Producto

- Obligatorio.
- Se escribe en el alta.

### Perfil

- Obligatorio.
- Valores: Aplica / No aplica.
- Por defecto: **Aplica**.
- Si Aplica, deberá agregarse al menos un criterio con sus límites.
- Mensaje de error sugerido: `Falta agregar el perfil de calidad o seleccionarlo como No aplica.`
- Si No aplica, `id_perfil` quedará en `NULL`.

### Stock mínimo (unidades)

- Opcional.
- Valor numérico (`stock_minimo_unidades`).
- Si se completa, deberá ser `>= 0`.
- Se utiliza en el indicador de stock bajo de Movimientos / Productos.

### Stock mínimo (kg)

- Opcional.
- Valor numérico (`stock_minimo_kg`).
- Si se completa, deberá ser `>= 0`.
- Se utiliza en el indicador de stock bajo de Movimientos / Productos.

### Estado

- Obligatorio.
- Por defecto: **Activo**.

### Descripción

- Opcional.
- Campo de texto largo.

## Validaciones de productos

- `codigo`: obligatorio, único, máximo 30 caracteres.
- `producto`: obligatorio, máximo 200 caracteres.
- `id_categoria`: obligatorio y existente.
- Perfil Aplica: al menos una línea de detalle.
- Perfil No aplica: `id_perfil = NULL`.
- `stock_minimo_unidades`: opcional; si se informa, `>= 0`.
- `stock_minimo_kg`: opcional; si se informa, `>= 0`.
- `estado`: Activo / Inactivo.

## Reglas de negocio de productos

- El código es único en la tabla `productos`.
- Cada producto pertenece a una única categoría.
- Puede tener un perfil de calidad propio o no tenerlo.
- Solo productos activos deberán seleccionarse en procesos operativos futuros.
- Preferir baja lógica mediante `estado = false`.
- Un producto con versiones asociadas no podrá eliminarse físicamente.
- El stock disponible se calcula desde `mov_productos` según `modulos/movimientos.md`.
- `stock_minimo_unidades` y `stock_minimo_kg` no alteran el stock; solo definen umbrales de alerta.

## Relaciones de productos

```text
productos.id_categoria → categorias.id
productos.id_perfil → perfiles.id
productos.creado_por → usuarios.id
```

---

# Submódulo: Versiones

## Descripción de la información

Cada versión registrará:

- Fecha de registro.
- Usuario creador.
- Producto asociado.
- Número o código de versión.
- Estado.
- Descripción.
- Detalle de ingredientes con tipo, puesto y participación.
- Detalle de consumibles con base de cálculo y cantidad requerida.

## Funcionalidades

- Crear una versión de un producto.
- Editar una versión.
- Consultar versiones.
- Buscar por código de producto, nombre o versión.
- Filtrar por producto y estado.
- Ver el detalle de una versión.
- Ver las participaciones de la versión.
- Agregar, editar y eliminar líneas de detalle.
- Ver y administrar los consumibles de la versión.
- Activar o desactivar una versión.
- Eliminar una versión únicamente cuando no tenga relaciones históricas.

## Pantallas

- Versiones.
- Nueva Versión.
- Editar Versión.
- Detalle de Versión.
- Panel de participaciones / receta.

## Listado principal

| Código | Producto | Versión | Estado | Acciones |
|---|---|---|---|---|
| 23115 | ABQ FEED LOT AD NNP CON VIRGINIAMICINA Y CON AMBIFLUD | 01 | Activo | Ver participaciones / Ver consumibles / Ver detalles / Editar |

El listado combina datos de `productos` y `versiones`.

### Acciones del listado

- **Ver participaciones:** muestra el panel con los ingredientes, tipo, puesto y porcentaje de cada línea.
- **Ver consumibles:** muestra los envases, obleas y otros insumos requeridos por la versión.
- **Ver detalles:** muestra la ficha completa de la versión.
- **Editar:** abre el formulario de edición.

## Formulario de alta / edición de versión

### Producto

- Obligatorio.
- Debe listar productos existentes, preferentemente activos.
- Puede mostrarse código y nombre juntos.

### Versión

- Obligatorio.
- No puede repetirse para el mismo producto.
- Ejemplo: `01`.

### Estado

- Obligatorio.
- Por defecto: **Activo**.

### Descripción

- Opcional.
- Campo de texto largo.

### Detalle de receta / participaciones

El formulario deberá permitir cargar una o más líneas con:

- Ingrediente.
- Tipo: Macronutriente o Micronutriente.
- Puesto.
- Participación (%).
- Descripción opcional.

Cada línea podrá editarse o eliminarse.

## Reglas del campo Puesto

- Macronutriente: puestos del 01 al 04.
- Micronutriente: puestos del 01 al 05.
- El formulario deberá mostrar un ícono para agrandar o achicar el rango visible de puestos, sin superar los máximos permitidos por tipo.
- No podrá repetirse el mismo puesto para el mismo tipo dentro de una misma versión.

## Reglas del campo Participación

- Valor numérico en porcentaje.
- Hasta 2 decimales.
- No permitir valores menores a `0`.
- No permitir valores mayores a `100`.
- La suma de todas las participaciones de una misma versión deberá ser exactamente `100.00`.
- Si la suma es menor o mayor a 100, el sistema no deberá permitir registrar o guardar la versión.
- Mensaje de error sugerido: `La suma de las participaciones debe ser igual a 100%.`

## Ejemplo de panel de participaciones

| Ingrediente | Tipo | Puesto | Participación | Acciones |
|---|---|---|---|---|
| Carbonato | Macronutriente | 01 | 40.00 | Editar / Eliminar |
| Suero de queso | Macronutriente | 02 | 35.50 | Editar / Eliminar |
| Premix A | Micronutriente | 01 | 24.50 | Editar / Eliminar |

Total visible sugerido: `100.00 %`

### Detalle de consumibles

La misma versión deberá permitir asociar consumibles desde los maestros de Envases, Obleas y Otros.

Cada línea registrará:

- Tipo de consumible.
- Consumible.
- Base de cálculo.
- Cantidad base.
- Descripción opcional.

Bases de cálculo:

| Base | Cálculo durante la ejecución |
|---|---|
| Unidad | `cantidad_base * unidades_elaboradas` |
| Pallet | `cantidad_base * pallets_requeridos` |
| Batch | `cantidad_base * cantidad_batches` |
| Fijo | `cantidad_base` |

Para la base `pallet`, una fracción de pallet requiere sus consumibles y se utilizará `CEIL(pallets_elaborados)` en el cálculo. No podrá repetirse el mismo consumible dentro de una versión.

Ejemplo:

| Tipo | Consumible | Base | Cantidad base | Acciones |
|---|---|---|---:|---|
| Oblea | Oblea 23115 | Unidad | 1 | Editar / Eliminar |
| Otro | Cartón base de pallet | Pallet | 1 | Editar / Eliminar |
| Otro | Cartón tapa de pallet | Pallet | 1 | Editar / Eliminar |

## Flujo del submódulo

```text
Inicio

↓

Productos / Versiones

↓

Nueva Versión

↓

Seleccionar producto y definir versión

↓

Agregar ingredientes con tipo, puesto y participación

↓

Agregar consumibles y definir sus bases de cálculo

↓

Validar puestos, duplicados, suma = 100% y consumibles

↓

Guardar versión y detalles

↓

Actualización del listado
```

## Validaciones de versiones

### Producto

- Obligatorio.
- Debe existir en `productos`.

### Versión

- Obligatoria.
- Máximo 10 caracteres.
- Única por `id_producto`.

### Estado

- Obligatorio.
- `true` → Activo.
- `false` → Inactivo.
- Valor inicial en alta: Activo.

### Ingrediente

- Obligatorio en cada línea.
- Debe existir en `ingredientes`.
- Preferentemente activo.
- No podrá repetirse el mismo ingrediente dentro de la misma versión.

### Tipo

- Obligatorio.
- Solo admite:
  - Macronutriente
  - Micronutriente
- En base de datos se almacenará como `macronutriente` o `micronutriente`.

### Puesto

- Obligatorio.
- Macronutriente: 1 a 4.
- Micronutriente: 1 a 5.
- Único por tipo dentro de la misma versión.

### Participación

- Obligatoria.
- Entre 0 y 100 inclusive.
- Hasta 2 decimales.
- La suma total por versión debe ser exactamente 100.00.

### Descripción

- Opcional.
- Máximo 2000 caracteres.

### Consumibles

- Cada línea deberá apuntar a un único maestro: Envase, Oblea u Otro.
- `cantidad_base` deberá ser mayor que `0`.
- `base_calculo` solo admitirá `unidad`, `pallet`, `batch` o `fijo`.
- No podrá repetirse el mismo consumible para la misma versión.
- Solo podrán agregarse consumibles activos.

### Fecha y usuario

- `fecha_registro` se genera automáticamente.
- `creado_por` se asigna con el usuario autenticado.

## Reglas de negocio de versiones

- Una versión pertenece a un único producto.
- Un producto puede tener muchas versiones.
- No puede existir la misma versión dos veces para el mismo producto.
- Los detalles de receta se almacenan en `version_detalles` mediante `id_version`.
- Los consumibles se almacenan en `version_consumibles` mediante `id_version`.
- No se utiliza un campo `id_detalleVersion` en la cabecera `versiones`, porque la relación es de uno a muchos.
- La suma de participaciones de cada versión debe ser exactamente 100%.
- Preferir baja lógica de versiones mediante `estado = false`.
- Una versión utilizada en producción u otros procesos históricos no podrá eliminarse físicamente.
- Al eliminar físicamente una versión deberán eliminarse también sus `version_detalles` y `version_consumibles`.
- Una versión utilizada en una solicitud o ejecución quedará congelada; para modificar su receta o sus consumibles deberá crearse una nueva versión.

## Eliminación de versiones

Se deberá preferir la baja lógica mediante `estado = false`.

La eliminación física solo estará permitida cuando:

- La versión no tenga relaciones históricas.
- El usuario posea permiso de eliminar.

Las líneas de `version_detalles` sí podrán eliminarse individualmente mientras se edita la receta, siempre que al confirmar el guardado la suma de participaciones quede en 100%.

## Relaciones de versiones

```text
productos (1)
    ↓
versiones (N)
    ↓
version_detalles (N)

ingredientes (1)
    ↓
version_detalles (N)

versiones (1)
    ↓
version_consumibles (N)
```

```text
versiones.id_producto → productos.id
version_detalles.id_version → versiones.id
version_detalles.id_ingrediente → ingredientes.id
version_consumibles.id_version → versiones.id
version_consumibles.id_envase → envases.id
version_consumibles.id_oblea → obleas.id
version_consumibles.id_otro → otros.id
```

---

# Permisos del módulo

## Productos

- Ver productos.
- Crear productos.
- Editar productos.
- Eliminar productos.

## Versiones

- Ver versiones.
- Crear versiones.
- Editar versiones.
- Eliminar versiones.

La gestión de participaciones y consumibles se autoriza junto con crear o editar versiones, porque ambos detalles forman parte del mismo formulario.

---

# Auditoría

Ambos submódulos registran:

- Fecha de registro.
- Usuario creador.

Antes de implementar podrá decidirse si también se incorporan:

- Fecha de última modificación.
- Usuario que realizó la última modificación.

---

# Mejoras futuras

- Copia de una versión existente como base de una nueva.
- Comparación entre versiones.
- Validación automática de puestos faltantes.
- Historial de cambios de receta.
- Detalle de movimientos que componen el stock.

---

# Historial de cambios

## 2026-07-30

- Incorporación de consumibles por versión mediante `version_consumibles`.
- Definición de bases de cálculo por unidad, pallet, batch o valor fijo.
- Bloqueo de cambios de receta y consumibles cuando la versión ya posee uso histórico.
- Incorporación de `stock_minimo_unidades` y `stock_minimo_kg`.
- Vinculación del cálculo de stock con `modulos/movimientos.md` (Movimientos / Productos).

## 2026-07-29

- Creación inicial del módulo Productos.
- Incorporación del submódulo Versiones.
- Definición de estructuras, participaciones, validación de suma 100%, puestos por tipo, permisos y reglas de negocio.
- Incorporación de columnas Stock (unidades) y Stock (kg) en el listado de productos.

---

# Observaciones

- La estructura de las tablas se encuentra en `01_estructura.md`.
- Las categorías iniciales se encuentran en `02_datos_iniciales.md`.
- El modelo de criterios y perfiles se encuentra en `modulos/calidad.md`.
- Los ingredientes disponibles se encuentran documentados en `modulos/insumos.md`.
- Los movimientos de stock de productos se encuentran en `modulos/movimientos.md`.
- Las reglas generales del sistema se encuentran en `03_reglas_generales.md`.
