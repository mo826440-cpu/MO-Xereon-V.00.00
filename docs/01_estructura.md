# Base de Datos

- **Motor:** PostgreSQL
- **Nombre:** Xereon_Produccion

---

# Convenciones

- Todas las tablas se nombran en plural.
- Todas las claves primarias se llaman `id`.
- Todas las claves foráneas comienzan con `id_`.
- Todos los nombres de tablas y columnas se escriben en minúsculas y separados por `_`.
- No se utilizan espacios, acentos ni caracteres especiales en nombres de tablas o columnas.
- Todas las contraseñas se almacenan únicamente como `password_hash`.
- Toda tabla debe tener una clave primaria (`id`).
- Las relaciones entre tablas se realizan mediante claves foráneas (`FK`).

---

# Tabla: usuarios

```text
usuarios {

    id: INTEGER (PK)
    fecha_creacion: TIMESTAMP NOT NULL

    nombre: VARCHAR(50) NOT NULL
    apellido: VARCHAR(50) NOT NULL

    usuario: VARCHAR(30) UNIQUE NOT NULL
    password_hash: TEXT NOT NULL

    id_rol: INTEGER (FK roles.id) NOT NULL

    estado: BOOLEAN NOT NULL

    observacion: TEXT

    ultimo_acceso: TIMESTAMP

    creado_por: INTEGER (FK usuarios.id)

    actualizado_por: INTEGER (FK usuarios.id)

}
```

---

# Tabla: roles

```text
roles {

    id: INTEGER (PK)

    nombre: VARCHAR(30) UNIQUE NOT NULL

    descripcion: TEXT

}
```

---

# Tabla: pantallas

```text
pantallas {

    id: INTEGER (PK)

    nombre: VARCHAR(50) UNIQUE NOT NULL

    descripcion: TEXT

    orden: INTEGER

}
```

---

# Tabla: permisos

```text
permisos {

    id: INTEGER (PK)

    id_pantalla: INTEGER (FK pantallas.id)

    accion: VARCHAR(30) NOT NULL

}
```

### Acciones permitidas

- ver
- crear
- editar
- eliminar
- exportar
- imprimir
- aprobar
- cerrar
- administrar

---

# Tabla: rol_permisos

```text
rol_permisos {

    id: INTEGER (PK)

    id_rol: INTEGER (FK roles.id)

    id_permiso: INTEGER (FK permisos.id)

}
```

---

# Relaciones

```text
usuarios.id_rol
    ↓
roles.id

permisos.id_pantalla
    ↓
pantallas.id

rol_permisos.id_rol
    ↓
roles.id

rol_permisos.id_permiso
    ↓
permisos.id
```

---

# Índices

```text
usuarios.usuario (UNIQUE)

roles.nombre (UNIQUE)

pantallas.nombre (UNIQUE)

rol_permisos (id_rol, id_permiso)
```

---

# Tabla: empresas

Registra los comercios o empresas vinculados con la operación de la planta.

```text
empresas {

    id: INTEGER (PK)

    fecha: TIMESTAMP NOT NULL

    comercio: VARCHAR(100) NOT NULL

    responsable: VARCHAR(100)

    contacto: VARCHAR(100)

    direccion: VARCHAR(200)

    latitud: NUMERIC(9,6)

    longitud: NUMERIC(10,6)

    observacion: TEXT

}
```

## Descripción de campos

- `id`: identificador único generado automáticamente.
- `fecha`: fecha y hora en que se registra la empresa.
- `comercio`: nombre comercial de la empresa.
- `responsable`: persona de referencia de la empresa.
- `contacto`: teléfono, correo electrónico u otro medio de contacto.
- `direccion`: domicilio o ubicación descriptiva del comercio.
- `latitud`: coordenada geográfica, con valores entre -90 y 90.
- `longitud`: coordenada geográfica, con valores entre -180 y 180.
- `observacion`: información adicional relevante.

## Restricciones e índices

```text
CHECK empresas.latitud BETWEEN -90 AND 90
CHECK empresas.longitud BETWEEN -180 AND 180

INDEX empresas.comercio
INDEX empresas.responsable
```

Las coordenadas son opcionales, pero deberán informarse ambas cuando se registre una ubicación geográfica.

---

# Tabla: categorias

Registra las categorías utilizadas para clasificar productos, insumos e ingredientes.

```text
categorias {

    id: INTEGER (PK)

    categoria: VARCHAR(100) UNIQUE NOT NULL

    descripcion: TEXT

}
```

## Descripción de campos

- `id`: identificador único generado automáticamente.
- `categoria`: nombre único de la categoría.
- `descripcion`: detalle opcional sobre el propósito o alcance de la categoría.

## Restricciones e índices

```text
categorias.categoria (UNIQUE)
```

La comparación para detectar categorías duplicadas deberá ignorar diferencias entre mayúsculas, minúsculas y espacios al inicio o al final.

---

# Tabla: criterios

Catálogo de criterios de calidad administrado desde el módulo Calidad.

```text
criterios {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id)

    criterio: VARCHAR(100) UNIQUE NOT NULL

    unidad_medida: VARCHAR(20) NOT NULL

    estado: BOOLEAN NOT NULL DEFAULT true

    descripcion: TEXT

}
```

## Descripción de campos

- `id`: identificador único generado automáticamente.
- `fecha_registro`: fecha y hora de alta del criterio.
- `creado_por`: usuario que registró el criterio.
- `criterio`: nombre único del criterio, por ejemplo Proteína, Humedad o Micotoxinas.
- `unidad_medida`: unidad asociada al criterio, por ejemplo `%` o `ppm`. Se muestra automáticamente al seleccionar el criterio en un perfil.
- `estado`: indica si el criterio está activo (`true`) o inactivo (`false`).
- `descripcion`: detalle opcional sobre qué se evalúa mediante el criterio.

## Restricciones e índices

```text
criterios.criterio (UNIQUE)
INDEX criterios.estado
```

La comparación para detectar criterios duplicados deberá ignorar diferencias entre mayúsculas, minúsculas y espacios al inicio o al final.

Solo los criterios activos podrán seleccionarse al armar un perfil nuevo.

---

# Tabla: perfiles

Cabecera del perfil de calidad asociado a un ingrediente o producto.

```text
perfiles {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id)

    codigo: VARCHAR(30) UNIQUE

    descripcion: TEXT

}
```

## Descripción de campos

- `id`: identificador único del perfil.
- `fecha_registro`: fecha y hora de creación del perfil.
- `creado_por`: usuario que creó el perfil.
- `codigo`: código opcional del perfil.
- `descripcion`: detalle opcional del perfil.

El perfil se crea desde el formulario de Ingredientes o Productos cuando el campo Perfil está en **Aplica**. No posee una pantalla de administración independiente.

---

# Tabla: perfil_detalles

Líneas del perfil: cada criterio seleccionado con sus límites mínimo y máximo.

```text
perfil_detalles {

    id: INTEGER (PK)

    id_perfil: INTEGER (FK perfiles.id) NOT NULL

    id_criterio: INTEGER (FK criterios.id) NOT NULL

    limite_min: NUMERIC(12,4)

    limite_max: NUMERIC(12,4)

    descripcion: TEXT

}
```

## Descripción de campos

- `id`: identificador único de la línea del perfil.
- `id_perfil`: perfil al que pertenece la línea; puede repetirse.
- `id_criterio`: criterio seleccionado desde el catálogo.
- `limite_min`: valor mínimo admitido. Puede ser nulo cuando no aplica.
- `limite_max`: valor máximo admitido. Puede ser nulo cuando no aplica.
- `descripcion`: detalle opcional de la línea.

La unidad de medida no se guarda en esta tabla. Se obtiene del criterio seleccionado.

## Restricciones e índices

```text
CHECK perfil_detalles.limite_min IS NULL
   OR perfil_detalles.limite_max IS NULL
   OR perfil_detalles.limite_min <= perfil_detalles.limite_max

UNIQUE (id_perfil, id_criterio)

INDEX perfil_detalles.id_perfil
INDEX perfil_detalles.id_criterio
```

Al menos uno de los dos límites deberá informarse. No podrá repetirse el mismo criterio dentro de un mismo perfil.

## Relaciones

```text
perfil_detalles.id_perfil
    ↓
perfiles.id

perfil_detalles.id_criterio
    ↓
criterios.id

ingredientes.id_perfil
    ↓
perfiles.id

productos.id_perfil
    ↓
perfiles.id

otros.id_perfil
    ↓
perfiles.id
```

La tabla `ingredientes` está documentada más abajo. Las tablas `productos` y `otros` también utilizan perfiles de calidad y están documentadas en este mismo archivo y en sus módulos.

Un ingrediente o producto podrá:

- Tener `id_perfil` asignado cuando Perfil = Aplica.
- Tener `id_perfil = NULL` cuando Perfil = No aplica.

---

# Tabla: ingredientes

Registra los ingredientes administrados desde el módulo Insumos.

```text
ingredientes {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id)

    id_categoria: INTEGER (FK categorias.id) NOT NULL

    codigo: VARCHAR(30) UNIQUE NOT NULL

    ingrediente: VARCHAR(100) NOT NULL

    id_perfil: INTEGER (FK perfiles.id)

    stock_minimo: NUMERIC(12,3)

    estado: BOOLEAN NOT NULL DEFAULT true

    descripcion: TEXT

}
```

## Descripción de campos

- `id`: identificador único generado automáticamente.
- `fecha_registro`: fecha y hora de alta del ingrediente.
- `creado_por`: usuario que registró el ingrediente.
- `id_categoria`: categoría del ingrediente, por ejemplo Premezcla o Sustituto Lácteo.
- `codigo`: código único del ingrediente, por ejemplo `MP-108`.
- `ingrediente`: nombre del ingrediente.
- `id_perfil`: perfil de calidad asociado. Será nulo cuando Perfil = No aplica.
- `stock_minimo`: stock mínimo de alerta en kilogramos. Será nulo cuando no se defina umbral. Se utiliza en el indicador de stock bajo del módulo Movimientos.
- `estado`: indica si el ingrediente está activo (`true`) o inactivo (`false`).
- `descripcion`: detalle opcional del ingrediente.

## Restricciones e índices

```text
ingredientes.codigo (UNIQUE)
CHECK ingredientes.stock_minimo IS NULL OR ingredientes.stock_minimo >= 0

INDEX ingredientes.id_categoria
INDEX ingredientes.ingrediente
INDEX ingredientes.id_perfil
INDEX ingredientes.estado
```

La comparación para detectar códigos duplicados deberá ignorar diferencias entre mayúsculas, minúsculas y espacios al inicio o al final.

## Relaciones

```text
ingredientes.id_categoria
    ↓
categorias.id

ingredientes.creado_por
    ↓
usuarios.id

ingredientes.id_perfil
    ↓
perfiles.id
```

Un ingrediente podrá:

- Tener `id_perfil` asignado cuando Perfil = Aplica.
- Tener `id_perfil = NULL` cuando Perfil = No aplica.

---

# Tabla: productos

Registra los productos administrados desde el módulo Productos.

