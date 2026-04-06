import 'package:flutter/material.dart';
import 'package:rehab/src/models/app_tab.dart';
import 'package:rehab/src/painters/arc_painter.dart';
import 'package:rehab/src/theme/app_colors.dart';
import 'package:rehab/src/widgets/knee_widgets.dart';

class ElbowTopBar extends StatelessWidget {
  const ElbowTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 768;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        border: const Border(bottom: BorderSide(color: Color(0x14000000))),
      ),
      child: Row(
        children: [
          const Icon(Icons.menu, color: AppColors.primary),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Rehab Sanctuary',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
          ),
          if (isWide) ...const [
            TopTabLabel(label: 'Knee', active: false),
            SizedBox(width: 18),
            TopTabLabel(label: 'Elbow', active: true),
            SizedBox(width: 18),
            TopTabLabel(label: 'Config', active: false),
            SizedBox(width: 18),
          ],
          const Icon(Icons.bluetooth_connected, color: AppColors.primary),
        ],
      ),
    );
  }
}

class ElbowSessionTitle extends StatelessWidget {
  const ElbowSessionTitle({super.key});

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
              'LIVE TRACKING',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Elbow Joint',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: AppColors.text,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.secondaryContainer.withValues(alpha: 0.3),
            border: Border.all(color: AppColors.secondaryContainer),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PulsingDot(),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STATUS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.8,
                      color: AppColors.textMuted,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'ElbowTracker-E2 Connected',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ElbowHeroCard extends StatelessWidget {
  const ElbowHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Positioned(
                top: -40,
                right: -30,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondary.withValues(alpha: 0.05),
                  ),
                ),
              ),
              SizedBox(
                width: 288,
                height: 288,
                child: CustomPaint(
                  painter: const ArcPainter(
                    progress: 0.24,
                    backgroundColor: AppColors.surfaceLow,
                    progressColor: AppColors.secondary,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Current Angle',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '42',
                              style: TextStyle(
                                fontSize: 88,
                                height: 0.95,
                                fontWeight: FontWeight.w900,
                                color: AppColors.text,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                '°',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'EXTENSION',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.6,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              Expanded(
                child: _InfoBox(
                  label: 'Max Flexion',
                  value: '145°',
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: _InfoBox(
                  label: 'Target Range',
                  value: '30°-120°',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ElbowMotionCard extends StatelessWidget {
  const ElbowMotionCard({super.key});

  @override
  Widget build(BuildContext context) {
    const bars = [
      0.25, 0.33, 0.50, 0.66, 0.75, 0.85, 0.95, 1.0, 0.80, 0.60,
      0.50, 0.33, 0.25, 0.20, 0.16,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Expanded(
                child: Text(
                  'Real-time Motion',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                  ),
                ),
              ),
              _MiniLegend(
                label: 'Flexion',
                color: AppColors.secondary,
              ),
              SizedBox(width: 12),
              _MiniLegend(
                label: 'Limit',
                color: Color(0xFFD5D9DF),
              ),
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
                        child: Container(
                          height: 192 * value,
                          decoration: BoxDecoration(
                            color: value >= 0.66
                                ? AppColors.secondary.withValues(
                                    alpha: value.clamp(0.2, 1.0),
                                  )
                                : AppColors.surfaceLow,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '-10s',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8,
                  color: Color(0xFF8C92A1),
                ),
              ),
              Text(
                'Now',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8,
                  color: Color(0xFF8C92A1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ElbowRepetitionCard extends StatelessWidget {
  const ElbowRepetitionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 224,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -10,
            bottom: -22,
            child: Icon(
              Icons.accessibility_new,
              size: 110,
              color: Color(0xFFF4F6FA),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Expanded(
                    child: Text(
                      'Repetitions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  Icon(Icons.edit_note, color: AppColors.secondary),
                ],
              ),
              const Spacer(),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '12',
                    style: TextStyle(
                      fontSize: 68,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text,
                    ),
                  ),
                  SizedBox(width: 10),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      '/ 20',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF9BA1B0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: const LinearProgressIndicator(
                  value: 0.6,
                  minHeight: 10,
                  backgroundColor: AppColors.surfaceLow,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ElbowDailyGoalCard extends StatelessWidget {
  const ElbowDailyGoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emoji_events, color: Color(0xFF943700)),
              SizedBox(width: 10),
              Text(
                'Daily Goal',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Completion',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              Text(
                '85%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: ProgressBlock(color: AppColors.secondary)),
              SizedBox(width: 6),
              Expanded(child: ProgressBlock(color: AppColors.secondary)),
              SizedBox(width: 6),
              Expanded(child: ProgressBlock(color: AppColors.secondary)),
              SizedBox(width: 6),
              Expanded(child: ProgressBlock(color: AppColors.secondary)),
              SizedBox(width: 6),
              Expanded(child: ProgressBlock(color: AppColors.secondary)),
              SizedBox(width: 6),
              Expanded(
                child: ProgressBlock(
                  color: Color(0x3386F2E4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            "You're 3 reps away from hitting your target extension today. Keep going!",
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppColors.outline,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {},
              child: const Text(
                'View Detailed Insights',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ElbowTherapyTipCard extends StatelessWidget {
  const ElbowTherapyTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TherapyIconBox(),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Therapy Tip',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Ensure your shoulder remains neutral while performing extensions to isolate the elbow joint correctly.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: AppColors.textMuted,
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

class ElbowBottomNav extends StatelessWidget {
  const ElbowBottomNav({
    super.key,
    required this.currentTab,
    required this.onSelect,
  });

  final AppTab currentTab;
  final ValueChanged<AppTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return KneeBottomNav(
      currentTab: currentTab,
      onSelect: onSelect,
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Color(0xFF7B8190),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniLegend extends StatelessWidget {
  const _MiniLegend({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color == AppColors.secondary
                ? AppColors.secondary
                : const Color(0xFFB9BFCA),
          ),
        ),
      ],
    );
  }
}

class _TherapyIconBox extends StatelessWidget {
  const _TherapyIconBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.lightbulb_outline,
        color: AppColors.primary,
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 14,
      height: 14,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: 0.6 + (t * 1.2),
                child: Opacity(
                  opacity: (1 - t) * 0.5,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
