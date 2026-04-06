import 'package:flutter/material.dart';
import 'package:rehab/src/models/app_tab.dart';
import 'package:rehab/src/theme/app_colors.dart';
import 'package:rehab/src/widgets/knee_widgets.dart';

class KneePage extends StatelessWidget {
  const KneePage({
    super.key,
    required this.currentTab,
    required this.onSelect,
  });

  final AppTab currentTab;
  final ValueChanged<AppTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const KneeHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 950;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SessionTitle(),
                            const SizedBox(height: 24),
                            if (isWide)
                              const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 7, child: AngleCard()),
                                  SizedBox(width: 24),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      children: [
                                        RepCountCard(),
                                        SizedBox(height: 24),
                                        SessionProgressCard(),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            else
                              const Column(
                                children: [
                                  AngleCard(compact: true),
                                  SizedBox(height: 24),
                                  RepCountCard(),
                                  SizedBox(height: 24),
                                  SessionProgressCard(),
                                ],
                              ),
                            const SizedBox(height: 24),
                            const MotionChartCard(),
                            const SizedBox(height: 24),
                            const CoachTipCard(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: KneeBottomNav(
        currentTab: currentTab,
        onSelect: onSelect,
      ),
    );
  }
}
