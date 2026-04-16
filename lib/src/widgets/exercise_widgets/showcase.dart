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

class _KneeExerciseShowcase extends StatelessWidget {
  const _KneeExerciseShowcase({
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
                movementType: exercise.movementType,
                startAngleDeg: exercise.startAngle,
                endAngleDeg: exercise.endAngle,
                modelPath: 'assets/models/Shannon_opt.glb',
                modelScale: 0.01,
                debugBones: false,
                
                
                cameraPositionY: 0.15,
                cameraPositionZ: 2.5,
                cameraTargetY: 0.82,
                
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
