import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/cart_provider.dart';

/// Checkout de demostración conectado al repositorio de carrito local.
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('Checkout')),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.isEmpty) {
            return const Center(child: Text('No hay productos para pagar'));
          }
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Resumen del pedido',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                ...cart.cart!.items.map(
                  (item) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.cakeName),
                    subtitle: Text('Cantidad: ${item.quantity}'),
                    trailing: Text(item.formattedSubtotal),
                  ),
                ),
                const Divider(),
                Text(
                  'Total: ${cart.cart!.formattedTotal}',
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                Text(
                  'Modo de demostración: no se realizará ningún cobro.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: cart.isLoading
                      ? null
                      : () async {
                          final completed = await cart.checkout();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                completed
                                    ? 'Pedido de demostración confirmado'
                                    : cart.errorMessage ??
                                          'No se pudo completar el pedido',
                              ),
                            ),
                          );
                          if (completed) GoRouter.of(context).go('/');
                        },
                  child: Text(
                    cart.isLoading ? 'Procesando...' : 'Confirmar pedido',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
