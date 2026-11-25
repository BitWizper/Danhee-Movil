import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';
import '../../models/appointment.dart';
import '../../providers/auth_provider.dart';
import '../../repositories/appointment_repository.dart';
import '../../utils/permission_service.dart';

/// Dashboard básico del repostero con sus solicitudes de cita.
class BakerDashboardScreen extends StatelessWidget {
  const BakerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user!;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('Dashboard de Repostero')),
      body: FutureBuilder<List<Appointment>>(
        future: MockAppointmentRepositories.instance.getAppointments(
          userId: user.id,
          isBaker: true,
        ),
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
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.store, color: AppColors.gold),
                  title: Text(user.name ?? 'Mi pastelería'),
                  subtitle: Text(user.email),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _requestPhotoPermission(
                      context,
                      camera: false,
                    ),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Permitir galería'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _requestPhotoPermission(
                      context,
                      camera: true,
                    ),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Permitir cámara'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Solicitudes de cita (${appointments.length})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (appointments.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text('Aún no tienes solicitudes de cita.'),
                )
              else
                ...appointments.map(
                  (appointment) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.event, color: AppColors.gold),
                      title: Text(appointment.clientName),
                      subtitle: Text(
                        '${appointment.formattedDate} · ${appointment.timeSlot}'
                        '\nEstado: ${appointment.status}'
                        '${appointment.notes == null ? '' : '\n${appointment.notes}'}',
                      ),
                      isThreeLine: appointment.notes != null,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () =>
                    GoRouter.of(context).go(AppRoutes.myAppointments),
                child: const Text('Ver todas las citas'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _requestPhotoPermission(
    BuildContext context, {
    required bool camera,
  }) async {
    final service = PermissionService();
    final result = camera
        ? await service.requestCameraAccess()
        : await service.requestGalleryAccess();
    if (!context.mounted) return;

    if (result == PermissionAccess.granted ||
        result == PermissionAccess.limited) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permiso concedido. La carga de fotos se integrará después.'),
        ),
      );
      return;
    }

    if (result == PermissionAccess.permanentlyDenied) {
      final openSettings = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Permiso necesario'),
          content: const Text(
            'Habilita el acceso desde los ajustes de la aplicación.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Ahora no'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Abrir ajustes'),
            ),
          ],
        ),
      );
      if (openSettings == true) await service.openSettings();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result == PermissionAccess.restricted
              ? 'El dispositivo restringe este permiso.'
              : 'No se concedió el permiso.',
        ),
      ),
    );
  }
}