```text
productos {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id)

    id_categoria: INTEGER (FK categorias.id) NOT NULL

    codigo: VARCHAR(30) UNIQUE NOT NULL

    producto: VARCHAR(200) NOT NULL

    id_perfil: INTEGER (FK perfiles.id)

    stock_minimo_unidades: NUMERIC(12,3)

    stock_minimo_kg: NUMERIC(12,3)

    estado: BOOLEAN NOT NULL DEFAULT true

    descripcion: TEXT

}
```

## Descripción de campos

- `id`: identificador único generado automáticamente.
- `fecha_registro`: fecha y hora de alta del producto.
- `creado_por`: usuario que registró el producto.
- `id_categoria`: categoría del producto, por ejemplo Premezcla o Sustituto Lácteo.
- `codigo`: código único del producto, por ejemplo `23115`.
- `producto`: nombre del producto.
- `id_perfil`: perfil de calidad asociado. Será nulo cuando Perfil = No aplica.
- `stock_minimo_unidades`: umbral de alerta en unidades. Nulo si no se define.
- `stock_minimo_kg`: umbral de alerta en kilogramos. Nulo si no se define.
- `estado`: indica si el producto está activo (`true`) o inactivo (`false`).
- `descripcion`: detalle opcional del producto.

## Restricciones e índices

```text
productos.codigo (UNIQUE)
CHECK productos.stock_minimo_unidades IS NULL OR productos.stock_minimo_unidades >= 0
CHECK productos.stock_minimo_kg IS NULL OR productos.stock_minimo_kg >= 0

INDEX productos.id_categoria
INDEX productos.producto
INDEX productos.id_perfil
INDEX productos.estado
```

La comparación para detectar códigos duplicados deberá ignorar diferencias entre mayúsculas, minúsculas y espacios al inicio o al final.

## Relaciones

```text
productos.id_categoria
    ↓
categorias.id

productos.creado_por
    ↓
usuarios.id

productos.id_perfil
    ↓
perfiles.id
```

Un producto podrá:

- Tener `id_perfil` asignado cuando Perfil = Aplica.
- Tener `id_perfil = NULL` cuando Perfil = No aplica.

---

# Tabla: versiones

Registra las versiones de receta asociadas a cada producto.

```text
versiones {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id)

    id_producto: INTEGER (FK productos.id) NOT NULL

    version: VARCHAR(10) NOT NULL

    estado: BOOLEAN NOT NULL DEFAULT true

    descripcion: TEXT

}
```

## Descripción de campos

- `id`: identificador único de la versión.
- `fecha_registro`: fecha y hora de alta de la versión.
- `creado_por`: usuario que registró la versión.
- `id_producto`: producto al que pertenece la versión.
- `version`: número o código de versión dentro del producto, por ejemplo `01`. No puede repetirse para el mismo producto.
- `estado`: indica si la versión está activa (`true`) o inactiva (`false`).
- `descripcion`: detalle opcional de la versión.

Los ingredientes y participaciones de la receta no se guardan en esta tabla. Se registran en `version_detalles`.

## Restricciones e índices

```text
UNIQUE (id_producto, version)

INDEX versiones.id_producto
INDEX versiones.estado
```

La comparación de `version` deberá ignorar diferencias entre mayúsculas, minúsculas y espacios al inicio o al final.

## Relaciones

```text
versiones.id_producto
    ↓
productos.id

versiones.creado_por
    ↓
usuarios.id
```

---

# Tabla: version_detalles

Registra los ingredientes y participaciones de cada versión de producto.

```text
version_detalles {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id)

    id_version: INTEGER (FK versiones.id) NOT NULL

    id_ingrediente: INTEGER (FK ingredientes.id) NOT NULL

    tipo: VARCHAR(20) NOT NULL

    puesto: INTEGER NOT NULL

    participacion: NUMERIC(5,2) NOT NULL

    descripcion: TEXT

}
```

## Descripción de campos

- `id`: identificador único de la línea de detalle.
- `fecha_registro`: fecha y hora de alta de la línea.
- `creado_por`: usuario que registró la línea.
- `id_version`: versión a la que pertenece el detalle.
- `id_ingrediente`: ingrediente utilizado en la receta.
- `tipo`: clasificación del ingrediente en la versión. Valores permitidos:
  - `macronutriente`
  - `micronutriente`
- `puesto`: posición del ingrediente dentro de su tipo.
  - Macronutriente: de 1 a 4.
  - Micronutriente: de 1 a 5.
- `participacion`: porcentaje de participación del ingrediente en la versión. Hasta 2 decimales.
- `descripcion`: detalle opcional de la línea.

## Restricciones e índices

```text
CHECK version_detalles.tipo IN ('macronutriente', 'micronutriente')

CHECK version_detalles.participacion >= 0
 AND version_detalles.participacion <= 100

CHECK (
    (tipo = 'macronutriente' AND puesto BETWEEN 1 AND 4)
 OR (tipo = 'micronutriente' AND puesto BETWEEN 1 AND 5)
)

UNIQUE (id_version, id_ingrediente)
UNIQUE (id_version, tipo, puesto)

INDEX version_detalles.id_version
INDEX version_detalles.id_ingrediente
```

La suma de `participacion` de todas las líneas de una misma `id_version` deberá ser exactamente `100.00`. Esta validación se realizará al guardar o confirmar la versión.

Los detalles podrán crearse, editarse y eliminarse.

## Relaciones

```text
version_detalles.id_version
    ↓
versiones.id

version_detalles.id_ingrediente
    ↓
ingredientes.id

version_detalles.creado_por
    ↓
usuarios.id
```

```text
productos (1)
    ↓
versiones (N)
    ↓
version_detalles (N)
```

---

# Tabla: version_consumibles

Registra los consumibles asociados a cada versión y la forma de calcular su necesidad durante una ejecución.

```text
version_consumibles {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id)

    id_version: INTEGER (FK versiones.id) NOT NULL

    tipo_consumible: VARCHAR(20) NOT NULL

    id_envase: INTEGER (FK envases.id)

    id_oblea: INTEGER (FK obleas.id)

    id_otro: INTEGER (FK otros.id)

    base_calculo: VARCHAR(20) NOT NULL

    cantidad_base: NUMERIC(14,4) NOT NULL

    descripcion: TEXT

}
```

## Descripción de campos

- `id_version`: versión de producto a la que pertenece el consumible.
- `tipo_consumible`: identifica si el registro corresponde a un `envase`, una `oblea` u `otro`.
- `id_envase`, `id_oblea`, `id_otro`: referencia al maestro correspondiente. Solo uno puede tener valor.
- `base_calculo`: determina si la cantidad se calcula por `unidad`, `pallet`, `batch` o como valor `fijo`.
- `cantidad_base`: unidades de consumible requeridas por cada elemento de la base de cálculo.
- `descripcion`: observación opcional.

## Restricciones e índices

```text
CHECK version_consumibles.tipo_consumible IN ('envase', 'oblea', 'otro')
CHECK version_consumibles.base_calculo IN ('unidad', 'pallet', 'batch', 'fijo')
CHECK version_consumibles.cantidad_base > 0

CHECK (
    (tipo_consumible = 'envase' AND id_envase IS NOT NULL AND id_oblea IS NULL AND id_otro IS NULL)
 OR (tipo_consumible = 'oblea' AND id_envase IS NULL AND id_oblea IS NOT NULL AND id_otro IS NULL)
 OR (tipo_consumible = 'otro' AND id_envase IS NULL AND id_oblea IS NULL AND id_otro IS NOT NULL)
)

UNIQUE INDEX (id_version, id_envase) WHERE tipo_consumible = 'envase'
UNIQUE INDEX (id_version, id_oblea) WHERE tipo_consumible = 'oblea'
UNIQUE INDEX (id_version, id_otro) WHERE tipo_consumible = 'otro'

INDEX version_consumibles.id_version
INDEX version_consumibles.id_envase
INDEX version_consumibles.id_oblea
INDEX version_consumibles.id_otro
```

## Relaciones

```text
version_consumibles.id_version → versiones.id
version_consumibles.id_envase → envases.id
version_consumibles.id_oblea → obleas.id
version_consumibles.id_otro → otros.id
version_consumibles.creado_por → usuarios.id
```

Las líneas de `version_consumibles` forman parte de la definición de la versión. Una versión utilizada en producción no podrá modificar ni eliminar físicamente estas líneas; deberá generarse una nueva versión.

---

# Tabla: envases

Registra los envases administrados desde el módulo Insumos.

```text
envases {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id)

    id_categoria: INTEGER (FK categorias.id) NOT NULL

    codigo: VARCHAR(30) UNIQUE NOT NULL

    envase: VARCHAR(150) NOT NULL

    capacidad_kg: NUMERIC(12,4) NOT NULL

    stock_minimo: NUMERIC(12,3)

    estado: BOOLEAN NOT NULL DEFAULT true

    descripcion: TEXT

}
```

## Descripción de campos

- `id`: identificador único generado automáticamente.
- `fecha_registro`: fecha y hora de alta del envase.
- `creado_por`: usuario que registró el envase.
- `id_categoria`: categoría asociada al envase.
- `codigo`: código único del envase, por ejemplo `ENV-001`.
- `envase`: nombre o descripción corta del envase.
- `capacidad_kg`: capacidad del envase expresada en kilogramos.
- `stock_minimo`: stock mínimo de alerta en unidades. Será nulo cuando no se defina umbral. Se utiliza en el indicador de stock bajo del módulo Movimientos / Envases.
- `estado`: indica si el envase está activo (`true`) o inactivo (`false`).
- `descripcion`: detalle opcional del envase.

Las imágenes no se almacenan dentro de esta tabla. Se registran en `envase_imagenes`.

## Restricciones e índices

```text
envases.codigo (UNIQUE)
CHECK envases.capacidad_kg > 0
CHECK envases.stock_minimo IS NULL OR envases.stock_minimo >= 0

INDEX envases.id_categoria
INDEX envases.envase
INDEX envases.estado
```

La comparación para detectar códigos duplicados deberá ignorar diferencias entre mayúsculas, minúsculas y espacios al inicio o al final.

## Relaciones

```text
envases.id_categoria
    ↓
categorias.id

envases.creado_por
    ↓
usuarios.id
```

---

# Tabla: envase_imagenes

Almacena hasta 4 imágenes asociadas a cada envase.

```text
envase_imagenes {

    id: INTEGER (PK)

    id_envase: INTEGER (FK envases.id) NOT NULL

    ruta_archivo: VARCHAR(255) NOT NULL

    nombre_original: VARCHAR(150)

    formato: VARCHAR(10) NOT NULL

    orden: INTEGER NOT NULL

    fecha_registro: TIMESTAMP NOT NULL

}
```

## Descripción de campos

- `id`: identificador único de la imagen.
- `id_envase`: envase al que pertenece la imagen.
- `ruta_archivo`: ubicación relativa del archivo almacenado por el sistema.
- `nombre_original`: nombre del archivo cargado por el usuario.
- `formato`: extensión normalizada del archivo, por ejemplo `png`, `jpg` o `webp`.
- `orden`: posición de la imagen dentro del envase, de 1 a 4. La imagen con `orden = 1` se usa como vista previa en el listado.
- `fecha_registro`: fecha y hora de carga de la imagen.

