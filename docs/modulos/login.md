# Módulo: Login

## Objetivo

Permitir el acceso seguro al sistema mediante la validación de las credenciales del usuario y establecer el vínculo entre la aplicación (frontend / escritorio) y la base de datos PostgreSQL a través del backend.

Este documento detalla:

1. Qué datos debe cargar el usuario para ingresar.
2. Cómo se valida la autenticación.
3. Cómo se establecen las conexiones con la base de datos.
4. Qué información queda disponible en sesión tras un ingreso correcto.
5. La presencia del ícono de descarga local en la pantalla de Login (el detalle de su funcionamiento se documenta aparte).

---

# Tablas involucradas

- usuarios
- roles
- pantallas
- permisos
- rol_permisos

> La estructura de estas tablas se encuentra documentada en `01_estructura.md`.  
> La administración de usuarios, roles y permisos se documenta en `modulos/usuarios.md`.

El Login **no posee tablas propias**. Opera exclusivamente sobre el maestro de usuarios y su cadena de permisos.

---

# Pantalla

- Login (única pantalla pública del sistema, accesible sin sesión).

Tras un ingreso exitoso, el usuario es dirigido a **Inicio**.

## Ícono de descarga local

La pantalla de Login deberá mostrar un ícono que permita **descargar el sistema localmente**.

- El ícono será visible sin necesidad de iniciar sesión.
- Su ubicación sugerida es un área secundaria de la pantalla (por ejemplo, esquina inferior o superior), sin competir con el formulario de Usuario y Contraseña.
- Deberá tener texto accesible / tooltip claro, por ejemplo: `Descargar sistema local`.
- El detalle del funcionamiento de ese ícono (qué descarga, requisitos, instalación y flujo) se encuentra en `modulos/descarga_local.md`.

---

# Datos que debe cargar el usuario

El formulario de Login solicitará únicamente dos campos:

| Campo | Tipo | Obligatorio | Descripción |
|---|---|---|---|
| Usuario | Texto | Sí | Nombre de usuario registrado en `usuarios.usuario` |
| Contraseña | Contraseña | Sí | Contraseña en texto claro solo en el formulario; nunca se almacena así |

## Campo 01 - Usuario

- Obligatorio.
- Máximo 30 caracteres.
- Sin espacios al inicio ni al final.
- Se compara contra `usuarios.usuario` (único).
- La comparación deberá ignorar diferencias accidentales de espacios extremos; mayúsculas/minúsculas se tratarán de forma consistente (recomendación: almacenar y comparar en la misma normalización definida al crear el usuario).

## Campo 02 - Contraseña

- Obligatoria.
- Se envía al backend por canal seguro (HTTPS en entorno remoto; en local, dentro del canal de la app).
- El backend **nunca** compara la contraseña en texto plano contra la base.
- Se verifica mediante el algoritmo de hash seguro almacenado en `usuarios.password_hash`.

## Datos que el usuario NO carga en el Login

- Nombre o apellido.
- Rol.
- Permisos.
- Datos de conexión a la base de datos.
- Nombre de la base, host, puerto o credenciales de PostgreSQL.

Esos datos los resuelve el sistema automáticamente.

---

# Flujo de autenticación

```text
Usuario abre la aplicación

↓

Pantalla Login

↓

Ingresa Usuario + Contraseña

↓

Frontend envía credenciales al Backend (API)

↓

Backend abre/utiliza conexión a PostgreSQL

↓

Busca el registro en usuarios por usuario

↓

¿Existe y estado = activo?

↓ No → rechazar ingreso
↓ Sí

Verificar contraseña contra password_hash

↓ No coincide → rechazar ingreso
↓ Sí

Cargar rol (id_rol → roles)

↓

Cargar permisos del rol (rol_permisos → permisos → pantallas)

↓

Actualizar usuarios.ultimo_acceso

↓

Emitir sesión / token al frontend

↓

Frontend guarda la sesión y navega a Inicio
```

---

# Validaciones de ingreso

- Usuario obligatorio.
- Contraseña obligatoria.
- El usuario debe existir.
- El usuario debe estar activo (`estado = true`).
- La contraseña debe coincidir con `password_hash`.
- El usuario debe tener un rol asignado.
- Mensajes sugeridos (sin revelar qué falló exactamente, por seguridad):
  - `Usuario o contraseña incorrectos.`
  - `El usuario se encuentra inactivo. Contacte al administrador.`

No deberá indicarse si falló el usuario o la contraseña por separado, salvo el caso explícito de usuario inactivo cuando las credenciales sean válidas (opcional; por defecto se puede unificar el mensaje).

---

# Reglas de negocio

- Solo usuarios activos pueden iniciar sesión.
- Las contraseñas nunca se almacenan ni se registran en logs en texto plano.
- Cada sesión autenticada carga los permisos del rol; no hay permisos directos por usuario.
- El administrador inicial deberá cambiar su contraseña en el primer ingreso (ver `02_datos_iniciales.md`).
- Al cerrar sesión se invalida el token/sesión en el cliente y, si aplica, en el servidor.
- Toda operación posterior al Login deberá enviarse con la sesión autenticada.

---

# Conexión con la base de datos

## Principio

El usuario final **no configura ni ve** la conexión a PostgreSQL desde el Login.

La conexión la establece el **backend** (FastAPI + SQLAlchemy) usando parámetros de entorno / configuración del servidor o de la instalación local.

