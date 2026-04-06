import 'package:flutter/material.dart';
import 'package:rehab/src/models/app_tab.dart';
import 'package:rehab/src/theme/app_colors.dart';
import 'package:rehab/src/widgets/elbow_widgets.dart';

class ElbowPage extends StatelessWidget {
  const ElbowPage({
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
            const ElbowTopBar(),
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
                            const ElbowSessionTitle(),
                            const SizedBox(height: 24),
                            if (isWide)
                              const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Column(
                                      children: [
                                        ElbowHeroCard(),
                                        SizedBox(height: 24),
                                        ElbowMotionCard(),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 24),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      children: [
                                        ElbowRepetitionCard(),
                                        SizedBox(height: 24),
                                        ElbowDailyGoalCard(),
                                        SizedBox(height: 24),
                                        ElbowTherapyTipCard(),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            else
                              const Column(
                                children: [
                                  ElbowHeroCard(),
                                  SizedBox(height: 24),
                                  ElbowMotionCard(),
                                  SizedBox(height: 24),
                                  ElbowRepetitionCard(),
                                  SizedBox(height: 24),
                                  ElbowDailyGoalCard(),
                                  SizedBox(height: 24),
                                  ElbowTherapyTipCard(),
                                ],
                              ),
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
      bottomNavigationBar: ElbowBottomNav(
        currentTab: currentTab,
        onSelect: onSelect,
      ),
    );
  }
}
