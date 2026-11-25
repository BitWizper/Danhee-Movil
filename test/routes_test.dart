import 'package:flutter/widgets.dart';
import 'package:danhee_movil/config/routes.dart';
import 'package:danhee_movil/main.dart';
import 'package:danhee_movil/models/user.dart';
import 'package:danhee_movil/providers/auth_provider.dart';
import 'package:danhee_movil/providers/cart_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class _TestAuthProvider extends AuthProvider {
  User? currentUser;

  @override
  User? get user => currentUser;

  @override
  bool get isAuthenticated => currentUser != null;

  @override
  bool get isBaker => currentUser?.isBaker ?? false;

  @override
  bool get isClient => currentUser?.isClient ?? false;

  void authenticate(User user) {
    currentUser = user;
    notifyListeners();
  }
}

void main() {
  testWidgets('redirects guests from protected routes to login', (tester) async {
    final auth = _TestAuthProvider();
    final router = createGoRouter(auth);
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(auth, router));
    await tester.pump();
    router.go('/carrito');
    await tester.pump(const Duration(seconds: 1));

    expect(router.routeInformationProvider.value.uri.path, '/login');
    expect(
      router.routeInformationProvider.value.uri.queryParameters['from'],
      '/carrito',
    );
  });

  testWidgets('redirects clients away from the baker dashboard', (tester) async {
    final auth = _TestAuthProvider()
      ..currentUser = User(
        id: 'client-test',
        email: 'client@test.invalid',
        role: 'cliente',
      );
    final router = createGoRouter(auth);
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(auth, router));
    await tester.pump();
    router.go('/dashboard');
    await tester.pump(const Duration(seconds: 1));

    expect(router.routeInformationProvider.value.uri.path, '/');
  });

  testWidgets('redirects bakers away from client-only routes', (tester) async {
    final auth = _TestAuthProvider()
      ..currentUser = User(
        id: 'baker-test',
        email: 'baker@test.invalid',
        role: 'repostero',
      );
    final router = createGoRouter(auth);
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(auth, router));
    await tester.pump();
    router.go('/carrito');
    await tester.pump(const Duration(seconds: 1));

    expect(router.routeInformationProvider.value.uri.path, '/dashboard');
  });

  testWidgets('allows a client to open the cart', (tester) async {
    final auth = _TestAuthProvider()
      ..authenticate(User(
        id: 'client-test',
        email: 'client@test.invalid',
        role: 'cliente',
      ));
    final router = createGoRouter(auth);
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(auth, router));
    await tester.pump();
    router.go('/carrito');
    await tester.pump(const Duration(seconds: 1));

    expect(router.routeInformationProvider.value.uri.path, '/carrito');
  });
}

Widget _app(_TestAuthProvider auth, GoRouter router) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>.value(value: auth),
      ChangeNotifierProvider(create: (_) => CartProvider()),
    ],
    child: DanheeApp(router: router),
  );
}
