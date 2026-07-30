# Módulo: Usuarios

## Objetivo

Administrar los usuarios del sistema, sus roles y los permisos de acceso a cada módulo.

Este módulo controla la autenticación, autorización y administración de usuarios, garantizando que cada persona acceda únicamente a las funcionalidades permitidas según su rol.

---

# Tablas involucradas

- usuarios
- roles
- pantallas
- permisos
- rol_permisos

> La estructura de estas tablas se encuentra documentada en `01_estructura.md`.

---

# Funcionalidades

## Autenticación

- Iniciar sesión.
- Cerrar sesión.
- Cambio de contraseña.
- Recuperación de contraseña (futuro).
- Cierre automático por inactividad (futuro).

---

## Gestión de usuarios

- Crear usuario.
- Editar usuario.
- Activar usuario.
- Desactivar usuario.
- Consultar usuarios.
- Buscar usuarios.
- Filtrar usuarios.
- Visualizar historial de accesos (futuro).

> Los usuarios no podrán eliminarse físicamente. Solo podrán desactivarse.

---

## Gestión de roles

- Crear rol.
- Editar rol.
- Asignar permisos.
- Consultar permisos del rol.

---

## Gestión de permisos

- Asignar permisos a un rol.
- Modificar permisos de un rol.
- Consultar permisos por pantalla.
- Consultar permisos por acción.

---

# Pantallas

- Login
- Inicio
- Usuarios
- Nuevo Usuario
- Editar Usuario
- Roles
- Permisos

---

# Flujo del módulo

```text
Inicio

↓

Login

↓

Validación de usuario

↓

Validación de contraseña

↓

Usuario activo

↓

Carga del rol

↓

Carga de permisos

↓

Ingreso al sistema
```

---

# Validaciones

## Usuario

- Obligatorio.
- Único.
- Máximo 30 caracteres.
- No permitir espacios al inicio o al final.

---

## Contraseña

- Obligatoria.
- Mínimo 8 caracteres.
- Al menos una letra mayúscula.
- Al menos una letra minúscula.
- Al menos un número.
- Al menos un carácter especial.
- No se permiten espacios.
- Se almacena únicamente como `password_hash`.

---

## Nombre

- Obligatorio.
- Máximo 50 caracteres.

---

## Apellido

- Obligatorio.
- Máximo 50 caracteres.

---

## Rol

- Obligatorio.
- Debe existir en la tabla `roles`.

---

## Estado

- Solo se permiten los valores:
  - Activo
  - Inactivo

---

# Permisos del módulo

Las acciones disponibles dependerán del rol asignado al usuario.

Permisos disponibles:

- Ver usuarios.
- Crear usuarios.
- Editar usuarios.
- Administrar roles.
- Administrar permisos.

---

# Reglas de negocio

- Cada usuario deberá tener un único rol asignado.
- El nombre de usuario deberá ser único.
- Solo los usuarios activos podrán iniciar sesión.
- Las contraseñas nunca se almacenarán en texto plano.
- Todos los permisos se obtendrán a través del rol asignado.
- No se asignarán permisos directamente a un usuario.
- Los usuarios no podrán eliminarse físicamente.
- El usuario administrador inicial deberá cambiar su contraseña en el primer inicio de sesión.

---

# Auditoría

El módulo deberá registrar, cuando corresponda:

- Fecha de creación.
- Usuario creador.
- Usuario que realizó la última modificación.
- Último acceso al sistema.

---

# Relaciones

Este módulo se relaciona con todos los demás módulos del sistema mediante el control de acceso.

Todo usuario autenticado deberá poseer permisos para acceder a cada pantalla y ejecutar cada acción.

---

# Mejoras futuras

- Recuperación de contraseña mediante correo electrónico.
- Bloqueo temporal por intentos fallidos de inicio de sesión.
- Doble factor de autenticación (2FA).
- Registro de historial de accesos.
- Registro de auditoría de acciones realizadas por cada usuario.
- Gestión de sesiones activas.
- Política de vencimiento de contraseñas.
- Configuración de complejidad de contraseñas.

---

# Observaciones

- El detalle del Login, datos de ingreso y conexión a la base de datos se encuentra en `modulos/login.md`.
- La definición de las tablas utilizadas por este módulo se encuentra en `01_estructura.md`.
- Los datos iniciales (roles, pantallas y permisos) se encuentran en `02_datos_iniciales.md`.
- Las reglas generales del sistema se encuentran en `03_reglas_generales.md`.
- Este módulo es obligatorio para el funcionamiento del sistema, ya que controla la autenticación y autorización de todos los usuarios.
