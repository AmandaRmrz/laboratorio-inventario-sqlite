import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/producto.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('inventario.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE productos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT,
        precio REAL NOT NULL CHECK (precio >= 0),
        cantidad INTEGER NOT NULL CHECK (cantidad >= 0)
      )
    ''');
  }

  Future<int> insertarProducto(Producto producto) async {
    try {
      final db = await instance.database;
      final datos = producto.toMap()..remove('id');
      return await db.insert('productos', datos);
    } catch (e) {
      throw Exception('Error al registrar el producto en la base de datos: $e');
    }
  }

  Future<List<Producto>> obtenerProductos() async {
    try {
      final db = await instance.database;
      final resultado = await db.query(
        'productos',
        orderBy: 'nombre COLLATE NOCASE ASC',
      );
      return resultado.map((mapa) => Producto.fromMap(mapa)).toList();
    } catch (e) {
      throw Exception('Error al consultar los productos: $e');
    }
  }

  Future<int> actualizarProducto(Producto producto) async {
    try {
      final db = await instance.database;
      return await db.update(
        'productos',
        producto.toMap(),
        where: 'id = ?',
        whereArgs: [producto.id],
      );
    } catch (e) {
      throw Exception('Error al actualizar el producto: $e');
    }
  }

  Future<int> eliminarProducto(int id) async {
    try {
      final db = await instance.database;
      return await db.delete(
        'productos',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Error al eliminar el producto: $e');
    }
  }
}