import 'package:flutter/material.dart';
import 'package:rehab/src/data/exercise_library.dart';
import 'package:rehab/src/firebase/firebase_bootstrap.dart';
import 'package:rehab/src/firebase/rehab_firestore.dart';
import 'package:rehab/src/models/exercise.dart';
import 'package:rehab/src/theme/app_colors.dart';
import 'package:rehab/src/widgets/exercise_widgets.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({
    super.key,
    required this.initialJoint,
    required this.patientId,
  });

  final ExerciseJoint initialJoint;
  final String patientId;

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  late ExerciseJoint _selectedJoint;
  String? _selectedExerciseId;

  @override
  void initState() {
    super.initState();
    _selectedJoint = widget.initialJoint;
    _selectedExerciseId = ExerciseLibrary.byJoint(_selectedJoint).first.id;
  }

  @override
  Widget build(BuildContext context) {
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
                    'Use these movement guides to show patients the target path, range, and pacing before they begin a session.',
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
                  _ExercisesBody(
                    patientId: widget.patientId,
                    joint: _selectedJoint,
                    selectedExerciseId: _selectedExerciseId,
                    onSelectExercise: (exerciseId) {
                      setState(() {
                        _selectedExerciseId = exerciseId;
                      });
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
      _selectedExerciseId = ExerciseLibrary.byJoint(joint).first.id;
    });
  }
}

class _ExercisesBody extends StatelessWidget {
  const _ExercisesBody({
    required this.patientId,
    required this.joint,
    required this.selectedExerciseId,
    required this.onSelectExercise,
  });

  final String patientId;
  final ExerciseJoint joint;
  final String? selectedExerciseId;
  final ValueChanged<String> onSelectExercise;

  @override
  Widget build(BuildContext context) {
    if (!FirebaseBootstrap.isReady) {
      return _ExerciseGallery(
        exercises: ExerciseLibrary.byJoint(joint),
        selectedExerciseId: selectedExerciseId,
        onSelectExercise: onSelectExercise,
      );
    }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: const RehabFirestore().watchAssignedExercises(patientId),
      builder: (context, assignmentSnapshot) {
        final assignments = (assignmentSnapshot.data ?? const <Map<String, dynamic>>[])
            .where((assignment) => assignment['joint'] == joint.name)
            .toList();

        final definitionStream = joint == ExerciseJoint.knee
            ? const RehabFirestore().watchKneeExercises()
            : const RehabFirestore().watchElbowExercises();

        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: definitionStream,
          builder: (context, definitionSnapshot) {
            final definitionsById = {
              for (final definition
                  in definitionSnapshot.data ?? const <Map<String, dynamic>>[])
                definition['id'] as String: definition,
            };

            final assignedExercises = assignments
                .map((assignment) {
                  final definition = definitionsById[assignment['exerciseId']];
                  if (definition == null) {
                    return null;
                  }
                  return _exerciseFromFirestore(joint, definition, assignment);
                })
                .whereType<ExerciseDefinition>()
                .toList();

            final exercises = assignedExercises.isNotEmpty
                ? assignedExercises
                : ExerciseLibrary.byJoint(joint);

            return _ExerciseGallery(
              exercises: exercises,
              selectedExerciseId: selectedExerciseId,
              onSelectExercise: onSelectExercise,
            );
          },
        );
      },
    );
  }
}

class _ExerciseGallery extends StatelessWidget {
  const _ExerciseGallery({
    required this.exercises,
    required this.selectedExerciseId,
    required this.onSelectExercise,
  });

  final List<ExerciseDefinition> exercises;
  final String? selectedExerciseId;
  final ValueChanged<String> onSelectExercise;

  @override
  Widget build(BuildContext context) {
    final selectedExercise = exercises.firstWhere(
      (exercise) => exercise.id == selectedExerciseId,
      orElse: () => exercises.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExerciseHeroCard(exercise: selectedExercise),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: exercises.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 360,
            mainAxisExtent: 240,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
          ),
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            return ExerciseCard(
              exercise: exercise,
              selected: exercise.id == selectedExercise.id,
              onTap: () => onSelectExercise(exercise.id),
            );
          },
        ),
      ],
    );
  }
}

ExerciseDefinition _exerciseFromFirestore(
  ExerciseJoint joint,
  Map<String, dynamic> definition,
  Map<String, dynamic> assignment,
) {
  final coachingPoints =
      (definition['coachingPoints'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList();

  return ExerciseDefinition(
    id: definition['id'] as String? ?? '',
    joint: joint,
    title: definition['title'] as String? ?? 'Untitled',
    movementLabel: _prettyLabel(
      definition['movementType'] as String? ?? joint.name,
    ),
    description: definition['description'] as String? ?? '',
    targetRange: definition['targetRangeLabel'] as String? ?? '--',
    reps:
        (assignment['targetReps'] as num?)?.toInt() ??
        (definition['reps'] as num?)?.toInt() ??
        0,
    sets:
        (assignment['targetSets'] as num?)?.toInt() ??
        (definition['sets'] as num?)?.toInt() ??
        0,
    startAngle: (definition['targetMinAngle'] as num?)?.toDouble() ?? 0,
    endAngle: (definition['targetMaxAngle'] as num?)?.toDouble() ?? 0,
    coachingPoints: coachingPoints,
  );
}

String _prettyLabel(String raw) => raw
    .split('_')
    .where((part) => part.isNotEmpty)
    .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
    .join(' ');
