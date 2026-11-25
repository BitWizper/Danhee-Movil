import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/explore/explore_screen.dart';
import '../screens/baker/baker_profile_screen.dart';
import '../screens/baker/baker_dashboard_screen.dart';
import '../screens/cake/cake_detail_screen.dart';
import '../screens/appointment/appointment_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/my_appointments/my_appointments_screen.dart';
import '../config/app_theme.dart';
import '../providers/auth_provider.dart';

/// Configuración de rutas de la aplicación usando go_router
/// Todas las rutas están centralizadas en este archivo
class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String explore = '/explore';
  static const String bakerProfile = '/repostero/:id';
  static const String bakerDashboard = '/dashboard';
  static const String cakeDetail = '/pastel/:id';
  static const String appointment = '/agenda';
  static const String appointmentWithBaker = '/agenda/:id';
  static const String cart = '/carrito';
  static const String checkout = '/checkout';
  static const String myAppointments = '/mis-citas';
  
  // Categorías
  static const String wedding = '/wedding';
  static const String anniversary = '/anniversary';
  static const String corporate = '/corporate';
  static const String graduation = '/graduation';
  static const String xv = '/xv';
  static const String birthday = '/birthday';
  static const String babyshower = '/babyshower';
}

/// Crea el router enlazado al estado de autenticación de la sesión.
GoRouter createGoRouter(AuthProvider authProvider) => GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true,
  refreshListenable: authProvider,
  redirect: (context, state) {
    final isAuthenticated = authProvider.isAuthenticated;
    final location = state.matchedLocation;
    final isLoginOrRegister =
        location == AppRoutes.login || location == AppRoutes.register;
    final isBakerRoute = location == AppRoutes.bakerDashboard;
    final isClientRoute = location == AppRoutes.appointment ||
        location.startsWith('${AppRoutes.appointment}/') ||
        location == AppRoutes.cart ||
        location == AppRoutes.checkout ||
        location == AppRoutes.myAppointments;

    if (!isAuthenticated && (isBakerRoute || isClientRoute)) {
      return Uri(
        path: AppRoutes.login,
        queryParameters: {'from': state.uri.toString()},
      ).toString();
    }

    if (isAuthenticated && isLoginOrRegister) {
      final requestedLocation = state.uri.queryParameters['from'];
      if (requestedLocation != null &&
          requestedLocation.startsWith('/') &&
          !requestedLocation.startsWith('//') &&
          requestedLocation != AppRoutes.login &&
          requestedLocation != AppRoutes.register) {
        return requestedLocation;
      }
      return authProvider.isBaker ? AppRoutes.bakerDashboard : AppRoutes.home;
    }

    if (isAuthenticated && isBakerRoute && !authProvider.isBaker) {
      return AppRoutes.home;
    }
    if (isAuthenticated && isClientRoute && !authProvider.isClient) {
      return authProvider.isBaker ? AppRoutes.bakerDashboard : AppRoutes.home;
    }
    return null;
  },
  routes: [
    // Rutas públicas
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.explore,
      name: 'explore',
      builder: (context, state) => const ExploreScreen(),
    ),
    GoRoute(
      path: AppRoutes.bakerProfile,
      name: 'baker-profile',
      builder: (context, state) {
        final bakerId = state.pathParameters['id']!;
        return BakerProfileScreen(bakerId: bakerId);
      },
    ),
    GoRoute(
      path: AppRoutes.cakeDetail,
      name: 'cake-detail',
      builder: (context, state) {
        final cakeId = state.pathParameters['id']!;
        return CakeDetailScreen(cakeId: cakeId);
      },
    ),
    
    // Categorías
    GoRoute(
      path: AppRoutes.wedding,
      name: 'wedding',
      builder: (context, state) => const ExploreScreen(category: 'wedding'),
    ),
    GoRoute(
      path: AppRoutes.anniversary,
      name: 'anniversary',
      builder: (context, state) => const ExploreScreen(category: 'anniversary'),
    ),
    GoRoute(
      path: AppRoutes.corporate,
      name: 'corporate',
      builder: (context, state) => const ExploreScreen(category: 'corporate'),
    ),
    GoRoute(
      path: AppRoutes.graduation,
      name: 'graduation',
      builder: (context, state) => const ExploreScreen(category: 'graduation'),
    ),
    GoRoute(
      path: AppRoutes.xv,
      name: 'xv',
      builder: (context, state) => const ExploreScreen(category: 'xv'),
    ),
    GoRoute(
      path: AppRoutes.birthday,
      name: 'birthday',
      builder: (context, state) => const ExploreScreen(category: 'birthday'),
    ),
    GoRoute(
      path: AppRoutes.babyshower,
      name: 'babyshower',
      builder: (context, state) => const ExploreScreen(category: 'babyshower'),
    ),
    
    // Rutas protegidas (requieren autenticación)
    GoRoute(
      path: AppRoutes.appointment,
      name: 'appointment',
      builder: (context, state) => const AppointmentScreen(),
    ),
    GoRoute(
      path: AppRoutes.appointmentWithBaker,
      name: 'appointment-with-baker',
      builder: (context, state) {
        final bakerId = state.pathParameters['id']!;
        return AppointmentScreen(bakerId: bakerId);
      },
    ),
    GoRoute(
      path: AppRoutes.cart,
      name: 'cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: AppRoutes.checkout,
      name: 'checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: AppRoutes.myAppointments,
      name: 'my-appointments',
      builder: (context, state) => const MyAppointmentsScreen(),
    ),
    GoRoute(
      path: AppRoutes.bakerDashboard,
      name: 'baker-dashboard',
      builder: (context, state) => const BakerDashboardScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: AppColors.bg,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '🎂',
            style: TextStyle(fontSize: 64),
          ),
          SizedBox(height: 16),
          Text(
            'Página no encontrada',
            style: TextStyle(
              color: AppColors.cream,
              fontSize: 24,
              fontFamily: 'Cormorant Garamond',
            ),
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () => context.go(AppRoutes.home),
            child: Text(
              '← Volver al inicio',
              style: TextStyle(color: AppColors.gold),
            ),
          ),
        ],
      ),
    ),
  ),
  );
