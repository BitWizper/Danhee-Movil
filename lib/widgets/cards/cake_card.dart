import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/app_theme.dart';
import '../../models/cake.dart';

/// Card para mostrar un pastel
class CakeCard extends StatelessWidget {
  final Cake cake;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  
  const CakeCard({
    required this.cake,
    this.onTap,
    this.onAddToCart,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del pastel
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: cake.hasImage
                  ? CachedNetworkImage(
                      imageUrl: cake.imageUrl!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 180,
                        color: AppColors.surface2,
                        child: const Center(
                          child: CircularProgressIndicator(color: AppColors.gold),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 180,
                        color: AppColors.surface2,
                        child: const Center(
                          child: Icon(Icons.cake, size: 48, color: AppColors.goldDim),
                        ),
                      ),
                    )
                  : Container(
                      height: 180,
                      color: AppColors.surface2,
                      child: const Center(
                        child: Icon(Icons.cake, size: 48, color: AppColors.goldDim),
                      ),
                    ),
            ),
            
            // Información del pastel
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre
                  Text(
                    cake.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Descripción
                  Text(
                    cake.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  
                  // Precio y botón agregar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cake.formattedPrice,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (onAddToCart != null)
                        IconButton(
                          onPressed: onAddToCart,
                          icon: const Icon(Icons.add_shopping_cart),
                          color: AppColors.gold,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
