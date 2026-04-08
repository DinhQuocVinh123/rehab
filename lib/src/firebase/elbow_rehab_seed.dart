abstract final class ElbowRehabSeed {
  static const exercises = <String, Map<String, dynamic>>{
    'passive_elbow_flexion': {
      'title': 'Passive Elbow Flexion',
      'movementType': 'elbow_flexion',
      'phase': 'early_rehab',
      'description':
          'Gentle assisted flexion to reduce stiffness and improve mobility.',
      'targetMinAngle': 30,
      'targetMaxAngle': 120,
      'targetRangeLabel': '30° - 120°',
      'reps': 10,
      'sets': 2,
      'holdSeconds': 2,
      'difficulty': 'guided',
      'contraindications': [
        'Avoid forcing motion into sharp pain.',
        'Respect post-operative or casting limits.',
      ],
      'coachingPoints': [
        'Support your upper arm on a firm surface for stability.',
        'Move slowly and avoid any sharp or sudden pain.',
      ],
      'isActive': true,
    },
    'controlled_elbow_extension': {
      'title': 'Controlled Elbow Extension',
      'movementType': 'elbow_extension',
      'phase': 'mid_rehab',
      'description':
          'Extend the elbow gradually while keeping the upper arm stable to isolate the joint.',
      'targetMinAngle': 30,
      'targetMaxAngle': 120,
      'targetRangeLabel': '120° - 30°',
      'reps': 10,
      'sets': 3,
      'holdSeconds': 1,
      'difficulty': 'moderate',
      'contraindications': [
        'Do not snap into full extension under momentum.',
      ],
      'coachingPoints': [
        'Keep the shoulder relaxed and close to neutral.',
        'Do not swing the arm to gain momentum.',
        'Pause briefly at end range before returning.',
      ],
      'isActive': true,
    },
    'elbow_flexion_reach': {
      'title': 'Elbow Flexion Reach',
      'movementType': 'elbow_flexion',
      'phase': 'mid_rehab',
      'description':
          'Bring the hand toward the shoulder with smooth elbow flexion to improve active range and control.',
      'targetMinAngle': 25,
      'targetMaxAngle': 135,
      'targetRangeLabel': '25° - 135°',
      'reps': 12,
      'sets': 2,
      'holdSeconds': 1,
      'difficulty': 'guided',
      'contraindications': [
        'Do not compensate by hiking the shoulder.',
      ],
      'coachingPoints': [
        'Keep the wrist loose and forearm aligned.',
        'Use a controlled tempo both up and down.',
        'Avoid shrugging or leaning the trunk.',
      ],
      'isActive': true,
    },
  };

  static const elbowProgressSummary = <String, dynamic>{
    'currentPhase': 'early_rehab',
    'latestExtension': 28,
    'latestFlexion': 118,
    'bestExtension': 20,
    'bestFlexion': 125,
    'painBaseline': 2,
    'painTrend': 'improving',
    'swellingLevel': 'minimal',
    'adherenceScore': 0.88,
    'recommendedExerciseIds': [
      'passive_elbow_flexion',
      'controlled_elbow_extension',
      'elbow_flexion_reach',
    ],
  };

  static const latestElbowSession = <String, dynamic>{
    'exerciseId': 'passive_elbow_flexion',
    'joint': 'elbow',
    'side': 'right',
    'status': 'completed',
    'plannedReps': 10,
    'plannedSets': 2,
    'completedReps': 10,
    'completedSets': 2,
    'targetMinAngle': 30,
    'targetMaxAngle': 120,
    'actualMinAngle': 34,
    'actualMaxAngle': 116,
    'avgRange': 82,
    'painBefore': 2,
    'painAfter': 2,
    'notes': 'Good tolerance with mild end-range tightness.',
  };
}
