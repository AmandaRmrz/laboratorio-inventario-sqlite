import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/producto.dart';

class FormularioProductoScreen extends StatefulWidget {
  final Producto? producto;

  const FormularioProductoScreen({super.key, this.producto});

  @override
  State<FormularioProductoScreen> createState() =>
      _FormularioProductoScreenState();
}

class _FormularioProductoScreenState extends State<FormularioProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  late TextEditingController _cantidadController;
  bool _guardando = false;

  bool get _esEdicion => widget.producto != null;

  @override
  void initState() {
    super.initState();
    _nombreController =
        TextEditingController(text: widget.producto?.nombre ?? '');
    _descripcionController =
        TextEditingController(text: widget.producto?.descripcion ?? '');
    _precioController = TextEditingController(
      text: widget.producto != null ? widget.producto!.precio.toString() : '',
    );
    _cantidadController = TextEditingController(
      text: widget.producto != null ? widget.producto!.cantidad.toString() : '',
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final nombre = _nombreController.text.trim();
    final descripcion = _descripcionController.text.trim();
    final precio = double.parse(_precioController.text.trim());
    final cantidad = int.parse(_cantidadController.text.trim());

    try {
      if (_esEdicion) {
        final productoActualizado = widget.producto!.copyWith(
          nombre: nombre,
          descripcion: descripcion,
          precio: precio,
          cantidad: cantidad,
        );
        await DatabaseHelper.instance.actualizarProducto(productoActualizado);
      } else {
        final nuevoProducto = Producto(
          nombre: nombre,
          descripcion: descripcion,
          precio: precio,
          cantidad: cantidad,
        );
        await DatabaseHelper.instance.insertarProducto(nuevoProducto);
      }

      if (!mounted) return;
      Navigator.pop(context, _esEdicion ? 'actualizado' : 'guardado');
    } catch (e) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo guardar el producto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar Producto' : 'Nuevo Producto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del producto *',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(
                  labelText: 'Precio *',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Ingrese un precio numérico';
                  }
                  final numero = double.tryParse(valor.trim());
                  if (numero == null) {
                    return 'Ingrese un precio numérico';
                  }
                  if (numero < 0) {
                    return 'El precio no puede ser negativo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cantidadController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad disponible *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Ingrese una cantidad entera válida';
                  }
                  final entero = int.tryParse(valor.trim());
                  if (entero == null) {
                    return 'Ingrese una cantidad entera válida';
                  }
                  if (entero < 0) {
                    return 'La cantidad no puede ser negativa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _guardando ? null : _guardarProducto,
                icon: Icon(_esEdicion ? Icons.save_as : Icons.save),
                label: Text(_esEdicion ? 'Actualizar' : 'Guardar'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}