## Restricciones e índices

```text
CHECK envase_imagenes.orden BETWEEN 1 AND 4
UNIQUE (id_envase, orden)

INDEX envase_imagenes.id_envase
```

Un envase podrá tener como máximo 4 imágenes.

## Relación

```text
envase_imagenes.id_envase
    ↓
envases.id
```

Al eliminar físicamente un envase deberán eliminarse también sus imágenes asociadas y los archivos correspondientes del almacenamiento.

---

# Tabla: obleas

Registra las obleas administradas desde el módulo Insumos.

```text
obleas {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id)

    id_categoria: INTEGER (FK categorias.id) NOT NULL

    id_producto: INTEGER (FK productos.id)

    codigo: VARCHAR(30) UNIQUE NOT NULL

    oblea: VARCHAR(200) NOT NULL

    stock_minimo: NUMERIC(12,3)

    estado: BOOLEAN NOT NULL DEFAULT true

    descripcion: TEXT

}
```

## Descripción de campos

- `id`: identificador único generado automáticamente.
- `fecha_registro`: fecha y hora de alta de la oblea.
- `creado_por`: usuario que registró la oblea.
- `id_categoria`: categoría asociada a la oblea.
- `id_producto`: producto al que está asociada la oblea. Permite autocompletar la oblea al registrar una solicitud de producción.
- `codigo`: código único de la oblea, por ejemplo `OB-001`.
- `oblea`: nombre o descripción de la oblea.
- `stock_minimo`: stock mínimo de alerta en unidades. Será nulo cuando no se defina umbral. Se utiliza en el indicador de stock bajo del módulo Movimientos / Obleas.
- `estado`: indica si la oblea está activa (`true`) o inactiva (`false`).
- `descripcion`: detalle opcional de la oblea.

Las imágenes no se almacenan dentro de esta tabla. Se registran en `oblea_imagenes`.

## Restricciones e índices

```text
obleas.codigo (UNIQUE)
CHECK obleas.stock_minimo IS NULL OR obleas.stock_minimo >= 0

INDEX obleas.id_categoria
INDEX obleas.id_producto
INDEX obleas.oblea
INDEX obleas.estado
```

La comparación para detectar códigos duplicados deberá ignorar diferencias entre mayúsculas, minúsculas y espacios al inicio o al final.

## Relaciones

```text
obleas.id_categoria
    ↓
categorias.id

obleas.id_producto
    ↓
productos.id

obleas.creado_por
    ↓
usuarios.id
```

Si al seleccionar un producto existe una única oblea asociada, deberá cargarse automáticamente. Si existen varias, deberán listarse solo las obleas vinculadas a ese producto.

---

# Tabla: oblea_imagenes

Almacena hasta 2 imágenes asociadas a cada oblea.

```text
oblea_imagenes {

    id: INTEGER (PK)

    id_oblea: INTEGER (FK obleas.id) NOT NULL

    ruta_archivo: VARCHAR(255) NOT NULL

    nombre_original: VARCHAR(150)

    formato: VARCHAR(10) NOT NULL

    orden: INTEGER NOT NULL

    fecha_registro: TIMESTAMP NOT NULL

}
```

## Descripción de campos

- `id`: identificador único de la imagen.
- `id_oblea`: oblea a la que pertenece la imagen.
- `ruta_archivo`: ubicación relativa del archivo almacenado por el sistema.
- `nombre_original`: nombre del archivo cargado por el usuario.
- `formato`: extensión normalizada del archivo, por ejemplo `png`, `jpg` o `webp`.
- `orden`: posición de la imagen dentro de la oblea, de 1 a 2. La imagen con `orden = 1` se usa como vista previa en el listado.
- `fecha_registro`: fecha y hora de carga de la imagen.

## Restricciones e índices

```text
CHECK oblea_imagenes.orden BETWEEN 1 AND 2
UNIQUE (id_oblea, orden)

INDEX oblea_imagenes.id_oblea
```

Una oblea podrá tener como máximo 2 imágenes.

## Relación

```text
oblea_imagenes.id_oblea
    ↓
obleas.id
```

Al eliminar físicamente una oblea deberán eliminarse también sus imágenes asociadas y los archivos correspondientes del almacenamiento.

---

# Tabla: otros

Registra otros insumos administrados desde el módulo Insumos.

```text
otros {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id)

    id_categoria: INTEGER (FK categorias.id) NOT NULL

    codigo: VARCHAR(30) UNIQUE NOT NULL

    insumo: VARCHAR(150) NOT NULL

    id_perfil: INTEGER (FK perfiles.id)

    stock_minimo: NUMERIC(12,3)

    estado: BOOLEAN NOT NULL DEFAULT true

    descripcion: TEXT

}
```

## Descripción de campos

- `id`: identificador único generado automáticamente.
- `fecha_registro`: fecha y hora de alta del insumo.
- `creado_por`: usuario que registró el insumo.
- `id_categoria`: categoría asociada al insumo.
- `codigo`: código único del insumo, por ejemplo `OT-001`.
- `insumo`: nombre del insumo.
- `id_perfil`: perfil de calidad asociado. Será nulo cuando Perfil = No aplica.
- `stock_minimo`: stock mínimo de alerta en unidades. Será nulo cuando no se defina umbral. Se utiliza en el indicador de stock bajo del módulo Movimientos / Otros.
- `estado`: indica si el insumo está activo (`true`) o inactivo (`false`).
- `descripcion`: detalle opcional del insumo.

Las imágenes no se almacenan dentro de esta tabla. Se registran en `otro_imagenes`.

## Restricciones e índices

```text
otros.codigo (UNIQUE)
CHECK otros.stock_minimo IS NULL OR otros.stock_minimo >= 0

INDEX otros.id_categoria
INDEX otros.insumo
INDEX otros.id_perfil
INDEX otros.estado
```

La comparación para detectar códigos duplicados deberá ignorar diferencias entre mayúsculas, minúsculas y espacios al inicio o al final.

## Relaciones

```text
otros.id_categoria
    ↓
categorias.id

otros.creado_por
    ↓
usuarios.id

otros.id_perfil
    ↓
perfiles.id
```

Un registro de otros insumos podrá:

- Tener `id_perfil` asignado cuando Perfil = Aplica.
- Tener `id_perfil = NULL` cuando Perfil = No aplica.

---

# Tabla: otro_imagenes

Almacena hasta 4 imágenes asociadas a cada registro de otros insumos.

```text
otro_imagenes {

    id: INTEGER (PK)

    id_otro: INTEGER (FK otros.id) NOT NULL

    ruta_archivo: VARCHAR(255) NOT NULL

    nombre_original: VARCHAR(150)

    formato: VARCHAR(10) NOT NULL

    orden: INTEGER NOT NULL

    fecha_registro: TIMESTAMP NOT NULL

}
```

## Descripción de campos

- `id`: identificador único de la imagen.
- `id_otro`: registro de otros insumos al que pertenece la imagen.
- `ruta_archivo`: ubicación relativa del archivo almacenado por el sistema.
- `nombre_original`: nombre del archivo cargado por el usuario.
- `formato`: extensión normalizada del archivo, por ejemplo `png`, `jpg` o `webp`.
- `orden`: posición de la imagen, de 1 a 4. La imagen con `orden = 1` se usa como vista previa en el listado.
- `fecha_registro`: fecha y hora de carga de la imagen.

## Restricciones e índices

```text
CHECK otro_imagenes.orden BETWEEN 1 AND 4
UNIQUE (id_otro, orden)

INDEX otro_imagenes.id_otro
```

Cada registro de otros insumos podrá tener como máximo 4 imágenes.

## Relación

```text
otro_imagenes.id_otro
    ↓
otros.id
```

Al eliminar físicamente un registro de otros insumos deberán eliminarse también sus imágenes asociadas y los archivos correspondientes del almacenamiento.

---

# Tabla: solicitudes

Registra las solicitudes de producción.

```text
solicitudes {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id)

    orden_compra: VARCHAR(50)

    id_categoria: INTEGER (FK categorias.id) NOT NULL

    id_producto: INTEGER (FK productos.id) NOT NULL

    id_version: INTEGER (FK versiones.id) NOT NULL

    id_envase: INTEGER (FK envases.id) NOT NULL

    id_oblea: INTEGER (FK obleas.id)

    cantidad_unidades: NUMERIC(12,4) NOT NULL

    unidades_pallets: NUMERIC(12,4) NOT NULL

    cantidad_pallets: NUMERIC(12,4) NOT NULL

    pesaje_total: NUMERIC(14,4) NOT NULL

    unidades_pendientes: NUMERIC(12,4) NOT NULL

    pallets_pendientes: NUMERIC(12,4) NOT NULL

    pesaje_pendiente: NUMERIC(14,4) NOT NULL

    fecha_estimada: DATE

    fecha_fin: DATE

    lote: VARCHAR(50)

    estado: VARCHAR(30) NOT NULL

    descripcion: TEXT

}
```

## Descripción de campos

- `id`: identificador único de la solicitud.
- `fecha_registro`: fecha y hora de alta de la solicitud.
- `creado_por`: usuario que registró la solicitud.
- `orden_compra`: número de orden de compra u OC/SAP. Puede repetirse en varias solicitudes. Una misma OC puede incluir distintos productos y cantidades.
- `id_categoria`: categoría del producto solicitado.
- `id_producto`: producto solicitado.
- `id_version`: versión de fórmula/receta a utilizar.
- `id_envase`: envase seleccionado.
- `id_oblea`: oblea asociada al producto. Puede ser nula si no existe oblea vinculada.
- `cantidad_unidades`: cantidad total de unidades solicitadas.
- `unidades_pallets`: cantidad de unidades apiladas por pallet.
- `cantidad_pallets`: cantidad total de pallets calculada.
- `pesaje_total`: kilogramos totales solicitados.
- `unidades_pendientes`: unidades aún pendientes de elaborar.
- `pallets_pendientes`: pallets aún pendientes de elaborar.
- `pesaje_pendiente`: kilogramos aún pendientes de elaborar.
- `fecha_estimada`: fecha estimada de finalización.
- `fecha_fin`: fecha real de finalización.
- `lote`: lote asignado al producto.
- `estado`: estado operativo de la solicitud.
- `descripcion`: detalle opcional.

## Estados permitidos

```text
a_coordinar
proximo_a_iniciar
en_curso
pausado
cancelado
finalizado
```

## Cálculos automáticos

```text
cantidad_pallets = cantidad_unidades / unidades_pallets
pesaje_total = cantidad_unidades * envases.capacidad_kg
unidades_pendientes = pallets_pendientes * unidades_pallets
pesaje_pendiente = unidades_pendientes * envases.capacidad_kg
```

## Restricciones e índices

