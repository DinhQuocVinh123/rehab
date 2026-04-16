part of 'package:rehab/src/widgets/exercise_widgets.dart';

class _KneeHeroVisual extends StatefulWidget {
  const _KneeHeroVisual({
    required this.exercise,
    required this.accent,
  });

  final ExerciseDefinition exercise;
  final Color accent;

  @override
  State<_KneeHeroVisual> createState() => _KneeHeroVisualState();
}

class _KneeHeroVisualState extends State<_KneeHeroVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
      value: 0.5,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = Curves.easeInOutCubic.transform(_controller.value);
          final angle = lerpDouble(
            widget.exercise.startAngle,
            widget.exercise.endAngle,
            progress,
          )!;

          return Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 24,
                  right: 24,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.78),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.45),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ANGLE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${angle.round()}°',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: widget.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0x0C94CCFF),
                          Color(0x00FFFFFF),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Stack(
                      children: [
                        const Positioned.fill(
                          child: Center(
                            child: _KneeAngleArc(),
                          ),
                        ),
                        Center(
                          child: Transform.scale(
                            scale: 0.985 + (progress * 0.018),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: SizedBox(
                                width: 128,
                                height: 128,
                                child: _AnimatedKneeSvg(
                                  progress: progress,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedKneeSvg extends StatelessWidget {
  const _AnimatedKneeSvg({
    required this.progress,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    final kneePivot = const Offset(52, 44);
    final hipPivot = const Offset(92, 22);
    final lowerRotation = lerpDouble(-0.42, 0.08, progress)!;
    final upperRotation = lerpDouble(-0.06, 0.02, progress)!;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Transform(
            alignment: Alignment.topLeft,
            transform: Matrix4.identity()
              ..translateByDouble(kneePivot.dx, kneePivot.dy, 0, 1)
              ..rotateZ(lowerRotation)
              ..translateByDouble(-kneePivot.dx, -kneePivot.dy, 0, 1),
            child: SvgPicture.string(
              _kneeCalfSvg,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned.fill(
          child: Transform(
            alignment: Alignment.topLeft,
            transform: Matrix4.identity()
              ..translateByDouble(hipPivot.dx, hipPivot.dy, 0, 1)
              ..rotateZ(upperRotation)
              ..translateByDouble(-hipPivot.dx, -hipPivot.dy, 0, 1),
            child: SvgPicture.string(
              _kneeThighSvg,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

class _KneeAngleArc extends StatelessWidget {
  const _KneeAngleArc();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 260,
      child: CustomPaint(
        painter: _KneeArcPainter(),
      ),
    );
  }
}

class _KneeArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x33005D90)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.shortestSide * 0.35,
      ),
      -math.pi / 2,
      1.55,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _KneeMetricCard extends StatelessWidget {
  const _KneeMetricCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: AppColors.outline,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _KneeCoachingCard extends StatelessWidget {
  const _KneeCoachingCard({
    required this.points,
  });

  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: AppColors.secondary, size: 20),
              const SizedBox(width: 10),
              const Text(
                'Coaching Points',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LightElbowVisual extends StatefulWidget {
  const _LightElbowVisual({
    required this.exercise,
    required this.accent,
  });

  final ExerciseDefinition exercise;
  final Color accent;

  @override
  State<_LightElbowVisual> createState() => _LightElbowVisualState();
}

class _LightElbowVisualState extends State<_LightElbowVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
      value: 0.5,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = Curves.easeInOutCubic.transform(_controller.value);
        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _LightElbowArcPainter(
                  accent: widget.accent,
                ),
              ),
            ),
            Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: 232,
                    height: 232,
                    child: Transform.translate(
                      offset: const Offset(-28, 6),
                      child: Transform.scale(
                        scale: 0.82 + (progress * 0.012),
                        child: _LightAnimatedElbowSvg(
                          progress: progress,
                          accent: widget.accent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ExerciseMotionDemo extends StatefulWidget {
  const ExerciseMotionDemo({
    super.key,
    required this.exercise,
    required this.accentColor,
  });

  final ExerciseDefinition exercise;
  final Color accentColor;

  @override
  State<ExerciseMotionDemo> createState() => _ExerciseMotionDemoState();
}

class _ExerciseMotionDemoState extends State<ExerciseMotionDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
      value: 0.5,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.05,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = Curves.easeInOutCubic.transform(_controller.value);
          final angle = lerpDouble(
            widget.exercise.startAngle,
            widget.exercise.endAngle,
            progress,
          )!;
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF434552),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Stack(
              children: [
                if (widget.exercise.joint == ExerciseJoint.elbow)
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 28, 28, 74),
                      child: _AnimatedElbowSvg(
                        progress: progress,
                        angleDegrees: angle,
                      ),
                    ),
                  )
                else
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ExerciseJointPainter(
                        joint: widget.exercise.joint,
                        angleDegrees: angle,
                        accentColor: widget.accentColor,
                      ),
                    ),
                  ),
                Positioned(
                  left: 18,
                  bottom: 18,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.14),
                      ),
                    ),
                    child: Text(
                      '${angle.round()}\u00B0',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 18,
                  bottom: 18,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.14),
                      ),
                    ),
                    child: Text(
                      widget.exercise.movementLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: widget.accentColor.withValues(alpha: 0.95),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedElbowSvg extends StatelessWidget {
  const _AnimatedElbowSvg({
    required this.progress,
    required this.angleDegrees,
  });

  final double progress;
  final double angleDegrees;

  @override
  Widget build(BuildContext context) {

    Widget svgLayer(String Function({required String fill, required String stroke}) builder) {
      return SvgPicture.string(
        builder(fill: '#0F172A', stroke: '#F1F3F8'), // Slate 900 fill, light stroke
        fit: BoxFit.contain,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Keep the elbow animation to an approximately 65-degree motion arc.
        final rotation = lerpDouble(-1.13, 0.0, progress)!;

        return Stack(
          children: [
            Positioned.fill(
              child: svgLayer(elbowUpperArmSvg),
            ),
            Positioned.fill(
              child: Transform.rotate(
                angle: rotation,
                alignment: Alignment.center,
                child: svgLayer(elbowForearmSvg),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _ElbowArcPainter(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LightAnimatedElbowSvg extends StatelessWidget {
  const _LightAnimatedElbowSvg({
    required this.progress,
    required this.accent,
  });

  final double progress;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    Widget svgLayer(String Function({required String fill, required String stroke}) builder) {
      return SvgPicture.string(
        builder(fill: '#F8FAFC', stroke: '#5D636F'), // Slate 50 fill, dark stroke
        fit: BoxFit.contain,
      );
    }

    final rotation = lerpDouble(-1.13, 0.0, progress)!;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: svgLayer(elbowUpperArmSvg),
        ),
        Positioned.fill(
          child: Transform.rotate(
            angle: rotation,
            alignment: Alignment.center,
            child: svgLayer(elbowForearmSvg),
          ),
        ),
        Positioned(
          // Place center dot indicator
          left: 111,
          top: 111,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22005D90),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LightElbowArcPainter extends CustomPainter {
  const _LightElbowArcPainter({
    required this.accent,
  });

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final arcPaint = Paint()
      ..color = accent.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    final guide = Paint()
      ..color = const Color(0x33005D90)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.shortestSide * 0.16),
      4.95,
      1.15,
      false,
      arcPaint,
    );
    canvas.drawCircle(center, 3, Paint()..color = accent);
    canvas.drawLine(
      center,
      Offset(size.width * 0.8, center.dy),
      guide,
    );
    canvas.drawLine(
      center,
      Offset(size.width * 0.7, size.height * 0.2),
      guide,
    );
  }

  @override
  bool shouldRepaint(covariant _LightElbowArcPainter oldDelegate) {
    return oldDelegate.accent != accent;
  }
}

class _ElbowArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final guide = Paint()
      ..color = const Color(0x66FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final arcPaint = Paint()
      ..color = const Color(0xFF4ED0C4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    _drawDashedLine(canvas, Offset(10, center.dy), Offset(size.width - 10, center.dy), guide);
    _drawDashedLine(canvas, Offset(center.dx, 10), Offset(center.dx, size.height - 10), guide);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.shortestSide * 0.18),
      math.pi * 1.05,
      math.pi * 0.6,
      false,
      arcPaint,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dash = 6.0;
    const gap = 5.0;
    final total = (end - start).distance;
    final direction = (end - start) / total;
    double current = 0;
    while (current < total) {
      final dashStart = start + direction * current;
      final dashEnd = start + direction * math.min(current + dash, total);
      canvas.drawLine(dashStart, dashEnd, paint);
      current += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ElbowGuidePainterLegacy extends CustomPainter {
  const ElbowGuidePainterLegacy({
    required this.angleDegrees,
  });

  final double angleDegrees;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.27, size.height * 0.57);
    final guide = Paint()
      ..color = const Color(0x66FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final arcPaint = Paint()
      ..color = const Color(0xFF4ED0C4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    _drawDashedLine(canvas, Offset(10, center.dy), Offset(size.width - 10, center.dy), guide);
    _drawDashedLine(canvas, Offset(center.dx, 10), Offset(center.dx, size.height - 10), guide);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.shortestSide * 0.18),
      math.pi * 1.05,
      math.pi * 0.6,
      false,
      arcPaint,
    );

    _drawCanvasLabel(
      canvas,
      text: '${angleDegrees.round()}°',
      offset: Offset(center.dx - 20, size.height - 30),
      fontSize: 20,
      weight: FontWeight.w900,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dash = 6.0;
    const gap = 5.0;
    final total = (end - start).distance;
    final direction = (end - start) / total;
    double current = 0;
    while (current < total) {
      final dashStart = start + direction * current;
      final dashEnd = start + direction * math.min(current + dash, total);
      canvas.drawLine(dashStart, dashEnd, paint);
      current += dash + gap;
    }
  }

  void _drawCanvasLabel(
    Canvas canvas, {
    required String text,
    required Offset offset,
    double fontSize = 12,
    FontWeight weight = FontWeight.w700,
    Color color = const Color(0xFFF1F3F8),
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: weight,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant ElbowGuidePainterLegacy oldDelegate) {
    return oldDelegate.angleDegrees != angleDegrees;
  }
}

