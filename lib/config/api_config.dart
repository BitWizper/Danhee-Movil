/// Configuración centralizada de la API
/// Todas las URLs y endpoints están definidos en este archivo
class ApiConfig {
  // URL base del backend - cambiar según entorno
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:4000/api',
  );
  
  // Endpoints de autenticación
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String registerBaker = '/auth/register-baker';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
  
  // Endpoints de pasteles
  static const String cakes = '/cakes';
  static const String cakeDetail = '/cakes/';
  static const String cakesByCategory = '/cakes/category/';
  
  // Endpoints de categorías
  static const String categories = '/categories';
  
  // Endpoints de reposteros
  static const String bakers = '/bakers';
  static const String bakerProfile = '/bakers/';
  static const String bakerCakes = '/bakers/';
  
  // Endpoints de citas
  static const String appointments = '/appointments';
  static const String myAppointments = '/appointments/my';
  static const String bakerAppointments = '/appointments/baker';
  
  // Endpoints de carrito
  static const String cart = '/cart';
  static const String cartAdd = '/cart/add';
  static const String cartRemove = '/cart/remove';
  static const String cartUpdate = '/cart/update';
  
  // Endpoints de checkout/pagos
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  
  // Endpoints de chatbot
  static const String chat = '/chat';
  
  // Timeout para las peticiones
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