```text
CHECK solicitudes.cantidad_unidades > 0
CHECK solicitudes.unidades_pallets > 0
CHECK solicitudes.pallets_pendientes >= 0
CHECK solicitudes.estado IN (
    'a_coordinar',
    'proximo_a_iniciar',
    'en_curso',
    'pausado',
    'cancelado',
    'finalizado'
)

INDEX solicitudes.id_categoria
INDEX solicitudes.id_producto
INDEX solicitudes.id_version
INDEX solicitudes.id_envase
INDEX solicitudes.id_oblea
INDEX solicitudes.estado
INDEX solicitudes.fecha_estimada
INDEX solicitudes.fecha_fin
INDEX solicitudes.orden_compra
```

`orden_compra` no es único. Varias solicitudes pueden compartir la misma orden de compra.

Ejemplo:

```text
OC 01-252526-02 → solicitud de 1000 unidades del producto 01
OC 01-252526-02 → solicitud de 500 unidades del producto 02
```

Reglas de exclusividad:

- Solo puede existir una solicitud con estado `proximo_a_iniciar` a la vez.
- Solo puede existir una solicitud con estado `en_curso` a la vez.

## Relaciones

```text
solicitudes.id_categoria → categorias.id
solicitudes.id_producto → productos.id
solicitudes.id_version → versiones.id
solicitudes.id_envase → envases.id
solicitudes.id_oblea → obleas.id
solicitudes.creado_por → usuarios.id
```

La versión seleccionada deberá pertenecer al producto seleccionado.
El envase deberá pertenecer a la categoría seleccionada.
La oblea, cuando exista, deberá estar asociada al producto seleccionado.

---

# Tabla: ejecuciones

Registra cada ejecución parcial o total realizada sobre una solicitud de producción.

```text
ejecuciones {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id) NOT NULL

    id_solicitud: INTEGER (FK solicitudes.id) NOT NULL

    pesaje_batch: NUMERIC(14,4) NOT NULL

    cantidad_batches: INTEGER NOT NULL

    unidades_elaboradas: NUMERIC(14,4) NOT NULL

    pallets_elaborados: NUMERIC(14,4) NOT NULL

    kilogramos_elaborados: NUMERIC(14,4) NOT NULL

    dosificaciones_finalizadas: BOOLEAN NOT NULL DEFAULT false

    consumibles_finalizados: BOOLEAN NOT NULL DEFAULT false

    limpieza_previa_estado: VARCHAR(20) NOT NULL DEFAULT 'no_realizado'

    limpieza_fin: VARCHAR(20)

    estado: VARCHAR(20) NOT NULL DEFAULT 'en_curso'

    descripcion: TEXT

    fecha_finalizacion: TIMESTAMP

    finalizado_por: INTEGER (FK usuarios.id)

}
```

## Descripción de campos

- `id_solicitud`: solicitud sobre la que se registra la producción.
- `pesaje_batch`: suma de los kilogramos de macro y micronutrientes dosificados en cada batch.
- `cantidad_batches`: cantidad entera de batches incluidos en la ejecución.
- `unidades_elaboradas`: unidades equivalentes calculadas según la capacidad del envase de la solicitud.
- `pallets_elaborados`: pallets equivalentes calculados según las unidades por pallet de la solicitud.
- `kilogramos_elaborados`: resultado de `cantidad_batches * pesaje_batch`.
- `dosificaciones_finalizadas`: confirma que el panel de dosificaciones fue revisado y cerrado.
- `consumibles_finalizados`: confirma que el panel de consumibles fue revisado y cerrado.
- `limpieza_previa_estado`: valor automático `realizado` o `no_realizado`, derivado del checklist.
- `limpieza_fin`: evaluación final `conforme` o `no_conforme`.
- `estado`: estado propio de la ejecución: `en_curso` o `finalizado`.
- `fecha_finalizacion` y `finalizado_por`: auditoría del cierre.

## Cálculos

```text
kilogramos_elaborados = cantidad_batches * pesaje_batch
unidades_elaboradas = kilogramos_elaborados / solicitudes.envases.capacidad_kg
pallets_elaborados = unidades_elaboradas / solicitudes.unidades_pallets
```

Los cálculos se realizarán con decimales, sin redondeos silenciosos. Para finalizar, `unidades_elaboradas` deberá representar una cantidad entera de envases. `pallets_elaborados` podrá ser decimal para representar un pallet parcial.

## Restricciones e índices

```text
CHECK ejecuciones.pesaje_batch > 0
CHECK ejecuciones.cantidad_batches > 0
CHECK ejecuciones.unidades_elaboradas > 0
CHECK ejecuciones.pallets_elaborados > 0
CHECK ejecuciones.kilogramos_elaborados > 0
CHECK ejecuciones.limpieza_previa_estado IN ('realizado', 'no_realizado')
CHECK ejecuciones.limpieza_fin IS NULL
   OR ejecuciones.limpieza_fin IN ('conforme', 'no_conforme')
CHECK ejecuciones.estado IN ('en_curso', 'finalizado')

INDEX ejecuciones.id_solicitud
INDEX ejecuciones.fecha_registro
INDEX ejecuciones.estado

UNIQUE INDEX ejecuciones_unica_en_curso
ON ejecuciones ((1))
WHERE estado = 'en_curso'
```

Solo podrá existir una ejecución global en estado `en_curso`. La finalización deberá ejecutarse en una única transacción junto con la actualización de pendientes y la conversión de reservas de stock en egresos.

## Relaciones

```text
ejecuciones.id_solicitud → solicitudes.id
ejecuciones.creado_por → usuarios.id
ejecuciones.finalizado_por → usuarios.id
```

---

# Tabla: dosificaciones

Registra la planificación FIFO y el consumo de lotes de ingredientes para cada ejecución.

```text
dosificaciones {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id) NOT NULL

    id_ejecucion: INTEGER (FK ejecuciones.id) NOT NULL

    id_version_detalle: INTEGER (FK version_detalles.id) NOT NULL

    id_ingrediente: INTEGER (FK ingredientes.id) NOT NULL

    lote: VARCHAR(80) NOT NULL

    pesaje: NUMERIC(14,4) NOT NULL

    batch_inicio: INTEGER NOT NULL

    batch_fin: INTEGER NOT NULL

    sin_stock: BOOLEAN NOT NULL DEFAULT false

    descripcion: TEXT

}
```

## Descripción de campos

- `id_version_detalle`: línea de receta que origina la dosificación.
- `id_ingrediente`: ingrediente dosificado.
- `lote`: lote físico asignado o el texto controlado `SIN STOCK DISP`.
- `pesaje`: kilogramos totales asignados a la fila.
- `batch_inicio` y `batch_fin`: rango de batches alcanzado por la asignación.
- `sin_stock`: identifica una fila de faltante; estas filas no reservan ni descuentan stock.
- `descripcion`: justificación opcional; será obligatoria cuando un usuario altere manualmente el orden FIFO.

Mientras la ejecución se encuentre `en_curso`, cada fila con `sin_stock = false` representa una reserva del lote. Al finalizar, la reserva se convierte en egreso. La identificación, fecha de ingreso y saldo de cada lote provendrán del módulo de movimientos de stock; `lote` conserva el valor histórico visible.

## Restricciones e índices

```text
CHECK dosificaciones.pesaje > 0
CHECK dosificaciones.batch_inicio >= 1
CHECK dosificaciones.batch_fin >= dosificaciones.batch_inicio
CHECK (
    (sin_stock = true AND lote = 'SIN STOCK DISP')
 OR (sin_stock = false AND lote <> 'SIN STOCK DISP')
)

INDEX dosificaciones.id_ejecucion
INDEX dosificaciones.id_version_detalle
INDEX dosificaciones.id_ingrediente
INDEX dosificaciones.lote
```

## Relaciones

```text
dosificaciones.id_ejecucion → ejecuciones.id
dosificaciones.id_version_detalle → version_detalles.id
dosificaciones.id_ingrediente → ingredientes.id
dosificaciones.creado_por → usuarios.id
```

---

# Tabla: consumibles

Registra la necesidad, disponibilidad y reserva de consumibles para cada ejecución.

```text
consumibles {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id) NOT NULL

    id_ejecucion: INTEGER (FK ejecuciones.id) NOT NULL

    id_version_consumible: INTEGER (FK version_consumibles.id) NOT NULL

    insumo: VARCHAR(200) NOT NULL

    cantidad_programada: NUMERIC(14,4) NOT NULL

    cantidad_disponible: NUMERIC(14,4) NOT NULL

    cantidad_reservada: NUMERIC(14,4) NOT NULL

    cantidad_faltante: NUMERIC(14,4) NOT NULL

    batch_inicio: INTEGER

    batch_fin: INTEGER

}
```

`insumo` conserva el nombre visible al momento de la ejecución. La relación con el maestro se resuelve mediante `id_version_consumible`.

```text
cantidad_reservada = MIN(cantidad_programada, cantidad_disponible)
cantidad_faltante = MAX(cantidad_programada - cantidad_reservada, 0)
```

Mientras la ejecución se encuentre `en_curso`, `cantidad_reservada` se resta del stock disponible para otras operaciones. Al finalizar, se convierte en egreso.

## Restricciones e índices

```text
CHECK consumibles.cantidad_programada > 0
CHECK consumibles.cantidad_disponible >= 0
CHECK consumibles.cantidad_reservada >= 0
CHECK consumibles.cantidad_reservada <= consumibles.cantidad_programada
CHECK consumibles.cantidad_reservada <= consumibles.cantidad_disponible
CHECK consumibles.cantidad_faltante >= 0
CHECK (
    (batch_inicio IS NULL AND batch_fin IS NULL)
 OR (batch_inicio >= 1 AND batch_fin >= batch_inicio)
)

UNIQUE (id_ejecucion, id_version_consumible)

INDEX consumibles.id_ejecucion
INDEX consumibles.id_version_consumible
```

## Relaciones

```text
consumibles.id_ejecucion → ejecuciones.id
consumibles.id_version_consumible → version_consumibles.id
consumibles.creado_por → usuarios.id
```

---

# Tabla: sectores_equipos

Registra los sectores, equipos, vehículos y otros elementos disponibles para los controles de limpieza y orden.

```text
sectores_equipos {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id) NOT NULL

    tipo: VARCHAR(20) NOT NULL

    nombre: VARCHAR(150) NOT NULL

    estado: BOOLEAN NOT NULL DEFAULT true

    descripcion: TEXT

}
```

## Restricciones e índices

```text
CHECK sectores_equipos.tipo IN ('sector', 'equipo', 'vehiculo', 'otro')
UNIQUE (tipo, nombre)

INDEX sectores_equipos.tipo
INDEX sectores_equipos.nombre
INDEX sectores_equipos.estado
```

Los registros utilizados en ejecuciones no podrán eliminarse físicamente. Se utilizará `estado = false` para ocultarlos de nuevos checklists sin perder el historial.

## Relaciones

```text
sectores_equipos.creado_por → usuarios.id
```

---

# Tabla: limpiezas_orden

Registra el resultado del checklist de limpieza y orden de una ejecución.

