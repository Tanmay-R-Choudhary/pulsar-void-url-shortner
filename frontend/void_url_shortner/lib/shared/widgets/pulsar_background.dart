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

  // Easter egg: Mouse tracking
  Offset _mousePosition = const Offset(0.5, 0.5); // Normalized coordinates
  bool _isMouseActive = false;
  int _clickCount = 0;
  DateTime? _lastClickTime;

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

    // Reduced opacity ranges for even darker effect
    _opacityAnimation1 = Tween<double>(
      begin: 0.01,
      end: 0.05,
    ).animate(CurvedAnimation(parent: _controller1, curve: Curves.easeInOut));

    _opacityAnimation2 = Tween<double>(
      begin: 0.015,
      end: 0.06,
    ).animate(CurvedAnimation(parent: _controller2, curve: Curves.easeInOut));

    _opacityAnimation3 = Tween<double>(
      begin: 0.01,
      end: 0.04,
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
    return MouseRegion(
      onHover: (event) {
        final size = MediaQuery.of(context).size;
        setState(() {
          _mousePosition = Offset(
            event.localPosition.dx / size.width,
            event.localPosition.dy / size.height,
          );
          _isMouseActive = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isMouseActive = false;
        });
      },
      child: GestureDetector(
        onTapDown: (details) {
          final now = DateTime.now();
          if (_lastClickTime != null &&
              now.difference(_lastClickTime!).inMilliseconds < 500) {
            _clickCount++;
          } else {
            _clickCount = 1;
          }
          _lastClickTime = now;

          final size = MediaQuery.of(context).size;
          setState(() {
            _mousePosition = Offset(
              details.localPosition.dx / size.width,
              details.localPosition.dy / size.height,
            );
          });
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 2.5, // Even larger radius for more subtle gradient
              colors: [
                AppTheme.deepSpace.withValues(alpha: 0.03), // Much much darker
                AppTheme.voidBlack,
                AppTheme.voidBlack, // Pure black at edges
              ],
              stops: const [0.0, 0.4, 1.0], // Darker transition point
            ),
          ),
          child: Stack(
            children: [
              // Deep space overlay for extra darkness
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.5), // Increased darkness
                      Colors.black.withValues(alpha: 0.3), // Increased darkness
                      Colors.black.withValues(alpha: 0.6), // Increased darkness
                    ],
                  ),
                ),
              ),
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
                                  alpha: _opacityAnimation1.value * 0.3,
                                ),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 1.0], // Tighter gradient
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
                                  alpha: _opacityAnimation2.value * 0.2,
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
                                  alpha: _opacityAnimation3.value * 0.2,
                                ),
                                Colors.transparent,
                              ],
                              stops: const [
                                0.0,
                                0.4,
                                1.0,
                              ], // Tighter for subtlety
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Secret effects on multiple clicks
              // (Removed supernova effect)
              AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return Positioned.fill(
                    child: CustomPaint(
                      painter: StarFieldPainter(
                        _rotationController.value,
                        _mousePosition,
                        _isMouseActive,
                        _clickCount,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StarFieldPainter extends CustomPainter {
  final double animationValue;
  final Offset mousePosition;
  final bool isMouseActive;
  final int clickCount;

  StarFieldPainter(
    this.animationValue,
    this.mousePosition,
    this.isMouseActive,
    this.clickCount,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppTheme.starlight.withValues(alpha: 1.0); // Bright stars

    // Predefined star positions for more natural distribution
    final stars = [
      {'x': 0.1, 'y': 0.15, 'speed': 1.0, 'brightness': 0.9}, // Bright stars
      {'x': 0.25, 'y': 0.08, 'speed': 0.7, 'brightness': 0.7},
      {'x': 0.35, 'y': 0.22, 'speed': 1.2, 'brightness': 1.0},
      {'x': 0.45, 'y': 0.05, 'speed': 0.9, 'brightness': 0.6},
      {'x': 0.55, 'y': 0.18, 'speed': 0.8, 'brightness': 0.8},
      {'x': 0.68, 'y': 0.12, 'speed': 1.1, 'brightness': 0.9},
      {'x': 0.75, 'y': 0.25, 'speed': 0.6, 'brightness': 0.5},
      {'x': 0.85, 'y': 0.07, 'speed': 1.3, 'brightness': 1.0},
      {'x': 0.92, 'y': 0.20, 'speed': 0.5, 'brightness': 0.7},
      {'x': 0.15, 'y': 0.35, 'speed': 0.9, 'brightness': 0.8},
      {'x': 0.28, 'y': 0.42, 'speed': 1.1, 'brightness': 0.6},
      {'x': 0.38, 'y': 0.55, 'speed': 0.8, 'brightness': 0.9},
      {'x': 0.52, 'y': 0.48, 'speed': 1.2, 'brightness': 0.7},
      {'x': 0.62, 'y': 0.38, 'speed': 0.7, 'brightness': 1.0},
      {'x': 0.72, 'y': 0.58, 'speed': 1.0, 'brightness': 0.5},
      {'x': 0.82, 'y': 0.45, 'speed': 0.6, 'brightness': 0.8},
      {'x': 0.18, 'y': 0.65, 'speed': 1.3, 'brightness': 0.9},
      {'x': 0.32, 'y': 0.72, 'speed': 0.9, 'brightness': 0.6},
      {'x': 0.48, 'y': 0.68, 'speed': 0.8, 'brightness': 0.7},
      {'x': 0.58, 'y': 0.78, 'speed': 1.1, 'brightness': 1.0},
      {'x': 0.78, 'y': 0.72, 'speed': 0.7, 'brightness': 0.6},
      {'x': 0.88, 'y': 0.65, 'speed': 1.2, 'brightness': 0.9},
      {'x': 0.12, 'y': 0.85, 'speed': 0.5, 'brightness': 0.7},
      {'x': 0.25, 'y': 0.92, 'speed': 1.0, 'brightness': 0.8},
      {'x': 0.42, 'y': 0.88, 'speed': 0.8, 'brightness': 0.6},
      {'x': 0.65, 'y': 0.95, 'speed': 0.9, 'brightness': 0.9},
      {'x': 0.78, 'y': 0.88, 'speed': 1.1, 'brightness': 0.7},
      {'x': 0.92, 'y': 0.82, 'speed': 0.6, 'brightness': 1.0},
      // Additional scattered stars
      {'x': 0.05, 'y': 0.45, 'speed': 1.4, 'brightness': 0.5},
      {'x': 0.95, 'y': 0.35, 'speed': 0.4, 'brightness': 0.8},
      {'x': 0.22, 'y': 0.28, 'speed': 1.0, 'brightness': 0.6},
      {'x': 0.87, 'y': 0.52, 'speed': 0.8, 'brightness': 0.7},
      {'x': 0.33, 'y': 0.15, 'speed': 1.2, 'brightness': 0.5},
      {'x': 0.67, 'y': 0.75, 'speed': 0.7, 'brightness': 0.9},
      {'x': 0.53, 'y': 0.32, 'speed': 0.9, 'brightness': 0.7},
      {'x': 0.73, 'y': 0.18, 'speed': 1.1, 'brightness': 0.8},
      {'x': 0.08, 'y': 0.62, 'speed': 0.6, 'brightness': 0.6},
      {'x': 0.98, 'y': 0.75, 'speed': 1.3, 'brightness': 0.7},
      {'x': 0.43, 'y': 0.08, 'speed': 0.5, 'brightness': 0.9},
      {'x': 0.17, 'y': 0.98, 'speed': 1.0, 'brightness': 0.5},
      // Extra bright stars for dramatic effect
      {'x': 0.13, 'y': 0.25, 'speed': 0.8, 'brightness': 1.2},
      {'x': 0.77, 'y': 0.35, 'speed': 1.1, 'brightness': 1.1},
      {'x': 0.41, 'y': 0.75, 'speed': 0.9, 'brightness': 1.3},
      {'x': 0.89, 'y': 0.15, 'speed': 1.2, 'brightness': 1.2},
      {'x': 0.31, 'y': 0.85, 'speed': 0.7, 'brightness': 1.1},
    ];

    for (final star in stars) {
      // Add slow star movement - each star drifts based on its speed and animation time
      final driftX = sin(animationValue * star['speed']! * 10) * 20;
      final driftY = cos(animationValue * star['speed']! * 10) * 20;
      final x = star['x']! * size.width + driftX;
      final y = star['y']! * size.height + driftY;
      final speed = star['speed']!;
      final brightness = star['brightness']!;

      // Create dramatic twinkling effect
      final twinklePhase = animationValue * speed * 2 * 3.14159;
      final twinkle = 0.4 + 0.6 * (sin(twinklePhase) * 0.5 + 0.5);

      // Easter egg: Mouse interaction effects
      double mouseInfluence = 1.0;
      if (isMouseActive || clickCount > 0) {
        // Made it work even when mouse isn't actively moving
        final mouseX = mousePosition.dx * size.width;
        final mouseY = mousePosition.dy * size.height;
        final distance = sqrt(pow(x - mouseX, 2) + pow(y - mouseY, 2));
        final maxInfluenceDistance =
            150; // Removed variable distance based on click count

        if (distance < maxInfluenceDistance) {
          final normalizedDistance = distance / maxInfluenceDistance;
          mouseInfluence =
              1.0 +
              (2.0 - normalizedDistance * 2.0) *
                  1.5; // Removed supernova multiplier

          // Stars get brighter and bigger when mouse is near
          if (clickCount >= 3) {
            // Secret rainbow effect
            final colorPhase = (animationValue + normalizedDistance) * 6;
            paint.color = Color.lerp(
              AppTheme.starlight,
              Color.fromARGB(
                255,
                (sin(colorPhase) * 127 + 128).round(),
                (sin(colorPhase + 2) * 127 + 128).round(),
                (sin(colorPhase + 4) * 127 + 128).round(),
              ),
              0.5,
            )!.withValues(
              alpha: (brightness * twinkle * mouseInfluence).clamp(0.0, 1.0),
            );
          }
        }
      }

      final finalOpacity = (brightness * twinkle * mouseInfluence).clamp(
        0.0,
        1.0,
      );

      // Bigger, more dramatic star sizes
      final baseSize = brightness > 0.8 ? 2.5 : (brightness > 0.6 ? 1.8 : 1.2);
      final radius =
          baseSize *
          (0.7 + 0.5 * twinkle) *
          (mouseInfluence > 1.0 ? mouseInfluence * 0.5 : 1.0);

      // Main star (use default color if not affected by rainbow effect)
      if (!isMouseActive ||
          clickCount < 3 ||
          paint.color == AppTheme.starlight.withValues(alpha: 1.0)) {
        paint.color = AppTheme.starlight.withValues(alpha: finalOpacity);
      }
      canvas.drawCircle(Offset(x, y), radius, paint);

      // Add bright glow for all visible stars
      if (brightness > 0.5) {
        paint.color = AppTheme.starlight.withValues(
          alpha:
              finalOpacity *
              0.4 *
              (mouseInfluence > 1.0 ? mouseInfluence * 0.3 : 1.0),
        );
        canvas.drawCircle(Offset(x, y), radius * 2.5, paint);
      }

      // Extra dramatic glow for brightest stars
      if (brightness > 0.9) {
        paint.color = AppTheme.starlight.withValues(alpha: finalOpacity * 0.2);
        canvas.drawCircle(Offset(x, y), radius * 4, paint);

        // Add colored tint to brightest stars
        paint.color = AppTheme.plasmaGreen.withValues(
          alpha:
              finalOpacity *
              0.1 *
              (mouseInfluence > 1.0 ? mouseInfluence * 0.5 : 1.0),
        );
        canvas.drawCircle(Offset(x, y), radius * 3, paint);
      }
    }

    // Easter egg: Draw constellation lines when clicked multiple times
    if (clickCount >= 2) {
      paint.color = AppTheme.starlight.withValues(alpha: 0.3);
      paint.strokeWidth = 1.0;
      paint.style = PaintingStyle.stroke;

      final mouseX = mousePosition.dx * size.width;
      final mouseY = mousePosition.dy * size.height;

      // Draw lines to nearby stars
      for (int i = 0; i < stars.length; i++) {
        final star = stars[i];
        final driftX = sin(animationValue * star['speed']! * 10) * 20;
        final driftY = cos(animationValue * star['speed']! * 10) * 20;
        final x = star['x']! * size.width + driftX;
        final y = star['y']! * size.height + driftY;
        final distance = sqrt(pow(x - mouseX, 2) + pow(y - mouseY, 2));

        if (distance < 200 && star['brightness']! > 0.7) {
          canvas.drawLine(Offset(mouseX, mouseY), Offset(x, y), paint);
        }
      }

      paint.style = PaintingStyle.fill; // Reset to fill for other drawings
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
