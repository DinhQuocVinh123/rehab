part of 'package:rehab/src/widgets/exercise_widgets.dart';

class _ExerciseHeroContent extends StatelessWidget {
  const _ExerciseHeroContent({
    required this.exercise,
    required this.accent,
  });

  final ExerciseDefinition exercise;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            exercise.joint == ExerciseJoint.knee
                ? 'KNEE EXERCISE'
                : 'ELBOW EXERCISE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.6,
              color: accent,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          exercise.title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          exercise.description,
          style: const TextStyle(
            fontSize: 15,
            height: 1.55,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ExerciseBadge(label: 'Target', value: exercise.targetRange),
            _ExerciseBadge(label: 'Reps', value: '${exercise.reps}'),
            _ExerciseBadge(label: 'Sets', value: '${exercise.sets}'),
          ],
        ),
        const SizedBox(height: 22),
        const Text(
          'Coaching Points',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 12),
        ...exercise.coachingPoints.map(
          (point) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Icon(Icons.check_circle, size: 18, color: accent),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    point,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ExerciseBadge extends StatelessWidget {
  const _ExerciseBadge({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.6,
              color: AppColors.outline,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseMeta extends StatelessWidget {
  const _ExerciseMeta({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.6,
            color: AppColors.outline,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}

class _ExerciseJointPainter extends CustomPainter {
  const _ExerciseJointPainter({
    required this.joint,
    required this.angleDegrees,
    required this.accentColor,
  });

  final ExerciseJoint joint;
  final double angleDegrees;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (joint == ExerciseJoint.knee) {
      _paintKnee(canvas, size);
    } else {
      _paintElbow(canvas, size);
    }
  }

  void _paintKnee(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.52, size.height * 0.35);
    final thighLength = size.shortestSide * 0.32;
    final shinLength = size.shortestSide * 0.28;
    final radians = _toRadians(180 - angleDegrees);
    final hip = Offset(center.dx + thighLength * 0.18, center.dy - thighLength);
    final ankle = Offset(
      center.dx - (shinLength * math.cos(radians)),
      center.dy + (shinLength * math.sin(radians)),
    );
    final toe = ankle + Offset(size.shortestSide * 0.11, size.shortestSide * 0.055);

    _drawGuides(canvas, size, center);

    final limbPaint = Paint()
      ..color = const Color(0xFFF1F3F8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    final arcPaint = Paint()
      ..color = const Color(0xFF4ED0C4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final anglePaint = Paint()
      ..color = const Color(0xFFE0A73B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final thigh = Path()
      ..moveTo(hip.dx - 8, hip.dy - 6)
      ..quadraticBezierTo(center.dx - 4, center.dy - 64, center.dx + 2, center.dy - 4);
    final shin = Path()
      ..moveTo(center.dx - 2, center.dy + 2)
      ..quadraticBezierTo(ankle.dx + 14, ankle.dy - 10, ankle.dx + 2, ankle.dy + 2);
    final foot = Path()
      ..moveTo(ankle.dx - 1, ankle.dy + 3)
      ..quadraticBezierTo(toe.dx - 6, toe.dy - 6, toe.dx + 6, toe.dy + 2);

    canvas.drawPath(thigh, limbPaint);
    canvas.drawPath(shin, limbPaint);
    canvas.drawPath(foot, limbPaint);
    canvas.drawCircle(center, 7, Paint()..color = Colors.white);
    canvas.drawCircle(ankle, 4.5, Paint()..color = Colors.white);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.shortestSide * 0.255),
      math.pi * 0.58,
      math.pi * 0.62,
      false,
      arcPaint,
    );

    canvas.drawLine(center, Offset(center.dx - 4, center.dy + 98), anglePaint);
    canvas.drawLine(center, Offset(center.dx + 72, center.dy + 48), anglePaint);

    _drawLabel(canvas, text: '0°', offset: Offset(center.dx - 128, center.dy - 10));
    _drawLabel(canvas, text: '29°', offset: Offset(center.dx - 102, center.dy + 76));
    _drawLabel(canvas, text: '125°', offset: Offset(center.dx + 98, center.dy + 82));
    _drawLabel(
      canvas,
      text: '${angleDegrees.round()}\u00B0',
      offset: Offset(center.dx - 18, center.dy + 118),
      fontSize: 20,
      weight: FontWeight.w900,
    );
    _drawLabel(
      canvas,
      text: '90°',
      offset: Offset(center.dx + 2, center.dy + 142),
      fontSize: 12,
      color: const Color(0xFFD4D8E3),
    );
  }

  void _paintElbow(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.48);
    final upperArmLength = size.shortestSide * 0.28;
    final forearmLength = size.shortestSide * 0.26;
    final radians = _toRadians(180 - angleDegrees);
    final shoulder = Offset(center.dx - upperArmLength * 0.14, center.dy - upperArmLength);
    final wrist = Offset(
      center.dx + (forearmLength * math.cos(radians)),
      center.dy - (forearmLength * math.sin(radians)),
    );
    final hand = wrist + Offset(size.shortestSide * 0.09, size.shortestSide * 0.02);

    _drawGuides(canvas, size, center);

    final limbPaint = Paint()
      ..color = const Color(0xFFF1F3F8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    final arcPaint = Paint()
      ..color = const Color(0xFF4ED0C4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final anglePaint = Paint()
      ..color = const Color(0xFFE0A73B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final upperArm = Path()
      ..moveTo(shoulder.dx - 4, shoulder.dy - 6)
      ..quadraticBezierTo(center.dx - 26, center.dy - 40, center.dx - 2, center.dy - 2);
    final forearm = Path()
      ..moveTo(center.dx + 2, center.dy)
      ..quadraticBezierTo(wrist.dx - 16, wrist.dy + 8, wrist.dx, wrist.dy);
    final palm = Path()
      ..moveTo(wrist.dx - 1, wrist.dy)
      ..quadraticBezierTo(hand.dx + 4, hand.dy - 2, hand.dx + 8, hand.dy + 12);

    canvas.drawPath(upperArm, limbPaint);
    canvas.drawPath(forearm, limbPaint);
    canvas.drawPath(palm, limbPaint);
    canvas.drawCircle(center, 7, Paint()..color = Colors.white);
    canvas.drawCircle(wrist, 4.5, Paint()..color = Colors.white);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.shortestSide * 0.22),
      math.pi * 1.02,
      math.pi * 0.6,
      false,
      arcPaint,
    );

    canvas.drawLine(center, Offset(center.dx + 92, center.dy - 4), anglePaint);
    canvas.drawLine(center, Offset(center.dx + 70, center.dy - 80), anglePaint);

    _drawLabel(canvas, text: '30°', offset: Offset(center.dx + 102, center.dy - 16));
    _drawLabel(canvas, text: '135°', offset: Offset(center.dx + 78, center.dy - 98));
    _drawLabel(
      canvas,
      text: '${angleDegrees.round()}\u00B0',
      offset: Offset(center.dx - 18, center.dy + 108),
      fontSize: 20,
      weight: FontWeight.w900,
    );
    _drawLabel(
      canvas,
      text: '90°',
      offset: Offset(center.dx + 4, center.dy + 132),
      fontSize: 12,
      color: const Color(0xFFD4D8E3),
    );
  }

  void _drawGuides(Canvas canvas, Size size, Offset center) {
    final guide = Paint()
      ..color = const Color(0x66FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    _drawDashedLine(canvas, Offset(10, center.dy), Offset(size.width - 10, center.dy), guide);
    _drawDashedLine(canvas, Offset(center.dx, 10), Offset(center.dx, size.height - 10), guide);
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

  void _drawLabel(
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

  double _toRadians(double degrees) => degrees * math.pi / 180;

  @override
  bool shouldRepaint(covariant _ExerciseJointPainter oldDelegate) {
    return oldDelegate.angleDegrees != angleDegrees ||
        oldDelegate.joint != joint ||
        oldDelegate.accentColor != accentColor;
  }
}
