# Laboratorio App con Base de Datos Local - Inventario

* **Estudiante:** Andrea Amanda Ramírez Díaz
* **Asignatura:** Técnicas de Calidad de Software
* **Tecnologías:** Flutter, Dart, SQLite (`sqflite`, `path`)

## 1. Objetivo del Proyecto
Desarrollar una aplicación móvil llamada **Inventario** utilizando Flutter y SQLite para guardar datos de forma local, aplicando buena organización de carpetas, validaciones en los formularios, manejo de errores y documentación de pruebas funcionales.

## 2. Descripción de la Aplicación
La aplicación sirve para administrar un inventario de productos usando operaciones CRUD completas (Crear, Consultar, Actualizar y Eliminar). Todos los productos se guardan directamente en el teléfono dentro de una base de datos SQLite (`inventario.db`), por lo que la información no se pierde aunque se cierre la app por completo.

## 3. Tecnologías Utilizadas
* **Flutter:** SDK estable (Configurado con Android SDK 34)
* **Dart:** Lenguaje de programación
* **sqflite:** Librería para manejar la base de datos SQLite local
* **path:** Librería para armar las rutas de archivos en el dispositivo
* **Git y GitHub:** Control de versiones

## 4. Requisitos para Ejecutar el Proyecto
* Tener instalado Flutter SDK y configurado en el PATH.
* Visual Studio Code o Android Studio con las extensiones de Flutter y Dart.
* Un emulador Android (API 34 o superior) o un teléfono Android físico con depuración USB activada *(no funciona en Web ni Windows sin configuración extra)*.

## 5. Instrucciones de Instalación
1. Clonar este repositorio en la computadora:
   ```bash
   git clone https://github.com/AmandaRmrz/laboratorio-inventario-sqlite.git
2. Entrar a la carpeta del proyecto:
    ```bash
    cd laboratorio-inventario-sqlite
3. Descargar los paquetes necesarios:
    ```bash
    flutter pub get
## 6. Instrucciones para Ejecutar la Aplicación
1. Revisar que el emulador o celular esté conectado:
   ```bash
   flutter devices
2. Verificar que el código no tenga errores:
    ```bash
    flutter analyze
3. Correr la aplicación:
    ```bash
    flutter run
## 7. Estructura de Carpetas
```text
laboratorio-inventario-sqlite/
├── android/
├── docs/
│   ├── evidencias/
│   │   ├── E1_base_datos.png
│   │   ├── E2_registro.png
│   │   ├── E3_consulta.png
│   │   ├── E4_actualizacion_antes.png
│   │   ├── E4_actualizacion_despues.png
│   │   ├── E5_eliminacion.png
│   │   ├── E6_validaciones.png
│   │   ├── E7_persistencia.png
│   │   └── E8_matriz_pruebas.png
│   └── matriz_pruebas.md
├── ios/
├── lib/
│   ├── database/
│   │   └── database_helper.dart
│   ├── models/
│   │   └── producto.dart
│   ├── screens/
│   │   ├── formulario_producto_screen.dart
│   │   └── lista_productos_screen.dart
│   ├── widgets/
│   │   └── producto_card.dart
│   └── main.dart
├── test/
├── .gitignore
├── pubspec.lock
├── pubspec.yaml
└── README.md
```
## 8. Operaciones CRUD Implementadas
Toda la lógica de SQLite está separada en `lib/database/database_helper.dart` usando bloques `try/catch` para controlar cualquier fallo:

* **Create (`insertarProducto`):** Recibe un objeto `Producto`, lo pasa a mapa sin enviar el `id` (para que se genere automático) y lo guarda en la tabla `productos`.

* **Read (`obtenerProductos`):** Consulta todos los productos guardados, los ordena de la A a la Z por nombre y los convierte en una lista usando `fromMap()`.

* **Update (`actualizarProducto`):** Edita los datos de un producto buscando exactamente su `id` mediante `where: 'id = ?'` y `whereArgs`.

* **Delete (`eliminarProducto`):** Borra un producto específico por su `id` usando `whereArgs`, después de que el usuario confirma la acción en un `AlertDialog`.

## 9. Matriz de Pruebas Funcionales
Los resultados obtenidos al probar los 16 casos de prueba (P01 a P16) se encuentran documentados aquí:

[Ir a Matriz de Pruebas Funcionales](docs/matriz_pruebas.md)

## 10. Evidencias de Ejecución
Todas las capturas tomadas durante la ejecución en el emulador están guardadas en `docs/evidencias/`:

[Ir a Carpeta de Evidencias](docs/evidencias/)

* `E1_base_datos.png`: Primera ejecución de la app con la tabla productos recién creada.

* `E2_registro.png`: Registro de producto completado y aviso SnackBar de confirmación.

* `E3_consulta.png`: Listado con varios productos ordenados alfabéticamente.

* `E4_actualizacion_antes.png`: Datos originales del producto antes de editarlo.

* `E4_actualizacion_despues.png`: Tarjeta actualizada después de modificar descripción y cantidad.

* `E5_eliminacion.png`: Diálogo de confirmación y lista actualizada tras eliminar el registro.

* `E6_validaciones.png`: Mensajes de error mostrados al ingresar datos vacíos, texto en precio o cantidad negativa.

* `E7_persistencia.png`: Comprobación de que los datos siguen guardados tras cerrar y volver a abrir la app.

* `E8_matriz_pruebas.png`: Captura del archivo de matriz de pruebas completado.

## 11. Conclusiones
Al desarrollar esta aplicación de inventario pude comprender cómo integrar una base de datos local SQLite en Flutter manteniendo el proyecto bien organizado por capas. Separar el modelo `Producto`, la clase `DatabaseHelper` y las pantallas, facilitó mucho el mantenimiento del código y evitó mezclar consultas SQL directamente en la interfaz gráfica. Además, ejecutar las 16 pruebas funcionales permitió verificar que las validaciones del formulario, las consultas parametrizadas (`whereArgs`) y las restricciones de la tabla protegen la integridad de los datos incluso después de cerrar la aplicación por completo.