import 'package:flutter/material.dart';
import 'package:rehab/src/models/app_tab.dart';
import 'package:rehab/src/painters/arc_painter.dart';
import 'package:rehab/src/theme/app_colors.dart';

class KneeHeader extends StatelessWidget {
  const KneeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        border: const Border(bottom: BorderSide(color: Color(0x14000000))),
      ),
      child: const Text(
        'Rehab Sanctuary',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class SessionTitle extends StatelessWidget {
  const SessionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 16,
      spacing: 16,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ACTIVE SESSION',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Knee Mobility',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: AppColors.text,
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: const [
            StatPill(label: 'Elapsed', value: '14:22'),
            StatPill(
              label: 'Status',
              value: 'Optimal',
              accent: AppColors.secondary,
              borderAccent: true,
            ),
          ],
        ),
      ],
    );
  }
}

class AngleCard extends StatelessWidget {
  const AngleCard({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 240.0 : 280.0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryGlow,
            blurRadius: 48,
            offset: Offset(0, 24),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: const ArcPainter(
                progress: 0.75,
                backgroundColor: AppColors.surfaceHighest,
                progressColor: AppColors.primary,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '85°',
                      style: TextStyle(
                        fontSize: compact ? 60 : 82,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'FLEXION',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.8,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                MetricColumn(label: 'Target', value: '90°'),
                VerticalDividerBlock(),
                MetricColumn(label: 'Max Today', value: '102°'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RepCountCard extends StatelessWidget {
  const RepCountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Opacity(
              opacity: 0.18,
              child: Transform.scale(
                scale: 1.25,
                child: const Icon(
                  Icons.accessibility_new,
                  size: 72,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'REPETITION COUNT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: const Color(0xFFB4C5FF).withValues(alpha: 0.95),
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '12',
                    style: TextStyle(
                      fontSize: 74,
                      height: 0.95,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      '/ 20',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0x99FFFFFF),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: const LinearProgressIndicator(
                  value: 0.6,
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SessionProgressCard extends StatelessWidget {
  const SessionProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'SESSION PROGRESS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              Text(
                '72%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(child: ProgressBlock(color: AppColors.secondary)),
              SizedBox(width: 8),
              Expanded(child: ProgressBlock(color: AppColors.secondary)),
              SizedBox(width: 8),
              Expanded(child: ProgressBlock(color: AppColors.secondary)),
              SizedBox(width: 8),
              Expanded(child: ProgressBlock(color: AppColors.secondaryContainer)),
              SizedBox(width: 8),
              Expanded(child: ProgressBlock(color: AppColors.surfaceHighest)),
            ],
          ),
        ],
      ),
    );
  }
}

class MotionChartCard extends StatelessWidget {
  const MotionChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    const bars = [
      0.40, 0.45, 0.60, 0.85, 0.95, 0.80, 0.55, 0.30, 0.25, 0.45,
      0.70, 0.90, 0.75, 0.50, 0.40, 0.65, 0.88, 0.95, 0.70, 0.40,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryGlow,
            blurRadius: 48,
            offset: Offset(0, 24),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Motion Flow',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Last 10 seconds of activity',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ),
              LegendDot(),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 192,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: bars
                  .map(
                    (value) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 192 * value,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(
                                alpha: value > 0.75 ? 1 : 0.2,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class CoachTipCard extends StatelessWidget {
  const CoachTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Wrap(
        spacing: 18,
        runSpacing: 18,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.info_outline,
              size: 30,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coach Tip',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMuted,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Maintain a steady pace during flexion. Avoid jerky movements to ensure accurate tracking and joint safety.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class KneeBottomNav extends StatelessWidget {
  const KneeBottomNav({
    super.key,
    required this.currentTab,
    required this.onSelect,
  });

  final AppTab currentTab;
  final ValueChanged<AppTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 24,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomNavItem(
              icon: Icons.accessibility_new,
              label: 'Knee',
              active: currentTab == AppTab.knee,
              onTap: () => onSelect(AppTab.knee),
            ),
            BottomNavItem(
              icon: Icons.fitness_center,
              label: 'Elbow',
              active: currentTab == AppTab.elbow,
              onTap: () => onSelect(AppTab.elbow),
            ),
            BottomNavItem(
              icon: Icons.settings,
              label: 'Config',
              active: currentTab == AppTab.config,
              onTap: () => onSelect(AppTab.config),
            ),
          ],
        ),
      ),
    );
  }
}

class StatPill extends StatelessWidget {
  const StatPill({
    super.key,
    required this.label,
    required this.value,
    this.accent,
    this.borderAccent = false,
  });

  final String label;
  final String value;
  final Color? accent;
  final bool borderAccent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(18),
        border: borderAccent
            ? const Border(
                left: BorderSide(color: AppColors.secondary, width: 4),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              color: AppColors.outline,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: accent ?? AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class MetricColumn extends StatelessWidget {
  const MetricColumn({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            color: AppColors.outline,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}

class VerticalDividerBlock extends StatelessWidget {
  const VerticalDividerBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 28),
      color: AppColors.surfaceLow,
    );
  }
}

class ProgressBlock extends StatelessWidget {
  const ProgressBlock({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class LegendDot extends StatelessWidget {
  const LegendDot({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: SizedBox(width: 12, height: 12),
        ),
        SizedBox(width: 8),
        Text(
          'ANGLE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.8,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background = active ? AppColors.primarySoft : Colors.transparent;
    final color = active ? AppColors.primary : const Color(0xFF8C92A1);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 6),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopTabLabel extends StatelessWidget {
  const TopTabLabel({
    super.key,
    required this.label,
    required this.active,
  });

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        color: active ? AppColors.primary : const Color(0xFF8C92A1),
      ),
    );
  }
}
