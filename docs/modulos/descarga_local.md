# Descarga e instalación local

## Objetivo

Definir el funcionamiento del ícono **Descargar sistema local** presente en la pantalla de Login, y el asistente de instalación que permite dejar Xereon operativo en un equipo Windows de forma guiada, segura y auditable.

Este proceso **no requiere iniciar sesión**.

---

# Alcance y modo de entrega

El Login (posible entorno web o app) **no instala herramientas directamente en el PC** desde el navegador.

Flujo de entrega recomendado:

1. El usuario hace clic en el ícono de descarga en Login.
2. Se muestra el asistente inicial (requisitos + avisos legales).
3. Tras aceptar, se descarga el **instalador local** de Xereon (por ejemplo `.exe` / `.msi`).
4. El usuario ejecuta el instalador en Windows (con permisos de administrador cuando haga falta).
5. El instalador ejecuta el resto del flujo: carpeta, herramientas, base de datos, archivos, acceso directo y cierre.

> El detalle técnico de empaquetado del instalador se definirá en la implementación. La especificación funcional de este documento es la referencia de comportamiento.

---

# Punto de entrada

- Pantalla: **Login**
- Control: ícono `Descargar sistema local`
- Documentación del Login: `modulos/login.md`
- Herramientas de referencia: `05_Lenguajes_herramientas.md`
- Estructura de carpetas: `06_Estructura_del_proyecto.md`

---

# Requisitos mínimos del equipo

Antes de avanzar, el asistente deberá informar como mínimo:

| Requisito | Valor sugerido |
|---|---|
| Sistema operativo | Windows 10 o 11 (64 bit) |
| Memoria RAM | 8 GB o más (mínimo usable: 4 GB) |
| Espacio en disco | 5 GB libres o más (recomendado: 10 GB) |
| Permisos | Administrador del equipo para instalar motores/servicios |
| Conexión | Internet para descargar el instalador y componentes faltantes |
| Arquitectura | x64 |

Los valores exactos podrán ajustarse al cerrar el tamaño del paquete final.

---

# Flujo general del asistente

```text
Clic en ícono (Login)

↓

Paso 1 — Requisitos + avisos legales → Aceptar

↓

Descarga / ejecución del instalador local

↓

Paso 2 — Elegir carpeta raíz de instalación

↓

Paso 3 — Resumen de acciones + modo de instalación

↓

Paso 4 — Análisis de herramientas del equipo (checklist)

↓

Paso 5 — Confirmar instalación de faltantes (aceptar / rechazar / guía)

↓

Paso 6 — Panel de avance unificado
         (archivos → herramientas aceptadas → base de datos → acceso directo)

↓

Paso 7 — Crear acceso directo (Sí / No)

↓

Paso 8 — Mensaje de finalización + siguientes pasos
```

---

# Paso 1 — Requisitos y avisos legales

Antes de descargar o instalar cualquier cosa, el sistema deberá mostrar un **panel obligatorio** con dos bloques:

## 1.1 Requisitos del sistema

- Lista clara de requisitos mínimos (tabla anterior).
- Aviso de que la instalación puede requerir permisos de administrador.
- Aviso de que se pueden instalar componentes de terceros (por ejemplo PostgreSQL, runtimes).
- Espacio estimado a utilizar.
- Enlace o referencia a la guía de herramientas (`05_Lenguajes_herramientas.md` / equivalente en el instalador).

## 1.2 Avisos legales

El panel deberá incluir, como mínimo, texto orientado a resguardo legal futuro sobre:

- Licencia de uso del software Xereon (términos de uso).
- Que el software se entrega “tal cual” en la medida que defina la licencia.
- Responsabilidad del usuario/organización sobre el uso productivo, respaldo de datos y cumplimiento normativo interno.
- Tratamiento de datos: la instalación local almacena información en el equipo y/o servidor local del cliente; el proveedor no accede a esos datos salvo acuerdo distinto.
- Componentes de terceros: licencias propias (PostgreSQL, Python, Node, etc.) que el usuario acepta al instalarlos.
- Prohibición de redistribución no autorizada del instalador o del código, según la licencia definida.
- Consentimiento informado para modificar el equipo (instalación de software, creación de servicios, escritura en disco).

> El texto legal definitivo deberá ser revisado/aprobado por quien corresponda legalmente. Este documento fija la **obligación de mostrarlo y exigir aceptación**, no el articulado final.

## 1.3 Controles del paso

- Casilla obligatoria: `He leído y acepto los requisitos y los términos legales.`
- Botones:
  - `Cancelar` → cierra el asistente sin descargar.
  - `Aceptar y continuar` → habilitado solo con la casilla marcada.

Sin aceptación completa **no** se descarga el instalador ni se modifica el equipo.

---

