import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/appointment.dart';
import '../../providers/auth_provider.dart';
import '../../repositories/appointment_repository.dart';

/// Citas relacionadas con el usuario autenticado.
class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  late Future<List<Appointment>> _appointments;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  void _loadAppointments() {
    final user = context.read<AuthProvider>().user!;
    _appointments = MockAppointmentRepositories.instance.getAppointments(
      userId: user.id,
      isBaker: user.isBaker,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBaker = context.read<AuthProvider>().isBaker;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(isBaker ? 'Citas recibidas' : 'Mis Citas')),
      body: FutureBuilder<List<Appointment>>(
        future: _appointments,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('No se pudieron cargar las citas: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }
          final appointments = snapshot.data!;
          if (appointments.isEmpty) {
            return const Center(child: Text('Todavía no tienes citas.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.event, color: AppColors.gold),
                  title: Text(
                    isBaker ? appointment.clientName : appointment.bakerName,
                  ),
                  subtitle: Text(
                    '${appointment.formattedDate} · ${appointment.timeSlot}\n'
                    'Estado: ${appointment.status}'
                    '${appointment.notes == null ? '' : '\n${appointment.notes}'}',
                  ),
                  isThreeLine: appointment.notes != null,
                  trailing: appointment.isCancelled
                      ? null
                      : IconButton(
                          tooltip: 'Cancelar cita',
                          icon: const Icon(Icons.close, color: AppColors.error),
                          onPressed: () async {
                            await MockAppointmentRepositories.instance
                                .cancelAppointment(appointment.id);
                            if (mounted) setState(_loadAppointments);
                          },
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
