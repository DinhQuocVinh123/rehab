import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rehab/src/painters/dot_pattern_painter.dart';

class DecorativeBackground extends StatelessWidget {
  const DecorativeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(
          top: -96,
          right: -96,
          child: BlurBubble(
            size: 384,
            color: Color(0x14006A61),
          ),
        ),
        Positioned(
          bottom: -180,
          left: -180,
          child: BlurBubble(
            size: 500,
            color: Color(0x14004AC6),
          ),
        ),
        Positioned.fill(child: DotPattern()),
      ],
    );
  }
}

class GlowCircle extends StatelessWidget {
  const GlowCircle({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 192,
      height: 192,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 60,
            spreadRadius: 12,
          ),
        ],
      ),
    );
  }
}

class BlurBubble extends StatelessWidget {
  const BlurBubble({super.key, required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class DotPattern extends StatelessWidget {
  const DotPattern({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: DotPatternPainter(),
        size: Size.infinite,
      ),
    );
  }
}
