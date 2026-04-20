part of 'package:rehab/src/widgets/exercise_widgets.dart';

class ExerciseHeroCard extends StatelessWidget {
  const ExerciseHeroCard({
    super.key,
    required this.exercise,
  });

  final ExerciseDefinition exercise;

  @override
  Widget build(BuildContext context) {
    final accent = exercise.joint == ExerciseJoint.knee
        ? AppColors.primary
        : AppColors.secondary;

    if (exercise.joint == ExerciseJoint.knee) {
      return _KneeExerciseShowcase(
        exercise: exercise,
        accent: accent,
      );
    }

    if (exercise.joint == ExerciseJoint.elbow) {
      return _ElbowExerciseShowcase(
        exercise: exercise,
        accent: accent,
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14004AC6),
            blurRadius: 42,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 760;
          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExerciseMotionDemo(
                  exercise: exercise,
                  accentColor: accent,
                ),
                const SizedBox(height: 24),
                _ExerciseHeroContent(exercise: exercise, accent: accent),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: ExerciseMotionDemo(
                  exercise: exercise,
                  accentColor: accent,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 6,
                child: _ExerciseHeroContent(exercise: exercise, accent: accent),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _KneeExerciseShowcase extends StatefulWidget {
  const _KneeExerciseShowcase({
    required this.exercise,
    required this.accent,
  });

  final ExerciseDefinition exercise;
  final Color accent;

  @override
  State<_KneeExerciseShowcase> createState() => _KneeExerciseShowcaseState();
}

class _KneeExerciseShowcaseState extends State<_KneeExerciseShowcase> {
  final _viewer = Character3DController();
  final _ble    = DaqBleService();

  StreamSubscription<DaqSensorData>? _bleSub;
  Timer?  _smoothTimer;
  bool    _connecting   = false;
  bool    _wsConnected  = false;
  String? _error;
  int     _zeroTick     = 0;
  double  _targetAngle  = 0;
  double  _currentAngle = 0;

  static const double _ticksPerDeg  = 50.0;
  static const int    _encoderIndex = 1;
  static const double _lerpSpeed    = 0.12;

  @override
  void dispose() {
    _smoothTimer?.cancel();
    _bleSub?.cancel();
    _ble.dispose();
    _viewer.dispose();
    super.dispose();
  }

  void _startSmoothTimer() {
    _smoothTimer?.cancel();
    _smoothTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      final diff = _targetAngle - _currentAngle;
      if (diff.abs() < 0.05) return;
      final next = _currentAngle + diff * _lerpSpeed;
      setState(() => _currentAngle = next);
      _viewer.setAngle(next);
    });
  }

  Future<void> _toggleBridge() async {
    if (_wsConnected) {
      _smoothTimer?.cancel();
      await _bleSub?.cancel();
      await _ble.disconnectWebSocket();
      setState(() { _wsConnected = false; _targetAngle = 0; _currentAngle = 0; });
      _viewer.setAngle(0);
      return;
    }
    setState(() { _connecting = true; _error = null; });
    try {
      await _ble.connectViaWebSocket();
      bool firstReading = true;
      _bleSub = _ble.dataStream.listen((data) {
        if (data.encoderValues.length <= _encoderIndex) return;
        final tick = data.encoderValues[_encoderIndex];
        if (firstReading) { _zeroTick = tick; firstReading = false; }
        _targetAngle = ((tick - _zeroTick) / _ticksPerDeg).clamp(-130.0, 130.0);
      });
      _startSmoothTimer();
      setState(() { _wsConnected = true; _connecting = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _connecting = false; });
    }
  }

  void _setZero() {
    _bleSub?.cancel();
    bool firstReading = true;
    _bleSub = _ble.dataStream.listen((data) {
      if (data.encoderValues.length <= _encoderIndex) return;
      final tick = data.encoderValues[_encoderIndex];
      if (firstReading) { _zeroTick = tick; firstReading = false; }
      _targetAngle = (tick - _zeroTick) / _ticksPerDeg;
    });
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    final accent = widget.accent;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14004AC6),
            blurRadius: 42,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Treatment Plan'.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.2,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Knee Exercise',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              height: 1.08,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 340,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Character3DViewer(
                controller: _viewer,
                movementType: exercise.movementType,
                startAngleDeg: exercise.startAngle,
                endAngleDeg: exercise.endAngle,
                modelPath: 'assets/models/Shannon_opt.glb',
                modelScale: 0.01,
                debugBones: false,
                cameraPositionY: 0.5,
                cameraPositionZ: 1.6,
                cameraTargetY: 0.9,
                fov: 65,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              FilledButton.icon(
                onPressed: _connecting ? null : _toggleBridge,
                icon: Icon(_wsConnected ? Icons.wifi_off : Icons.wifi),
                label: Text(_connecting
                    ? 'Connecting...'
                    : _wsConnected ? 'Disconnect' : 'Bridge'),
                style: FilledButton.styleFrom(
                  backgroundColor: _wsConnected ? Colors.red.shade400 : accent,
                ),
              ),
              if (_wsConnected) ...[
                const SizedBox(width: 12),
                Text(
                  '${_currentAngle.toStringAsFixed(1)}°',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _setZero,
                  child: const Text('Set Zero'),
                ),
              ],
            ],
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      exercise.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.info, color: accent),
                style: IconButton.styleFrom(
                  backgroundColor: accent.withValues(alpha: 0.06),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _KneeMetricCard(
                  label: 'Target',
                  value: exercise.targetRange,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _KneeMetricCard(
                  label: 'Reps',
                  value: '${exercise.reps}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _KneeMetricCard(
                  label: 'Sets',
                  value: '${exercise.sets}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _KneeCoachingCard(
            points: exercise.coachingPoints,
          ),
        ],
      ),
    );
  }
}

