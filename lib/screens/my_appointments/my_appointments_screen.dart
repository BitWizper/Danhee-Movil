import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

/// Pantalla de mis citas
class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Mis Citas'),
      ),
      body: const Center(
        child: Text('Mis Citas - En desarrollo'),
      ),
    );
  }
}
