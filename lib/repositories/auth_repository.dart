import '../api/api_service.dart';
import '../config/api_config.dart';
import '../models/auth_response.dart';
import '../models/user.dart';
import '../utils/storage_helper.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract interface class AuthRepository {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> registerClient({
    required String name,
    required String email,
    required String password,
    required String phone,
  });
  Future<AuthResponse> registerBaker({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String businessName,
    required String specialty,
    required String location,
    required String businessHours,
  });
  Future<User> getCurrentUser();
  Future<void> logout();
}

class MockAuthRepository implements AuthRepository {
  static final Map<String, _MockAccount> _accounts = {
    'cliente@danhee.test': _MockAccount(
      password: 'cliente123',
      user: User(
        id: 'demo-client',
        name: 'Cliente de prueba',
        email: 'cliente@danhee.test',
        phone: '5551234567',
        role: 'cliente',
      ),
    ),
    'repostero@danhee.test': _MockAccount(
      password: 'repostero123',
      user: User(
        id: 'baker-1',
        name: 'Dulce Atelier',
        email: 'repostero@danhee.test',
        phone: '5559876543',
        role: 'repostero',
      ),
    ),
  };
  static final Map<String, User> _usersByAccessToken = {};
  static int _nextUserId = 1;

  @override
  Future<AuthResponse> login(String email, String password) async {
    final account = _accounts[email.toLowerCase()];
    if (account == null || account.password != password) {
      throw StateError('Correo o contraseña incorrectos.');
    }
    return _createResponse(account.user);
  }

  @override
  Future<AuthResponse> registerClient({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    return _register(
      name: name,
      email: email,
      password: password,
      phone: phone,
      role: 'cliente',
    );
  }

  @override
  Future<AuthResponse> registerBaker({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String businessName,
    required String specialty,
    required String location,
    required String businessHours,
  }) async {
    return _register(
      name: businessName,
      email: email,
      password: password,
      phone: phone,
      role: 'repostero',
    );
  }

  Future<AuthResponse> _register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    final normalizedEmail = email.toLowerCase();
    if (_accounts.containsKey(normalizedEmail)) {
      throw StateError('Ya existe una cuenta con ese correo.');
    }
    final user = User(
      id: 'demo-user-${_nextUserId++}',
      name: name,
      email: normalizedEmail,
      phone: phone,
      role: role,
    );
    _accounts[normalizedEmail] = _MockAccount(password: password, user: user);
    return _createResponse(user);
  }

  AuthResponse _createResponse(User user) {
    final token = 'demo-access-${user.id}';
    _usersByAccessToken[token] = user;
    return AuthResponse(
      accessToken: token,
      refreshToken: 'demo-refresh-${user.id}',
      user: user,
    );
  }

  @override
  Future<User> getCurrentUser() async {
    final token = await StorageHelper.getAccessToken();
    final user = token == null ? null : _usersByAccessToken[token];
    if (user != null) return user;

    final userId = await StorageHelper.getUserId();
    final role = await StorageHelper.getUserRole();
    final name = await StorageHelper.getUserName();
    final email = await StorageHelper.getUserEmail();
    if (userId == null || role == null || email == null) {
      throw StateError('No se encontró la sesión de demostración.');
    }
    final restored = User(id: userId, name: name, email: email, role: role);
    if (token != null) _usersByAccessToken[token] = restored;
    return restored;
  }

  @override
  Future<void> logout() async {}
}

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  @override
  Future<AuthResponse> login(String email, String password) async {
    final response = await _apiService.post(
      ApiConfig.login,
      data: {'email': email, 'password': password},
    );
    return AuthResponse.fromJson(response.data);
  }

  @override
  Future<AuthResponse> registerClient({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final response = await _apiService.post(
      ApiConfig.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'role': 'cliente',
      },
    );
    return AuthResponse.fromJson(response.data);
  }

  @override
  Future<AuthResponse> registerBaker({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String businessName,
    required String specialty,
    required String location,
    required String businessHours,
  }) async {
    final response = await _apiService.post(
      ApiConfig.registerBaker,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'businessName': businessName,
        'specialty': specialty,
        'location': location,
        'businessHours': businessHours,
      },
    );
    return AuthResponse.fromJson(response.data);
  }

  @override
  Future<User> getCurrentUser() async {
    final response = await _apiService.get(ApiConfig.me);
    return User.fromJson(response.data);
  }

  @override
  Future<void> logout() async {
    await _apiService.post(ApiConfig.logout);
  }
}

