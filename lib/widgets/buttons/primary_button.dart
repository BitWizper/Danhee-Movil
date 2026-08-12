import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

/// Botón primario personalizado
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  
  const PrimaryButton({
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppColors.bg,
                  strokeWidth: 2,
                ),
              )
            : Text(text),
      ),
    );
  }
}
