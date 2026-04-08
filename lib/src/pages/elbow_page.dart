import 'package:flutter/material.dart';
import 'package:rehab/src/firebase/firebase_bootstrap.dart';
import 'package:rehab/src/firebase/rehab_firestore.dart';
import 'package:rehab/src/models/app_tab.dart';
import 'package:rehab/src/models/exercise.dart';
import 'package:rehab/src/pages/exercises_page.dart';
import 'package:rehab/src/theme/app_colors.dart';
import 'package:rehab/src/widgets/elbow_widgets.dart';
import 'package:rehab/src/widgets/exercise_widgets.dart';

class ElbowPage extends StatelessWidget {
  const ElbowPage({
    super.key,
    required this.currentTab,
    required this.onSelect,
  });

  final AppTab currentTab;
  final ValueChanged<AppTab> onSelect;

  static const _patientId = RehabFirestore.demoPatientId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const ElbowTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 980),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Elbow Overview',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Firestore-backed elbow rehab status for the current patient.',
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.45,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (!FirebaseBootstrap.isReady)
                          const _PageOfflineNotice(jointLabel: 'elbow')
                        else ...[
                          _ElbowPhaseAndRomSection(patientId: _patientId),
                          const SizedBox(height: 24),
                          _ElbowRecommendedExercisesSection(patientId: _patientId),
                          const SizedBox(height: 24),
                          _ElbowLatestSessionSection(patientId: _patientId),
                        ],
                        const SizedBox(height: 24),
                        ExerciseShortcutCard(
                          title: 'Guided Elbow Exercises',
                          subtitle:
                              'Open the exercise gallery to inspect the patient-facing elbow movement visuals.',
                          buttonLabel: 'Open',
                          icon: Icons.fitness_center,
                          accentColor: AppColors.secondary,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const ExercisesPage(
                                  initialJoint: ExerciseJoint.elbow,
                                  patientId: _patientId,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ElbowBottomNav(
        currentTab: currentTab,
        onSelect: onSelect,
      ),
    );
  }
}

class _ElbowPhaseAndRomSection extends StatelessWidget {
  const _ElbowPhaseAndRomSection({required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: const RehabFirestore().watchElbowProgressSummary(patientId),
      builder: (context, snapshot) {
        final data = snapshot.data ?? const <String, dynamic>{};
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _InfoCard(
              title: 'Current Phase',
              value: _pretty(data['currentPhase'] as String? ?? 'unknown'),
              accent: AppColors.secondary,
            ),
            _InfoCard(
              title: 'Latest ROM',
              value:
                  'Ext ${data['latestExtension'] ?? '--'}° / Flex ${data['latestFlexion'] ?? '--'}°',
              accent: AppColors.primary,
            ),
            _InfoCard(
              title: 'Best ROM',
              value:
                  'Ext ${data['bestExtension'] ?? '--'}° / Flex ${data['bestFlexion'] ?? '--'}°',
            ),
          ],
        );
      },
    );
  }
}

class _ElbowRecommendedExercisesSection extends StatelessWidget {
  const _ElbowRecommendedExercisesSection({required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: const RehabFirestore().watchAssignedExercises(
        patientId,
        joint: 'elbow',
      ),
      builder: (context, assignmentSnapshot) {
        final assignments =
            assignmentSnapshot.data ?? const <Map<String, dynamic>>[];

        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: const RehabFirestore().watchElbowExercises(),
          builder: (context, exerciseSnapshot) {
            final exercisesById = {
              for (final exercise
                  in exerciseSnapshot.data ?? const <Map<String, dynamic>>[])
                exercise['id'] as String: exercise,
            };

            return _SectionBlock(
              title: 'Assigned Exercises',
              subtitle:
                  'Global elbow exercise definitions assigned to this patient.',
              child: Column(
                children: assignments
                    .map((assignment) {
                      final exercise =
                          exercisesById[assignment['exerciseId']] ??
                          const <String, dynamic>{};
                      final reps =
                          assignment['targetReps'] ?? exercise['reps'] ?? '--';
                      final sets =
                          assignment['targetSets'] ?? exercise['sets'] ?? '--';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ExerciseSummaryTile(
                          title: exercise['title'] as String? ??
                              _pretty(
                                assignment['exerciseId'] as String? ??
                                    'untitled',
                              ),
                          subtitle:
                              '${_pretty(assignment['status'] as String? ?? 'assigned')} • ${exercise['targetRangeLabel'] ?? '--'} • $reps x $sets',
                        ),
                      );
                    })
                    .toList(),
              ),
            );
          },
        );
      },
    );
  }
}

class _ElbowLatestSessionSection extends StatelessWidget {
  const _ElbowLatestSessionSection({required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: const RehabFirestore().watchLatestElbowSession(patientId),
      builder: (context, snapshot) {
        final data = snapshot.data ?? const <String, dynamic>{};
        return _SectionBlock(
          title: 'Latest Session Summary',
          subtitle: 'Most recent stored elbow session for this patient.',
          child: Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              _MetricTile(
                label: 'Exercise',
                value: _pretty(data['exerciseId'] as String? ?? 'unknown'),
              ),
              _MetricTile(
                label: 'Completion',
                value:
                    '${data['completedReps'] ?? '--'} reps / ${data['completedSets'] ?? '--'} sets',
              ),
              _MetricTile(
                label: 'Target ROM',
                value:
                    '${data['targetMinAngle'] ?? '--'}° to ${data['targetMaxAngle'] ?? '--'}°',
              ),
              _MetricTile(
                label: 'Actual ROM',
                value:
                    '${data['actualMinAngle'] ?? '--'}° to ${data['actualMaxAngle'] ?? '--'}°',
              ),
              _MetricTile(
                label: 'Pain',
                value:
                    '${data['painBefore'] ?? '--'} → ${data['painAfter'] ?? '--'}',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PageOfflineNotice extends StatelessWidget {
  const _PageOfflineNotice({required this.jointLabel});

  final String jointLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        'Firebase is not ready on this platform, so $jointLabel data cannot be loaded from Firestore.',
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
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
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
    this.accent,
  });

  final String title;
  final String value;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.8,
              color: AppColors.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: accent ?? AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseSummaryTile extends StatelessWidget {
  const _ExerciseSummaryTile({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
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
              letterSpacing: 1.6,
              color: AppColors.outline,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

String _pretty(String raw) => raw
    .split('_')
    .where((part) => part.isNotEmpty)
    .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
    .join(' ');