typedef FirebaseBakerRoleProvisioner = Future<void> Function({
  required String uid,
  required String businessName,
  required String specialty,
  required String location,
  required String businessHours,
});

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required firebase_auth.FirebaseAuth firebaseAuth,
    this.bakerRoleProvisioner,
  }) : _firebaseAuth = firebaseAuth {
    _configureApiTokenProvider();
  }

  void _configureApiTokenProvider() {
    ApiService().setAccessTokenProvider(
      ({bool forceRefresh = false}) async =>
          _firebaseAuth.currentUser?.getIdToken(forceRefresh),
    );
  }

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseBakerRoleProvisioner? bakerRoleProvisioner;

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      _configureApiTokenProvider();
      final user = credential.user;
      if (user == null) throw StateError('Firebase no devolvió un usuario.');
      return await _createResponse(user);
    } on firebase_auth.FirebaseAuthException catch (error) {
      if (error.code == 'invalid-credential' ||
          error.code == 'user-not-found' ||
          error.code == 'wrong-password') {
        throw StateError('Correo o contraseña incorrectos.');
      }
      rethrow;
    }
  }

  @override
  Future<AuthResponse> registerClient({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    _configureApiTokenProvider();
    final user = credential.user;
    if (user == null) throw StateError('Firebase no devolvió un usuario.');
    await user.updateDisplayName(name.trim());
    await user.reload();
    return _createResponse(_firebaseAuth.currentUser ?? user);
  }

  @override
  Future<AuthResponse> registerBaker({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String businessName,
    required String specialty,
    required String location,
    required String businessHours,
  }) async {
    final provisionRole = bakerRoleProvisioner;
    if (provisionRole == null) {
      throw UnsupportedError(
        'El rol de repostero debe asignarse desde un servicio confiable.',
      );
    }

    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    _configureApiTokenProvider();
    final user = credential.user;
    if (user == null) throw StateError('Firebase no devolvió un usuario.');
    await user.updateDisplayName(businessName.trim());
    await provisionRole(
      uid: user.uid,
      businessName: businessName.trim(),
      specialty: specialty.trim(),
      location: location.trim(),
      businessHours: businessHours.trim(),
    );
    await user.getIdToken(true);
    await user.reload();
    return _createResponse(_firebaseAuth.currentUser ?? user);
  }

  @override
  Future<User> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw StateError('No hay una sesión de Firebase activa.');
    return _toAppUser(user);
  }

  @override
  Future<void> logout() => _firebaseAuth.signOut();

  Future<AuthResponse> _createResponse(firebase_auth.User user) async {
    final accessToken = await user.getIdToken();
    if (accessToken == null || accessToken.isEmpty) {
      throw StateError('Firebase no pudo emitir un token de acceso.');
    }
    return AuthResponse(
      accessToken: accessToken,
      // FirebaseAuth administra internamente la renovación de su refresh token.
      refreshToken: '',
      user: await _toAppUser(user),
    );
  }

  Future<User> _toAppUser(firebase_auth.User firebaseUser) async {
    final email = firebaseUser.email;
    if (email == null || email.isEmpty) {
      throw StateError('La cuenta de Firebase no tiene un correo asociado.');
    }
    final tokenResult = await firebaseUser.getIdTokenResult();
    final roleClaim = tokenResult.claims?['role'];
    return User(
      id: firebaseUser.uid,
      name: firebaseUser.displayName,
      email: email,
      phone: firebaseUser.phoneNumber,
      role: roleClaim == 'repostero' ? 'repostero' : 'cliente',
    );
  }
}

class _MockAccount {
  const _MockAccount({required this.password, required this.user});

  final String password;
  final User user;
}

class MockAuthRepositories {
  MockAuthRepositories._();

  static final AuthRepository instance = MockAuthRepository();
}