# Paso 2 — Ubicación de la carpeta raíz

Inmediatamente después de aceptar el Paso 1 (y al iniciar el instalador local), se pedirá dónde guardar la instalación.

## Comportamiento

- El sistema **sugiere** una ruta por defecto, por ejemplo:

```text
C:\Xereon\
```

o

```text
C:\Program Files\Xereon\
```

- El usuario podrá **aceptar la sugerida** o **elegir otra ubicación** (diálogo de carpeta).
- Se validará:
  - permisos de escritura;
  - espacio libre suficiente;
  - que la ruta no apunte a un medio no apto (según reglas del instalador).

## Si la carpeta ya existe

- Detectar instalación previa.
- Opciones sugeridas:
  - Cancelar
  - Elegir otra carpeta
  - Actualizar / reparar (sin borrar datos de negocio, salvo confirmación explícita)
- **Nunca** borrar una base de datos o carpeta de datos existente sin confirmación fuerte.

La estructura creada deberá respetar `06_Estructura_del_proyecto.md` (`backend`, `frontend`, `docs`, etc., según el paquete de distribución local).

---

# Paso 3 — Resumen previo y modo de instalación

Antes de ejecutar acciones invasivas, mostrar un **resumen** de lo que se hará:

- Carpeta destino elegida.
- Componentes a verificar/instalar.
- Creación de base de datos `Xereon_Produccion` (si corresponde).
- Creación opcional de acceso directo.
- Espacio estimado / tiempo estimado (si se puede calcular).

## Modos de instalación

| Modo | Descripción |
|---|---|
| Completa (recomendada) | Archivos + herramientas faltantes + base de datos + acceso directo opcional |
| Solo archivos | Copia la estructura de Xereon; no instala herramientas ni crea BD |
| Personalizada | El usuario marca qué bloques ejecutar |

El usuario deberá confirmar con `Comenzar instalación` o `Cancelar`.

---

# Paso 4 — Análisis de herramientas del equipo

Durante el proceso (antes o al inicio del panel de avance), el instalador analizará si el equipo cuenta con lo indispensable.

Checklist mínimo a detectar:

| Componente | Criterio orientativo |
|---|---|
| Python | 3.11+ disponible en PATH |
| Node.js | LTS disponible en PATH |
| PostgreSQL | Servicio/instalación detectable + `psql` o puerto 5432 |
| Git | Opcional para uso productivo local; recomendado en entornos de desarrollo |
| WebView2 | Presente (para app de escritorio) |
| Visual C++ / build tools | Solo si el paquete local requiere compilar Tauri en ese equipo |

Resultado por ítem:

- `Encontrado`
- `No encontrado`
- `Versión incompatible`
- `No verificado` (si no se pudo comprobar)

El checklist se mostrará al usuario antes de instalar nada faltante.

---

# Paso 5 — Instalación de herramientas faltantes

Para cada componente `No encontrado` o incompatible:

1. Explicar para qué sirve.
2. Preguntar de forma explícita:
   - `Instalar ahora`
   - `Omitir / Más tarde`
   - `Abrir guía manual`
3. No instalar en silencio sin esa confirmación.
4. Si requiere administrador, solicitar elevación UAC y explicar el motivo.
5. Registrar el resultado en el log del instalador.

## Reglas

- Se puede ofrecer un botón `Instalar todos los faltantes` que equivale a aceptar uno por uno en bloque, siempre con confirmación previa.
- Si el usuario omite un componente crítico, el asistente continuará solo si el modo lo permite, y al final listará lo pendiente.
- Componentes de terceros se instalan con sus propios instaladores oficiales o paquetes aprobados por el proyecto.

---

# Paso 6 — Panel de avance unificado

Al aceptar la instalación, se abrirá un panel de progreso que muestre el avance global y el paso actual.

## Etapas sugeridas en la barra / lista

1. Preparando carpeta destino  
2. Descargando / copiando archivos del sistema  
3. Verificando herramientas  
4. Instalando componentes aceptados  
5. Configurando base de datos  
6. Aplicando migraciones y datos iniciales  
7. Configurando acceso directo (si aplica)  
8. Verificación final  

## Comportamiento del panel

- Porcentaje global o pasos completados / totales.
- Texto del paso en curso.
- Área de log resumido (expandible).
- Botón `Cancelar` con confirmación (debe dejar el equipo en estado seguro; si ya se instaló algo, indicarlo).
- Ante error:
  - mensaje claro;
  - `Reintentar` el paso;
  - `Continuar` (si el error no es bloqueante);
  - `Abortar`.

## Verificación de integridad

Antes o al finalizar la copia de archivos del sistema:

- Validar hash/firma del paquete cuando exista.
- Si falla la integridad: detener y no ejecutar migraciones ni servicios.

---

# Paso 7 — Base de datos local

