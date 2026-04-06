import 'package:flutter/material.dart';
import 'package:rehab/src/models/app_tab.dart';
import 'package:rehab/src/theme/app_colors.dart';
import 'package:rehab/src/widgets/knee_widgets.dart';

class SettingsTopBar extends StatelessWidget {
  const SettingsTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        border: const Border(bottom: BorderSide(color: Color(0x14000000))),
      ),
      child: const Row(
        children: [
          Icon(Icons.menu, color: AppColors.primary),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Rehab Sanctuary',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
          ),
          Icon(Icons.bluetooth_connected, color: AppColors.primary),
        ],
      ),
    );
  }
}

class SettingsProfileCard extends StatelessWidget {
  const SettingsProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ProfileAvatar(),
          SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr. Elena Vance',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Goal: Full ACL Mobility Restoration',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                ),
                SizedBox(height: 12),
                _StatusChip(label: 'Active Patient'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsIntro extends StatelessWidget {
  const SettingsIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Config',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Manage your rehabilitation biomechanic sensors and connectivity preferences.',
          style: TextStyle(
            fontSize: 15,
            height: 1.45,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class ConnectedDevicesSection extends StatelessWidget {
  const ConnectedDevicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Connected Devices',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.sync, size: 18),
              label: const Text(
                'Refresh',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const ActiveDeviceCard(),
        const SizedBox(height: 16),
        const AvailableDeviceCard(),
      ],
    );
  }
}

class ActiveDeviceCard extends StatelessWidget {
  const ActiveDeviceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x26C3C6D7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.accessibility_new,
                  size: 28,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Knee Kinematics v2',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        _StatusDot(color: AppColors.secondary),
                        SizedBox(width: 8),
                        Text(
                          'ACTIVE & SYNCING',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.8,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 640;
              if (isWide) {
                return const Row(
                  children: [
                    Expanded(child: DeviceMetricCard(
                      label: 'Battery',
                      value: '75%',
                      icon: Icons.battery_5_bar,
                      accent: AppColors.secondary,
                    )),
                    SizedBox(width: 12),
                    Expanded(child: DeviceMetricCard(
                      label: 'Signal',
                      value: 'Excellent',
                      icon: Icons.signal_cellular_alt,
                      accent: AppColors.secondary,
                    )),
                    SizedBox(width: 12),
                    Expanded(child: DeviceMetricCard(
                      label: 'Firmware',
                      value: 'v2.4.1',
                    )),
                    SizedBox(width: 12),
                    Expanded(child: DeviceMetricCard(
                      label: 'Serial',
                      value: 'RS-9920-KNE',
                      dense: true,
                    )),
                  ],
                );
              }

              return Column(
                children: const [
                  Row(
                    children: [
                      Expanded(
                        child: DeviceMetricCard(
                          label: 'Battery',
                          value: '75%',
                          icon: Icons.battery_5_bar,
                          accent: AppColors.secondary,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: DeviceMetricCard(
                          label: 'Signal',
                          value: 'Excellent',
                          icon: Icons.signal_cellular_alt,
                          accent: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DeviceMetricCard(
                          label: 'Firmware',
                          value: 'v2.4.1',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: DeviceMetricCard(
                          label: 'Serial',
                          value: 'RS-9920-KNE',
                          dense: true,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class AvailableDeviceCard extends StatelessWidget {
  const AvailableDeviceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC3C6D7)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.textMuted.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.fitness_center, color: AppColors.textMuted),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Elbow Sleeve 1.0',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMuted,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Last seen: 2 days ago',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0x99434655),
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.surfaceHighest,
              foregroundColor: AppColors.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Connect',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class ConnectivityPreferencesSection extends StatefulWidget {
  const ConnectivityPreferencesSection({super.key});

  @override
  State<ConnectivityPreferencesSection> createState() =>
      _ConnectivityPreferencesSectionState();
}

class _ConnectivityPreferencesSectionState
    extends State<ConnectivityPreferencesSection> {
  bool _realTimeSyncing = true;
  bool _autoConnect = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Connectivity Preferences',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 18),
        PreferenceTile(
          icon: Icons.bolt,
          title: 'Real-time syncing',
          subtitle: 'Stream joint data instantly during therapy',
          value: _realTimeSyncing,
          onChanged: (value) {
            setState(() {
              _realTimeSyncing = value;
            });
          },
        ),
        const SizedBox(height: 14),
        PreferenceTile(
          icon: Icons.autorenew,
          title: 'Auto-connect',
          subtitle: 'Pair automatically when in range',
          value: _autoConnect,
          onChanged: (value) {
            setState(() {
              _autoConnect = value;
            });
          },
        ),
      ],
    );
  }
}

class SettingsActionsSection extends StatelessWidget {
  const SettingsActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text(
              'Pair New Device',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textMuted,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Troubleshoot Connection',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsBottomNav extends StatelessWidget {
  const SettingsBottomNav({
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

class DeviceMetricCard extends StatelessWidget {
  const DeviceMetricCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.accent,
    this.dense = false,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? accent;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.8,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          if (icon != null)
            Row(
              children: [
                Icon(icon, size: 20, color: accent ?? AppColors.text),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: dense ? 14 : 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          else
            Text(
              value,
              style: TextStyle(
                fontSize: dense ? 14 : 20,
                fontWeight: FontWeight.w900,
                color: AppColors.text,
              ),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}

class PreferenceTile extends StatelessWidget {
  const PreferenceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFDCE4FF),
      ),
      child: const Icon(
        Icons.person,
        size: 40,
        color: AppColors.primary,
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.6,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
