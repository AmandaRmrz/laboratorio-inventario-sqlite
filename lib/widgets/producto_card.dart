import 'package:flutter/material.dart';
import '../models/producto.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const ProductoCard({
    super.key,
    required this.producto,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final sinDescripcion = producto.descripcion.trim().isEmpty;
    final textoDescripcion =
        sinDescripcion ? 'Sin descripción' : producto.descripcion;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.teal.shade100),
      ),
      elevation: 1.5,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF0F766E),
          foregroundColor: Colors.white,
          child: Text(
            producto.nombre.isNotEmpty
                ? producto.nombre[0].toUpperCase()
                : 'P',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          producto.nombre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textoDescripcion,
                style: TextStyle(
                  fontSize: 14,
                  color: sinDescripcion ? Colors.grey[600] : Colors.black87,
                  fontStyle:
                      sinDescripcion ? FontStyle.italic : FontStyle.normal,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Precio: \$${producto.precio.toStringAsFixed(2)}  •  Disponibles: ${producto.cantidad}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.teal.shade800,
                ),
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.teal),
              tooltip: 'Editar producto',
              onPressed: onEditar,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              tooltip: 'Eliminar producto',
              onPressed: onEliminar,
            ),
          ],
        ),
      ),
    );
  }
}