import 'dart:math';

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PulsarBackground extends StatefulWidget {
  const PulsarBackground({super.key});

  @override
  State<PulsarBackground> createState() => _PulsarBackgroundState();
}

class _PulsarBackgroundState extends State<PulsarBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _rotationController;

  late Animation<double> _pulseAnimation1;
  late Animation<double> _pulseAnimation2;
  late Animation<double> _pulseAnimation3;
  late Animation<double> _opacityAnimation1;
  late Animation<double> _opacityAnimation2;
  late Animation<double> _opacityAnimation3;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _controller2 = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _controller3 = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation1 = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller1, curve: Curves.easeInOut));

    _pulseAnimation2 = Tween<double>(
      begin: 0.2,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller2, curve: Curves.easeInOut));

    _pulseAnimation3 = Tween<double>(
      begin: 0.4,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller3, curve: Curves.easeInOut));

    _opacityAnimation1 = Tween<double>(
      begin: 0.05,
      end: 0.15,
    ).animate(CurvedAnimation(parent: _controller1, curve: Curves.easeInOut));

    _opacityAnimation2 = Tween<double>(
      begin: 0.08,
      end: 0.20,
    ).animate(CurvedAnimation(parent: _controller2, curve: Curves.easeInOut));

    _opacityAnimation3 = Tween<double>(
      begin: 0.06,
      end: 0.12,
    ).animate(CurvedAnimation(parent: _controller3, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.5,
          colors: [
            AppTheme.deepSpace.withValues(alpha: 0.3),
            AppTheme.voidBlack,
          ],
        ),
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller1,
            builder: (context, child) {
              return Positioned(
                top: 100,
                right: 50,
                child: Transform.rotate(
                  angle: _rotationController.value * 2 * 3.14159,
                  child: Transform.scale(
                    scale: _pulseAnimation1.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.plasmaGreen.withValues(
                              alpha: _opacityAnimation1.value,
                            ),
                            AppTheme.plasmaGreen.withValues(
                              alpha: _opacityAnimation1.value * 0.5,
                            ),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _controller2,
            builder: (context, child) {
              return Positioned(
                bottom: 150,
                left: 30,
                child: Transform.rotate(
                  angle: -_rotationController.value * 1.5 * 3.14159,
                  child: Transform.scale(
                    scale: _pulseAnimation2.value,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.magneticField.withValues(
                              alpha: _opacityAnimation2.value,
                            ),
                            AppTheme.magneticField.withValues(
                              alpha: _opacityAnimation2.value * 0.3,
                            ),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.8, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _controller3,
            builder: (context, child) {
              return Positioned(
                top: 300,
                left: MediaQuery.of(context).size.width * 0.6,
                child: Transform.rotate(
                  angle: _rotationController.value * 0.8 * 3.14159,
                  child: Transform.scale(
                    scale: _pulseAnimation3.value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.neutronWhite.withValues(
                              alpha: _opacityAnimation3.value,
                            ),
                            AppTheme.neutronWhite.withValues(
                              alpha: _opacityAnimation3.value * 0.4,
                            ),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Positioned.fill(
                child: CustomPaint(
                  painter: StarFieldPainter(_rotationController.value),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class StarFieldPainter extends CustomPainter {
  final double animationValue;

  StarFieldPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppTheme.starlight.withValues(alpha: 0.6);

    // Predefined star positions for more natural distribution
    final stars = [
      {'x': 0.1, 'y': 0.15, 'speed': 1.0, 'brightness': 0.8},
      {'x': 0.25, 'y': 0.08, 'speed': 0.7, 'brightness': 0.6},
      {'x': 0.35, 'y': 0.22, 'speed': 1.2, 'brightness': 0.9},
      {'x': 0.45, 'y': 0.05, 'speed': 0.9, 'brightness': 0.5},
      {'x': 0.55, 'y': 0.18, 'speed': 0.8, 'brightness': 0.7},
      {'x': 0.68, 'y': 0.12, 'speed': 1.1, 'brightness': 0.8},
      {'x': 0.75, 'y': 0.25, 'speed': 0.6, 'brightness': 0.4},
      {'x': 0.85, 'y': 0.07, 'speed': 1.3, 'brightness': 0.9},
      {'x': 0.92, 'y': 0.20, 'speed': 0.5, 'brightness': 0.6},
      {'x': 0.15, 'y': 0.35, 'speed': 0.9, 'brightness': 0.7},
      {'x': 0.28, 'y': 0.42, 'speed': 1.1, 'brightness': 0.5},
      {'x': 0.38, 'y': 0.55, 'speed': 0.8, 'brightness': 0.8},
      {'x': 0.52, 'y': 0.48, 'speed': 1.2, 'brightness': 0.6},
      {'x': 0.62, 'y': 0.38, 'speed': 0.7, 'brightness': 0.9},
      {'x': 0.72, 'y': 0.58, 'speed': 1.0, 'brightness': 0.4},
      {'x': 0.82, 'y': 0.45, 'speed': 0.6, 'brightness': 0.7},
      {'x': 0.18, 'y': 0.65, 'speed': 1.3, 'brightness': 0.8},
      {'x': 0.32, 'y': 0.72, 'speed': 0.9, 'brightness': 0.5},
      {'x': 0.48, 'y': 0.68, 'speed': 0.8, 'brightness': 0.6},
      {'x': 0.58, 'y': 0.78, 'speed': 1.1, 'brightness': 0.9},
      {'x': 0.78, 'y': 0.72, 'speed': 0.7, 'brightness': 0.4},
      {'x': 0.88, 'y': 0.65, 'speed': 1.2, 'brightness': 0.8},
      {'x': 0.12, 'y': 0.85, 'speed': 0.5, 'brightness': 0.6},
      {'x': 0.25, 'y': 0.92, 'speed': 1.0, 'brightness': 0.7},
      {'x': 0.42, 'y': 0.88, 'speed': 0.8, 'brightness': 0.5},
      {'x': 0.65, 'y': 0.95, 'speed': 0.9, 'brightness': 0.8},
      {'x': 0.78, 'y': 0.88, 'speed': 1.1, 'brightness': 0.6},
      {'x': 0.92, 'y': 0.82, 'speed': 0.6, 'brightness': 0.9},
      // Additional scattered stars
      {'x': 0.05, 'y': 0.45, 'speed': 1.4, 'brightness': 0.3},
      {'x': 0.95, 'y': 0.35, 'speed': 0.4, 'brightness': 0.7},
      {'x': 0.22, 'y': 0.28, 'speed': 1.0, 'brightness': 0.5},
      {'x': 0.87, 'y': 0.52, 'speed': 0.8, 'brightness': 0.6},
      {'x': 0.33, 'y': 0.15, 'speed': 1.2, 'brightness': 0.4},
      {'x': 0.67, 'y': 0.75, 'speed': 0.7, 'brightness': 0.8},
      {'x': 0.53, 'y': 0.32, 'speed': 0.9, 'brightness': 0.5},
      {'x': 0.73, 'y': 0.18, 'speed': 1.1, 'brightness': 0.7},
      {'x': 0.08, 'y': 0.62, 'speed': 0.6, 'brightness': 0.4},
      {'x': 0.98, 'y': 0.75, 'speed': 1.3, 'brightness': 0.6},
      {'x': 0.43, 'y': 0.08, 'speed': 0.5, 'brightness': 0.8},
      {'x': 0.17, 'y': 0.98, 'speed': 1.0, 'brightness': 0.3},
    ];

    for (final star in stars) {
      final x = star['x']! * size.width;
      final y = star['y']! * size.height;
      final speed = star['speed']!;
      final brightness = star['brightness']!;

      // Create twinkling effect with different phases for each star
      final twinklePhase = animationValue * speed * 2 * 3.14159;
      final twinkle = 0.3 + 0.7 * (sin(twinklePhase) * 0.5 + 0.5);
      final finalOpacity = brightness * twinkle * 0.8;

      // Vary star sizes slightly
      final baseSize = brightness > 0.7 ? 1.5 : 1.0;
      final radius = baseSize * (0.8 + 0.4 * twinkle);

      paint.color = AppTheme.starlight.withValues(alpha: finalOpacity);
      canvas.drawCircle(Offset(x, y), radius, paint);

      // Add subtle glow for brighter stars
      if (brightness > 0.7) {
        paint.color = AppTheme.plasmaGreen.withValues(
          alpha: finalOpacity * 0.3,
        );
        canvas.drawCircle(Offset(x, y), radius * 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
