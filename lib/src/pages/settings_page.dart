import 'package:flutter/material.dart';
import 'package:rehab/src/models/app_tab.dart';
import 'package:rehab/src/theme/app_colors.dart';
import 'package:rehab/src/widgets/settings_widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
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
            const SettingsTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SettingsProfileCard(),
                        SizedBox(height: 28),
                        SettingsIntro(),
                        SizedBox(height: 28),
                        FirebaseSetupCard(),
                        SizedBox(height: 28),
                        ConnectedDevicesSection(),
                        SizedBox(height: 28),
                        ConnectivityPreferencesSection(),
                        SizedBox(height: 28),
                        SettingsActionsSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SettingsBottomNav(
        currentTab: currentTab,
        onSelect: onSelect,
      ),
    );
  }
}
