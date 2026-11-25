import 'package:danhee_movil/config/routes.dart';
import 'package:danhee_movil/main.dart';
import 'package:danhee_movil/providers/auth_provider.dart';
import 'package:danhee_movil/providers/cart_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('shows the home screen', (tester) async {
    final authProvider = AuthProvider();
    final router = createGoRouter(authProvider);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authProvider),
          ChangeNotifierProvider(create: (_) => CartProvider()),
        ],
        child: DanheeApp(router: router),
      ),
    );
    await tester.pump();

    expect(find.text('Categorías'), findsOneWidget);
    expect(find.text('Pasteles Destacados'), findsOneWidget);
  });
}
