# Matriz de Pruebas Funcionales - Inventario SQLite

* **Estudiante:** Andrea Amanda Ramírez Díaz
* **Asignatura:** Técnicas de Calidad de Software
* **Fecha de ejecución:** 24/11/2026
* **Entorno de prueba:** Emulador Android (SDK 34)

| ID | Resultado obtenido | Estado | Observaciones |
| :--- | :--- | :--- | :--- |
| **P01** | Al abrir la app por primera vez sin productos guardados, salió el ícono de la caja y el texto "No hay productos registrados" (`E1_base_datos.png`). | Aprobada | La base de datos `inventario.db` y la tabla `productos` se crearon solas al iniciar. |
| **P02** | Registré "Laptop Dell Inspiron 15 3530" con precio $749.00 y cantidad 8. Al guardar, volvió a la pantalla principal, salió el SnackBar "Producto guardado" y apareció en la lista (`E2_registro.png`). | Aprobada | Funcionó bien el método `insertarProducto`. |
| **P03** | En la tarjeta de la laptop se ven claros los cuatro datos: nombre, descripción, precio ($749.00) y disponibles (8). | Aprobada | Los datos se leen bien desde SQLite usando `fromMap`. |
| **P04** | Agregué "Monitor Gamer LG UltraGear 24\"", "Mouse Logitech MX Master 3S" y "Teclado Logitech G213 Prodigy". En la lista salieron los 4 ordenados alfabéticamente (`E3_consulta.png`). | Aprobada | El `orderBy` por nombre ordenó los registros correctamente. |
| **P05** | Edité "Mouse Logitech MX Master 3S" agregándole descripción y subiendo disponibles de 10 a 15. Al darle a Actualizar, la tarjeta cambió al instante y mostró el SnackBar "Producto actualizado" (`E4_actualizacion_antes.png` y `E4_actualizacion_despues.png`). | Aprobada | Se actualizó solo ese producto filtrando por su `id`. |
| **P06** | Presioné el ícono de eliminar en "Mouse Logitech MX Master 3S" y confirmé en el aviso. El producto se borró de la lista y salió el SnackBar "Producto eliminado" (`E5_eliminacion.png`). | Aprobada | Eliminación correcta usando `whereArgs`. |
| **P07** | Probé darle a eliminar a un producto y luego presioné "Cancelar" en el cuadro de confirmación. El diálogo se cerró y el producto siguió ahí sin borrarse. | Aprobada | La cancelación detiene la acción sin tocar la base de datos. |
| **P08** | Intenté guardar un formulario dejando el nombre en blanco, no me dejó guardar y marcó en rojo "El nombre es obligatorio" (`E6_validaciones.png`). | Aprobada | La validación del formulario bloqueó el envío. |
| **P09** | Escribí "dos" en el precio y le di a Guardar; salió el mensaje "Ingrese un precio numérico" y no registró nada (`E6_validaciones.png`). | Aprobada | Validado con `double.tryParse`. |
| **P10** | Digité un número negativo en el precio y salió el aviso "El precio no puede ser negativo" y no me dejó guardar. | Aprobada | Validado en pantalla y con `CHECK` en la tabla SQLite. |
| **P11** | Probé poner decimales y "-1" en cantidad, salieron los avisos "Ingrese una cantidad entera válida" y "La cantidad no puede ser negativa" (`E6_validaciones.png`). | Aprobada | Validado con `int.tryParse` y mayor o igual a cero. |
| **P12** | Guardé el "Mouse Logitech MX Master 3S" dejando la descripción vacía, se registró sin problema y en la tarjeta apareció "Sin descripción" (`E3_consulta.png`). | Aprobada | Controlado en el widget `ProductoCard`. |
| **P13** | Abrí las apps recientes del emulador y deslicé la app hacia arriba para cerrarla por completo. | Aprobada | La aplicación se cerró totalmente de memoria. |
| **P14** | Volví a abrir la app desde el menú del teléfono y cargaron enseguida los productos que había dejado guardados (`E7_persistencia.png`). | Aprobada | Se comprobó que SQLite guarda los datos de forma persistente. |
| **P15** | Revisé los datos después de volver a abrir: Laptop ($749.00, 8), Monitor ($189.99, 12) y Teclado ($54.95, 15) seguían iguales y el Mouse eliminado no volvió a salir (`E7_persistencia.png`). | Aprobada | Todos los cambios del CRUD se mantuvieron intactos. |
| **P16** | Borré los tres productos que quedaban, cerré la app desde recientes y al abrirla de nuevo volvió a salir "No hay productos registrados". | Aprobada | El estado de lista vacía funciona bien al quedar la tabla sin registros. |