class _ElbowExerciseShowcase extends StatefulWidget {
  const _ElbowExerciseShowcase({
    required this.exercise,
    required this.accent,
  });

  final ExerciseDefinition exercise;
  final Color accent;

  @override
  State<_ElbowExerciseShowcase> createState() => _ElbowExerciseShowcaseState();
}

class _ElbowExerciseShowcaseState extends State<_ElbowExerciseShowcase> {
  final _viewer = Character3DController();
  final _ble    = DaqBleService();

  StreamSubscription<DaqSensorData>? _bleSub;
  Timer?  _smoothTimer;
  bool    _connecting   = false;
  bool    _wsConnected  = false;
  String? _error;
  int     _zeroTick      = 0;
  double  _smoothedTick  = 0;
  double  _targetAngle   = 0;
  double  _currentAngle  = 0;

  static const int    _encoderIndex  = 1;
  static const double _lerpSpeed     = 0.12;
  static const double _ticksPerDeg   = 15.8;
  static const double _emaAlpha      = 0.15; // lower = smoother, slower
  static const double _angleDeadzone = 1.0;  // ignore changes < 1°
  @override
  void dispose() {
    _smoothTimer?.cancel();
    _bleSub?.cancel();
    _ble.dispose();
    _viewer.dispose();
    super.dispose();
  }