```text
limpiezas_orden {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id) NOT NULL

    id_ejecucion: INTEGER (FK ejecuciones.id) NOT NULL

    id_sector_equipo: INTEGER (FK sectores_equipos.id) NOT NULL

    momento: VARCHAR(20) NOT NULL DEFAULT 'previa'

    realizado: BOOLEAN NOT NULL DEFAULT false

    descripcion: TEXT

}
```

Se guardará una fila por cada elemento mostrado en el checklist, incluso cuando `realizado = false`, para conservar la evidencia completa de lo revisado.

## Restricciones e índices

```text
CHECK limpiezas_orden.momento IN ('previa', 'final')
UNIQUE (id_ejecucion, id_sector_equipo, momento)

INDEX limpiezas_orden.id_ejecucion
INDEX limpiezas_orden.id_sector_equipo
INDEX limpiezas_orden.realizado
```

El valor `ejecuciones.limpieza_previa_estado` será `realizado` cuando exista al menos una fila previa marcada y `no_realizado` cuando no exista ninguna.

## Relaciones

```text
limpiezas_orden.id_ejecucion → ejecuciones.id
limpiezas_orden.id_sector_equipo → sectores_equipos.id
limpiezas_orden.creado_por → usuarios.id
```

---

# Tabla: mov_ingredientes

Registra los movimientos de ingreso y egreso de ingredientes del depósito.

```text
mov_ingredientes {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id) NOT NULL

    movimiento: VARCHAR(20) NOT NULL

    id_categoria: INTEGER (FK categorias.id) NOT NULL

    id_ingrediente: INTEGER (FK ingredientes.id) NOT NULL

    id_empresa: INTEGER (FK empresas.id) NOT NULL

    lote: VARCHAR(50) NOT NULL

    fecha_vencimiento: DATE

    cantidad_unidades: NUMERIC(12,3) NOT NULL

    capacidad_unidad: NUMERIC(12,3) NOT NULL

    unidades_por_pallet: NUMERIC(12,3) NOT NULL

    cantidad_pallets: NUMERIC(12,3) NOT NULL

    comprobante: VARCHAR(50)

    control_calidad: VARCHAR(20) NOT NULL

    descripcion: TEXT

}
```

Las imágenes no se almacenan dentro de esta tabla. Se registran en `mov_ingrediente_comprobante_imagenes` y `mov_ingrediente_imagenes`.

## Descripción de campos

- `id`: identificador único del movimiento.
- `fecha_registro`: fecha y hora de alta del movimiento.
- `creado_por`: usuario que registró el movimiento.
- `movimiento`: tipo de operación. Valores permitidos:
  - `ingreso`
  - `egreso`
- `id_categoria`: categoría del ingrediente al momento del movimiento.
- `id_ingrediente`: ingrediente movido.
- `id_empresa`: proveedor o empresa asociada al movimiento.
- `lote`: número de lote informado por el proveedor. La identidad lógica del lote es `(id_ingrediente, lote)`.
- `fecha_vencimiento`: fecha de vencimiento del lote. Obligatoria en ingresos.
- `cantidad_unidades`: cantidad de unidades ingresadas o egresadas.
- `capacidad_unidad`: peso de cada unidad en kilogramos (kg/unidad).
- `unidades_por_pallet`: cantidad de unidades que conforman un pallet completo.
- `cantidad_pallets`: valor calculado `cantidad_unidades / unidades_por_pallet`. Puede contener decimales.
- `comprobante`: número de remito, factura u otro comprobante asociado.
- `control_calidad`: resultado del control en recepción. Valores permitidos:
  - `conforme`
  - `no_conforme`
- `descripcion`: observaciones opcionales del movimiento.

```text
kilogramos_movimiento = cantidad_unidades * capacidad_unidad
```

El stock del lote se calcula como la suma de kilogramos de ingresos menos la suma de kilogramos de egresos para la misma combinación `(id_ingrediente, lote)`.

## Restricciones e índices

```text
CHECK mov_ingredientes.movimiento IN ('ingreso', 'egreso')
CHECK mov_ingredientes.control_calidad IN ('conforme', 'no_conforme')
CHECK mov_ingredientes.cantidad_unidades > 0
CHECK mov_ingredientes.capacidad_unidad > 0
CHECK mov_ingredientes.unidades_por_pallet > 0
CHECK mov_ingredientes.cantidad_pallets > 0

INDEX mov_ingredientes.fecha_registro
INDEX mov_ingredientes.movimiento
INDEX mov_ingredientes.id_categoria
INDEX mov_ingredientes.id_ingrediente
INDEX mov_ingredientes.id_empresa
INDEX mov_ingredientes.lote
INDEX mov_ingredientes.control_calidad
INDEX (id_ingrediente, lote)
```

La unicidad del lote por ingrediente se valida a nivel de negocio: no podrá existir otra identidad de lote distinta con el mismo número para el mismo ingrediente. Varios movimientos podrán compartir el mismo `(id_ingrediente, lote)`.

## Relaciones

```text
mov_ingredientes.id_categoria → categorias.id
mov_ingredientes.id_ingrediente → ingredientes.id
mov_ingredientes.id_empresa → empresas.id
mov_ingredientes.creado_por → usuarios.id
```

---

# Tabla: mov_ingrediente_comprobante_imagenes

Almacena hasta 2 imágenes del comprobante asociadas a cada movimiento de ingrediente.

```text
mov_ingrediente_comprobante_imagenes {

    id: INTEGER (PK)

    id_mov_ingrediente: INTEGER (FK mov_ingredientes.id) NOT NULL

    ruta_archivo: VARCHAR(255) NOT NULL

    nombre_original: VARCHAR(150)

    formato: VARCHAR(10) NOT NULL

    orden: INTEGER NOT NULL

    fecha_registro: TIMESTAMP NOT NULL

}
```

## Descripción de campos

- `id`: identificador único de la imagen.
- `id_mov_ingrediente`: movimiento al que pertenece la imagen.
- `ruta_archivo`: ubicación relativa del archivo almacenado por el sistema.
- `nombre_original`: nombre del archivo cargado por el usuario.
- `formato`: extensión normalizada del archivo, por ejemplo `png`, `jpg` o `webp`.
- `orden`: posición de la imagen dentro del movimiento, de 1 a 2.
- `fecha_registro`: fecha y hora de carga de la imagen.

## Restricciones e índices

```text
CHECK mov_ingrediente_comprobante_imagenes.orden BETWEEN 1 AND 2
UNIQUE (id_mov_ingrediente, orden)

INDEX mov_ingrediente_comprobante_imagenes.id_mov_ingrediente
```

Un movimiento podrá tener como máximo 2 imágenes de comprobante.

## Relación

```text
mov_ingrediente_comprobante_imagenes.id_mov_ingrediente
    ↓
mov_ingredientes.id
```

Al eliminar físicamente un movimiento deberán eliminarse también sus imágenes de comprobante y los archivos correspondientes del almacenamiento.

---

# Tabla: mov_ingrediente_imagenes

Almacena hasta 5 imágenes del ingrediente asociado a cada movimiento.

```text
mov_ingrediente_imagenes {

    id: INTEGER (PK)

    id_mov_ingrediente: INTEGER (FK mov_ingredientes.id) NOT NULL

    ruta_archivo: VARCHAR(255) NOT NULL

    nombre_original: VARCHAR(150)

    formato: VARCHAR(10) NOT NULL

    orden: INTEGER NOT NULL

    fecha_registro: TIMESTAMP NOT NULL

}
```

## Descripción de campos

- `id`: identificador único de la imagen.
- `id_mov_ingrediente`: movimiento al que pertenece la imagen.
- `ruta_archivo`: ubicación relativa del archivo almacenado por el sistema.
- `nombre_original`: nombre del archivo cargado por el usuario.
- `formato`: extensión normalizada del archivo, por ejemplo `png`, `jpg` o `webp`.
- `orden`: posición de la imagen dentro del movimiento, de 1 a 5.
- `fecha_registro`: fecha y hora de carga de la imagen.

## Restricciones e índices

```text
CHECK mov_ingrediente_imagenes.orden BETWEEN 1 AND 5
UNIQUE (id_mov_ingrediente, orden)

INDEX mov_ingrediente_imagenes.id_mov_ingrediente
```

Un movimiento podrá tener como máximo 5 imágenes del ingrediente.

## Relación

```text
mov_ingrediente_imagenes.id_mov_ingrediente
    ↓
mov_ingredientes.id
```

Al eliminar físicamente un movimiento deberán eliminarse también sus imágenes de ingrediente y los archivos correspondientes del almacenamiento.

---

# Tabla: mov_envases

Registra los movimientos de ingreso y egreso de envases del depósito.

```text
mov_envases {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id) NOT NULL

    movimiento: VARCHAR(20) NOT NULL

    id_categoria: INTEGER (FK categorias.id) NOT NULL

    id_envase: INTEGER (FK envases.id) NOT NULL

    id_empresa: INTEGER (FK empresas.id)

    cantidad_unidades: NUMERIC(12,3) NOT NULL

    comprobante: VARCHAR(50)

    control_calidad: VARCHAR(20) NOT NULL

    descripcion: TEXT

}
```

Las imágenes no se almacenan dentro de esta tabla. Se registran en `mov_envase_comprobante_imagenes` y `mov_envase_imagenes`.

## Descripción de campos

- `id`: identificador único del movimiento.
- `fecha_registro`: fecha y hora de alta del movimiento.
- `creado_por`: usuario que registró el movimiento.
- `movimiento`: tipo de operación. Valores permitidos:
  - `ingreso`
  - `egreso`
- `id_categoria`: categoría del envase al momento del movimiento.
- `id_envase`: envase movido.
- `id_empresa`: proveedor o empresa asociada. Obligatoria en ingresos; opcional en egresos.
- `cantidad_unidades`: cantidad de unidades ingresadas o egresadas.
- `comprobante`: número de remito, factura u otro documento asociado.
- `control_calidad`: resultado del control. Valores permitidos:
  - `conforme`
  - `no_conforme`
- `descripcion`: observaciones opcionales del movimiento.

```text
stock_envase_unidades =
    suma(ingresos)
    - suma(egresos)

stock_disponible_produccion =
    suma(ingresos conforme)
    - suma(egresos)
```

## Restricciones e índices

```text
CHECK mov_envases.movimiento IN ('ingreso', 'egreso')
CHECK mov_envases.control_calidad IN ('conforme', 'no_conforme')
CHECK mov_envases.cantidad_unidades > 0
CHECK (
    (movimiento = 'ingreso' AND id_empresa IS NOT NULL)
 OR (movimiento = 'egreso')
)

INDEX mov_envases.fecha_registro
INDEX mov_envases.movimiento
INDEX mov_envases.id_categoria
INDEX mov_envases.id_envase
INDEX mov_envases.id_empresa
INDEX mov_envases.control_calidad
```

## Relaciones

```text
mov_envases.id_categoria → categorias.id
mov_envases.id_envase → envases.id
mov_envases.id_empresa → empresas.id
mov_envases.creado_por → usuarios.id
```

---

# Tabla: mov_envase_comprobante_imagenes

Almacena hasta 2 imágenes del comprobante asociadas a cada movimiento de envase.

