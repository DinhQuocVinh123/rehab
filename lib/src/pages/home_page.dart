import 'package:flutter/material.dart';
import 'package:rehab/src/firebase/firebase_bootstrap.dart';
import 'package:rehab/src/firebase/rehab_firestore.dart';
import 'package:rehab/src/models/app_tab.dart';
import 'package:rehab/src/pages/elbow_page.dart';
import 'package:rehab/src/pages/knee_page.dart';
import 'package:rehab/src/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _patientId = RehabFirestore.demoPatientId;

  AppTab _currentTab = AppTab.knee;

  @override
  void initState() {
    super.initState();
    if (FirebaseBootstrap.isReady) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        const RehabFirestore().ensurePatientSetup(_patientId);
      });
    }
  }

  void _selectTab(AppTab tab) {
    if (_currentTab == tab) {
      return;
    }
    setState(() {
      _currentTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return switch (_currentTab) {
      AppTab.knee => KneePage(
          currentTab: _currentTab,
          onSelect: _selectTab,
        ),
      AppTab.elbow => ElbowPage(
          currentTab: _currentTab,
          onSelect: _selectTab,
        ),
      AppTab.config => SettingsPage(
          currentTab: _currentTab,
          onSelect: _selectTab,
        ),
    };
  }
}
