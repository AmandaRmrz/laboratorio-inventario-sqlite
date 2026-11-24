import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/producto.dart';
import '../widgets/producto_card.dart';
import 'formulario_producto_screen.dart';

class ListaProductosScreen extends StatefulWidget {
  const ListaProductosScreen({super.key});

  @override
  State<ListaProductosScreen> createState() => _ListaProductosScreenState();
}

class _ListaProductosScreenState extends State<ListaProductosScreen> {
  List<Producto> _productos = [];
  bool _cargando = true;
  String? _mensajeError;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    try {
      final lista = await DatabaseHelper.instance.obtenerProductos();
      if (!mounted) return;
      setState(() {
        _productos = lista;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _mensajeError = 'Ocurrió un error al cargar el inventario.';
        _cargando = false;
      });
    }
  }

  void _mostrarSnackBar(String mensaje, {bool esError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? Colors.red : Colors.green.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _abrirFormulario({Producto? producto}) async {
    final resultado = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioProductoScreen(producto: producto),
      ),
    );

    if (resultado != null && mounted) {
      await _cargarProductos();
      if (resultado == 'guardado') {
        _mostrarSnackBar('Producto guardado');
      } else if (resultado == 'actualizado') {
        _mostrarSnackBar('Producto actualizado');
      }
    }
  }

  Future<void> _confirmarEliminacion(Producto producto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Estás seguro de que deseas eliminar "${producto.nombre}" del inventario?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true && producto.id != null) {
      try {
        await DatabaseHelper.instance.eliminarProducto(producto.id!);
        if (!mounted) return;
        await _cargarProductos();
        _mostrarSnackBar('Producto eliminado');
      } catch (e) {
        _mostrarSnackBar('Error al eliminar el producto', esError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        centerTitle: true,
      ),
      body: _construirCuerpo(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        tooltip: 'Agregar producto',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _construirCuerpo() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_mensajeError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                _mensajeError!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _cargarProductos,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (_productos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'No hay productos registrados',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: _productos.length,
      itemBuilder: (context, index) {
        final producto = _productos[index];
        return ProductoCard(
          producto: producto,
          onEditar: () => _abrirFormulario(producto: producto),
          onEliminar: () => _confirmarEliminacion(producto),
        );
      },
    );
  }
}