```text
mov_envase_comprobante_imagenes {

    id: INTEGER (PK)

    id_mov_envase: INTEGER (FK mov_envases.id) NOT NULL

    ruta_archivo: VARCHAR(255) NOT NULL

    nombre_original: VARCHAR(150)

    formato: VARCHAR(10) NOT NULL

    orden: INTEGER NOT NULL

    fecha_registro: TIMESTAMP NOT NULL

}
```

## Descripción de campos

- `id`: identificador único de la imagen.
- `id_mov_envase`: movimiento al que pertenece la imagen.
- `ruta_archivo`: ubicación relativa del archivo almacenado por el sistema.
- `nombre_original`: nombre del archivo cargado por el usuario.
- `formato`: extensión normalizada del archivo, por ejemplo `png`, `jpg` o `webp`.
- `orden`: posición de la imagen dentro del movimiento, de 1 a 2.
- `fecha_registro`: fecha y hora de carga de la imagen.

## Restricciones e índices

```text
CHECK mov_envase_comprobante_imagenes.orden BETWEEN 1 AND 2
UNIQUE (id_mov_envase, orden)

INDEX mov_envase_comprobante_imagenes.id_mov_envase
```

Un movimiento podrá tener como máximo 2 imágenes de comprobante.

## Relación

```text
mov_envase_comprobante_imagenes.id_mov_envase
    ↓
mov_envases.id
```

Al eliminar físicamente un movimiento deberán eliminarse también sus imágenes de comprobante y los archivos correspondientes del almacenamiento.

---

# Tabla: mov_envase_imagenes

Almacena hasta 5 imágenes del estado de los envases asociadas a cada movimiento.

```text
mov_envase_imagenes {

    id: INTEGER (PK)

    id_mov_envase: INTEGER (FK mov_envases.id) NOT NULL

    ruta_archivo: VARCHAR(255) NOT NULL

    nombre_original: VARCHAR(150)

    formato: VARCHAR(10) NOT NULL

    orden: INTEGER NOT NULL

    fecha_registro: TIMESTAMP NOT NULL

}
```

## Descripción de campos

- `id`: identificador único de la imagen.
- `id_mov_envase`: movimiento al que pertenece la imagen.
- `ruta_archivo`: ubicación relativa del archivo almacenado por el sistema.
- `nombre_original`: nombre del archivo cargado por el usuario.
- `formato`: extensión normalizada del archivo, por ejemplo `png`, `jpg` o `webp`.
- `orden`: posición de la imagen dentro del movimiento, de 1 a 5.
- `fecha_registro`: fecha y hora de carga de la imagen.

## Restricciones e índices

```text
CHECK mov_envase_imagenes.orden BETWEEN 1 AND 5
UNIQUE (id_mov_envase, orden)

INDEX mov_envase_imagenes.id_mov_envase
```

Un movimiento podrá tener como máximo 5 imágenes del envase.

## Relación

```text
mov_envase_imagenes.id_mov_envase
    ↓
mov_envases.id
```

Al eliminar físicamente un movimiento deberán eliminarse también sus imágenes de envase y los archivos correspondientes del almacenamiento.

---

# Tabla: mov_obleas

Registra los movimientos de ingreso y egreso de obleas del depósito.

```text
mov_obleas {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id) NOT NULL

    movimiento: VARCHAR(20) NOT NULL

    id_categoria: INTEGER (FK categorias.id) NOT NULL

    id_oblea: INTEGER (FK obleas.id) NOT NULL

    id_empresa: INTEGER (FK empresas.id) NOT NULL

    cantidad_unidades: NUMERIC(12,3) NOT NULL

    comprobante: VARCHAR(50)

    control_calidad: VARCHAR(20) NOT NULL

    descripcion: TEXT

}
```

Las imágenes no se almacenan dentro de esta tabla. Se registran en `mov_oblea_comprobante_imagenes` y `mov_oblea_imagenes`.

## Descripción de campos

- `id`: identificador único del movimiento.
- `fecha_registro`: fecha y hora de alta del movimiento.
- `creado_por`: usuario que registró el movimiento.
- `movimiento`: tipo de operación. Valores permitidos:
  - `ingreso`
  - `egreso`
- `id_categoria`: categoría de la oblea al momento del movimiento.
- `id_oblea`: oblea movida.
- `id_empresa`: proveedor o empresa asociada al movimiento.
- `cantidad_unidades`: cantidad de unidades ingresadas o egresadas.
- `comprobante`: número de remito, factura u otro comprobante asociado.
- `control_calidad`: resultado del control en recepción. Valores permitidos:
  - `conforme`
  - `no_conforme`
- `descripcion`: observaciones opcionales del movimiento.

```text
stock_oblea_unidades =
    suma(ingresos)
    - suma(egresos)

stock_disponible_produccion =
    suma(ingresos conforme)
    - suma(egresos)
```

## Restricciones e índices

```text
CHECK mov_obleas.movimiento IN ('ingreso', 'egreso')
CHECK mov_obleas.control_calidad IN ('conforme', 'no_conforme')
CHECK mov_obleas.cantidad_unidades > 0

INDEX mov_obleas.fecha_registro
INDEX mov_obleas.movimiento
INDEX mov_obleas.id_categoria
INDEX mov_obleas.id_oblea
INDEX mov_obleas.id_empresa
INDEX mov_obleas.control_calidad
```

## Relaciones

```text
mov_obleas.id_categoria → categorias.id
mov_obleas.id_oblea → obleas.id
mov_obleas.id_empresa → empresas.id
mov_obleas.creado_por → usuarios.id
```

---

# Tabla: mov_oblea_comprobante_imagenes

Almacena hasta 2 imágenes del comprobante asociadas a cada movimiento de oblea.

```text
mov_oblea_comprobante_imagenes {

    id: INTEGER (PK)

    id_mov_oblea: INTEGER (FK mov_obleas.id) NOT NULL

    ruta_archivo: VARCHAR(255) NOT NULL

    nombre_original: VARCHAR(150)

    formato: VARCHAR(10) NOT NULL

    orden: INTEGER NOT NULL

    fecha_registro: TIMESTAMP NOT NULL

}
```

## Descripción de campos

- `id`: identificador único de la imagen.
- `id_mov_oblea`: movimiento al que pertenece la imagen.
- `ruta_archivo`: ubicación relativa del archivo almacenado por el sistema.
- `nombre_original`: nombre del archivo cargado por el usuario.
- `formato`: extensión normalizada del archivo, por ejemplo `png`, `jpg` o `webp`.
- `orden`: posición de la imagen dentro del movimiento, de 1 a 2.
- `fecha_registro`: fecha y hora de carga de la imagen.

## Restricciones e índices

```text
CHECK mov_oblea_comprobante_imagenes.orden BETWEEN 1 AND 2
UNIQUE (id_mov_oblea, orden)

INDEX mov_oblea_comprobante_imagenes.id_mov_oblea
```

Un movimiento podrá tener como máximo 2 imágenes de comprobante.

## Relación

```text
mov_oblea_comprobante_imagenes.id_mov_oblea
    ↓
mov_obleas.id
```

Al eliminar físicamente un movimiento deberán eliminarse también sus imágenes de comprobante y los archivos correspondientes del almacenamiento.

---

# Tabla: mov_oblea_imagenes

Almacena hasta 5 imágenes de las obleas asociadas a cada movimiento.

```text
mov_oblea_imagenes {

    id: INTEGER (PK)

    id_mov_oblea: INTEGER (FK mov_obleas.id) NOT NULL

    ruta_archivo: VARCHAR(255) NOT NULL

    nombre_original: VARCHAR(150)

    formato: VARCHAR(10) NOT NULL

    orden: INTEGER NOT NULL

    fecha_registro: TIMESTAMP NOT NULL

}
```

## Descripción de campos

- `id`: identificador único de la imagen.
- `id_mov_oblea`: movimiento al que pertenece la imagen.
- `ruta_archivo`: ubicación relativa del archivo almacenado por el sistema.
- `nombre_original`: nombre del archivo cargado por el usuario.
- `formato`: extensión normalizada del archivo, por ejemplo `png`, `jpg` o `webp`.
- `orden`: posición de la imagen dentro del movimiento, de 1 a 5.
- `fecha_registro`: fecha y hora de carga de la imagen.

## Restricciones e índices

```text
CHECK mov_oblea_imagenes.orden BETWEEN 1 AND 5
UNIQUE (id_mov_oblea, orden)

INDEX mov_oblea_imagenes.id_mov_oblea
```

Un movimiento podrá tener como máximo 5 imágenes de oblea.

## Relación

```text
mov_oblea_imagenes.id_mov_oblea
    ↓
mov_obleas.id
```

Al eliminar físicamente un movimiento deberán eliminarse también sus imágenes de oblea y los archivos correspondientes del almacenamiento.

---

# Tabla: mov_otros

Registra los movimientos de ingreso y egreso de otros insumos del depósito.

```text
mov_otros {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id) NOT NULL

    movimiento: VARCHAR(20) NOT NULL

    id_otro: INTEGER (FK otros.id) NOT NULL

    id_empresa: INTEGER (FK empresas.id) NOT NULL

    cantidad_unidades: NUMERIC(12,3) NOT NULL

    comprobante: VARCHAR(50)

    control_calidad: VARCHAR(20) NOT NULL

    descripcion: TEXT

}
```

Las imágenes no se almacenan dentro de esta tabla. Se registran en `mov_otro_comprobante_imagenes` y `mov_otro_imagenes`.

La categoría no se almacena en el movimiento. Se obtiene mediante `otros.id_categoria`.

## Descripción de campos

- `id`: identificador único del movimiento.
- `fecha_registro`: fecha y hora de alta del movimiento.
- `creado_por`: usuario que registró el movimiento.
- `movimiento`: tipo de operación. Valores permitidos:
  - `ingreso`
  - `egreso`
- `id_otro`: otro insumo movido.
- `id_empresa`: proveedor o empresa asociada al movimiento.
- `cantidad_unidades`: cantidad de unidades ingresadas o egresadas.
- `comprobante`: número de remito, factura u otro comprobante asociado.
- `control_calidad`: resultado del control en recepción. Valores permitidos:
  - `conforme`
  - `no_conforme`
- `descripcion`: observaciones opcionales del movimiento.

```text
stock_otro_unidades =
    suma(ingresos)
    - suma(egresos)

stock_disponible_produccion =
    suma(ingresos conforme)
    - suma(egresos)
```

## Restricciones e índices

```text
CHECK mov_otros.movimiento IN ('ingreso', 'egreso')
CHECK mov_otros.control_calidad IN ('conforme', 'no_conforme')
CHECK mov_otros.cantidad_unidades > 0

INDEX mov_otros.fecha_registro
INDEX mov_otros.movimiento
INDEX mov_otros.id_otro
INDEX mov_otros.id_empresa
INDEX mov_otros.control_calidad
```

## Relaciones

```text
mov_otros.id_otro → otros.id
mov_otros.id_empresa → empresas.id
mov_otros.creado_por → usuarios.id
```

---

# Tabla: mov_otro_comprobante_imagenes

