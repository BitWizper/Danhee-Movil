import 'package:danhee_movil/models/cake.dart';
import 'package:danhee_movil/providers/auth_provider.dart';
import 'package:danhee_movil/providers/cart_provider.dart';
import 'package:danhee_movil/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('auth provider surfaces failed credentials and resets loading', () async {
    final provider = AuthProvider(repository: MockAuthRepository());

    final authenticated = await provider.login(
      'cliente@danhee.test',
      'wrong-password',
    );

    expect(authenticated, isFalse);
    expect(provider.isLoading, isFalse);
    expect(provider.errorMessage, isNotNull);
    expect(provider.isAuthenticated, isFalse);
  });

  test('cart provider adds a cake and updates total state', () async {
    final provider = CartProvider();
    final cake = Cake(
      id: 'provider-cake',
      name: 'Prueba',
      description: '',
      price: 180,
      categoryId: 'birthday',
      bakerId: 'baker-test',
    );

    expect(await provider.addToCart(cake, quantity: 2), isTrue);
    expect(provider.itemCount, 2);
    expect(provider.total, 360);
    expect(provider.errorMessage, isNull);
  });
}
