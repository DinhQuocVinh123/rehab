import 'package:flutter/material.dart';
import 'package:rehab/src/data/exercise_library.dart';
import 'package:rehab/src/models/exercise.dart';
import 'package:rehab/src/theme/app_colors.dart';
import 'package:rehab/src/widgets/exercise_widgets.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({
    super.key,
    required this.initialJoint,
  });

  final ExerciseJoint initialJoint;

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  late ExerciseJoint _selectedJoint;
  late ExerciseDefinition _selectedExercise;

  @override
  void initState() {
    super.initState();
    _selectedJoint = widget.initialJoint;
    _selectedExercise = ExerciseLibrary.byJoint(_selectedJoint).first;
  }

  @override
  Widget build(BuildContext context) {
    final exercises = ExerciseLibrary.byJoint(_selectedJoint);

    if (!exercises.contains(_selectedExercise)) {
      _selectedExercise = exercises.first;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.text,
        title: const Text(
          'Guided Exercises',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1160),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Visual guidance for each movement',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Use these animated movement guides to show patients the target path, range, and pacing before they begin a session.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ExerciseJointChip(
                        label: 'Knee',
                        selected: _selectedJoint == ExerciseJoint.knee,
                        onTap: () => _setJoint(ExerciseJoint.knee),
                      ),
                      const SizedBox(width: 10),
                      ExerciseJointChip(
                        label: 'Elbow',
                        selected: _selectedJoint == ExerciseJoint.elbow,
                        onTap: () => _setJoint(ExerciseJoint.elbow),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ExerciseHeroCard(exercise: _selectedExercise),
                  const SizedBox(height: 24),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: exercises.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 360,
                          mainAxisExtent: 240,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                        ),
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      return ExerciseCard(
                        exercise: exercise,
                        selected: exercise.id == _selectedExercise.id,
                        onTap: () {
                          setState(() {
                            _selectedExercise = exercise;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setJoint(ExerciseJoint joint) {
    if (_selectedJoint == joint) {
      return;
    }

    setState(() {
      _selectedJoint = joint;
      _selectedExercise = ExerciseLibrary.byJoint(joint).first;
    });
  }
}