Durante la instalación completa (o si el usuario la incluyó en modo personalizado), el asistente creará lo necesario para el funcionamiento local.

## Acciones

1. Verificar que PostgreSQL esté disponible (instalado en el paso 5 o ya existente).
2. Solicitar, si hace falta, credenciales del superusuario local o usar un método de confianza del instalador.
3. Crear la base `Xereon_Produccion` si no existe.
4. Crear/actualizar el usuario de aplicación `xereon_app` (o el definido en configuración) con permisos sobre esa base.
5. Generar el archivo `.env` local del backend a partir de `.env.example`, sin exponer secretos en pantalla más de lo necesario.
6. Ejecutar migraciones (Alembic) y datos iniciales (`02_datos_iniciales.md`).
7. Verificar conexión de prueba.

## Reglas

- Si la base ya existe: preguntar `Usar existente` / `Cancelar` / `Recrear (destructivo)`.
- Recrear exige confirmación explícita (texto de confirmación o doble aviso).
- No continuar como “exitoso” si la BD crítica falló en modo Completa.

---

# Paso 8 — Acceso directo

Antes del cierre (o como etapa del avance), preguntar:

```text
¿Desea crear un acceso directo para abrir Xereon?
[ Sí ]  [ No ]
```

Si el usuario acepta:

- Crear acceso directo en Escritorio y/o Menú Inicio.
- El acceso deberá abrir la forma de ejecución local definida (app Tauri o launcher que levante backend + frontend según el empaquetado).

Si rechaza: continuar sin acceso directo; podrá crearse después desde un utilitario del sistema.

---

# Paso 9 — Finalización

Al terminar, mostrar un panel de **finalización** con:

## Si todo fue exitoso

- Mensaje: `La instalación de Xereon finalizó correctamente.`
- Carpeta de instalación utilizada.
- Estado de la base de datos.
- Herramientas instaladas / omitidas.
- Botones:
  - `Abrir Xereon`
  - `Abrir carpeta de instalación`
  - `Cerrar`

## Si finalizó con pendientes o errores no críticos

- Mensaje: `La instalación finalizó con observaciones.`
- Lista de pendientes (herramientas omitidas, BD no creada, etc.).
- Enlace a log de instalación.
- Botones: `Reintentar pendientes` / `Abrir guía` / `Cerrar`

## Si falló de forma bloqueante

- Mensaje de error.
- Paso donde falló.
- Log.
- `Reintentar` / `Cerrar`

---

# Opción “Solo archivos”

Cuando el usuario elija este modo:

- Se omiten instalación de herramientas y creación de BD.
- Solo se copia la estructura del sistema en la carpeta elegida.
- Al final se informa que el entorno debe configurarse manualmente (`05_Lenguajes_herramientas.md`).

---

# Seguridad y resguardo

- No iniciar descarga/instalación sin aceptación legal (Paso 1).
- No instalar componentes faltantes sin confirmación.
- No borrar datos existentes sin confirmación destructiva explícita.
- Registrar un **log de instalación** en la carpeta del producto o en `%LOCALAPPDATA%\Xereon\logs\`.
- No escribir contraseñas en el log en texto plano.
- Preferir paquetes firmados / hashes verificables.
- El proceso `.env` local no debe subirse a Git.

---

# Relación con otros documentos

| Documento | Uso |
|---|---|
| `modulos/login.md` | Ícono de entrada en Login |
| `05_Lenguajes_herramientas.md` | Lista de herramientas y versiones |
| `06_Estructura_del_proyecto.md` | Carpetas a crear |
| `01_estructura.md` / `02_datos_iniciales.md` | Esquema y seeds de BD |
| `modulos/configuracion.md` | Parámetros iniciales post-instalación |

---

# Mejoras futuras

- Instalación silenciosa corporativa (parámetros CLI).
- Actualización automática desde una versión local ya instalada.
- Paquete offline completo (todas las tools incluidas en un solo medio).
- Soporte multi-sede / elección de instancia de PostgreSQL remota.
- Firma digital del instalador (Authenticode).

---

# Historial de cambios

## 2026-07-30

- Creación de la especificación de descarga e instalación local.
- Incorporación de requisitos, avisos legales, elección de carpeta, checklist de herramientas, confirmaciones de instalación, creación de BD, acceso directo y finalización.
- Separación entre descarga del instalador (desde Login) e instalación local en el equipo.

---

# Observaciones

- El texto legal definitivo debe validarse fuera de este documento técnico.
- Los comandos exactos de instalación de Python/Node/PostgreSQL se definirán en el empaquetado del instalador, manteniendo este flujo funcional.
- Mientras el instalador no exista, el ícono de Login podrá mostrar el asistente informativo y/o descargar un paquete preliminar, sin saltarse la aceptación legal.
