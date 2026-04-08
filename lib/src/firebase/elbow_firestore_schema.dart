abstract final class ElbowFirestoreSchema {
  static const elbowExercisesCollection = 'elbow_exercises';
  static const elbowSessionsCollection = 'elbow_sessions';
  static const elbowProgressCollection = 'elbow_progress';
  static const elbowProgressSummaryDoc = 'summary';

  static const elbowSessionFields = <String, String>{
    'exerciseId': 'exerciseId',
    'joint': 'joint',
    'side': 'side',
    'status': 'status',
    'plannedReps': 'plannedReps',
    'plannedSets': 'plannedSets',
    'completedReps': 'completedReps',
    'completedSets': 'completedSets',
    'targetMinAngle': 'targetMinAngle',
    'targetMaxAngle': 'targetMaxAngle',
    'actualMinAngle': 'actualMinAngle',
    'actualMaxAngle': 'actualMaxAngle',
    'avgRange': 'avgRange',
    'painBefore': 'painBefore',
    'painAfter': 'painAfter',
    'notes': 'notes',
    'startedAt': 'startedAt',
    'endedAt': 'endedAt',
    'createdAt': 'createdAt',
    'updatedAt': 'updatedAt',
  };

  static const elbowProgressFields = <String, String>{
    'currentPhase': 'currentPhase',
    'latestExtension': 'latestExtension',
    'latestFlexion': 'latestFlexion',
    'bestExtension': 'bestExtension',
    'bestFlexion': 'bestFlexion',
    'painBaseline': 'painBaseline',
    'painTrend': 'painTrend',
    'swellingLevel': 'swellingLevel',
    'adherenceScore': 'adherenceScore',
    'recommendedExerciseIds': 'recommendedExerciseIds',
    'updatedAt': 'updatedAt',
  };
}
