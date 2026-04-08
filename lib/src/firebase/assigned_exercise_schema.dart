abstract final class AssignedExerciseSchema {
  static const assignedExercisesCollection = 'assigned_exercises';

  static const fields = <String, String>{
    'exerciseId': 'exerciseId',
    'joint': 'joint',
    'status': 'status',
    'assignedBy': 'assignedBy',
    'assignedAt': 'assignedAt',
    'startDate': 'startDate',
    'endDate': 'endDate',
    'targetReps': 'targetReps',
    'targetSets': 'targetSets',
    'notes': 'notes',
    'updatedAt': 'updatedAt',
  };
}
