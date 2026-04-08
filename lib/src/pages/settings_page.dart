import 'package:flutter/material.dart';
import 'package:rehab/src/firebase/rehab_firestore.dart';
import 'package:rehab/src/models/app_tab.dart';
import 'package:rehab/src/theme/app_colors.dart';
import 'package:rehab/src/widgets/settings_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.currentTab,
    required this.onSelect,
  });

  final AppTab currentTab;
  final ValueChanged<AppTab> onSelect;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const _patientId = RehabFirestore.demoPatientId;

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SettingsProfileCard(patientId: _patientId),
                        SizedBox(height: 28),
                        SettingsIntro(),
                        SizedBox(height: 28),
                        ConnectedDevicesSection(patientId: _patientId),
                        SizedBox(height: 28),
                        ConnectivityPreferencesSection(patientId: _patientId),
                        SizedBox(height: 28),
                        SettingsActionsSection(patientId: _patientId),
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
        currentTab: widget.currentTab,
        onSelect: widget.onSelect,
      ),
    );
  }
}
