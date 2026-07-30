# Resumen de estructura de base de datos

Motor: PostgreSQL  
Nombre: Xereon_Produccion

---

## Índice de tablas

1. usuarios
2. roles
3. pantallas
4. permisos
5. rol_permisos
6. empresas
7. categorias
8. criterios
9. perfiles
10. perfil_detalles
11. ingredientes
12. productos
13. versiones
14. version_detalles
15. version_consumibles
16. envases
17. envase_imagenes
18. obleas
19. oblea_imagenes
20. otros
21. otro_imagenes
22. solicitudes
23. ejecuciones
24. dosificaciones
25. consumibles
26. sectores_equipos
27. limpiezas_orden
28. mov_ingredientes
29. mov_ingrediente_comprobante_imagenes
30. mov_ingrediente_imagenes
31. mov_envases
32. mov_envase_comprobante_imagenes
33. mov_envase_imagenes
34. mov_obleas
35. mov_oblea_comprobante_imagenes
36. mov_oblea_imagenes
37. mov_otros
38. mov_otro_comprobante_imagenes
39. mov_otro_imagenes
40. mov_productos
41. mov_producto_comprobante_imagenes
42. mov_producto_imagenes
43. reservas
44. mantenimientos
45. mantenimiento_imagenes
46. reportes_generados
47. configuraciones

Pendientes: (ninguno)

---

## Tabla: usuarios

Columna 01: id  
Columna 02: fecha_creacion  
Columna 03: nombre  
Columna 04: apellido  
Columna 05: usuario  
Columna 06: password_hash  
Columna 07: id_rol  
Columna 08: estado  
Columna 09: observacion  
Columna 10: ultimo_acceso  
Columna 11: creado_por  
Columna 12: actualizado_por

---

## Tabla: roles

Columna 01: id  
Columna 02: nombre  
Columna 03: descripcion

---

## Tabla: pantallas

Columna 01: id  
Columna 02: nombre  
Columna 03: descripcion  
Columna 04: orden

---

## Tabla: permisos

Columna 01: id  
Columna 02: id_pantalla  
Columna 03: accion

---

## Tabla: rol_permisos

Columna 01: id  
Columna 02: id_rol  
Columna 03: id_permiso

---

## Tabla: empresas

Columna 01: id  
Columna 02: fecha  
Columna 03: comercio  
Columna 04: responsable  
Columna 05: contacto  
Columna 06: direccion  
Columna 07: latitud  
Columna 08: longitud  
Columna 09: observacion

---

## Tabla: categorias

Columna 01: id  
Columna 02: categoria  
Columna 03: descripcion

---

## Tabla: criterios

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: criterio  
Columna 05: unidad_medida  
Columna 06: estado  
Columna 07: descripcion

---

## Tabla: perfiles

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: codigo  
Columna 05: descripcion

---

## Tabla: perfil_detalles

Columna 01: id  
Columna 02: id_perfil  
Columna 03: id_criterio  
Columna 04: limite_min  
Columna 05: limite_max  
Columna 06: descripcion

---

## Tabla: ingredientes

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: id_categoria  
Columna 05: codigo  
Columna 06: ingrediente  
Columna 07: id_perfil  
Columna 08: stock_minimo  
Columna 09: estado  
Columna 10: descripcion

---

## Tabla: productos

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: id_categoria  
Columna 05: codigo  
Columna 06: producto  
Columna 07: id_perfil  
Columna 08: stock_minimo_unidades  
Columna 09: stock_minimo_kg  
Columna 10: estado  
Columna 11: descripcion

---

## Tabla: versiones

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: id_producto  
Columna 05: version  
Columna 06: estado  
Columna 07: descripcion

---

## Tabla: version_detalles

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: id_version  
Columna 05: id_ingrediente  
Columna 06: tipo  
Columna 07: puesto  
Columna 08: participacion  
Columna 09: descripcion

---

## Tabla: version_consumibles

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: id_version  
Columna 05: tipo_consumible  
Columna 06: id_envase  
Columna 07: id_oblea  
Columna 08: id_otro  
Columna 09: base_calculo  
Columna 10: cantidad_base  
Columna 11: descripcion

---

## Tabla: envases

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: id_categoria  
Columna 05: codigo  
Columna 06: envase  
Columna 07: capacidad_kg  
Columna 08: stock_minimo  
Columna 09: estado  
Columna 10: descripcion

---

## Tabla: envase_imagenes

Columna 01: id  
Columna 02: id_envase  
Columna 03: ruta_archivo  
Columna 04: nombre_original  
Columna 05: formato  
Columna 06: orden  
Columna 07: fecha_registro

---

