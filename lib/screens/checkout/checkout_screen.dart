import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

/// Pantalla de checkout
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: const Center(
        child: Text('Checkout - En desarrollo'),
      ),
    );
  }
}
