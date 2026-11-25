import 'package:danhee_movil/config/routes.dart';
import 'package:danhee_movil/main.dart';
import 'package:danhee_movil/providers/auth_provider.dart';
import 'package:danhee_movil/providers/cart_provider.dart';
import 'package:danhee_movil/utils/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('demo user can order a cake end to end', (tester) async {
    await StorageHelper.clearSession();
    final cartProvider = CartProvider();
    final authProvider = AuthProvider(
      onSessionCleanup: cartProvider.clearSession,
    );
    await authProvider.initAuth();
    final router = createGoRouter(authProvider);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authProvider),
          ChangeNotifierProvider.value(value: cartProvider),
        ],
        child: DanheeApp(router: router),
      ),
    );
    await tester.pump();

    router.go('/login');
    await tester.pump(const Duration(seconds: 1));
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'cliente@danhee.test',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'cliente123');
    await tester.tap(find.text('Iniciar Sesión'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(authProvider.isClient, isTrue);

    router.go('/explore');
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('Pastel de Boda Elegante'));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('Agregar al carrito'));
    await tester.pump();

    router.go('/carrito');
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Pastel de Boda Elegante'), findsOneWidget);
    await tester.tap(find.text('Continuar al checkout'));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('Confirmar pedido'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(router.routeInformationProvider.value.uri.path, '/');
    expect(cartProvider.isEmpty, isTrue);
    await authProvider.logout();
  });
}
