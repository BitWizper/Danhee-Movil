import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

/// Pantalla de dashboard de repostero
class BakerDashboardScreen extends StatelessWidget {
  const BakerDashboardScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Dashboard de Repostero'),
      ),
      body: const Center(
        child: Text('Dashboard de Repostero - En desarrollo'),
      ),
    );
  }
}
