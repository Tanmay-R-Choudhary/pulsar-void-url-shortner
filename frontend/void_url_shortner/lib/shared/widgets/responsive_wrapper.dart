import 'package:flutter/material.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;
        final isTablet =
            constraints.maxWidth > 600 && constraints.maxWidth <= 1024;

        return Center(
          child: Container(
            width: constraints.maxWidth > maxWidth ? maxWidth : null,
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 48 : (isTablet ? 32 : 16),
              vertical: padding.vertical,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
