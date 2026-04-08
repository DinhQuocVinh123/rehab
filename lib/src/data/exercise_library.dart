import 'package:rehab/src/models/exercise.dart';

abstract final class ExerciseLibrary {
  static const List<ExerciseDefinition> all = [
    ExerciseDefinition(
      id: 'knee-flexion-slide',
      joint: ExerciseJoint.knee,
      title: 'Heel Slide Flexion',
      movementLabel: 'Knee Flexion',
      description:
          'Slide the heel toward the body to improve active knee flexion without forcing the joint.',
      targetRange: '30° - 95°',
      reps: 12,
      sets: 3,
      startAngle: 25,
      endAngle: 95,
      coachingPoints: [
        'Keep the hip neutral and let the movement come from the knee.',
        'Move smoothly into flexion, then pause before returning.',
        'Stop if pain becomes sharp instead of mild stretch.',
      ],
    ),
    ExerciseDefinition(
      id: 'knee-terminal-extension',
      joint: ExerciseJoint.knee,
      title: 'Terminal Knee Extension',
      movementLabel: 'Knee Extension',
      description:
          'Straighten the knee through the last few degrees of extension to restore control and symmetry.',
      targetRange: '70° - 0°',
      reps: 15,
      sets: 3,
      startAngle: 70,
      endAngle: 0,
      coachingPoints: [
        'Engage the quadriceps before fully locking out.',
        'Avoid lifting the hip or rotating the foot outward.',
        'Control the return instead of dropping back quickly.',
      ],
    ),
    ExerciseDefinition(
      id: 'elbow-extension-control',
      joint: ExerciseJoint.elbow,
      title: 'Controlled Elbow Extension',
      movementLabel: 'Elbow Extension',
      description:
          'Extend the elbow gradually while keeping the upper arm stable to isolate the joint.',
      targetRange: '120° - 30°',
      reps: 10,
      sets: 3,
      startAngle: 120,
      endAngle: 30,
      coachingPoints: [
        'Keep the shoulder relaxed and close to neutral.',
        'Do not swing the arm to gain momentum.',
        'Pause briefly at end range before returning.',
      ],
    ),
    ExerciseDefinition(
      id: 'elbow-flexion-reach',
      joint: ExerciseJoint.elbow,
      title: 'Elbow Flexion Reach',
      movementLabel: 'Elbow Flexion',
      description:
          'Bring the hand toward the shoulder with smooth elbow flexion to improve active range and control.',
      targetRange: '25° - 135°',
      reps: 12,
      sets: 2,
      startAngle: 25,
      endAngle: 135,
      coachingPoints: [
        'Keep the wrist loose and forearm aligned.',
        'Use a controlled tempo both up and down.',
        'Avoid shrugging or leaning the trunk.',
      ],
    ),
  ];

  static List<ExerciseDefinition> byJoint(ExerciseJoint joint) {
    return all.where((exercise) => exercise.joint == joint).toList();
  }
}
