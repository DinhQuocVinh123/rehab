enum ExerciseJoint {
  knee,
  elbow,
}

class ExerciseDefinition {
  const ExerciseDefinition({
    required this.id,
    required this.joint,
    required this.title,
    required this.movementLabel,
    required this.description,
    required this.targetRange,
    required this.reps,
    required this.sets,
    required this.startAngle,
    required this.endAngle,
    required this.coachingPoints,
  });

  final String id;
  final ExerciseJoint joint;
  final String title;
  final String movementLabel;
  final String description;
  final String targetRange;
  final int reps;
  final int sets;
  final double startAngle;
  final double endAngle;
  final List<String> coachingPoints;
}
