import 'package:danhee_movil/models/cake.dart';
import 'package:danhee_movil/repositories/appointment_repository.dart';
import 'package:danhee_movil/repositories/auth_repository.dart';
import 'package:danhee_movil/repositories/cake_repository.dart';
import 'package:danhee_movil/repositories/cart_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mock repositories', () {
    test('filters cakes by category and search query', () async {
      final repository = MockCakeRepository();

      final cakes = await repository.getCakes(
        category: 'wedding',
        query: 'elegante',
      );

      expect(cakes, hasLength(1));
      expect(cakes.single.id, 'cake-wedding');
    });

    test('updates cart quantities and clears it after checkout', () async {
      final repository = MockCartRepository();
      const userId = 'cart-test-user';
      final cake = Cake(
        id: 'cake-test',
        name: 'Pastel de prueba',
        description: '',
        price: 250,
        categoryId: 'birthday',
        bakerId: 'baker-test',
      );

      await repository.addCake(userId: userId, cake: cake, quantity: 2);
      final cart = await repository.getCart(userId: userId);
      expect(cart.total, 500);
      expect(cart.totalItems, 2);

      await repository.checkout(userId: userId);
      expect((await repository.getCart(userId: userId)).isEmpty, isTrue);
    });

    test('creates, filters and cancels appointments', () async {
      final repository = MockAppointmentRepository();
      final appointment = await repository.createAppointment(
        clientId: 'client-test',
        clientName: 'Cliente',
        bakerId: 'baker-test',
        bakerName: 'Repostero',
        date: DateTime(2026, 12, 1),
        timeSlot: '10:00',
      );

      expect(
        await repository.getAppointments(userId: 'client-test', isBaker: false),
        hasLength(1),
      );
      expect(
        await repository.getAppointments(userId: 'baker-test', isBaker: true),
        hasLength(1),
      );

      await repository.cancelAppointment(appointment.id);
      final appointments = await repository.getAppointments(
        userId: 'client-test',
        isBaker: false,
      );
      expect(appointments.single.isCancelled, isTrue);
    });

    test('supports demo logins and rejects invalid credentials', () async {
      final repository = MockAuthRepository();

      final client = await repository.login(
        'cliente@danhee.test',
        'cliente123',
      );
      expect(client.user.isClient, isTrue);

      await expectLater(
        repository.login('cliente@danhee.test', 'wrong-password'),
        throwsStateError,
      );
    });
  });
}
