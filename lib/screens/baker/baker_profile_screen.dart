import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

/// Pantalla de perfil de repostero
class BakerProfileScreen extends StatelessWidget {
  final String bakerId;
  
  const BakerProfileScreen({required this.bakerId, super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Perfil del Repostero'),
      ),
      body: const Center(
        child: Text('Perfil del Repostero - En desarrollo'),
      ),
    );
  }
}
