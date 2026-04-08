abstract final class KneeFirestoreSchema {
  static const kneeExercisesCollection = 'knee_exercises';
  static const kneeSessionsCollection = 'knee_sessions';
  static const kneeProgressCollection = 'knee_progress';
  static const kneeProgressSummaryDoc = 'summary';

  static const kneeSessionFields = <String, String>{
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

  static const kneeProgressFields = <String, String>{
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
