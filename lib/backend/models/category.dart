/// Modelo de categoría
/// Mapea con la tabla 'categories' en PostgreSQL
class Category {
  final int id;
  final String name;
  final String slug;
  final String? icon;
  final String? description;
  final bool isActive;
  final int sortOrder;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.icon,
    this.description,
    this.isActive = true,
    this.sortOrder = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      icon: json['icon'] as String?,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'icon': icon,
      'description': description,
      'is_active': isActive,
      'sort_order': sortOrder,
    };
  }
}
