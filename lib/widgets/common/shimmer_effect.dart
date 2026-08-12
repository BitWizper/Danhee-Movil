import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

/// Efecto shimmer para elementos interactivos
/// Simula un destello que pasa sobre el elemento
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Duration duration;
  
  const ShimmerEffect({
    required this.child,
    this.duration = const Duration(seconds: 2),
    super.key,
  });
  
  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(begin: -1, end: 1).animate(_controller);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.gold.withOpacity(0.0),
                AppColors.gold.withOpacity(0.3),
                AppColors.gold.withOpacity(0.0),
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
              transform: _SlidingGradientTransform(
                slidePercent: _animation.value,
              ),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  
  _SlidingGradientTransform({required this.slidePercent});
  
  @override
  Gradient? transform(Gradient gradient, Rect? bounds) {
    return gradient;
  }
}
