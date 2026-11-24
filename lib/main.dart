import 'package:flutter/material.dart';
import 'screens/lista_productos_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const InventarioApp());
}

class InventarioApp extends StatelessWidget {
  const InventarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventario',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0F766E), 
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F766E),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
),
      home: const ListaProductosScreen(),
    );
  }
}