Almacena hasta 2 imágenes del comprobante asociadas a cada movimiento de otro.

```text
mov_otro_comprobante_imagenes {

    id: INTEGER (PK)

    id_mov_otro: INTEGER (FK mov_otros.id) NOT NULL

    ruta_archivo: VARCHAR(255) NOT NULL

    nombre_original: VARCHAR(150)

    formato: VARCHAR(10) NOT NULL

    orden: INTEGER NOT NULL

    fecha_registro: TIMESTAMP NOT NULL

}
```

## Descripción de campos

- `id`: identificador único de la imagen.
- `id_mov_otro`: movimiento al que pertenece la imagen.
- `ruta_archivo`: ubicación relativa del archivo almacenado por el sistema.
- `nombre_original`: nombre del archivo cargado por el usuario.
- `formato`: extensión normalizada del archivo, por ejemplo `png`, `jpg` o `webp`.
- `orden`: posición de la imagen dentro del movimiento, de 1 a 2.
- `fecha_registro`: fecha y hora de carga de la imagen.

## Restricciones e índices

```text
CHECK mov_otro_comprobante_imagenes.orden BETWEEN 1 AND 2
UNIQUE (id_mov_otro, orden)

INDEX mov_otro_comprobante_imagenes.id_mov_otro
```

Un movimiento podrá tener como máximo 2 imágenes de comprobante.

## Relación

```text
mov_otro_comprobante_imagenes.id_mov_otro
    ↓
mov_otros.id
```

Al eliminar físicamente un movimiento deberán eliminarse también sus imágenes de comprobante y los archivos correspondientes del almacenamiento.

---

# Tabla: mov_otro_imagenes

Almacena hasta 5 imágenes del insumo asociadas a cada movimiento de otro.

```text
mov_otro_imagenes {

    id: INTEGER (PK)

    id_mov_otro: INTEGER (FK mov_otros.id) NOT NULL

    ruta_archivo: VARCHAR(255) NOT NULL

    nombre_original: VARCHAR(150)

    formato: VARCHAR(10) NOT NULL

    orden: INTEGER NOT NULL

    fecha_registro: TIMESTAMP NOT NULL

}
```

## Descripción de campos

- `id`: identificador único de la imagen.
- `id_mov_otro`: movimiento al que pertenece la imagen.
- `ruta_archivo`: ubicación relativa del archivo almacenado por el sistema.
- `nombre_original`: nombre del archivo cargado por el usuario.
- `formato`: extensión normalizada del archivo, por ejemplo `png`, `jpg` o `webp`.
- `orden`: posición de la imagen dentro del movimiento, de 1 a 5.
- `fecha_registro`: fecha y hora de carga de la imagen.

## Restricciones e índices

```text
CHECK mov_otro_imagenes.orden BETWEEN 1 AND 5
UNIQUE (id_mov_otro, orden)

INDEX mov_otro_imagenes.id_mov_otro
```

Un movimiento podrá tener como máximo 5 imágenes del insumo.

## Relación

```text
mov_otro_imagenes.id_mov_otro
    ↓
mov_otros.id
```

Al eliminar físicamente un movimiento deberán eliminarse también sus imágenes del insumo y los archivos correspondientes del almacenamiento.

---

# Tabla: mov_productos

Registra los movimientos de ingreso y egreso de productos terminados del depósito.

```text
mov_productos {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id) NOT NULL

    movimiento: VARCHAR(20) NOT NULL

    id_categoria: INTEGER (FK categorias.id) NOT NULL

    id_producto: INTEGER (FK productos.id) NOT NULL

    lote: VARCHAR(50) NOT NULL

    cantidad_unidades: NUMERIC(12,3) NOT NULL

    capacidad_unidad: NUMERIC(12,3) NOT NULL

    unidades_por_pallet: NUMERIC(12,3) NOT NULL

    cantidad_pallets: NUMERIC(12,3) NOT NULL

    cantidad_pesaje: NUMERIC(12,3) NOT NULL

    comprobante: VARCHAR(50)

    control_calidad: VARCHAR(20) NOT NULL

    descripcion: TEXT

}
```

Las imágenes no se almacenan dentro de esta tabla. Se registran en `mov_producto_comprobante_imagenes` y `mov_producto_imagenes`.

## Descripción de campos

- `id`: identificador único del movimiento.
- `fecha_registro`: fecha y hora de alta del movimiento.
- `creado_por`: usuario que registró el movimiento.
- `movimiento`: tipo de operación. Valores permitidos:
  - `ingreso`
  - `egreso`
- `id_categoria`: categoría del producto al momento del movimiento.
- `id_producto`: producto movido.
- `lote`: número de lote del producto terminado. Identidad lógica: `(id_producto, lote)`.
- `cantidad_unidades`: cantidad de unidades ingresadas o egresadas.
- `capacidad_unidad`: kilogramos por unidad.
- `unidades_por_pallet`: unidades que conforman un pallet.
- `cantidad_pallets`: valor calculado `cantidad_unidades / unidades_por_pallet`.
- `cantidad_pesaje`: valor calculado `cantidad_unidades * capacidad_unidad` (kg).
- `comprobante`: número de remito, factura u otro documento asociado.
- `control_calidad`: resultado del control. Valores permitidos:
  - `conforme`
  - `no_conforme`
- `descripcion`: observaciones opcionales del movimiento.

```text
stock_unidades = suma(ingresos unidades) - suma(egresos unidades)
stock_kg = suma(ingresos pesaje) - suma(egresos pesaje)
```

## Restricciones e índices

```text
CHECK mov_productos.movimiento IN ('ingreso', 'egreso')
CHECK mov_productos.control_calidad IN ('conforme', 'no_conforme')
CHECK mov_productos.cantidad_unidades > 0
CHECK mov_productos.capacidad_unidad > 0
CHECK mov_productos.unidades_por_pallet > 0
CHECK mov_productos.cantidad_pallets > 0
CHECK mov_productos.cantidad_pesaje > 0

INDEX mov_productos.fecha_registro
INDEX mov_productos.movimiento
INDEX mov_productos.id_categoria
INDEX mov_productos.id_producto
INDEX mov_productos.lote
INDEX mov_productos.control_calidad
INDEX (id_producto, lote)
```

## Relaciones

```text
mov_productos.id_categoria → categorias.id
mov_productos.id_producto → productos.id
mov_productos.creado_por → usuarios.id
```

---

# Tabla: mov_producto_comprobante_imagenes

Almacena hasta 2 imágenes del comprobante asociadas a cada movimiento de producto.

```text
mov_producto_comprobante_imagenes {

    id: INTEGER (PK)

    id_mov_producto: INTEGER (FK mov_productos.id) NOT NULL

    ruta_archivo: VARCHAR(255) NOT NULL

    nombre_original: VARCHAR(150)

    formato: VARCHAR(10) NOT NULL

    orden: INTEGER NOT NULL

    fecha_registro: TIMESTAMP NOT NULL

}
```

## Restricciones e índices

```text
CHECK mov_producto_comprobante_imagenes.orden BETWEEN 1 AND 2
UNIQUE (id_mov_producto, orden)

INDEX mov_producto_comprobante_imagenes.id_mov_producto
```

## Relación

```text
mov_producto_comprobante_imagenes.id_mov_producto → mov_productos.id
```

Al eliminar físicamente un movimiento deberán eliminarse también sus imágenes de comprobante y los archivos correspondientes.

---

# Tabla: mov_producto_imagenes

Almacena hasta 5 imágenes del producto asociadas a cada movimiento.

```text
mov_producto_imagenes {

    id: INTEGER (PK)

    id_mov_producto: INTEGER (FK mov_productos.id) NOT NULL

    ruta_archivo: VARCHAR(255) NOT NULL

    nombre_original: VARCHAR(150)

    formato: VARCHAR(10) NOT NULL

    orden: INTEGER NOT NULL

    fecha_registro: TIMESTAMP NOT NULL

}
```

## Restricciones e índices

```text
CHECK mov_producto_imagenes.orden BETWEEN 1 AND 5
UNIQUE (id_mov_producto, orden)

INDEX mov_producto_imagenes.id_mov_producto
```

## Relación

```text
mov_producto_imagenes.id_mov_producto → mov_productos.id
```

Al eliminar físicamente un movimiento deberán eliminarse también sus imágenes de producto y los archivos correspondientes.

---

# Tabla: reservas

Registra el stock apartado por ejecuciones de producción en curso. Es la fuente de verdad del stock reservado para el cálculo de disponibilidad.

```text
reservas {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id) NOT NULL

    id_ejecucion: INTEGER (FK ejecuciones.id) NOT NULL

    origen: VARCHAR(20) NOT NULL

    id_dosificacion: INTEGER (FK dosificaciones.id)

    id_consumible: INTEGER (FK consumibles.id)

    tipo_recurso: VARCHAR(20) NOT NULL

    id_ingrediente: INTEGER (FK ingredientes.id)

    id_envase: INTEGER (FK envases.id)

    id_oblea: INTEGER (FK obleas.id)

    id_otro: INTEGER (FK otros.id)

    lote: VARCHAR(50)

    cantidad: NUMERIC(12,3) NOT NULL

    unidad: VARCHAR(10) NOT NULL

    estado: VARCHAR(20) NOT NULL DEFAULT 'activa'

    fecha_cambio_estado: TIMESTAMP

    id_mov_ingrediente: INTEGER (FK mov_ingredientes.id)

    id_mov_envase: INTEGER (FK mov_envases.id)

    id_mov_oblea: INTEGER (FK mov_obleas.id)

    id_mov_otro: INTEGER (FK mov_otros.id)

    descripcion: TEXT

}
```

## Descripción de campos

- `id`: identificador único de la reserva.
- `fecha_registro`: fecha y hora de creación de la reserva.
- `creado_por`: usuario que generó o confirmó la reserva.
- `id_ejecucion`: ejecución de producción que originó la reserva.
- `origen`: origen operativo. Valores permitidos:
  - `dosificacion`
  - `consumible`
- `id_dosificacion`: fila de dosificación asociada. Obligatoria cuando `origen = dosificacion`.
- `id_consumible`: fila de consumible asociada. Obligatoria cuando `origen = consumible`.
- `tipo_recurso`: recurso reservado. Valores permitidos:
  - `ingrediente`
  - `envase`
  - `oblea`
  - `otro`
- `id_ingrediente` / `id_envase` / `id_oblea` / `id_otro`: maestro del recurso. Solo uno aplica según `tipo_recurso`.
- `lote`: lote del ingrediente. Obligatorio solo cuando `tipo_recurso = ingrediente`.
- `cantidad`: cantidad reservada. En kilogramos para ingredientes; en unidades para envases, obleas y otros.
- `unidad`: unidad de la cantidad. Valores permitidos:
  - `kg`
  - `unidades`
- `estado`: estado de la reserva. Valores permitidos:
  - `activa`: resta del stock disponible
  - `convertida`: ya generó egreso al finalizar la ejecución
  - `liberada`: liberada por recálculo, edición o anulación
