# Módulo: Calidad

## Objetivo

Administrar el catálogo de criterios de calidad y definir cómo esos criterios se utilizan dentro de los perfiles asociados a ingredientes y productos.

El módulo Calidad administra directamente:

- Criterios.

Los perfiles de calidad no se administran en una pantalla aparte. Se crean y consultan desde los formularios de Ingredientes y Productos.

---

# Tablas involucradas

- criterios
- perfiles
- perfil_detalles

> La estructura de las tablas se encuentra documentada en `01_estructura.md`.

Las tablas `ingredientes`, `otros` y `productos` consumirán `id_perfil`.

Sus formularios ya están documentados en:

- `modulos/insumos.md`
- `modulos/productos.md`

---

# Modelo de información

## Criterios

Catálogo reutilizable de parámetros de control, por ejemplo:

- Proteína
- Humedad
- Cenizas
- Micotoxinas

Cada criterio define su unidad de medida. Al seleccionar un criterio en un perfil, la unidad se muestra automáticamente.

## Perfiles

Un perfil agrupa uno o más criterios con sus límites mínimo y máximo.

Se crea al registrar o editar un ingrediente o producto cuando el campo Perfil está en **Aplica**.

## Detalle del perfil

Cada línea del perfil contiene:

- Criterio.
- Unidad de medida heredada del criterio.
- Límite mínimo opcional.
- Límite máximo opcional.
- Descripción opcional.

---

# Submódulo: Criterios

## Funcionalidades

- Crear un criterio.
- Editar un criterio.
- Activar o desactivar un criterio.
- Consultar criterios.
- Buscar por nombre o descripción.
- Ver el detalle de un criterio.

## Pantallas

- Criterios.
- Nuevo Criterio.
- Editar Criterio.
- Detalle de Criterio.

## Listado principal

| Criterio | Unidad | Estado | Descripción | Acciones |
|---|---|---|---|---|
| Proteína | % | Activo | Valor proteico | Ver detalles / Editar |
| Humedad | % | Activo | Valor de humedad | Ver detalles / Editar |
| Cenizas | % | Inactivo | Valor de cenizas | Ver detalles / Editar |
| Micotoxinas | ppm | Activo | Valor de micotoxinas | Ver detalles / Editar |

## Formulario

- Criterio.
- Unidad de medida.
- Estado.
- Descripción.

El estado deberá aparecer en **Activo** por defecto al abrir el formulario de alta.

---

# Uso del perfil en Ingredientes y Productos

Los perfiles no tendrán una página propia. Se mostrarán como un panel dentro de la ficha o formulario del ingrediente o producto.

## Ejemplo de panel para MP-108

| Criterio | Un. medida | Min | Max | Acciones |
|---|---|---|---|---|
| Proteína | % | 10 | Null | Ver / Editar / Eliminar |
| Humedad | % | Null | 3 | Ver / Editar / Eliminar |

## Ejemplo de panel para MP-125

| Criterio | Un. medida | Min | Max | Acciones |
|---|---|---|---|---|
| Proteína | % | 20 | 30 | Ver / Editar / Eliminar |
| Humedad | % | Null | 8 | Ver / Editar / Eliminar |
| Micotoxinas | ppm | Null | 400 | Ver / Editar / Eliminar |

En el listado de ingredientes o productos deberá existir la acción **Ver perfil**.

---

# Formulario de alta de Ingredientes

El formulario de Ingredientes utilizará el siguiente criterio:

## Campos

### Categoría

- Obligatorio.
- Debe listar las categorías precargadas.

### Código

- Obligatorio.
- Se escribe o se genera en el alta.
- La selección desde códigos existentes se utilizará en módulos como Movimientos, no en el alta de ingredientes.

### Ingrediente

- Obligatorio.
- Se escribe en el alta.
- La selección desde ingredientes existentes se utilizará en módulos como Movimientos.

### Perfil

- Obligatorio.
- Valores:
  - Aplica
  - No aplica
- Por defecto deberá aparecer en **Aplica**.
- Si el usuario elige **Aplica**, deberá poder agregar al menos un criterio con sus límites.
- Si elige **Aplica** y no agrega ningún criterio, no podrá guardar el registro.
- Mensaje de error sugerido: `Falta agregar el perfil de calidad o seleccionarlo como No aplica.`
- Si elige **No aplica**, `id_perfil` quedará en `NULL`.

### Estado

- Obligatorio.
- Por defecto deberá aparecer en **Activo**.

### Descripción

- Opcional.
- Campo de texto largo.

## Flujo al guardar con Perfil = Aplica

```text
Formulario de Ingrediente / Producto

↓

Validar datos del registro

↓

Validar que exista al menos un criterio en el perfil

↓

Crear perfiles

↓

Crear perfil_detalles

↓

Guardar el registro con id_perfil
```

