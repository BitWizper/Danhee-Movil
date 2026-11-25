import '../models/cake.dart';
import '../models/cart.dart';

abstract interface class CartRepository {
  Future<Cart> getCart({required String userId});
  Future<Cart> addCake({
    required String userId,
    required Cake cake,
    required int quantity,
    String? notes,
  });
  Future<Cart> removeItem({required String userId, required String itemId});
  Future<Cart> updateQuantity({
    required String userId,
    required String itemId,
    required int quantity,
  });
  Future<Cart> clearCart({required String userId});
  Future<void> checkout({required String userId});
}

class MockCartRepository implements CartRepository {
  final Map<String, List<CartItem>> _itemsByUser = {};
  int _nextItemId = 1;

  @override
  Future<Cart> getCart({required String userId}) async => _buildCart(userId);

  @override
  Future<Cart> addCake({
    required String userId,
    required Cake cake,
    required int quantity,
    String? notes,
  }) async {
    if (quantity < 1) {
      throw ArgumentError.value(quantity, 'quantity', 'Must be positive');
    }
    final items = _itemsByUser.putIfAbsent(userId, () => []);
    final existingIndex = items.indexWhere((item) => item.cakeId == cake.id);
    if (existingIndex == -1) {
      items.add(
        CartItem(
          id: 'cart-item-${_nextItemId++}',
          cakeId: cake.id,
          cakeName: cake.name,
          cakeImage: cake.imageUrl,
          price: cake.price,
          quantity: quantity,
          notes: notes,
        ),
      );
    } else {
      final item = items[existingIndex];
      items[existingIndex] = CartItem(
        id: item.id,
        cakeId: item.cakeId,
        cakeName: item.cakeName,
        cakeImage: item.cakeImage,
        price: item.price,
        quantity: item.quantity + quantity,
        notes: notes ?? item.notes,
      );
    }
    return _buildCart(userId);
  }

  @override
  Future<Cart> removeItem({
    required String userId,
    required String itemId,
  }) async {
    _itemsByUser[userId]?.removeWhere((item) => item.id == itemId);
    return _buildCart(userId);
  }

  @override
  Future<Cart> updateQuantity({
    required String userId,
    required String itemId,
    required int quantity,
  }) async {
    if (quantity < 1) {
      return removeItem(userId: userId, itemId: itemId);
    }
    final items = _itemsByUser[userId] ?? [];
    final index = items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final item = items[index];
      items[index] = CartItem(
        id: item.id,
        cakeId: item.cakeId,
        cakeName: item.cakeName,
        cakeImage: item.cakeImage,
        price: item.price,
        quantity: quantity,
        notes: item.notes,
      );
    }
    return _buildCart(userId);
  }

  @override
  Future<Cart> clearCart({required String userId}) async {
    _itemsByUser.remove(userId);
    return _buildCart(userId);
  }

  @override
  Future<void> checkout({required String userId}) async {
    _itemsByUser.remove(userId);
  }

  Cart _buildCart(String userId) {
    final items = List<CartItem>.unmodifiable(_itemsByUser[userId] ?? []);
    return Cart(
      id: 'cart-$userId',
      userId: userId,
      items: items,
      total: items.fold(0.0, (total, item) => total + item.subtotal),
    );
  }
}

class MockCartRepositories {
  MockCartRepositories._();

  static final CartRepository instance = MockCartRepository();
}