- `fecha_cambio_estado`: fecha y hora del último cambio de estado.
- `id_mov_ingrediente` / `id_mov_envase` / `id_mov_oblea` / `id_mov_otro`: egreso generado al convertir la reserva. Solo uno aplica según `tipo_recurso`, y únicamente cuando `estado = convertida`.
- `descripcion`: observación opcional.

Las reservas de consumibles se realizan por maestro (envase, oblea u otro), sin lote. El historial es inmutable: al liberar o convertir no se elimina el registro.

```text
stock_fisico     = ingresos - egresos
stock_disponible = stock_fisico - suma(reservas con estado = activa)
```

## Restricciones e índices

```text
CHECK reservas.origen IN ('dosificacion', 'consumible')
CHECK reservas.tipo_recurso IN ('ingrediente', 'envase', 'oblea', 'otro')
CHECK reservas.unidad IN ('kg', 'unidades')
CHECK reservas.estado IN ('activa', 'convertida', 'liberada')
CHECK reservas.cantidad > 0

CHECK (
    (tipo_recurso = 'ingrediente'
      AND id_ingrediente IS NOT NULL AND lote IS NOT NULL
      AND id_envase IS NULL AND id_oblea IS NULL AND id_otro IS NULL
      AND unidad = 'kg')
 OR (tipo_recurso = 'envase'
      AND id_envase IS NOT NULL
      AND id_ingrediente IS NULL AND id_oblea IS NULL AND id_otro IS NULL AND lote IS NULL
      AND unidad = 'unidades')
 OR (tipo_recurso = 'oblea'
      AND id_oblea IS NOT NULL
      AND id_ingrediente IS NULL AND id_envase IS NULL AND id_otro IS NULL AND lote IS NULL
      AND unidad = 'unidades')
 OR (tipo_recurso = 'otro'
      AND id_otro IS NOT NULL
      AND id_ingrediente IS NULL AND id_envase IS NULL AND id_oblea IS NULL AND lote IS NULL
      AND unidad = 'unidades')
)

CHECK (
    (origen = 'dosificacion' AND id_dosificacion IS NOT NULL AND id_consumible IS NULL)
 OR (origen = 'consumible' AND id_consumible IS NOT NULL AND id_dosificacion IS NULL)
)

CHECK (
    (estado <> 'convertida'
      AND id_mov_ingrediente IS NULL
      AND id_mov_envase IS NULL
      AND id_mov_oblea IS NULL
      AND id_mov_otro IS NULL)
 OR (estado = 'convertida' AND tipo_recurso = 'ingrediente' AND id_mov_ingrediente IS NOT NULL
      AND id_mov_envase IS NULL AND id_mov_oblea IS NULL AND id_mov_otro IS NULL)
 OR (estado = 'convertida' AND tipo_recurso = 'envase' AND id_mov_envase IS NOT NULL
      AND id_mov_ingrediente IS NULL AND id_mov_oblea IS NULL AND id_mov_otro IS NULL)
 OR (estado = 'convertida' AND tipo_recurso = 'oblea' AND id_mov_oblea IS NOT NULL
      AND id_mov_ingrediente IS NULL AND id_mov_envase IS NULL AND id_mov_otro IS NULL)
 OR (estado = 'convertida' AND tipo_recurso = 'otro' AND id_mov_otro IS NOT NULL
      AND id_mov_ingrediente IS NULL AND id_mov_envase IS NULL AND id_mov_oblea IS NULL)
)

INDEX reservas.id_ejecucion
INDEX reservas.estado
INDEX reservas.tipo_recurso
INDEX (id_ingrediente, lote, estado)
INDEX (id_envase, estado)
INDEX (id_oblea, estado)
INDEX (id_otro, estado)
INDEX reservas.id_dosificacion
INDEX reservas.id_consumible
```

## Relaciones

```text
reservas.id_ejecucion → ejecuciones.id
reservas.id_dosificacion → dosificaciones.id
reservas.id_consumible → consumibles.id
reservas.id_ingrediente → ingredientes.id
reservas.id_envase → envases.id
reservas.id_oblea → obleas.id
reservas.id_otro → otros.id
reservas.creado_por → usuarios.id
reservas.id_mov_ingrediente → mov_ingredientes.id
reservas.id_mov_envase → mov_envases.id
reservas.id_mov_oblea → mov_obleas.id
reservas.id_mov_otro → mov_otros.id
```

## Ciclo de vida

```text
Confirmar dosificaciones / consumibles
        ↓
Crear filas reservas (estado = activa)
        ↓
stock_disponible descuenta esas cantidades
        ↓
┌──────────────────┬────────────────────────────┐
│ Recalcular/editar│ Finalizar ejecución         │
│ → estado=liberada│ → crear egreso en mov_*     │
│                  │ → estado=convertida         │
│                  │ → guardar id_mov_*          │
└──────────────────┴────────────────────────────┘
```

---

# Tabla: mantenimientos

Registra las tareas de mantenimiento asociadas a sectores, equipos, vehículos u otros elementos de la planta.

```text
mantenimientos {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id) NOT NULL

    id_sector_equipo: INTEGER (FK sectores_equipos.id) NOT NULL

    tipo: VARCHAR(20) NOT NULL

    fecha_programada: DATE NOT NULL

    fecha_realizacion: DATE

    estado: VARCHAR(20) NOT NULL DEFAULT 'programado'

    responsable: VARCHAR(150) NOT NULL

    descripcion: TEXT NOT NULL

    observacion: TEXT

}
```

Las imágenes no se almacenan dentro de esta tabla. Se registran en `mantenimiento_imagenes`.

## Descripción de campos

- `id`: identificador único del mantenimiento.
- `fecha_registro`: fecha y hora de alta.
- `creado_por`: usuario que registró el mantenimiento.
- `id_sector_equipo`: sector, equipo, vehículo u otro elemento mantenido.
- `tipo`: clasificación del trabajo. Valores permitidos:
  - `preventivo`
  - `correctivo`
  - `calibracion`
  - `otro`
- `fecha_programada`: fecha planificada.
- `fecha_realizacion`: fecha en que se ejecutó. Obligatoria al finalizar.
- `estado`: flujo operativo. Valores permitidos:
  - `programado`
  - `en_curso`
  - `finalizado`
  - `cancelado`
- `responsable`: técnico o área responsable.
- `descripcion`: detalle del trabajo.
- `observacion`: notas opcionales.

## Restricciones e índices

```text
CHECK mantenimientos.tipo IN ('preventivo', 'correctivo', 'calibracion', 'otro')
CHECK mantenimientos.estado IN ('programado', 'en_curso', 'finalizado', 'cancelado')
CHECK (
    (estado = 'finalizado' AND fecha_realizacion IS NOT NULL)
 OR (estado <> 'finalizado')
)

INDEX mantenimientos.id_sector_equipo
INDEX mantenimientos.tipo
INDEX mantenimientos.fecha_programada
INDEX mantenimientos.estado
INDEX mantenimientos.responsable
```

## Relaciones

```text
mantenimientos.id_sector_equipo → sectores_equipos.id
mantenimientos.creado_por → usuarios.id
```

---

# Tabla: mantenimiento_imagenes

Almacena hasta 4 imágenes de evidencia asociadas a cada mantenimiento.

```text
mantenimiento_imagenes {

    id: INTEGER (PK)

    id_mantenimiento: INTEGER (FK mantenimientos.id) NOT NULL

    ruta_archivo: VARCHAR(255) NOT NULL

    nombre_original: VARCHAR(150)

    formato: VARCHAR(10) NOT NULL

    orden: INTEGER NOT NULL

    fecha_registro: TIMESTAMP NOT NULL

}
```

## Restricciones e índices

```text
CHECK mantenimiento_imagenes.orden BETWEEN 1 AND 4
UNIQUE (id_mantenimiento, orden)

INDEX mantenimiento_imagenes.id_mantenimiento
```

## Relación

```text
mantenimiento_imagenes.id_mantenimiento → mantenimientos.id
```

Al eliminar físicamente un mantenimiento deberán eliminarse también sus imágenes y archivos.

---

# Tabla: reportes_generados

Registra el historial de exportaciones e impresiones realizadas desde el módulo Reportes.

```text
reportes_generados {

    id: INTEGER (PK)

    fecha_registro: TIMESTAMP NOT NULL

    creado_por: INTEGER (FK usuarios.id) NOT NULL

    codigo_reporte: VARCHAR(80) NOT NULL

    parametros: TEXT

    formato: VARCHAR(20) NOT NULL

    cantidad_filas: INTEGER

    descripcion: TEXT

}
```

## Descripción de campos

- `id`: identificador único del registro.
- `fecha_registro`: fecha y hora de la exportación o impresión.
- `creado_por`: usuario que generó el reporte.
- `codigo_reporte`: identificador del reporte del catálogo de aplicación, por ejemplo `stock_ingredientes` o `ejecuciones_periodo`.
- `parametros`: filtros utilizados, preferentemente en JSON texto.
- `formato`: formato de salida. Valores permitidos:
  - `csv`
  - `xlsx`
  - `pdf`
  - `impresion`
- `cantidad_filas`: cantidad de filas incluidas, cuando aplique.
- `descripcion`: observación opcional.

No existe tabla maestra de reportes en la versión inicial: el catálogo vive en la aplicación.

## Restricciones e índices

```text
CHECK reportes_generados.formato IN ('csv', 'xlsx', 'pdf', 'impresion')
CHECK reportes_generados.cantidad_filas IS NULL OR reportes_generados.cantidad_filas >= 0

INDEX reportes_generados.fecha_registro
INDEX reportes_generados.creado_por
INDEX reportes_generados.codigo_reporte
INDEX reportes_generados.formato
```

## Relaciones

```text
reportes_generados.creado_por → usuarios.id
```

---

# Tabla: configuraciones

Almacena parámetros generales del sistema en formato clave-valor tipado.

```text
configuraciones {

    id: INTEGER (PK)

    clave: VARCHAR(100) UNIQUE NOT NULL

    valor: TEXT NOT NULL

    tipo: VARCHAR(20) NOT NULL

    descripcion: TEXT

    fecha_actualizacion: TIMESTAMP NOT NULL

    actualizado_por: INTEGER (FK usuarios.id)

}
```

## Descripción de campos

- `id`: identificador único.
- `clave`: identificador técnico único, por ejemplo `planta.nombre`.
- `valor`: valor almacenado como texto; se interpreta según `tipo`.
- `tipo`: tipo de dato. Valores permitidos:
  - `texto`
  - `numero`
  - `booleano`
  - `json`
- `descripcion`: explicación del efecto de la configuración.
- `fecha_actualizacion`: última modificación del valor.
- `actualizado_por`: usuario que realizó la última modificación.

Las claves iniciales se siembran en la instalación. En la versión inicial la UI solo permite editar valores, no crear ni eliminar claves.

## Restricciones e índices

```text
configuraciones.clave (UNIQUE)
CHECK configuraciones.tipo IN ('texto', 'numero', 'booleano', 'json')

INDEX configuraciones.clave
INDEX configuraciones.tipo
```

## Relaciones

```text
configuraciones.actualizado_por → usuarios.id
```

