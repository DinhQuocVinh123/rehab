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
  bool   _wsConnected   = false;
  String? _error;
  int    _zeroTick      = 0;
  double _currentAngle  = 0;

  // Demo mode
  Timer?  _demoTimer;
  bool    _demoRunning  = false;
  double  _demoPhase    = 0;

  static const double _ticksPerDeg = 50.0;
  static const int    _encoderIndex = 1; // sensor[1] = knee encoder

  @override
  void dispose() {
    _demoTimer?.cancel();
    _bleSub?.cancel();
    _ble.dispose();
    _viewer.dispose();
    super.dispose();
  }

  void _toggleDemo() {
    if (_demoRunning) {
      _demoTimer?.cancel();
      setState(() { _demoRunning = false; _currentAngle = 0; });
      _viewer.setAngle(0);
      return;
    }
    _demoPhase = 0;
    setState(() => _demoRunning = true);

    // Dùng đúng format packet của KNEESENSE3 (từ nRF screenshot).
    // Vary encoder của sensor[0] (bytes[9..10]) để tạo chuyển động.
    // Range: 0 → 4500 ticks (≈ 0°–90° với ticksPerDeg=50)
    _demoTimer = Timer.periodic(const Duration(milliseconds: 32), (_) {
      _demoPhase += 0.035;
      final ticks = (4500 * (1 - math.cos(_demoPhase)) / 2).round(); // 0–4500
      final encLow  = ticks & 0xFF;
      final encHigh = (ticks >> 8) & 0xFF;

      // Build packet: copy sample, ghi đè encoder bytes của sensor[0]
      final packet = List<int>.from(DaqBleService.samplePacketBytes);
      packet[9]  = encLow;   // encoder low byte
      packet[10] = encHigh;  // encoder high byte

      final data = DaqBleService.parsePacket(Uint8List.fromList(packet));
      if (data == null) return;
      final angle = data.encoderValues[_encoderIndex] / _ticksPerDeg;
      setState(() => _currentAngle = angle);
      _viewer.setAngle(angle);
    });
  }

  Future<void> _toggleWsConnection() async {
    if (_wsConnected) {
      await _ble.disconnectWebSocket();
      setState(() { _wsConnected = false; _currentAngle = 0; });
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
        final angle = (tick - _zeroTick) / _ticksPerDeg;
        setState(() => _currentAngle = angle);
        _viewer.setAngle(angle);
      });
      setState(() { _wsConnected = true; _connecting = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _connecting = false; });
    }
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
        if (data.encoderValues.length <= _encoderIndex) return;
        final tick = data.encoderValues[_encoderIndex];
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
      if (data.encoderValues.length <= _encoderIndex) return;
      final tick = data.encoderValues[_encoderIndex];
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
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: _connected ? null : _toggleDemo,
                icon: Icon(_demoRunning ? Icons.stop : Icons.play_arrow),
                label: Text(_demoRunning ? 'Stop' : 'Demo'),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: (_connected || _demoRunning) ? null : _toggleWsConnection,
                icon: Icon(_wsConnected ? Icons.wifi_off : Icons.wifi),
                label: Text(_wsConnected ? 'Disconnect' : 'Bridge'),
              ),
              if (_connected || _demoRunning || _wsConnected) ...[
                const SizedBox(width: 12),
                Text(
                  '${_currentAngle.toStringAsFixed(1)}°',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                if (_connected || _wsConnected) ...[
                  const Spacer(),
                  TextButton(
                    onPressed: _setZero,
                    child: const Text('Set Zero'),
                  ),
                ],
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
