import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

/// Indicador de carga personalizado
class LoadingIndicator extends StatelessWidget {
  final String? message;
  
  const LoadingIndicator({this.message, super.key});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.gold,
            strokeWidth: 3,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
