import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';

/// Pantalla de perfil de repostero
class BakerProfileScreen extends StatelessWidget {
  final String bakerId;

  const BakerProfileScreen({required this.bakerId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('Perfil del Repostero')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 42,
              backgroundColor: AppColors.surface2,
              child: Icon(Icons.storefront, size: 40, color: AppColors.gold),
            ),
            const SizedBox(height: 20),
            Text(
              bakerId == 'baker-2' ? 'Horno de Ana' : 'Dulce Atelier',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Repostería artesanal y pasteles personalizados.'),
            const SizedBox(height: 8),
            const Text('Ubicación: Ciudad de México'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final route = AppRoutes.appointmentWithBaker.replaceFirst(
                    ':id',
                    bakerId,
                  );
                  GoRouter.of(context).go(route);
                },
                child: const Text('Agendar cita'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
