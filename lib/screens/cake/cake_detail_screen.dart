import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';
import '../../models/cake.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../repositories/cake_repository.dart';

/// Pantalla de detalle de pastel
class CakeDetailScreen extends StatelessWidget {
  final String cakeId;

  const CakeDetailScreen({required this.cakeId, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Cake?>(
      future: MockRepositories.cakes.getCakeById(cakeId),
      builder: (context, snapshot) {
        final cake = snapshot.data;
        return Scaffold(
          backgroundColor: AppColors.bg,
          appBar: AppBar(title: const Text('Detalle del Pastel')),
          body: snapshot.hasError
              ? Center(
                  child: Text('No se pudo cargar el pastel: ${snapshot.error}'),
                )
              : cake == null
              ? snapshot.connectionState == ConnectionState.done
                    ? const Center(child: Text('Pastel no encontrado'))
                    : const Center(
                        child: CircularProgressIndicator(color: AppColors.gold),
                      )
              : ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Container(
                      height: 240,
                      decoration: BoxDecoration(
                        color: AppColors.surface2,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.cake_outlined,
                        size: 96,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      cake.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cake.formattedPrice,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: AppColors.gold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      cake.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Elaborado por ${cake.bakerName ?? 'repostero local'}',
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final auth = context.read<AuthProvider>();
                        if (!auth.isAuthenticated || !auth.isClient) {
                          GoRouter.of(context).go(AppRoutes.cart);
                          return;
                        }
                        final added = await context
                            .read<CartProvider>()
                            .addToCart(cake);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                added
                                    ? 'Agregado al carrito'
                                    : 'No se pudo agregar al carrito',
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Agregar al carrito'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => GoRouter.of(
                        context,
                      ).go('${AppRoutes.appointment}/${cake.bakerId}'),
                      child: const Text('Agendar cita con el repostero'),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
