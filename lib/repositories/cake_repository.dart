import '../models/cake.dart';

abstract interface class CakeRepository {
  Future<List<Cake>> getCakes({
    String? category,
    String? query,
    bool featuredOnly = false,
  });

  Future<Cake?> getCakeById(String cakeId);
}

class MockCakeRepository implements CakeRepository {
  static final List<Cake> _cakes = [
    Cake(
      id: 'cake-wedding',
      name: 'Pastel de Boda Elegante',
      description: 'Pastel de tres pisos con fondant y flores frescas.',
      price: 2500,
      categoryId: 'wedding',
      categoryName: 'Boda',
      bakerId: 'baker-1',
      bakerName: 'Dulce Atelier',
      isFeatured: true,
    ),
    Cake(
      id: 'cake-birthday',
      name: 'Pastel de Cumpleaños',
      description: 'Bizcocho de vainilla, frutas frescas y crema.',
      price: 850,
      categoryId: 'birthday',
      categoryName: 'Cumpleaños',
      bakerId: 'baker-2',
      bakerName: 'Horno de Ana',
      isFeatured: true,
    ),
    Cake(
      id: 'cake-chocolate',
      name: 'Chocolate Intenso',
      description: 'Pastel de chocolate belga con ganache artesanal.',
      price: 950,
      categoryId: 'anniversary',
      categoryName: 'Aniversario',
      bakerId: 'baker-1',
      bakerName: 'Dulce Atelier',
    ),
    Cake(
      id: 'cake-babyshower',
      name: 'Pastel Baby Shower',
      description: 'Diseño personalizado en tonos pastel.',
      price: 1100,
      categoryId: 'babyshower',
      categoryName: 'Baby Shower',
      bakerId: 'baker-2',
      bakerName: 'Horno de Ana',
    ),
    Cake(
      id: 'cake-corporate',
      name: 'Pastel Corporativo',
      description: 'Pastel personalizado para celebraciones de empresa.',
      price: 1450,
      categoryId: 'corporate',
      categoryName: 'Corporativo',
      bakerId: 'baker-1',
      bakerName: 'Dulce Atelier',
    ),
    Cake(
      id: 'cake-graduation',
      name: 'Pastel de Graduación',
      description: 'Decoración temática para celebrar un gran logro.',
      price: 1250,
      categoryId: 'graduation',
      categoryName: 'Graduación',
      bakerId: 'baker-2',
      bakerName: 'Horno de Ana',
    ),
    Cake(
      id: 'cake-xv',
      name: 'Pastel XV Años',
      description: 'Diseño elegante con detalles hechos a mano.',
      price: 2200,
      categoryId: 'xv',
      categoryName: 'XV Años',
      bakerId: 'baker-1',
      bakerName: 'Dulce Atelier',
    ),
  ];

  @override
  Future<List<Cake>> getCakes({
    String? category,
    String? query,
    bool featuredOnly = false,
  }) async {
    final normalizedCategory = category?.toLowerCase();
    final normalizedQuery = query?.trim().toLowerCase();
    return _cakes.where((cake) {
      final matchesCategory =
          normalizedCategory == null ||
          cake.categoryId.toLowerCase() == normalizedCategory;
      final matchesQuery =
          normalizedQuery == null ||
          normalizedQuery.isEmpty ||
          cake.name.toLowerCase().contains(normalizedQuery) ||
          cake.description.toLowerCase().contains(normalizedQuery) ||
          (cake.bakerName?.toLowerCase().contains(normalizedQuery) ?? false);
      return matchesCategory &&
          matchesQuery &&
          (!featuredOnly || cake.isFeatured);
    }).toList();
  }

  @override
  Future<Cake?> getCakeById(String cakeId) async {
    for (final cake in _cakes) {
      if (cake.id == cakeId) return cake;
    }
    return null;
  }
}

class MockRepositories {
  MockRepositories._();

  static final CakeRepository cakes = MockCakeRepository();
}
