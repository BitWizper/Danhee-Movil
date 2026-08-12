import 'package:flutter/foundation.dart';
import '../api/api_service.dart';
import '../config/api_config.dart';
import '../models/cart.dart';
import '../models/cake.dart';

/// Provider para manejo del carrito
class CartProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
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
  
  /// Obtener carrito del usuario
  Future<void> fetchCart() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await _apiService.get(ApiConfig.cart);
      _cart = Cart.fromJson(response.data);
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
      await _apiService.post(
        ApiConfig.cartAdd,
        data: {
          'cakeId': cake.id,
          'quantity': quantity,
          'notes': notes,
        },
      );
      
      await fetchCart();
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
      await _apiService.delete('${ApiConfig.cartRemove}/$cartItemId');
      await fetchCart();
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
      await _apiService.put(
        ApiConfig.cartUpdate,
        data: {
          'cartItemId': cartItemId,
          'quantity': quantity,
        },
      );
      await fetchCart();
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
      await _apiService.delete(ApiConfig.cart);
      _cart = null;
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
