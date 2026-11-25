import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'config/routes.dart';
import 'providers/supabase_auth_provider.dart';
import 'providers/cart_provider.dart';
import 'backend/config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase
  await SupabaseConfig.initialize();

  // Inicializar Supabase Auth Provider
  final supabaseAuthProvider = SupabaseAuthProvider();
  await supabaseAuthProvider.initAuth();

  // Inicializar Cart Provider
  final cartProvider = CartProvider();

  final router = createGoRouter(supabaseAuthProvider);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: supabaseAuthProvider),
        ChangeNotifierProxyProvider<SupabaseAuthProvider, CartProvider>(
          create: (_) => cartProvider,
          update: (_, auth, cart) {
            final currentCart = cart ??
                CartProvider(userId: auth.user?.id ?? 'demo-client');
            currentCart.setUserId(auth.user?.id ?? 'demo-client');
            return currentCart;
          },
        ),
      ],
      child: DanheeApp(router: router),
    ),
  );
}

class DanheeApp extends StatelessWidget {
  final GoRouter router;

  const DanheeApp({required this.router, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Danhee Cake',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
