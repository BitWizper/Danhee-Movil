import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

/// Pantalla de detalle de pastel
class CakeDetailScreen extends StatelessWidget {
  final String cakeId;
  
  const CakeDetailScreen({required this.cakeId, super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Detalle del Pastel'),
      ),
      body: const Center(
        child: Text('Detalle del Pastel - En desarrollo'),
      ),
    );
  }
}
