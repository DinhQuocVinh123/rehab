import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rehab/src/data/elbow_exercise_svg.dart';
import 'package:rehab/src/models/exercise.dart';
import 'package:rehab/src/theme/app_colors.dart';

const _kneeExerciseSvg = '''
<?xml version="1.0" encoding="utf-8"?>
  <svg width="800px" height="800px" viewBox="0 0 128 128" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" aria-hidden="true" role="img" class="iconify iconify--noto" preserveAspectRatio="xMidYMid meet">
    <linearGradient id="IconifyId17ecdb2904d178eab9934" x1="117.29" x2="33.833" y1="19.903" y2="83.278" gradientUnits="userSpaceOnUse">
      <stop stop-color="#FFD29C" offset="0">
      </stop>
      <stop stop-color="#FFD39E" offset=".024">
      </stop>
      <stop stop-color="#FCD8AF" offset=".316">
      </stop>
      <stop stop-color="#FADCBA" offset=".629">
      </stop>
      <stop stop-color="#F9DDBD" offset="1">
      </stop>
    </linearGradient>
    <path d="M20.27 122.41c-1.11 0-2.16-.34-3.2-1.05c-.73-.5-1.16-1.2-1.21-1.98c-.08-1.28.87-2.19 1.06-2.36c.08-.07.16-.13.25-.18c0 0 4.45-2.58 5.6-3.23c.86-.49 2.53-1.78 4.47-3.26c2.47-1.9 5.55-4.26 8.53-6.21c3.5-2.29 4.91-3.98 6.31-7.54c.88-2.23.18-12.29-.5-22.03c-.74-10.7-1.58-22.81-.86-30.16c-.16-1.12-.34-2.16-.51-3.15c-.84-4.83-1.5-8.64 1.36-13.44a9.342 9.342 0 0 1 4.36-3.84c15.63-6.71 42.78-16.14 50.2-16.95c2.17-.24 4.08-.35 5.82-.35c6.54 0 15.51 1.45 17.83 14.02c.52 2.79 1.27 9.91-2.85 15.7c-2.6 3.66-6.55 5.91-11.74 6.7c-5.36 1.15-15.66 1.65-25.61 2.14c-5.2.25-10.15.5-13.92.82c6.48 14.6.27 26.75-3.9 34.91l-.48.95c-2.21 4.34-4.64 14.03-3.13 21.96c.07.38.18.82.29 1.3c.79 3.38 2.27 9.67-3.25 12.08c-1.85.8-3.48 1.15-5.46 1.15c-.78 0-1.56-.05-2.39-.1c-.54-.04-1.11-.07-1.73-.1c-.78-.03-1.47-.09-2.11-.14c-.73-.06-1.36-.11-1.96-.11c-.95 0-2.06.11-3.77.93c-.56.27-1.08.53-1.57.79c-1.53.79-2.98 1.54-5.01 1.9c-.3.05-.62.08-.95.08c-1.67 0-3.4-.69-4.54-1.25c-.52.55-1.29 1.11-2.4 1.43l-.39.11c-.82.21-1.68.46-2.64.46z" fill="url(#IconifyId17ecdb2904d178eab9934)">
    </path>
    <path d="M101.95 8.18c8.46 0 14.52 2.88 16.35 12.79c1.4 7.59-.54 18.69-13.34 20.65c-8.79 1.88-31.57 2.06-41.58 3.16c7.92 15.35.94 27.84-3.44 36.46c-2.19 4.3-4.91 14.28-3.26 22.92c.57 2.97 2.97 9.52-2.09 11.72c-1.87.81-3.34 1.02-4.86 1.02c-1.24 0-2.51-.14-4.06-.2c-1.66-.07-2.91-.26-4.14-.26c-1.33 0-2.64.22-4.42 1.07c-2.31 1.1-3.78 2.13-6.19 2.56c-.22.04-.45.06-.68.06c-2.3 0-4.99-1.72-4.99-1.72s-.54 1.44-2.35 1.95c-.93.26-1.76.55-2.63.55c-.73 0-1.49-.2-2.35-.79c-1.26-.86 0-1.98 0-1.98s4.45-2.57 5.59-3.23c2.1-1.2 7.73-6.03 13.08-9.52c3.75-2.45 5.37-4.38 6.89-8.24c2.01-5.13-2.7-38.47-1.25-52.77c-.91-6.48-2.53-10.48.62-15.79a7.9 7.9 0 0 1 3.67-3.23C63.06 18.25 89.4 9.28 96.3 8.52c1.98-.21 3.87-.34 5.65-.34m0-3c-1.8 0-3.75.12-5.98.36c-7.74.85-34.77 10.24-50.64 17.06c-2.12.91-3.86 2.45-5.06 4.45c-3.14 5.28-2.4 9.54-1.55 14.47c.16.94.33 1.91.48 2.93c-.7 7.5.14 19.56.88 30.23c.57 8.17 1.34 19.37.6 21.38c-1.28 3.25-2.51 4.72-5.73 6.83c-3.03 1.98-6.13 4.36-8.62 6.27c-1.82 1.4-3.53 2.71-4.3 3.15c-1.15.66-5.61 3.24-5.61 3.24c-.17.1-.34.22-.49.35c-.4.35-1.68 1.66-1.56 3.58c.08 1.25.74 2.36 1.87 3.12c1.3.88 2.62 1.31 4.04 1.31c1.17 0 2.18-.29 3.07-.55l.38-.11c.87-.25 1.62-.64 2.24-1.1c1.21.51 2.75.99 4.29.99c.41 0 .82-.03 1.21-.1c2.25-.4 3.87-1.23 5.43-2.04c.48-.25.97-.5 1.52-.77c1.36-.65 2.23-.78 3.13-.78c.54 0 1.14.05 1.84.11c.64.05 1.35.11 2.17.15c.6.02 1.16.06 1.69.1c.85.06 1.66.11 2.49.11c2.17 0 4.04-.39 6.06-1.27c6.68-2.91 4.88-10.54 4.11-13.8c-.11-.46-.21-.88-.28-1.24c-1.44-7.58.88-16.84 2.99-20.99l.48-.95c4.12-8.06 10.17-19.89 4.73-34.25c3.41-.24 7.53-.45 11.82-.66c9.96-.49 20.27-.99 25.85-2.17c5.56-.87 9.82-3.33 12.65-7.3c4.45-6.26 3.65-13.86 3.1-16.84c-1.89-10.28-8.2-15.27-19.3-15.27z" fill="#EDBD82">
    </path>
    <path d="M58.75 47.73c-.73 2.29-1.39 4.48-1.95 6.67c-.54 2.19-1.02 4.35-1.25 6.54c-.32 2.18-.46 4.37-.47 6.59c-.07 2.25.16 4.47.18 6.9v.03c0 .05-.04.1-.11.1c-.04 0-.09-.03-.1-.07c-.77-2.23-1.44-4.48-1.67-6.8c-.33-2.31-.27-4.65 0-6.97c.31-2.31.92-4.6 1.78-6.79c.86-2.2 1.97-4.33 3.4-6.3a.1.1 0 0 1 .14-.03c.04.02.05.07.04.11l.01.02z" fill="#EDBD82">
    </path>
    <path d="M52.65 102.09c.41.93.88 2.69-.01 4.44c-1.43 2.11-3.23 2.4-4.16 2.37c-.28-.01-.43-.3-.26-.51c.51-.61 1.46-1.83 2.26-3.21c.72-1.24 1.24-2.4 1.52-3.1c.13-.27.54-.26.65.01z" fill="#EDBD82">
    </path>
    <path d="M48.99 40.03c1.5-1.37 2.79-4.11 3.07-4.95c.27-.84 1.02-4.1.84-5.86l-.02-.09c-.01-.06.03-.12.1-.12c.03-.01.06 0 .08.02c1.1.75 1.67 1.97 1.85 3.15c.2 1.2.08 2.43-.27 3.59c-.38 1.15-1.04 2.26-2.01 3.12c-.95.87-2.29 1.39-3.63 1.4c-.06 0-.12-.05-.12-.11c0-.03.02-.07.04-.09l.07-.06z" fill="#EDBD82">
    </path>
  </svg>
''';

