import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/cards/cake_card.dart';
import '../../models/cake.dart';

/// Pantalla principal (Home)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeContent(),
          _ExploreContent(),
          _CartContent(),
          _ProfileContent(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();
  
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // AppBar
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Danhee Cake',
              style: TextStyle(
                fontFamily: 'Cormorant Garamond',
                color: AppColors.gold,
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.surface,
                    AppColors.bg,
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  '🎂',
                  style: TextStyle(fontSize: 80),
                ),
              ),
            ),
          ),
        ),
        
        // Contenido
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección de categorías
                Text(
                  'Categorías',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                
                // Categorías horizontal
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _CategoryCard(
                        icon: Icons.favorite,
                        label: 'Boda',
                        onTap: () => context.go(AppRoutes.wedding),
                      ),
                      _CategoryCard(
                        icon: Icons.cake,
                        label: 'Cumpleaños',
                        onTap: () => context.go(AppRoutes.birthday),
                      ),
                      _CategoryCard(
                        icon: Icons.child_care,
                        label: 'Baby Shower',
                        onTap: () => context.go(AppRoutes.babyshower),
                      ),
                      _CategoryCard(
                        icon: Icons.business,
                        label: 'Corporativo',
                        onTap: () => context.go(AppRoutes.corporate),
                      ),
                      _CategoryCard(
                        icon: Icons.school,
                        label: 'Graduación',
                        onTap: () => context.go(AppRoutes.graduation),
                      ),
                      _CategoryCard(
                        icon: Icons.celebration,
                        label: 'XV Años',
                        onTap: () => context.go(AppRoutes.xv),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Pasteles destacados
                Text(
                  'Pasteles Destacados',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                
                // Lista de pasteles (placeholder)
                _FeaturedCakesList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  
  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.gold, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedCakesList extends StatelessWidget {
  const _FeaturedCakesList();
  
  @override
  Widget build(BuildContext context) {
    // Placeholder - en producción esto vendría de la API
    final featuredCakes = <Cake>[
      Cake(
        id: '1',
        name: 'Pastel de Boda Elegante',
        description: 'Pastel de 3 pisos con decoración en fondant y flores frescas',
        price: 2500.00,
        imageUrl: null,
        categoryId: '1',
        bakerId: '1',
        isFeatured: true,
      ),
      Cake(
        id: '2',
        name: 'Pastel de Cumpleaños Infantil',
        description: 'Pastel temático con personajes y colores vibrantes',
        price: 850.00,
        imageUrl: null,
        categoryId: '2',
        bakerId: '2',
        isFeatured: true,
      ),
    ];
    
    return Column(
      children: featuredCakes.map((cake) {
        return CakeCard(
          cake: cake,
          onTap: () => context.go('${AppRoutes.cakeDetail}/${cake.id}'),
        );
      }).toList(),
    );
  }
}

class _ExploreContent extends StatelessWidget {
  const _ExploreContent();
  
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Explorar - En desarrollo'),
    );
  }
}

class _CartContent extends StatelessWidget {
  const _CartContent();
  
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Carrito - En desarrollo'),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();
  
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Avatar y nombre
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.gold,
                child: Text(
                  authProvider.user?.name?.substring(0, 1).toUpperCase() ?? 'U',
                  style: TextStyle(
                    fontSize: 32,
                    color: AppColors.bg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                authProvider.user?.name ?? 'Usuario',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              
              Text(
                authProvider.user?.email ?? '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.muted,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Opciones del menú
              _MenuOption(
                icon: Icons.person,
                title: 'Mi Perfil',
                onTap: () {},
              ),
              _MenuOption(
                icon: Icons.shopping_bag,
                title: 'Mis Pedidos',
                onTap: () => context.go(AppRoutes.myAppointments),
              ),
              if (authProvider.isBaker)
                _MenuOption(
                  icon: Icons.dashboard,
                  title: 'Dashboard de Repostero',
                  onTap: () => context.go(AppRoutes.bakerDashboard),
                ),
              _MenuOption(
                icon: Icons.settings,
                title: 'Configuración',
                onTap: () {},
              ),
              _MenuOption(
                icon: Icons.logout,
                title: 'Cerrar Sesión',
                onTap: () async {
                  await authProvider.logout();
                  if (context.mounted) {
                    context.go(AppRoutes.login);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MenuOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  
  const _MenuOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.gold),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
        onTap: onTap,
      ),
    );
  }
}
