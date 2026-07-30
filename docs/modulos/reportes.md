# Módulo: Reportes

## Objetivo

Centralizar la consulta, exportación e impresión de información operativa del sistema a partir de los datos ya registrados en Producción, Movimientos, Insumos, Productos, Calidad y Mantenimiento.

Este módulo **no introduce un maestro de negocio propio**. Los reportes son consultas parametrizadas sobre las tablas existentes. Sí se registra un historial liviano de exportaciones para auditoría.

---

# Tablas involucradas

- reportes_generados
- (consulta lectura de las tablas operativas según el reporte)

> La estructura de `reportes_generados` se encuentra documentada en `01_estructura.md`.

---

# Enfoque

| Qué | Decisión |
|---|---|
| Catálogo de reportes | Definido en código / configuración de aplicación (no tabla maestra en v1) |
| Datos del reporte | Siempre leídos en vivo desde las tablas de origen |
| Persistencia | Solo se guarda quién generó/exportó qué, cuándo y con qué filtros |
| Pantalla propia | Sí: hub de Reportes |

---

# Catálogo inicial de reportes

## Producción

1. Solicitudes del período (estado, pendientes, producto, lote).
2. Ejecuciones finalizadas del período (batches, kg, tiempos).
3. Consumo de ingredientes por ejecución / lote (FIFO).
4. Consumo de consumibles por ejecución.

## Stock y movimientos

5. Stock actual de ingredientes (kg) y alertas de mínimo.
6. Stock actual de envases, obleas y otros (unidades).
7. Stock actual de productos (unidades y kg).
8. Movimientos de ingredientes del período.
9. Movimientos de productos del período.
10. Lotes no conformes pendientes de regularización.

## Calidad

11. Criterios y perfiles asociados a productos / ingredientes / otros.

## Mantenimiento

12. Mantenimientos del período por estado y tipo.
13. Mantenimientos vencidos.

## Usuarios / auditoría operativa

14. Resumen de exportaciones generadas (desde `reportes_generados`).

---

# Funcionalidades

- Seleccionar un reporte del catálogo.
- Definir filtros (fechas, categoría, producto, estado, etc. según el reporte).
- Previsualizar resultados en pantalla.
- Exportar a archivo (CSV / Excel / PDF según disponibilidad).
- Imprimir la vista del reporte.
- Consultar el historial propio o general de exportaciones (según permiso).

---

# Pantallas

- Reportes (hub).
- Vista de reporte (filtros + grilla + acciones).
- Historial de exportaciones.

---

# Formulario / filtros comunes

Cada reporte expondrá solo los filtros que apliquen. Base sugerida:

- Período (fecha desde / hasta).
- Categoría.
- Producto / Ingrediente / Envase / Oblea / Otro.
- Estado.
- Lote.
- Usuario (cuando el reporte sea de auditoría).

---

# Tabla: historial de exportaciones

Cada exportación o impresión registrada guardará:

- Fecha y usuario.
- Código del reporte.
- Parámetros/filtros utilizados (JSON texto).
- Formato (`csv`, `xlsx`, `pdf`, `impresion`).
- Cantidad de filas exportadas (si aplica).
- Observación opcional.

---

# Reglas de negocio

- Un usuario solo podrá generar reportes si tiene permiso de Ver en Reportes.
- Exportar e Imprimir requieren sus permisos específicos.
- Los reportes nunca modifican datos operativos.
- Los filtros de fecha, cuando existan, usarán inclusive el rango indicado.
- Si un reporte no tiene datos, se mostrará vacío con mensaje claro; no se bloqueará la exportación.
- Los datos sensibles (hashes de contraseña, tokens) nunca se incluirán en reportes.
- El historial `reportes_generados` es de solo lectura para el usuario final (no editable).

---

# Validaciones

- Código de reporte existente en el catálogo.
- Fechas coherentes (`desde <= hasta`).
- Filtros de FK existentes cuando se informen.
- Formato de exportación permitido.

---

# Flujo del módulo

```text
Inicio

↓

Reportes

↓

Elegir reporte del catálogo

↓

Completar filtros

↓

Previsualizar

↓

Exportar / Imprimir

↓

Registrar fila en reportes_generados
```

---

# Relaciones

```text
reportes_generados.creado_por → usuarios.id
```

El resto son consultas de lectura a tablas de otros módulos.

---

# Permisos

## Reportes

- Ver
- Exportar
- Imprimir

---

# Mejoras futuras

- Programación de reportes por correo.
- Catálogo de reportes administrable desde Configuración.
- Plantillas PDF personalizadas por planta.
- Cubos / tableros analíticos.
- Comparativos mes vs mes.

---

# Historial de cambios

## 2026-07-30

- Creación inicial del módulo Reportes.
- Definición del catálogo inicial de reportes sin tabla maestra.
- Incorporación de `reportes_generados` para auditoría de exportaciones.

---

# Observaciones

- La estructura de `reportes_generados` se encuentra en `01_estructura.md`.
- Los datos de origen se documentan en los módulos correspondientes.
- Las reglas generales del sistema se encuentran en `03_reglas_generales.md`.
