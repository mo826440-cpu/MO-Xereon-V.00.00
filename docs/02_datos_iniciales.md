# Datos Iniciales

Este documento contiene los registros mínimos necesarios para que el sistema pueda funcionar luego de crear la base de datos.

---

# Roles

```text
1  Admin
2  Dirección
3  Coordinación
4  Operativo
5  Visita
```

---

# Descripción de Roles

## Admin

Acceso total al sistema.

Puede administrar usuarios, configuraciones y cualquier módulo.

---

## Dirección

Acceso a todos los módulos operativos y reportes.

No administra configuraciones críticas del sistema.

---

## Coordinación

Acceso a módulos relacionados con producción, logística y planificación.

Puede crear y editar registros.

---

## Operativo

Acceso únicamente a las tareas necesarias para realizar su trabajo.

No puede administrar usuarios ni configuraciones.

---

## Visita

Acceso únicamente en modo lectura.

No puede crear, editar ni eliminar registros.

---

# Categorías

```text
1  Sustituto Lácteo
2  Premezcla
```

Las descripciones iniciales quedan vacías hasta que se defina el alcance detallado de cada categoría.

---

# Pantallas

```text
1  Inicio
2  Usuarios
3  Empresas
4  Categorías
5  Calidad
6  Criterios
7  Productos
8  Versiones
9  Insumos
10 Ingredientes
11 Envases
12 Obleas
13 Otros
14 Producción
15 Solicitudes
16 Movimientos
17 Mov. Ingredientes
18 Mov. Envases
19 Mov. Obleas
20 Mov. Otros
21 Mov. Productos
22 Mantenimiento
23 Reportes
24 Configuración
25 Ejecuciones
26 Sectores y Equipos
```

---

# Acciones

```text
1  Ver
2  Crear
3  Editar
4  Eliminar
5  Exportar
6  Imprimir
7  Aprobar
8  Cerrar
9  Administrar
```

---

# Permisos

```text
Usuarios

- Ver
- Crear
- Editar
- Eliminar

Empresas

- Ver
- Crear
- Editar
- Eliminar

Categorías

- Ver
- Crear
- Editar
- Eliminar

Calidad

- Ver

Criterios

- Ver
- Crear
- Editar
- Eliminar

Productos

- Ver
- Crear
- Editar
- Eliminar

Versiones

- Ver
- Crear
- Editar
- Eliminar

Insumos

- Ver

Ingredientes

- Ver
- Crear
- Editar
- Eliminar

Envases

- Ver
- Crear
- Editar
- Eliminar

Obleas

- Ver
- Crear
- Editar
- Eliminar

Otros

- Ver
- Crear
- Editar
- Eliminar

Producción

- Ver

Solicitudes

- Ver
- Crear
- Editar
- Eliminar

Ejecuciones

- Ver
- Crear
- Editar
- Cerrar

Sectores y Equipos

- Ver
- Crear
- Editar
- Eliminar

Movimientos

- Ver
- Crear
- Editar
- Eliminar

Mov. Ingredientes

- Ver
- Crear
- Editar
- Eliminar

Mov. Envases

- Ver
- Crear
- Editar
- Eliminar

Mov. Obleas

- Ver
- Crear
- Editar
- Eliminar

Mov. Otros

- Ver
- Crear
- Editar
- Eliminar

Mov. Productos

- Ver
- Crear
- Editar
- Eliminar

Mantenimiento

- Ver
- Crear
- Editar
- Eliminar

Reportes

- Ver
- Exportar
- Imprimir

Configuración

- Administrar
```

---

# Asignación Inicial de Permisos

## Admin

- Todos los permisos.

---

## Dirección

- Ver
- Crear
- Editar
- Aprobar
- Exportar
- Imprimir

---

## Coordinación

- Ver
- Crear
- Editar

---

## Operativo

- Ver
- Crear

---

## Visita

- Ver únicamente.

---

# Configuraciones iniciales

```text
planta.nombre                   | Xereon                    | texto
planta.zona_horaria             | America/Argentina/Buenos_Aires        | texto
ui.filas_por_pagina             | 25                                    | numero
stock.alerta_dias_vencimiento   | 30                                    | numero
stock.mostrar_cero              | true                                  | booleano
reportes.max_filas_exportacion  | 50000                                 | numero
produccion.permitir_una_en_curso| true                                  | booleano
```

Las descripciones de cada clave se cargarán junto con el seed. En la versión inicial solo se edita el valor desde la pantalla Configuración.

---

# Usuario Administrador Inicial

```text
Nombre:
Administrador

Apellido:
Sistema

Usuario:
admin

Contraseña:
(Se genera durante la instalación y se almacena hasheada.)

Rol:
Admin

Estado:
Activo
```

---

# Observaciones

- Todos los permisos se asignan mediante la tabla `rol_permisos`.
- Ningún usuario posee permisos directos.
- Todo acceso al sistema depende exclusivamente del rol asignado al usuario.
- Las contraseñas nunca se almacenan en texto plano.
- El usuario administrador inicial deberá cambiar su contraseña en el primer inicio de sesión.
