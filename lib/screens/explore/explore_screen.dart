import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/cake.dart';
import '../../widgets/cards/cake_card.dart';

/// Pantalla de exploración de pasteles
class ExploreScreen extends StatefulWidget {
  final String? category;
  
  const ExploreScreen({this.category, super.key});
  
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(widget.category != null 
          ? _getCategoryName(widget.category!) 
          : 'Explorar Pasteles'),
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar pasteles...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          
          // Lista de pasteles
          Expanded(
            child: _CakesList(category: widget.category),
          ),
        ],
      ),
    );
  }
  
  String _getCategoryName(String category) {
    switch (category) {
      case 'wedding':
        return 'Pasteles de Boda';
      case 'birthday':
        return 'Pasteles de Cumpleaños';
      case 'babyshower':
        return 'Pasteles de Baby Shower';
      case 'corporate':
        return 'Pasteles Corporativos';
      case 'graduation':
        return 'Pasteles de Graduación';
      case 'xv':
        return 'Pasteles de XV Años';
      case 'anniversary':
        return 'Pasteles de Aniversario';
      default:
        return 'Explorar';
    }
  }
}

class _CakesList extends StatelessWidget {
  final String? category;
  
  const _CakesList({this.category});
  
  @override
  Widget build(BuildContext context) {
    // Placeholder - en producción esto vendría de la API
    final cakes = <Cake>[
      Cake(
        id: '1',
        name: 'Pastel de Boda Clásico',
        description: 'Elegante pastel de vainilla con decoración minimalista',
        price: 2200.00,
        imageUrl: null,
        categoryId: category ?? '1',
        bakerId: '1',
        isFeatured: true,
      ),
      Cake(
        id: '2',
        name: 'Pastel de Chocolate Intenso',
        description: 'Tres leches con cobertura de chocolate belga',
        price: 950.00,
        imageUrl: null,
        categoryId: category ?? '2',
        bakerId: '2',
        isFeatured: false,
      ),
      Cake(
        id: '3',
        name: 'Pastel de Fresa',
        description: 'Bizcocho de fresa con crema fresca',
        price: 800.00,
        imageUrl: null,
        categoryId: category ?? '3',
        bakerId: '1',
        isFeatured: false,
      ),
    ];
    
    if (cakes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cake_outlined,
              size: 64,
              color: AppColors.goldDim,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay pasteles disponibles',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: cakes.length,
      itemBuilder: (context, index) {
        return CakeCard(
          cake: cakes[index],
          onTap: () {
            // TODO: Navegar a detalle del pastel
          },
        );
      },
    );
  }
}
