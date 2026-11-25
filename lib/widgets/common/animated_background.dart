import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

/// Fondo animado con destellos dorados
/// Simula el efecto de CursorGlow de la web pero adaptado para móvil
class AnimatedBackground extends StatefulWidget {
  final Widget child;
  
  const AnimatedBackground({required this.child, super.key});
  
  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo base
        Container(color: AppColors.bg),
        
        // Destellos animados
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              size: Size.infinite,
              painter: _GlowPainter(_animation.value),
            );
          },
        ),
        
        // Contenido
        widget.child,
      ],
    );
  }
}

class _GlowPainter extends CustomPainter {
  final double animation;
  
  _GlowPainter(this.animation);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80)
      ..color = AppColors.gold.withValues(alpha: 0.15);
    
    // Crear múltiples destellos que se mueven
    final glow1 = Offset(
      size.width * 0.2 + (animation * size.width * 0.6),
      size.height * 0.3 + (animation * size.height * 0.4),
    );
    
    final glow2 = Offset(
      size.width * 0.8 - (animation * size.width * 0.6),
      size.height * 0.7 - (animation * size.height * 0.4),
    );
    
    final glow3 = Offset(
      size.width * 0.5 + (animation * size.width * 0.3 - size.width * 0.15),
      size.height * 0.5 + (animation * size.height * 0.3 - size.height * 0.15),
    );
    
    // Dibujar destellos
    canvas.drawCircle(glow1, 150, paint);
    canvas.drawCircle(glow2, 120, paint);
    canvas.drawCircle(glow3, 100, paint);
  }
  
  @override
  bool shouldRepaint(covariant _GlowPainter oldDelegate) => true;
}
