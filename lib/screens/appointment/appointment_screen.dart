import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

/// Pantalla de agendar cita
class AppointmentScreen extends StatelessWidget {
  final String? bakerId;
  
  const AppointmentScreen({this.bakerId, super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Agendar Cita'),
      ),
      body: const Center(
        child: Text('Agendar Cita - En desarrollo'),
      ),
    );
  }
}
