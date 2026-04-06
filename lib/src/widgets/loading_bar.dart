import 'package:flutter/material.dart';

class LoadingBar extends StatelessWidget {
  const LoadingBar({
    super.key,
    required this.controller,
    required this.trackColor,
    required this.fillColor,
  });

  final AnimationController controller;
  final Color trackColor;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    const totalWidth = 192.0;

    return SizedBox(
      width: totalWidth,
      height: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Stack(
          children: [
            ColoredBox(color: trackColor),
            AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final t = controller.value;
                final widthFactor = t <= 0.5 ? t : 1 - t;
                final leftFactor = t <= 0.5 ? t * 0.5 : t;
                final indicatorWidth = totalWidth * widthFactor.clamp(0.0, 0.5);
                final indicatorLeft = totalWidth * leftFactor.clamp(0.0, 1.0);

                return Stack(
                  children: [
                    Positioned(
                      left: indicatorLeft,
                      child: Container(
                        width: indicatorWidth,
                        height: 4,
                        decoration: BoxDecoration(
                          color: fillColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