class ExerciseShortcutCard extends StatelessWidget {
  const ExerciseShortcutCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPressed,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onPressed;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryGlow,
            blurRadius: 36,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: accentColor),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              buttonLabel,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseJointChip extends StatelessWidget {
  const ExerciseJointChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: selected ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.selected,
    required this.onTap,
  });

  final ExerciseDefinition exercise;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = exercise.joint == ExerciseJoint.knee
        ? AppColors.primary
        : AppColors.secondary;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? accent : Colors.transparent,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D004AC6),
              blurRadius: 26,
              offset: Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    exercise.movementLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: accent,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  selected ? Icons.play_circle_fill : Icons.play_circle_outline,
                  color: accent,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              exercise.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              exercise.description,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _ExerciseMeta(label: 'Range', value: exercise.targetRange),
                ),
                Expanded(
                  child: _ExerciseMeta(
                    label: 'Dose',
                    value: '${exercise.reps} x ${exercise.sets}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
          _KneeHeroVisual(
            exercise: exercise,
            accent: accent,
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
            'Elbow Exercise'.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.2,
              color: accent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            exercise.title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              height: 1.1,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            exercise.description,
            style: const TextStyle(
              fontSize: 18,
              height: 1.55,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          _ElbowHeroVisual(
            exercise: exercise,
            accent: accent,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _ElbowMetricCard(
                  label: 'Target Angle',
                  value: exercise.targetRange,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _ElbowMetricCard(
                  label: 'Prescription',
                  value: '${exercise.reps} Reps / ${exercise.sets} Sets',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _ElbowCoachingCard(
            accent: accent,
            points: exercise.coachingPoints,
          ),
        ],
      ),
    );
  }
}

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
          final progress = Curves.easeInOut.transform(_controller.value);
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
    Widget svgLayer() {
      return SvgPicture.string(
        _kneeExerciseSvg,
        fit: BoxFit.contain,
      );
    }

    final kneePivot = const Offset(52, 44);
    final hipPivot = const Offset(92, 22);
    final lowerRotation = lerpDouble(-0.42, 0.08, progress)!;
    final upperRotation = lerpDouble(-0.06, 0.02, progress)!;
    const upperLegRect = Rect.fromLTWH(0, 0, 128, 58);
    const lowerLegRect = Rect.fromLTWH(8, 36, 120, 92);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: ClipPath(
            clipper: const _RectClipper(lowerLegRect),
            child: Transform(
              alignment: Alignment.topLeft,
              transform: Matrix4.identity()
                ..translateByDouble(kneePivot.dx, kneePivot.dy, 0, 1)
                ..rotateZ(lowerRotation)
                ..translateByDouble(-kneePivot.dx, -kneePivot.dy, 0, 1),
              child: svgLayer(),
            ),
          ),
        ),
        Positioned.fill(
          child: ClipPath(
            clipper: const _RectClipper(upperLegRect),
            child: Transform(
              alignment: Alignment.topLeft,
              transform: Matrix4.identity()
                ..translateByDouble(hipPivot.dx, hipPivot.dy, 0, 1)
                ..rotateZ(upperRotation)
                ..translateByDouble(-hipPivot.dx, -hipPivot.dy, 0, 1),
              child: svgLayer(),
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

class _ElbowHeroVisual extends StatelessWidget {
  const _ElbowHeroVisual({
    required this.exercise,
    required this.accent,
  });

  final ExerciseDefinition exercise;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLowest,
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFDFEFF),
              Color(0xFFF4F8FB),
            ],
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.architecture, size: 16, color: accent),
                    const SizedBox(width: 8),
                    Text(
                      '${exercise.endAngle.round()}°',
                      style: TextStyle(
                        color: accent,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
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
                      Color(0x1A9DD6FF),
                      Color(0x00FFFFFF),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: _LightElbowVisual(
                  exercise: exercise,
                  accent: accent,
                ),
              ),
            ),
          ],
        ),
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
        final progress = Curves.easeInOut.transform(_controller.value);
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
          final progress = Curves.easeInOut.transform(_controller.value);
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
    const strokeColor = Color(0xFFF1F3F8);

    Widget svgLayer() {
      return SvgPicture.string(
        elbowExerciseSvg,
        fit: BoxFit.contain,
        colorFilter: const ColorFilter.mode(
          strokeColor,
          BlendMode.srcIn,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final pivot = Offset(width * 0.26, height * 0.56);
        final rotation = lerpDouble(-0.38, 0.14, progress)!;
        final staticUpperArmRect = Rect.fromLTWH(
          0,
          0,
          width * 0.42,
          height,
        );
        final movingForearmRect = Rect.fromLTWH(
          width * 0.24,
          height * 0.18,
          width * 0.80,
          height * 0.60,
        );

        return Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: OverflowBox(
                  maxWidth: width * 1.18,
                  maxHeight: height * 1.18,
                  child: ClipPath(
                    clipper: _RectClipper(staticUpperArmRect),
                    child: svgLayer(),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: OverflowBox(
                  maxWidth: width * 1.18,
                  maxHeight: height * 1.18,
                  child: ClipPath(
                    clipper: _RectClipper(movingForearmRect),
                    child: Transform(
                      alignment: Alignment.topLeft,
                      transform: Matrix4.identity()
                        ..translateByDouble(pivot.dx, pivot.dy, 0, 1)
                        ..rotateZ(rotation)
                        ..translateByDouble(-pivot.dx, -pivot.dy, 0, 1),
                      child: svgLayer(),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: pivot.dx - 2,
              top: pivot.dy - 9,
              child: Transform.rotate(
                angle: rotation,
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 34,
                  height: 18,
                  decoration: BoxDecoration(
                    color: strokeColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
            Positioned(
              left: pivot.dx - 12,
              top: pivot.dy - 12,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F3F8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _ElbowArcPainter(),
              ),
            ),
            Positioned(
              left: pivot.dx - 10,
              top: pivot.dy - 10,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: strokeColor,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ElbowMetricCard extends StatelessWidget {
  const _ElbowMetricCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.2,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _ElbowCoachingCard extends StatelessWidget {
  const _ElbowCoachingCard({
    required this.accent,
    required this.points,
  });

  final Color accent;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.12)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFB3EBFF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Icon(Icons.lightbulb, color: accent, size: 18),
              ),
              const SizedBox(width: 12),
              const Text(
                'Coaching Points',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.55,
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

class _LightAnimatedElbowSvg extends StatelessWidget {
  const _LightAnimatedElbowSvg({
    required this.progress,
    required this.accent,
  });

  final double progress;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    Widget svgLayer() {
      return SvgPicture.string(
        elbowExerciseSvg,
        fit: BoxFit.contain,
        colorFilter: const ColorFilter.mode(
          Color(0xFF5D636F),
          BlendMode.srcIn,
        ),
      );
    }

    final pivot = const Offset(76, 126);
    final rotation = lerpDouble(-0.34, 0.16, progress)!;
    const staticUpperArmRect = Rect.fromLTWH(0, 0, 112, 240);
    const movingForearmRect = Rect.fromLTWH(78, 44, 198, 138);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: ClipPath(
            clipper: const _RectClipper(staticUpperArmRect),
            child: svgLayer(),
          ),
        ),
        Positioned.fill(
          child: ClipPath(
            clipper: const _RectClipper(movingForearmRect),
            child: Transform(
              alignment: Alignment.topLeft,
              transform: Matrix4.identity()
                ..translateByDouble(pivot.dx, pivot.dy, 0, 1)
                ..rotateZ(rotation)
                ..translateByDouble(-pivot.dx, -pivot.dy, 0, 1),
              child: svgLayer(),
            ),
          ),
        ),
        Positioned(
          left: pivot.dx - 2,
          top: pivot.dy - 9,
          child: Transform.rotate(
            angle: rotation,
            alignment: Alignment.centerLeft,
            child: Container(
              width: 34,
              height: 18,
              decoration: const BoxDecoration(
                color: Color(0xFF5D636F),
                borderRadius: BorderRadius.all(Radius.circular(999)),
              ),
            ),
          ),
        ),
        Positioned(
          left: pivot.dx - 12,
          top: pivot.dy - 12,
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFF5D636F),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          left: pivot.dx - 9,
          top: pivot.dy - 9,
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
    final center = Offset(size.width * 0.44, size.height * 0.5);
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
      Offset(size.width * 0.76, size.height * 0.5),
      guide,
    );
    canvas.drawLine(
      center,
      Offset(size.width * 0.7, size.height * 0.35),
      guide,
    );
  }

  @override
  bool shouldRepaint(covariant _LightElbowArcPainter oldDelegate) {
    return oldDelegate.accent != accent;
  }
}

class _RectClipper extends CustomClipper<Path> {
  const _RectClipper(this.rect);

  final Rect rect;

  @override
  Path getClip(Size size) => Path()..addRect(rect);

  @override
  bool shouldReclip(covariant _RectClipper oldClipper) {
    return oldClipper.rect != rect;
  }
}

class _ElbowArcPainter extends CustomPainter {
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
