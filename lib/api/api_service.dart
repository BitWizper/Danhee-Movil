import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../utils/storage_helper.dart';

typedef AccessTokenProvider = Future<String?> Function({
  bool forceRefresh,
});

/// Servicio centralizado de API
/// Maneja todas las peticiones HTTP al backend
class ApiService {
  late final Dio _dio;
  AccessTokenProvider? _accessTokenProvider;

  void setAccessTokenProvider(AccessTokenProvider? provider) {
    _accessTokenProvider = provider;
  }
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    
    // Interceptor para agregar token JWT
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = _accessTokenProvider != null
            ? await _accessTokenProvider!(forceRefresh: false)
            : await StorageHelper.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Si es 401, intentar refresh token
        final isRefreshRequest =
            error.requestOptions.path.endsWith(ApiConfig.refreshToken);
        final alreadyRetried =
            error.requestOptions.extra['retriedAfterRefresh'] == true;
        if (error.response?.statusCode == 401 &&
            !isRefreshRequest &&
            !alreadyRetried) {
          try {
            final accessTokenProvider = _accessTokenProvider;
            if (accessTokenProvider == null) await _refreshToken();
            final token = accessTokenProvider != null
                ? await accessTokenProvider(forceRefresh: true)
                : await StorageHelper.getAccessToken();
            if (token != null) {
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $token';
              opts.extra['retriedAfterRefresh'] = true;
              final response = await _dio.fetch(opts);
              handler.resolve(response);
              return;
            }
          } catch (e) {
            // Si falla el refresh, limpiar tokens
            await StorageHelper.clearTokens();
          }
        }
        handler.next(error);
      },
    ));
  }
  
  /// Refrescar el token de acceso
  Future<void> _refreshToken() async {
    final refreshToken = await StorageHelper.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return;
    
    try {
      final response = await _dio.post(
        ApiConfig.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      
      if (response.statusCode == 200) {
        final accessToken = response.data['accessToken'];
        await StorageHelper.saveAccessToken(accessToken);
      }
    } catch (e) {
      throw Exception('Failed to refresh token');
    }
  }
  
  /// GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// POST request
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// PUT request
  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// DELETE request
  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// PATCH request
  Future<Response> patch(String path, {dynamic data}) async {
    try {
      return await _dio.patch(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Upload file
  Future<Response> uploadFile(String path, String filePath, {Map<String, dynamic>? data}) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        ...?data,
      });
      return await _dio.post(path, data: formData);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Manejar errores de Dio
  Exception _handleError(DioException error) {
    String message;
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Tiempo de espera agotado. Verifica tu conexión.';
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        final errorMessage = responseData is Map
            ? responseData['message']?.toString() ?? 'Error desconocido'
            : 'Error desconocido';
        
        switch (statusCode) {
          case 400:
            message = 'Solicitud inválida: $errorMessage';
            break;
          case 401:
            message = 'No autorizado. Inicia sesión nuevamente.';
            break;
          case 403:
            message = 'Acceso denegado.';
            break;
          case 404:
            message = 'Recurso no encontrado.';
            break;
          case 500:
            message = 'Error del servidor. Inténtalo más tarde.';
            break;
          default:
            message = errorMessage;
        }
        break;
      case DioExceptionType.cancel:
        message = 'Solicitud cancelada.';
        break;
      case DioExceptionType.unknown:
        message = 'Error de conexión. Verifica tu internet.';
        break;
      default:
        message = 'Error desconocido: ${error.message}';
    }
    
    return Exception(message);
  }
}
