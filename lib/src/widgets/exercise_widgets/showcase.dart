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
  bool   _connecting    = false;
  bool   _connected     = false;
  String? _error;
  int    _zeroTick      = 0;
  double _currentAngle  = 0;

  // Calibration constant — ticks per degree.
  // Adjust after measuring: move joint 90° and read encoder delta.
  static const double _ticksPerDeg = 50.0;

  @override
  void dispose() {
    _bleSub?.cancel();
    _ble.dispose();
    _viewer.dispose();
    super.dispose();
  }

  Future<void> _toggleConnection() async {
    if (_connected) {
      await _bleSub?.cancel();
      await _ble.disconnect();
      setState(() { _connected = false; _currentAngle = 0; });
      _viewer.setAngle(0);
      return;
    }

    setState(() { _connecting = true; _error = null; });
    try {
      await _ble.connect();
      bool firstReading = true;
      _bleSub = _ble.dataStream.listen((data) {
        if (data.encoderValues.isEmpty) return;
        final tick = data.encoderValues[0];
        if (firstReading) { _zeroTick = tick; firstReading = false; }
        final angle = (tick - _zeroTick) / _ticksPerDeg;
        setState(() => _currentAngle = angle);
        _viewer.setAngle(angle);
      });
      setState(() { _connected = true; _connecting = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _connecting = false; });
    }
  }

  void _setZero() {
    final sub = _bleSub;
    if (sub == null) return;
    sub.cancel();
    bool firstReading = true;
    _bleSub = _ble.dataStream.listen((data) {
      if (data.encoderValues.isEmpty) return;
      final tick = data.encoderValues[0];
      if (firstReading) { _zeroTick = tick; firstReading = false; }
      final angle = (tick - _zeroTick) / _ticksPerDeg;
      setState(() => _currentAngle = angle);
      _viewer.setAngle(angle);
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
                onPressed: _connecting ? null : _toggleConnection,
                icon: Icon(_connected
                    ? Icons.bluetooth_connected
                    : Icons.bluetooth),
                label: Text(_connecting
                    ? 'Connecting...'
                    : _connected
                        ? 'Disconnect'
                        : 'Connect Device'),
                style: FilledButton.styleFrom(
                  backgroundColor:
                      _connected ? Colors.red.shade400 : accent,
                ),
              ),
              if (_connected) ...[
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

class _ElbowExerciseShowcase extends StatelessWidget {
  const _ElbowExerciseShowcase({
    required this.exercise,
    required this.accent,
  });

  final ExerciseDefinition exercise;
  final Color accent;

  @override
  Widget build(BuildContext context) {
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
            style: const TextStyle(
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
                movementType: exercise.movementType,
                startAngleDeg: exercise.startAngle,
                endAngleDeg: exercise.endAngle,
                cameraPositionY: 1.3,
                cameraPositionZ: 2.8,
                cameraTargetY: 1.1,
              ),
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