## Tabla: obleas

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: id_categoria  
Columna 05: id_producto  
Columna 06: codigo  
Columna 07: oblea  
Columna 08: stock_minimo  
Columna 09: estado  
Columna 10: descripcion

---

## Tabla: oblea_imagenes

Columna 01: id  
Columna 02: id_oblea  
Columna 03: ruta_archivo  
Columna 04: nombre_original  
Columna 05: formato  
Columna 06: orden  
Columna 07: fecha_registro

---

## Tabla: otros

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: id_categoria  
Columna 05: codigo  
Columna 06: insumo  
Columna 07: id_perfil  
Columna 08: stock_minimo  
Columna 09: estado  
Columna 10: descripcion

---

## Tabla: otro_imagenes

Columna 01: id  
Columna 02: id_otro  
Columna 03: ruta_archivo  
Columna 04: nombre_original  
Columna 05: formato  
Columna 06: orden  
Columna 07: fecha_registro

---

## Tabla: solicitudes

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: orden_compra  
Columna 05: id_categoria  
Columna 06: id_producto  
Columna 07: id_version  
Columna 08: id_envase  
Columna 09: id_oblea  
Columna 10: cantidad_unidades  
Columna 11: unidades_pallets  
Columna 12: cantidad_pallets  
Columna 13: pesaje_total  
Columna 14: unidades_pendientes  
Columna 15: pallets_pendientes  
Columna 16: pesaje_pendiente  
Columna 17: fecha_estimada  
Columna 18: fecha_fin  
Columna 19: lote  
Columna 20: estado  
Columna 21: descripcion

---

## Tabla: ejecuciones

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: id_solicitud  
Columna 05: pesaje_batch  
Columna 06: cantidad_batches  
Columna 07: unidades_elaboradas  
Columna 08: pallets_elaborados  
Columna 09: kilogramos_elaborados  
Columna 10: dosificaciones_finalizadas  
Columna 11: consumibles_finalizados  
Columna 12: limpieza_previa_estado  
Columna 13: limpieza_fin  
Columna 14: estado  
Columna 15: descripcion  
Columna 16: fecha_finalizacion  
Columna 17: finalizado_por

---

## Tabla: dosificaciones

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: id_ejecucion  
Columna 05: id_version_detalle  
Columna 06: id_ingrediente  
Columna 07: lote  
Columna 08: pesaje  
Columna 09: batch_inicio  
Columna 10: batch_fin  
Columna 11: sin_stock  
Columna 12: descripcion

---

## Tabla: consumibles

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: id_ejecucion  
Columna 05: id_version_consumible  
Columna 06: insumo  
Columna 07: cantidad_programada  
Columna 08: cantidad_disponible  
Columna 09: cantidad_reservada  
Columna 10: cantidad_faltante  
Columna 11: batch_inicio  
Columna 12: batch_fin

---

## Tabla: sectores_equipos

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: tipo  
Columna 05: nombre  
Columna 06: estado  
Columna 07: descripcion

---

## Tabla: limpiezas_orden

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: id_ejecucion  
Columna 05: id_sector_equipo  
Columna 06: momento  
Columna 07: realizado  
Columna 08: descripcion

---

## Tabla: mov_ingredientes

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: movimiento  
Columna 05: id_categoria  
Columna 06: id_ingrediente  
Columna 07: id_empresa  
Columna 08: lote  
Columna 09: fecha_vencimiento  
Columna 10: cantidad_unidades  
Columna 11: capacidad_unidad  
Columna 12: unidades_por_pallet  
Columna 13: cantidad_pallets  
Columna 14: comprobante  
Columna 15: control_calidad  
Columna 16: descripcion

---

## Tabla: mov_ingrediente_comprobante_imagenes

Columna 01: id  
Columna 02: id_mov_ingrediente  
Columna 03: ruta_archivo  
Columna 04: nombre_original  
Columna 05: formato  
Columna 06: orden  
Columna 07: fecha_registro

---

## Tabla: mov_ingrediente_imagenes

Columna 01: id  
Columna 02: id_mov_ingrediente  
Columna 03: ruta_archivo  
Columna 04: nombre_original  
Columna 05: formato  
Columna 06: orden  
Columna 07: fecha_registro

---

## Tabla: mov_envases

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: movimiento  
Columna 05: id_categoria  
Columna 06: id_envase  
Columna 07: id_empresa  
Columna 08: cantidad_unidades  
Columna 09: comprobante  
Columna 10: control_calidad  
Columna 11: descripcion

---

## Tabla: mov_envase_comprobante_imagenes

Columna 01: id  
Columna 02: id_mov_envase  
Columna 03: ruta_archivo  
Columna 04: nombre_original  
Columna 05: formato  
Columna 06: orden  
Columna 07: fecha_registro

