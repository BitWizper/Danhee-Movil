import 'package:flutter/foundation.dart';
import '../models/cart.dart';
import '../models/cake.dart';
import '../repositories/cart_repository.dart';

/// Provider para manejo del carrito
class CartProvider with ChangeNotifier {
  CartProvider({CartRepository? repository, String userId = 'demo-client'})
    : _repository = repository ?? MockCartRepositories.instance,
      _userId = userId;

  final CartRepository _repository;
  String _userId;

  Cart? _cart;
  bool _isLoading = false;
  String? _errorMessage;

  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get total => _cart?.total ?? 0;
  int get itemCount => _cart?.totalItems ?? 0;
  bool get isEmpty => _cart?.isEmpty ?? true;
  bool get isNotEmpty => _cart?.isNotEmpty ?? false;

  void setUserId(String userId) {
    if (_userId == userId) return;
    _userId = userId;
    _cart = null;
  }

  Future<void> clearSession() async {
    final userId = _userId;
    _cart = null;
    _errorMessage = null;
    await _repository.clearCart(userId: userId);
    notifyListeners();
  }

  /// Obtener carrito del usuario
  Future<void> fetchCart() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cart = await _repository.getCart(userId: _userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Agregar pastel al carrito
  Future<bool> addToCart(Cake cake, {int quantity = 1, String? notes}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cart = await _repository.addCake(
        userId: _userId,
        cake: cake,
        quantity: quantity,
        notes: notes,
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Remover item del carrito
  Future<bool> removeFromCart(String cartItemId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cart = await _repository.removeItem(userId: _userId, itemId: cartItemId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Actualizar cantidad de item
  Future<bool> updateQuantity(String cartItemId, int quantity) async {
    if (quantity <= 0) {
      return await removeFromCart(cartItemId);
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cart = await _repository.updateQuantity(
        userId: _userId,
        itemId: cartItemId,
        quantity: quantity,
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Limpiar carrito
  Future<bool> clearCart() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cart = await _repository.clearCart(userId: _userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkout() async {
    if (isEmpty) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.checkout(userId: _userId);
      _cart = await _repository.getCart(userId: _userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Limpiar mensaje de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
