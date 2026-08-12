import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

/// Pantalla de carrito
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Mi Carrito'),
      ),
      body: const Center(
        child: Text('Carrito - En desarrollo'),
      ),
    );
  }
}
