abstract final class KneeRehabSeed {
  static const exercises = <String, Map<String, dynamic>>{
    'post_op_knee_extension': {
      'title': 'Post-Op Knee Extension',
      'movementType': 'knee_extension',
      'phase': 'early_rehab',
      'description':
          'Controlled extension work to restore terminal knee extension after surgery.',
      'targetMinAngle': 0,
      'targetMaxAngle': 90,
      'targetRangeLabel': '0° - 90°',
      'reps': 12,
      'sets': 3,
      'holdSeconds': 2,
      'difficulty': 'guided',
      'contraindications': [
        'Stop if sharp anterior knee pain increases.',
        'Avoid forcing the joint past surgeon limits.',
      ],
      'coachingPoints': [
        'Keep your heel on the surface at all times.',
        'Move slowly through the entire extension range.',
      ],
      'isActive': true,
    },
    'heel_slide_flexion': {
      'title': 'Heel Slide Flexion',
      'movementType': 'knee_flexion',
      'phase': 'early_rehab',
      'description':
          'Slide the heel toward the body to improve active knee flexion without forcing the joint.',
      'targetMinAngle': 30,
      'targetMaxAngle': 95,
      'targetRangeLabel': '30° - 95°',
      'reps': 12,
      'sets': 3,
      'holdSeconds': 1,
      'difficulty': 'guided',
      'contraindications': [
        'Do not pull into aggressive flexion when swelling is high.',
      ],
      'coachingPoints': [
        'Keep the hip neutral and let the movement come from the knee.',
        'Move smoothly into flexion, then pause before returning.',
        'Stop if pain becomes sharp instead of mild stretch.',
      ],
      'isActive': true,
    },
    'terminal_knee_extension': {
      'title': 'Terminal Knee Extension',
      'movementType': 'knee_extension',
      'phase': 'mid_rehab',
      'description':
          'Straighten the knee through the last few degrees of extension to restore control and symmetry.',
      'targetMinAngle': 0,
      'targetMaxAngle': 70,
      'targetRangeLabel': '70° - 0°',
      'reps': 15,
      'sets': 3,
      'holdSeconds': 2,
      'difficulty': 'moderate',
      'contraindications': [
        'Avoid locking with uncontrolled momentum.',
      ],
      'coachingPoints': [
        'Engage the quadriceps before fully locking out.',
        'Avoid lifting the hip or rotating the foot outward.',
        'Control the return instead of dropping back quickly.',
      ],
      'isActive': true,
    },
  };

  static const kneeProgressSummary = <String, dynamic>{
    'currentPhase': 'early_rehab',
    'latestExtension': 5,
    'latestFlexion': 96,
    'bestExtension': 2,
    'bestFlexion': 102,
    'painBaseline': 3,
    'painTrend': 'stable',
    'swellingLevel': 'mild',
    'adherenceScore': 0.82,
    'recommendedExerciseIds': [
      'post_op_knee_extension',
      'heel_slide_flexion',
      'terminal_knee_extension',
    ],
  };

  static const latestKneeSession = <String, dynamic>{
    'exerciseId': 'heel_slide_flexion',
    'joint': 'knee',
    'side': 'right',
    'status': 'completed',
    'plannedReps': 12,
    'plannedSets': 3,
    'completedReps': 10,
    'completedSets': 3,
    'targetMinAngle': 30,
    'targetMaxAngle': 95,
    'actualMinAngle': 34,
    'actualMaxAngle': 88,
    'avgRange': 54,
    'painBefore': 3,
    'painAfter': 4,
    'notes': 'Mild stiffness during final 2 repetitions.',
  };
}
