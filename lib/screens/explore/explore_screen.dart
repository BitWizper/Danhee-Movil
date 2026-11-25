import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../models/cake.dart';
import '../../widgets/cards/cake_card.dart';
import '../../repositories/cake_repository.dart';

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
        title: Text(
          widget.category != null
              ? _getCategoryName(widget.category!)
              : 'Explorar Pasteles',
        ),
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
            child: _CakesList(
              category: widget.category,
              query: _searchController.text,
            ),
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
  final String query;

  const _CakesList({this.category, required this.query});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cake>>(
      future: MockRepositories.cakes.getCakes(category: category, query: query),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'No se pudieron cargar los pasteles: ${snapshot.error}',
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.gold),
          );
        }
        final cakes = snapshot.data!;
        if (cakes.isEmpty) {
          return Center(
            child: Text(
              'No hay pasteles disponibles',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: cakes.length,
          itemBuilder: (context, index) => CakeCard(
            cake: cakes[index],
            onTap: () => GoRouter.of(
              context,
            ).pushNamed('cake-detail', pathParameters: {'id': cakes[index].id}),
          ),
        );
      },
    );
  }
}
