# Reglas Generales

Este documento define las reglas generales de diseño, desarrollo y funcionamiento del sistema **Xereon**. Todas las funcionalidades y módulos deberán respetar estas reglas.

---

# Base de Datos

- El motor de base de datos será **PostgreSQL**.
- Todas las tablas tendrán una clave primaria llamada `id`.
- Todas las relaciones entre tablas se realizarán mediante claves foráneas (`FK`).
- Todas las tablas utilizarán nombres en plural.
- Todos los nombres de tablas y columnas se escribirán en minúsculas y separados por `_`.
- No se utilizarán espacios, acentos ni caracteres especiales en nombres de tablas o columnas.
- Los estados de activación utilizarán `BOOLEAN`.
- Los estados de flujo operativo utilizarán texto controlado mediante restricciones `CHECK`.
- Las columnas de fecha y hora utilizarán el tipo `TIMESTAMP`.
- Las tablas deberán mantener la integridad referencial.
- No se eliminarán registros que formen parte del historial del sistema. Siempre que sea posible se utilizará baja lógica mediante el campo `estado`.

---

# Identificadores

- Todas las tablas utilizarán un campo `id` como clave primaria.
- Todas las claves foráneas comenzarán con `id_`.
- Los identificadores serán generados automáticamente por la base de datos.

---

# Usuarios

- Todos los usuarios deberán poseer un rol asignado.
- Solo los usuarios activos podrán iniciar sesión.
- El nombre de usuario deberá ser único.
- Las contraseñas nunca se almacenarán en texto plano.
- Las contraseñas se almacenarán únicamente mediante un algoritmo de hash seguro.
- El usuario administrador inicial deberá cambiar su contraseña en el primer inicio de sesión.

---

# Contraseñas

Las contraseñas deberán cumplir como mínimo con los siguientes requisitos:

- 8 caracteres.
- Al menos una letra mayúscula.
- Al menos una letra minúscula.
- Al menos un número.
- Al menos un carácter especial.
- No se permiten espacios.

---

# Permisos

- Todos los permisos se asignarán mediante roles.
- Ningún usuario tendrá permisos asignados directamente.
- Un usuario podrá acceder únicamente a las funciones permitidas por su rol.
- Los permisos estarán definidos por pantalla y acción.

---

# Estados

Cuando un maestro utilice `estado` para su activación, se admitirán únicamente:

- `true` → Activo
- `false` → Inactivo

La interfaz será la responsable de mostrar los textos "Activo" o "Inactivo".

Los estados de flujo, como los de solicitudes y ejecuciones, podrán utilizar valores de texto. Cada tabla deberá documentar su lista cerrada y protegerla con una restricción `CHECK`.

---

# Auditoría

Siempre que corresponda, las tablas deberán registrar:

- fecha_creacion
- creado_por
- actualizado_por

Cuando sea necesario también podrán registrar:

- fecha_actualizacion
- fecha_eliminacion
- eliminado_por

---

# Interfaz

La interfaz del sistema deberá cumplir las siguientes reglas:

- Diseño uniforme en todos los módulos.
- Navegación consistente.
- Botones y acciones ubicados siempre en la misma posición.
- Formularios simples y de rápida utilización.
- Prioridad a la productividad del usuario.
- Compatible con resolución Full HD (1920 × 1080).

---

# Validaciones

Toda información ingresada por el usuario deberá validarse antes de almacenarse.

Como mínimo deberán validarse:

- Campos obligatorios.
- Longitud máxima.
- Formato.
- Duplicados.
- Relaciones entre tablas.
- Permisos del usuario.

Las validaciones deberán realizarse tanto en el frontend como en el backend.

---

# Eliminación de registros

No deberán eliminarse registros que formen parte del funcionamiento del sistema.

Siempre que sea posible se utilizará:

- Baja lógica (`estado = false`).

Solo podrán eliminarse físicamente registros cuando:

- No existan relaciones con otras tablas.
- No formen parte del historial.
- La operación sea autorizada por un usuario con permisos suficientes.

---

# Documentación

Cada módulo deberá contar con su propia documentación.

Como mínimo deberá incluir:

- Objetivo.
- Tablas involucradas.
- Relaciones.
- Pantallas.
- Funcionalidades.
- Validaciones.
- Permisos.
- Flujo de trabajo.
- Historial de cambios.

---

# Código

El código deberá respetar las siguientes reglas:

- Una responsabilidad por archivo.
- Componentes reutilizables.
- Nombres descriptivos.
- Evitar código duplicado.
- Mantener una estructura uniforme en todo el proyecto.
- Documentar únicamente cuando la lógica no sea evidente.

---

# Seguridad

- Nunca almacenar contraseñas en texto plano.
- Nunca mostrar información sensible al usuario.
- Validar todos los datos recibidos.
- Respetar siempre los permisos del usuario autenticado.
- Registrar los errores críticos del sistema.

---

# Escalabilidad

Todas las nuevas funcionalidades deberán diseñarse considerando:

- Reutilización de código.
- Crecimiento futuro del sistema.
- Facilidad de mantenimiento.
- Compatibilidad con nuevos módulos.

---

# Convención para nuevos módulos

Todo nuevo módulo deberá incorporar, como mínimo:

- Estructura de tablas.
- Datos iniciales (si corresponde).
- Reglas de negocio.
- Documentación del módulo.
- Validaciones.
- Permisos.
- Pantallas.
- Flujo de trabajo.

---

# Stock

Cuando un módulo administre insumos o productos con existencia física, su listado deberá mostrar el stock disponible.

Unidades por tipo:

- Ingredientes: kg.
- Envases: unidades.
- Obleas: unidades.
- Otros insumos: unidades.
- Productos: unidades y kg.

El stock se calculará a partir de ingresos y egresos:

```text
stock = suma(ingresos) - suma(egresos)
```

No deberá cargarse manualmente en el alta del maestro. El detalle de movimientos de ingredientes, envases, obleas, otros y productos se encuentra en `modulos/movimientos.md`.

Cuando una operación en curso reserve existencias:

```text
stock_disponible = stock - suma(reservas con estado = activa)
```

- La fuente de verdad de las reservas es la tabla `reservas` (ver `01_estructura.md` y `modulos/movimientos.md`).
- La consulta y reserva deberán realizarse dentro de una transacción.
- Al finalizar la operación, la reserva se convertirá en egreso (`estado = convertida`).
- Al recalcular o anular la operación, la reserva deberá liberarse (`estado = liberada`) sin borrar el historial.
- Ninguna reserva podrá generar stock disponible negativo.

---

# Objetivo General

El sistema deberá desarrollarse siguiendo criterios de simplicidad, mantenibilidad, seguridad y escalabilidad, priorizando siempre la integridad de la información y la productividad de los usuarios.