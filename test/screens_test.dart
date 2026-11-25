import 'package:danhee_movil/models/cake.dart';
import 'package:danhee_movil/providers/auth_provider.dart';
import 'package:danhee_movil/providers/cart_provider.dart';
import 'package:danhee_movil/screens/auth/login_screen.dart';
import 'package:danhee_movil/screens/cart/cart_screen.dart';
import 'package:danhee_movil/screens/explore/explore_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('login form validates email and required password', (
    tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.tap(find.text('Iniciar Sesión'));
    await tester.pump();

    expect(find.text('Ingresa tu correo electrónico'), findsOneWidget);
    expect(find.text('Ingresa tu contraseña'), findsOneWidget);
  });

  testWidgets('explore screen displays mock cakes', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ExploreScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Pastel de Boda Elegante'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Chocolate Intenso');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == 'Chocolate Intenso',
      ),
      findsOneWidget,
    );
  });

  testWidgets('cart displays items from its provider', (tester) async {
    final provider = CartProvider();
    await provider.addToCart(
      Cake(
        id: 'screen-test-cake',
        name: 'Pastel de prueba',
        description: 'Prueba',
        price: 100,
        categoryId: 'birthday',
        bakerId: 'baker-test',
      ),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: CartScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Pastel de prueba'), findsOneWidget);
    expect(find.text('Total: \$100.00 MXN'), findsOneWidget);
  });
}