  void _startSmoothTimer() {
    _smoothTimer?.cancel();
    _smoothTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      final diff = _targetAngle - _currentAngle;
      if (diff.abs() < 0.05) return;
      final next = _currentAngle + diff * _lerpSpeed;
      setState(() => _currentAngle = next);
      _viewer.setAngle(next);
    });
  }

  Future<void> _toggleBridge() async {
    if (_wsConnected) {
      _smoothTimer?.cancel();
      await _bleSub?.cancel();
      await _ble.disconnectWebSocket();
      setState(() { _wsConnected = false; _targetAngle = 0; _currentAngle = 0; });
      _viewer.setAngle(0);
      return;
    }
    setState(() { _connecting = true; _error = null; });
    try {
      await _ble.connectViaWebSocket();
      bool firstReading = true;
      _bleSub = _ble.dataStream.listen((data) {
        if (data.encoderValues.length <= _encoderIndex) return;
        final tick = data.encoderValues[_encoderIndex];
        if (firstReading) {
          _zeroTick = tick;
          _smoothedTick = tick.toDouble();
          firstReading = false;
        }
        // EMA filter: smooth out sensor noise
        _smoothedTick = _smoothedTick * (1 - _emaAlpha) + tick * _emaAlpha;
        final newAngle = ((_smoothedTick - _zeroTick).abs() / _ticksPerDeg).clamp(0.0, 130.0);
        // Deadzone: ignore tiny fluctuations
        if ((newAngle - _targetAngle).abs() >= _angleDeadzone) {
          _targetAngle = newAngle;
        }
      });
      _startSmoothTimer();
      setState(() { _wsConnected = true; _connecting = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _connecting = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    final accent = widget.accent;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14004AC6),
            blurRadius: 42,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TREATMENT PLAN',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.2,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Elbow Exercise',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              height: 1.08,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 340,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Character3DViewer(
                controller: _viewer,
                movementType: exercise.movementType,
                startAngleDeg: exercise.startAngle,
                endAngleDeg: exercise.endAngle,
                cameraPositionY: 1.3,
                cameraPositionZ: 2.8,
                cameraTargetY: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              FilledButton.icon(
                onPressed: _connecting ? null : _toggleBridge,
                icon: Icon(_wsConnected ? Icons.wifi_off : Icons.wifi),
                label: Text(_connecting
                    ? 'Connecting...'
                    : _wsConnected ? 'Disconnect' : 'Bridge'),
                style: FilledButton.styleFrom(
                  backgroundColor: _wsConnected ? Colors.red.shade400 : accent,
                ),
              ),
              if (_wsConnected) ...[
                const SizedBox(width: 12),
                Text(
                  '${_currentAngle.toStringAsFixed(1)}°',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
              ],
            ],
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      exercise.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.info, color: accent),
                style: IconButton.styleFrom(
                  backgroundColor: accent.withValues(alpha: 0.06),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _AngleGauge(
            currentAngle: _currentAngle,
            targetStart: exercise.startAngle,
            targetEnd: exercise.endAngle,
            accentColor: accent,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _KneeMetricCard(label: 'Target', value: exercise.targetRange)),
              const SizedBox(width: 10),
              Expanded(child: _KneeMetricCard(label: 'Reps', value: '${exercise.reps}')),
              const SizedBox(width: 10),
              Expanded(child: _KneeMetricCard(label: 'Sets', value: '${exercise.sets}')),
            ],
          ),
          const SizedBox(height: 20),
          _KneeCoachingCard(points: exercise.coachingPoints),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Angle gauge widget
// ---------------------------------------------------------------------------

class _AngleGauge extends StatelessWidget {
  const _AngleGauge({
    required this.currentAngle,
    required this.targetStart,
    required this.targetEnd,
    required this.accentColor,
  });

  final double currentAngle;
  final double targetStart;
  final double targetEnd;
  final Color  accentColor;

  @override
  Widget build(BuildContext context) {
    final inTarget = currentAngle >= targetStart && currentAngle <= targetEnd;
    return Column(
      children: [
        SizedBox(
          height: 80,
          child: CustomPaint(
            painter: _AngleGaugePainter(
              currentAngle: currentAngle,
              targetStart: targetStart,
              targetEnd: targetEnd,
              accentColor: accentColor,
              inTarget: inTarget,
            ),
            child: const SizedBox.expand(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${currentAngle.toStringAsFixed(0)}°',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: inTarget ? Colors.green : AppColors.text,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Target: ${targetStart.toStringAsFixed(0)}°–${targetEnd.toStringAsFixed(0)}°',
              style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            if (inTarget) ...[
              const SizedBox(width: 6),
              const Icon(Icons.check_circle, size: 16, color: Colors.green),
            ],
          ],
        ),
      ],
    );
  }
}

class _AngleGaugePainter extends CustomPainter {
  _AngleGaugePainter({
    required this.currentAngle,
    required this.targetStart,
    required this.targetEnd,
    required this.accentColor,
    required this.inTarget,
  });

  final double currentAngle;
  final double targetStart;
  final double targetEnd;
  final Color  accentColor;
  final bool   inTarget;

  static const double _maxAngle  = 130.0;
  // Arc spans 180° (π), starting from left (π) going clockwise to right (0)
  static const double _startRad  = math.pi;
  static const double _sweepRad  = math.pi;

  double _angleToRad(double deg) => _startRad + (deg / _maxAngle) * _sweepRad;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.92;
    final r  = size.height * 0.85;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);

    // Track (background)
    canvas.drawArc(
      rect, _startRad, _sweepRad, false,
      Paint()
        ..color = Colors.grey.shade200
        ..strokeWidth = 10
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Target zone
    final tStart = _angleToRad(targetStart);
    final tSweep = (targetEnd - targetStart) / _maxAngle * _sweepRad;
    canvas.drawArc(
      rect, tStart, tSweep, false,
      Paint()
        ..color = accentColor.withValues(alpha: 0.25)
        ..strokeWidth = 10
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Current angle fill
    final cSweep = (currentAngle / _maxAngle * _sweepRad).clamp(0.0, _sweepRad);
    if (cSweep > 0) {
      canvas.drawArc(
        rect, _startRad, cSweep, false,
        Paint()
          ..color = inTarget ? Colors.green : accentColor
          ..strokeWidth = 6
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }

    // Needle
    final needleRad = _angleToRad(currentAngle.clamp(0.0, _maxAngle));
    final nx = cx + r * math.cos(needleRad);
    final ny = cy + r * math.sin(needleRad);
    canvas.drawCircle(
      Offset(nx, ny), 6,
      Paint()..color = inTarget ? Colors.green : accentColor,
    );

    // Target zone tick marks
    for (final deg in [targetStart, targetEnd]) {
      final rad = _angleToRad(deg);
      final inner = r - 10;
      final outer = r + 4;
      canvas.drawLine(
        Offset(cx + inner * math.cos(rad), cy + inner * math.sin(rad)),
        Offset(cx + outer * math.cos(rad), cy + outer * math.sin(rad)),
        Paint()..color = accentColor..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(_AngleGaugePainter old) =>
      old.currentAngle != currentAngle || old.inTarget != inTarget;
}
