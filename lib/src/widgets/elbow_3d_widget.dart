import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Animated 3-D arm demo that illustrates elbow flexion / extension.
///
/// Renders a pseudo-3D arm (upper arm → elbow joint → forearm → hand) using
/// [CustomPainter] with cylinder shading, specular highlights, and a
/// foreshortened cap, all driven by a looping [AnimationController].
class ElbowArm3DDemo extends StatefulWidget {
  const ElbowArm3DDemo({
    super.key,
    required this.startAngleDeg,
    required this.endAngleDeg,
    required this.accentColor,
  });

  /// Minimum flexion angle in degrees (e.g. 30).
  final double startAngleDeg;

  /// Maximum flexion angle in degrees (e.g. 120).
  final double endAngleDeg;

  /// Accent colour used for the angle arc and label.
  final Color accentColor;

  @override
  State<ElbowArm3DDemo> createState() => _ElbowArm3DemoState();
}

class _ElbowArm3DemoState extends State<ElbowArm3DDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = Curves.easeInOutCubic.transform(_ctrl.value);
        return CustomPaint(
          painter: _ArmPainter(
            flexionDeg: lerpDouble(
              widget.startAngleDeg,
              widget.endAngleDeg,
              t,
            )!,
            startDeg: widget.startAngleDeg,
            endDeg: widget.endAngleDeg,
            accent: widget.accentColor,
          ),
          isComplex: true,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Painter
// ---------------------------------------------------------------------------

class _ArmPainter extends CustomPainter {
  const _ArmPainter({
    required this.flexionDeg,
    required this.startDeg,
    required this.endDeg,
    required this.accent,
  });

  final double flexionDeg;
  final double startDeg;
  final double endDeg;
  final Color accent;

  // ── Skin palette (mid-tone warm skin) ────────────────────────────────────
  static const Color _hi   = Color(0xFFEDD5BC); // highlight
  static const Color _mid  = Color(0xFFDBA888); // mid-tone
  static const Color _base = Color(0xFFCE8F6A); // base
  static const Color _shd  = Color(0xFF9A5535); // shadow

  // Projected light direction (upper-left in canvas space).
  static const double _lx = -0.707;
  static const double _ly = -0.707;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Key anchor points ─────────────────────────────────────────────────
    // Shoulder sits in the upper-left quadrant; elbow below it.
    // The forearm swings to the right as flexion increases.
    final shoulder = Offset(w * 0.40, h * 0.08);
    final elbow    = Offset(w * 0.40, h * 0.52);

    final uaR = w * 0.078; // upper-arm cylinder radius
    final faR = w * 0.062; // forearm cylinder radius
    final faL = h * 0.37;  // forearm length

    // Forearm canvas angle:
    //   0° flexion  → pointing down   (π/2)
    //  90° flexion  → pointing right  (0)
    // 120° flexion  → pointing upper-right (-π/6)
    final faAngle = math.pi / 2 - flexionDeg * math.pi / 180;
    final wrist = Offset(
      elbow.dx + math.cos(faAngle) * faL,
      elbow.dy + math.sin(faAngle) * faL,
    );

    // ── Draw back-to-front ────────────────────────────────────────────────
    _drawRangeArc(canvas, elbow, faL * 0.62);
    _drawGhost(canvas, elbow, faR, faL);
    _drawCylinder(canvas, from: shoulder, to: elbow, r: uaR, startCap: true);
    _drawCylinder(canvas, from: elbow,    to: wrist, r: faR, startCap: false);
    _drawHand(canvas, wrist, faAngle, faR);
    _drawJoint(canvas, shoulder, uaR * 0.90); // shoulder
    _drawJoint(canvas, elbow,    uaR * 1.02); // elbow (in front of cylinder ends)
    _drawAngleIndicator(canvas, elbow, faAngle);
    _drawLabel(canvas, elbow, faAngle);
  }

  // ── Cylinder ─────────────────────────────────────────────────────────────
  void _drawCylinder(
    Canvas canvas, {
    required Offset from,
    required Offset to,
    required double r,
    bool startCap = false,
  }) {
    final d   = to - from;
    final len = d.distance;
    if (len < 1) return;

    final ax = d.dx / len; // axis unit vector
    final ay = d.dy / len;

    // Perpendicular vector, flipped so it points toward the light source.
    double px = -ay;
    double py =  ax;
    if (px * _lx + py * _ly < 0) {
      px = -px;
      py = -py;
    }

    final hiPt  = Offset(from.dx + px * r, from.dy + py * r);
    final shdPt = Offset(from.dx - px * r, from.dy - py * r);

    // Body rectangle
    final body = Path()
      ..moveTo(hiPt.dx,             hiPt.dy)
      ..lineTo(to.dx + px * r, to.dy + py * r)
      ..lineTo(to.dx - px * r, to.dy - py * r)
      ..lineTo(shdPt.dx,            shdPt.dy)
      ..close();

    // Cross-section gradient (highlight → mid → shadow)
    canvas.drawPath(
      body,
      Paint()
        ..shader = LinearGradient(
          colors: [_hi, _mid, _shd],
          stops: const [0.0, 0.38, 1.0],
        ).createShader(Rect.fromPoints(hiPt, shdPt)),
    );

    // Specular highlight strip along the lit edge
    canvas.drawLine(
      Offset(from.dx + px * r * 0.62, from.dy + py * r * 0.62),
      Offset(to.dx   + px * r * 0.62, to.dy   + py * r * 0.62),
      Paint()
        ..color      = Colors.white.withValues(alpha: 0.28)
        ..strokeWidth = r * 0.20
        ..style       = PaintingStyle.stroke
        ..strokeCap   = StrokeCap.round,
    );

    // Edge outline
    canvas.drawPath(
      body,
      Paint()
        ..style       = PaintingStyle.stroke
        ..color       = _shd.withValues(alpha: 0.15)
        ..strokeWidth = 0.8,
    );

    // Caps
    _drawCap(canvas, center: to,   ax:  ax, ay:  ay, r: r);
    if (startCap) _drawCap(canvas, center: from, ax: -ax, ay: -ay, r: r);
  }

  void _drawCap(
    Canvas canvas, {
    required Offset center,
    required double ax,
    required double ay,
    required double r,
  }) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.atan2(ay, ax));

    // Foreshortened ellipse: width (along cylinder) compressed, height full.
    final rect = Rect.fromCenter(
      center: Offset.zero,
      width:  r * 0.52,
      height: r * 2.0,
    );

    canvas.drawOval(
      rect,
      Paint()
        ..shader = RadialGradient(
          colors: [_hi, _mid, _shd],
          stops: const [0.0, 0.50, 1.0],
          center: const Alignment(-0.30, -0.40),
        ).createShader(rect),
    );
    canvas.drawOval(
      rect,
      Paint()
        ..style       = PaintingStyle.stroke
        ..color       = _shd.withValues(alpha: 0.18)
        ..strokeWidth = 0.8,
    );
    canvas.restore();
  }

  // ── Sphere joint ─────────────────────────────────────────────────────────
  void _drawJoint(Canvas canvas, Offset center, double r) {
    final rect = Rect.fromCircle(center: center, radius: r);
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..shader = RadialGradient(
          colors: [_hi, _base, _shd],
          stops: const [0.0, 0.52, 1.0],
          center: const Alignment(-0.38, -0.42),
        ).createShader(rect),
    );
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..style       = PaintingStyle.stroke
        ..color       = _shd.withValues(alpha: 0.20)
        ..strokeWidth = 1.0,
    );
  }

  // ── Hand ─────────────────────────────────────────────────────────────────
  void _drawHand(Canvas canvas, Offset wrist, double angle, double faR) {
    final hw = faR * 2.6;
    final hh = faR * 1.55;

    canvas.save();
    canvas.translate(wrist.dx, wrist.dy);
    canvas.rotate(angle);

    final rect = Rect.fromLTWH(faR * 0.3, -hh / 2, hw, hh);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(hh * 0.48));

    canvas.drawRRect(
      rRect,
      Paint()
        ..shader = LinearGradient(
          colors: [_hi, _base, _shd],
          stops: const [0.0, 0.38, 1.0],
          begin: Alignment.topCenter,
          end:   Alignment.bottomCenter,
        ).createShader(rect),
    );
    canvas.drawRRect(
      rRect,
      Paint()
        ..style       = PaintingStyle.stroke
        ..color       = _shd.withValues(alpha: 0.15)
        ..strokeWidth = 0.8,
    );
    canvas.restore();

    // Wrist joint sphere
    _drawJoint(canvas, wrist, faR * 0.80);
  }

  // ── Range arc (background glow) ──────────────────────────────────────────
  void _drawRangeArc(Canvas canvas, Offset elbow, double radius) {
    // aMax = canvas angle for endDeg (more negative = higher flexion)
    // aMin = canvas angle for startDeg (less negative)
    final aMax  = math.pi / 2 - endDeg   * math.pi / 180;
    final aMin  = math.pi / 2 - startDeg * math.pi / 180;
    final sweep = aMin - aMax; // positive (CW sweep from aMax → aMin)

    canvas.drawArc(
      Rect.fromCircle(center: elbow, radius: radius),
      aMax,
      sweep,
      false,
      Paint()
        ..color       = accent.withValues(alpha: 0.10)
        ..style       = PaintingStyle.stroke
        ..strokeWidth = radius * 0.18
        ..strokeCap   = StrokeCap.round,
    );
  }

  // ── Ghost forearm (target position indicator) ────────────────────────────
  void _drawGhost(Canvas canvas, Offset elbow, double r, double len) {
    final gAngle = math.pi / 2 - endDeg * math.pi / 180;
    final gTip   = elbow + Offset(math.cos(gAngle) * len, math.sin(gAngle) * len);

    final d    = gTip - elbow;
    final dist = d.distance;
    final px   = -d.dy / dist;
    final py   =  d.dx / dist;

    canvas.drawPath(
      Path()
        ..moveTo(elbow.dx + px * r, elbow.dy + py * r)
        ..lineTo(gTip.dx  + px * r, gTip.dy  + py * r)
        ..lineTo(gTip.dx  - px * r, gTip.dy  - py * r)
        ..lineTo(elbow.dx - px * r, elbow.dy - py * r)
        ..close(),
      Paint()
        ..color = accent.withValues(alpha: 0.07)
        ..style = PaintingStyle.fill,
    );
  }

  // ── Angle arc at elbow ───────────────────────────────────────────────────
  void _drawAngleIndicator(Canvas canvas, Offset elbow, double faAngle) {
    const arcR    = 36.0;
    // Arc spans from forearm angle (CW) to the "down" direction (π/2).
    final sweepAng = math.pi / 2 - faAngle; // = flexionDeg * π/180

    canvas.drawArc(
      Rect.fromCircle(center: elbow, radius: arcR),
      faAngle,   // start at forearm
      sweepAng,  // sweep CW to "down"
      false,
      Paint()
        ..color       = accent.withValues(alpha: 0.85)
        ..style       = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap   = StrokeCap.round,
    );

    // Dot at the moving end of the arc (on the forearm side)
    canvas.drawCircle(
      elbow + Offset(math.cos(faAngle) * arcR, math.sin(faAngle) * arcR),
      3.5,
      Paint()..color = accent,
    );
  }

  // ── Angle label ──────────────────────────────────────────────────────────
  void _drawLabel(Canvas canvas, Offset elbow, double faAngle) {
    // Place label halfway between "down" and the current forearm direction.
    final midAngle    = (faAngle + math.pi / 2) / 2;
    const labelRadius = 60.0;
    final labelCenter = elbow +
        Offset(math.cos(midAngle) * labelRadius, math.sin(midAngle) * labelRadius);

    final tp = TextPainter(
      text: TextSpan(
        text: '${flexionDeg.round()}°',
        style: TextStyle(
          fontSize:   14,
          fontWeight: FontWeight.w900,
          color:      accent,
          height:     1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, labelCenter - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _ArmPainter old) =>
      old.flexionDeg != flexionDeg || old.accent != accent;
}