```text
┌──────────────────────┐
│ Frontend (React)     │
│ App escritorio Tauri │
└──────────┬───────────┘
           │ HTTP / API (JSON)
           │ credenciales de Login
           │ luego: token de sesión
           ▼
┌──────────────────────┐
│ Backend (FastAPI)    │
│ SQLAlchemy / Alembic │
└──────────┬───────────┘
           │ conexión PostgreSQL
           │ (pool de conexiones)
           ▼
┌──────────────────────┐
│ PostgreSQL           │
│ Xereon_Produccion   │
└──────────────────────┘
```

## Responsabilidades por capa

### Frontend (React / Tauri)

- Mostrar el formulario de Login.
- Enviar `usuario` y `contraseña` al endpoint de autenticación.
- Guardar el token/sesión recibido.
- Adjuntar el token en las llamadas API posteriores.
- No contiene usuario/contraseña de PostgreSQL.
- No ejecuta SQL directo.

### Backend (FastAPI)

- Recibe las credenciales del Login.
- Usa el pool de conexiones a PostgreSQL.
- Consulta `usuarios`, verifica hash, carga rol y permisos.
- Devuelve el resultado de autenticación y el contexto de sesión.
- Es el único componente autorizado a hablar con la base de datos.

### Base de datos (PostgreSQL)

- Motor: PostgreSQL.
- Nombre de base: `Xereon_Produccion`.
- Persiste usuarios, roles, permisos y el resto de módulos.
- Expone un usuario técnico de aplicación (no el usuario de Login de negocio).

## Parámetros de conexión (backend)

La conexión se configurará mediante variables de entorno (o archivo `.env` local no versionado), por ejemplo:

```text
DB_HOST=localhost
DB_PORT=5432
DB_NAME=Xereon_Produccion
DB_USER=xereon_app
DB_PASSWORD=********
DB_DRIVER=postgresql+psycopg2
```

Cadena orientativa (SQLAlchemy):

```text
postgresql+psycopg2://DB_USER:DB_PASSWORD@DB_HOST:DB_PORT/DB_NAME
```

Reglas:

- Esos valores **no** se piden en la pantalla de Login.
- No se guardan en el frontend ni en el repositorio Git.
- En instalación local (Tauri + backend embebido o servicio local), el instalador o un archivo de configuración del entorno proveerá estos datos.
- En escenario remoto futuro, el frontend solo conocerá la URL del API; el API conocerá PostgreSQL.

## Pool de conexiones

- El backend mantendrá un pool de conexiones reutilizables (SQLAlchemy).
- Cada request autenticado no abre una conexión nueva “a mano” por pantalla: usa el pool.
- Las migraciones (Alembic) usan la misma configuración de base.

## Separación de credenciales

| Credencial | Quién la usa | Dónde vive |
|---|---|---|
| Usuario + contraseña de Login | Persona humana | Formulario → API → verificación contra `password_hash` |
| Usuario + contraseña de PostgreSQL | Backend | Variables de entorno / secreto del servidor |
| Token de sesión | Frontend + Backend | Memoria/almacenamiento seguro del cliente + validación server-side |

---

# Resultado de un Login exitoso

El backend deberá devolver al frontend, como mínimo:

- Identificador del usuario (`id`).
- Nombre y apellido (para mostrar en la interfaz).
- Nombre de usuario.
- Rol (`id_rol`, nombre del rol).
- Lista de permisos efectivos (pantalla + acción).
- Indicador de si debe cambiar la contraseña (primer ingreso del admin u obligación futura).
- Token / identificador de sesión.

Además actualizará:

- `usuarios.ultimo_acceso = ahora`

---

# Endpoint sugerido

```text
POST /api/auth/login
Body: { "usuario": "...", "password": "..." }

POST /api/auth/logout
Header: Authorization

GET /api/auth/me
Header: Authorization
```

Los nombres exactos podrán ajustarse en la implementación, manteniendo esta responsabilidad.

---

# Cierre de sesión

- Acción disponible desde la interfaz una vez autenticado.
- Invalida la sesión/token.
- Devuelve al usuario a la pantalla Login.
- No cierra la conexión del pool de PostgreSQL del backend (solo la sesión de negocio).

---

# Seguridad

- Comunicación frontend ↔ backend cifrada en despliegues remotos (HTTPS).
- Hash de contraseñas con algoritmo moderno (por ejemplo bcrypt o equivalente aprobado en implementación).
- No registrar contraseñas ni tokens completos en logs.
- Proteger el archivo `.env` y secretos de base.
- Futuro: bloqueo por intentos fallidos, 2FA y timeout por inactividad (ver `modulos/usuarios.md`).

---

# Relación con otros módulos

- **Usuarios:** alta de cuentas, roles y permisos.
- **Inicio y resto de módulos:** solo accesibles con sesión válida y permiso correspondiente.
- **Configuración:** parámetros globales; no reemplazan las variables de conexión a la base.

---

# Mejoras futuras

- Recuperación de contraseña.
- Bloqueo temporal por intentos fallidos.
- Doble factor de autenticación (2FA).
- Cierre automático por inactividad.
- Recordar usuario en el equipo (sin recordar contraseña).

---

# Historial de cambios

## 2026-07-30

- Creación inicial de la especificación del módulo Login.
- Definición de datos de ingreso del usuario.
- Definición del flujo de autenticación y de la conexión frontend → backend → PostgreSQL.
- Incorporación del ícono de descarga local en la pantalla de Login (detalle en `modulos/descarga_local.md`).

---

# Observaciones

- La estructura de `usuarios` y permisos se encuentra en `01_estructura.md`.
- La gestión administrativa de usuarios se encuentra en `modulos/usuarios.md`.
- Las reglas de contraseñas se encuentran en `03_reglas_generales.md`.
- El usuario administrador inicial se encuentra en `02_datos_iniciales.md`.
- El funcionamiento del ícono de descarga local se encuentra en `modulos/descarga_local.md`.
