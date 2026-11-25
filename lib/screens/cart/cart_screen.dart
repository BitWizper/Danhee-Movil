import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';
import '../../providers/cart_provider.dart';

/// Pantalla de carrito
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<CartProvider>().fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('Mi Carrito')),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          if (cartProvider.isLoading && cartProvider.cart == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }
          if (cartProvider.errorMessage != null && cartProvider.cart == null) {
            return Center(child: Text(cartProvider.errorMessage!));
          }
          if (cartProvider.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: AppColors.goldDim,
                  ),
                  const SizedBox(height: 12),
                  const Text('Tu carrito está vacío'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => GoRouter.of(context).go(AppRoutes.explore),
                    child: const Text('Explorar pasteles'),
                  ),
                ],
              ),
            );
          }
          final cart = cartProvider.cart!;
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.surface2,
                          child: Icon(Icons.cake, color: AppColors.gold),
                        ),
                        title: Text(item.cakeName),
                        subtitle: Text(
                          '${item.formattedPrice}  ·  Subtotal ${item.formattedSubtotal}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => cartProvider.updateQuantity(
                                item.id,
                                item.quantity - 1,
                              ),
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              onPressed: () => cartProvider.updateQuantity(
                                item.id,
                                item.quantity + 1,
                              ),
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                            IconButton(
                              onPressed: () =>
                                  cartProvider.removeFromCart(item.id),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Total: ${cart.formattedTotal}',
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () =>
                            GoRouter.of(context).go(AppRoutes.checkout),
                        child: const Text('Continuar al checkout'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