## Flujo al guardar con Perfil = No aplica

```text
Formulario de Ingrediente / Producto

↓

Validar datos del registro

↓

Guardar el registro con id_perfil = NULL
```

---

# Validaciones

## Criterio

- Obligatorio.
- Único.
- Máximo 100 caracteres.
- No permitir espacios al inicio o al final.
- La validación de duplicados deberá ignorar mayúsculas y minúsculas.

## Unidad de medida

- Obligatoria en el criterio.
- Máximo 20 caracteres.
- Se hereda automáticamente en el detalle del perfil.
- No se edita línea por línea dentro del perfil.

## Estado del criterio

- Obligatorio.
- `true` → Activo.
- `false` → Inactivo.
- Solo criterios activos podrán agregarse a un perfil nuevo.

## Límites del perfil

- `limite_min` y `limite_max` son opcionales de forma individual.
- Al menos uno de los dos deberá informarse.
- Si ambos existen, `limite_min` deberá ser menor o igual que `limite_max`.
- Se admitirán hasta 4 decimales.
- Los valores se almacenan como número. La unidad no forma parte del valor.

## Criterios dentro del perfil

- Obligatorio seleccionar un criterio existente y activo.
- No podrá repetirse el mismo criterio dentro del mismo perfil.

## Perfil en el alta

- Si Perfil = Aplica, deberá existir al menos una línea en `perfil_detalles`.
- Si Perfil = No aplica, no deberán cargarse líneas de perfil.

---

# Permisos del módulo

## Criterios

- Ver criterios.
- Crear criterios.
- Editar criterios.
- Eliminar criterios.

La creación y edición de perfiles se autorizará mediante los permisos de Ingredientes y Productos, ya que el perfil se gestiona dentro de esos formularios.

---

# Reglas de negocio

- Cada criterio posee una única unidad de medida.
- Al elegir un criterio en el perfil, la unidad se muestra automáticamente.
- Un perfil pertenece a un ingrediente o producto concreto.
- Un mismo criterio puede usarse en muchos perfiles con distintos límites.
- Desactivar un criterio no modificará los perfiles históricos ya guardados.
- Un criterio inactivo no podrá seleccionarse en perfiles nuevos.
- Un criterio utilizado en perfiles no podrá eliminarse físicamente.
- Código e ingrediente se cargan manualmente o se generan en el alta.
- La búsqueda o selección de códigos e ingredientes existentes se utilizará en registros operativos, por ejemplo Movimientos.

---

# Eliminación

## Criterios

Preferir baja lógica mediante `estado = false`.

La eliminación física solo estará permitida cuando el criterio no esté relacionado con `perfil_detalles`.

## Perfiles

Si se elimina o se marca como No aplica un perfil asociado a un registro, deberá definirse en los módulos de Ingredientes y Productos si:

- se conserva el perfil histórico
- se desvincula
- se elimina junto con sus detalles cuando no tenga historial de controles

---

# Relaciones

```text
criterios (1)
    ↓
perfil_detalles (N)

perfiles (1)
    ↓
perfil_detalles (N)

ingredientes / productos (N)
    ↓
perfiles (1)
```

```text
perfil_detalles.id_perfil → perfiles.id
perfil_detalles.id_criterio → criterios.id
ingredientes.id_perfil → perfiles.id
productos.id_perfil → perfiles.id
```

---

# Decisiones adoptadas

- Unidad de medida: se define en el criterio.
- Perfiles: se crean desde el formulario de Ingredientes o Productos.
- Perfil por defecto en el alta: Aplica.
- Estado por defecto en el alta: Activo.
- Código e ingrediente en el alta: se escriben o generan.
- Listado de códigos e ingredientes existentes: se utilizará en Movimientos y procesos similares.

---

# Mejoras futuras

- Plantillas de perfil reutilizables.
- Copia de perfil desde otro ingrediente o producto.
- Registro de controles medidos contra el perfil.
- Alertas por valores fuera de rango.
- Historial de cambios del perfil.

---

# Historial de cambios

## 2026-07-29

- Rediseño del módulo Calidad.
- Criterios como catálogo con unidad de medida y estado.
- Reemplazo del modelo de condiciones por perfiles y perfil_detalles.
- Definición del perfil embebido en formularios de Ingredientes y Productos.

## 2026-07-28

- Creación inicial del módulo Calidad con el modelo anterior de criterios y condiciones.

---

# Observaciones

- La estructura de las tablas se encuentra en `01_estructura.md`.
- Los permisos iniciales se encuentran en `02_datos_iniciales.md`.
- Las reglas generales del sistema se encuentran en `03_reglas_generales.md`.
- El detalle completo de Ingredientes y Productos se documentará en sus módulos correspondientes.