---

## Tabla: mov_envase_imagenes

Columna 01: id  
Columna 02: id_mov_envase  
Columna 03: ruta_archivo  
Columna 04: nombre_original  
Columna 05: formato  
Columna 06: orden  
Columna 07: fecha_registro

---

## Tabla: mov_obleas

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: movimiento  
Columna 05: id_categoria  
Columna 06: id_oblea  
Columna 07: id_empresa  
Columna 08: cantidad_unidades  
Columna 09: comprobante  
Columna 10: control_calidad  
Columna 11: descripcion

---

## Tabla: mov_oblea_comprobante_imagenes

Columna 01: id  
Columna 02: id_mov_oblea  
Columna 03: ruta_archivo  
Columna 04: nombre_original  
Columna 05: formato  
Columna 06: orden  
Columna 07: fecha_registro

---

## Tabla: mov_oblea_imagenes

Columna 01: id  
Columna 02: id_mov_oblea  
Columna 03: ruta_archivo  
Columna 04: nombre_original  
Columna 05: formato  
Columna 06: orden  
Columna 07: fecha_registro

---

## Tabla: mov_otros

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: movimiento  
Columna 05: id_otro  
Columna 06: id_empresa  
Columna 07: cantidad_unidades  
Columna 08: comprobante  
Columna 09: control_calidad  
Columna 10: descripcion

---

## Tabla: mov_otro_comprobante_imagenes

Columna 01: id  
Columna 02: id_mov_otro  
Columna 03: ruta_archivo  
Columna 04: nombre_original  
Columna 05: formato  
Columna 06: orden  
Columna 07: fecha_registro

---

## Tabla: mov_otro_imagenes

Columna 01: id  
Columna 02: id_mov_otro  
Columna 03: ruta_archivo  
Columna 04: nombre_original  
Columna 05: formato  
Columna 06: orden  
Columna 07: fecha_registro

---

## Tabla: mov_productos

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: movimiento  
Columna 05: id_categoria  
Columna 06: id_producto  
Columna 07: lote  
Columna 08: cantidad_unidades  
Columna 09: capacidad_unidad  
Columna 10: unidades_por_pallet  
Columna 11: cantidad_pallets  
Columna 12: cantidad_pesaje  
Columna 13: comprobante  
Columna 14: control_calidad  
Columna 15: descripcion

---

## Tabla: mov_producto_comprobante_imagenes

Columna 01: id  
Columna 02: id_mov_producto  
Columna 03: ruta_archivo  
Columna 04: nombre_original  
Columna 05: formato  
Columna 06: orden  
Columna 07: fecha_registro

---

## Tabla: mov_producto_imagenes

Columna 01: id  
Columna 02: id_mov_producto  
Columna 03: ruta_archivo  
Columna 04: nombre_original  
Columna 05: formato  
Columna 06: orden  
Columna 07: fecha_registro

---

## Tabla: reservas

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: id_ejecucion  
Columna 05: origen  
Columna 06: id_dosificacion  
Columna 07: id_consumible  
Columna 08: tipo_recurso  
Columna 09: id_ingrediente  
Columna 10: id_envase  
Columna 11: id_oblea  
Columna 12: id_otro  
Columna 13: lote  
Columna 14: cantidad  
Columna 15: unidad  
Columna 16: estado  
Columna 17: fecha_cambio_estado  
Columna 18: id_mov_ingrediente  
Columna 19: id_mov_envase  
Columna 20: id_mov_oblea  
Columna 21: id_mov_otro  
Columna 22: descripcion

---

## Tabla: mantenimientos

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: id_sector_equipo  
Columna 05: tipo  
Columna 06: fecha_programada  
Columna 07: fecha_realizacion  
Columna 08: estado  
Columna 09: responsable  
Columna 10: descripcion  
Columna 11: observacion

---

## Tabla: mantenimiento_imagenes

Columna 01: id  
Columna 02: id_mantenimiento  
Columna 03: ruta_archivo  
Columna 04: nombre_original  
Columna 05: formato  
Columna 06: orden  
Columna 07: fecha_registro

---

## Tabla: reportes_generados

Columna 01: id  
Columna 02: fecha_registro  
Columna 03: creado_por  
Columna 04: codigo_reporte  
Columna 05: parametros  
Columna 06: formato  
Columna 07: cantidad_filas  
Columna 08: descripcion

---

## Tabla: configuraciones

Columna 01: id  
Columna 02: clave  
Columna 03: valor  
Columna 04: tipo  
Columna 05: descripcion  
Columna 06: fecha_actualizacion  
Columna 07: actualizado_por

---

# Tablas pendientes (A definir)

No quedan tablas pendientes de definición para los módulos documentados.
