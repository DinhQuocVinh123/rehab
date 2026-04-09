import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rehab/src/firebase/firebase_bootstrap.dart';
import 'package:rehab/src/firebase/rehab_firestore.dart';
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

class SettingsProfileCard extends StatelessWidget {
  const SettingsProfileCard({
    super.key,
    required this.patientId,
  });

  final String patientId;

  @override
  Widget build(BuildContext context) {
    if (!FirebaseBootstrap.isReady) {
      return const _SectionCard(
        child: _ProfileCardBody(
          fullName: 'Offline Preview',
          goal: 'Connect Firebase to load patient profile',
          status: 'Preview Mode',
        ),
      );
    }

    return StreamBuilder<Map<String, dynamic>?>(
      stream: const RehabFirestore().watchPatientProfile(patientId),
      builder: (context, snapshot) {
        final data = snapshot.data ?? const <String, dynamic>{};
        return _SectionCard(
          child: _ProfileCardBody(
            fullName: data['fullName'] as String? ?? 'Loading patient...',
            goal: data['goal'] as String? ?? 'Preparing treatment profile',
            status: _capitalizeWords(data['status'] as String? ?? 'active'),
            subtitle:
                '${_capitalizeWords(data['injuryType'] as String? ?? 'Rehabilitation plan')} • ${_capitalizeWords(data['primaryJoint'] as String? ?? 'knee')}',
          ),
        );
      },
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
          'Manage patient identity, paired rehab sensors, and connectivity preferences backed by Firestore.',
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
  const ConnectedDevicesSection({
    super.key,
    required this.patientId,
  });

  final String patientId;

  @override
  Widget build(BuildContext context) {
    if (!FirebaseBootstrap.isReady) {
      return const _OfflineSectionPlaceholder(
        title: 'Connected Devices',
        subtitle: 'Connect Firebase to read paired rehab sensors.',
      );
    }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: const RehabFirestore().watchDevices(patientId),
      builder: (context, snapshot) {
        final devices = snapshot.data ?? const <Map<String, dynamic>>[];
        final activeDevice = devices.cast<Map<String, dynamic>?>().firstWhere(
              (device) => device != null && device['isPrimary'] == true,
              orElse: () => null,
            );
        final availableDevice = devices.cast<Map<String, dynamic>?>().firstWhere(
              (device) => device != null && device['isPrimary'] != true,
              orElse: () => null,
            );

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
                  onPressed: () => _runRefresh(context),
                  icon: const Icon(Icons.sync, size: 18),
                  label: const Text(
                    'Refresh',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            ActiveDeviceCard(device: activeDevice),
            const SizedBox(height: 16),
            AvailableDeviceCard(
              device: availableDevice,
              onConnect: () => _pairAvailable(context),
            ),
          ],
        );
      },
    );
  }

  Future<void> _runRefresh(BuildContext context) async {
    await const RehabFirestore().refreshDeviceTelemetry(patientId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Device telemetry refreshed')),
      );
    }
  }

  Future<void> _pairAvailable(BuildContext context) async {
    await const RehabFirestore().promoteAvailableDevice(patientId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Available device promoted to active')),
      );
    }
  }
}

class ActiveDeviceCard extends StatelessWidget {
  const ActiveDeviceCard({
    super.key,
    required this.device,
  });

  final Map<String, dynamic>? device;

  @override
  Widget build(BuildContext context) {
    if (device == null) {
      return const _SectionCard(
        child: Text(
          'No active device paired yet.',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textMuted,
          ),
        ),
      );
    }

    final battery = '${device!['batteryLevel'] ?? '--'}%';
    final signal = device!['signalStrength'] as String? ?? 'Unknown';
    final firmware = device!['firmwareVersion'] as String? ?? '--';
    final serial = device!['serialNumber'] as String? ?? '--';

    return _SectionCard(
      borderColor: const Color(0x26C3C6D7),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device!['name'] as String? ?? 'Unknown device',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const _StatusDot(color: AppColors.secondary),
                        const SizedBox(width: 8),
                        Text(
                          _deviceStatusLabel(device!['connectionStatus'] as String?),
                          style: const TextStyle(
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
                return Row(
                  children: [
                    Expanded(
                      child: DeviceMetricCard(
                        label: 'Battery',
                        value: battery,
                        icon: Icons.battery_5_bar,
                        accent: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DeviceMetricCard(
                        label: 'Signal',
                        value: signal,
                        icon: Icons.signal_cellular_alt,
                        accent: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DeviceMetricCard(
                        label: 'Firmware',
                        value: firmware,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DeviceMetricCard(
                        label: 'Serial',
                        value: serial,
                        dense: true,
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DeviceMetricCard(
                          label: 'Battery',
                          value: battery,
                          icon: Icons.battery_5_bar,
                          accent: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DeviceMetricCard(
                          label: 'Signal',
                          value: signal,
                          icon: Icons.signal_cellular_alt,
                          accent: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DeviceMetricCard(
                          label: 'Firmware',
                          value: firmware,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DeviceMetricCard(
                          label: 'Serial',
                          value: serial,
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
  const AvailableDeviceCard({
    super.key,
    required this.device,
    required this.onConnect,
  });

  final Map<String, dynamic>? device;
  final VoidCallback onConnect;

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device?['name'] as String? ?? 'No additional device available',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  device == null
                      ? 'Pair a new sensor to populate this slot'
                      : 'Last seen: ${_formatDateTime(device?['lastSeenAt'])}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0x99434655),
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: device == null ? null : onConnect,
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
  const ConnectivityPreferencesSection({
    super.key,
    required this.patientId,
  });

  final String patientId;

  @override
  State<ConnectivityPreferencesSection> createState() =>
      _ConnectivityPreferencesSectionState();
}

class _ConnectivityPreferencesSectionState
    extends State<ConnectivityPreferencesSection> {
  bool _isSavingRealtime = false;
  bool _isSavingAutoConnect = false;

  @override
  Widget build(BuildContext context) {
    if (!FirebaseBootstrap.isReady) {
      return const _OfflineSectionPlaceholder(
        title: 'Connectivity Preferences',
        subtitle: 'Connect Firebase to edit patient preferences.',
      );
    }

    return StreamBuilder<Map<String, dynamic>?>(
      stream: const RehabFirestore().watchPreferences(widget.patientId),
      builder: (context, snapshot) {
        final data = snapshot.data ?? const <String, dynamic>{};
        final realTimeSyncing = data['realTimeSyncing'] as bool? ?? true;
        final autoConnect = data['autoConnect'] as bool? ?? true;

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
              value: realTimeSyncing,
              isBusy: _isSavingRealtime,
              onChanged: (value) => _updateRealtime(value),
            ),
            const SizedBox(height: 14),
            PreferenceTile(
              icon: Icons.autorenew,
              title: 'Auto-connect',
              subtitle: 'Pair automatically when in range',
              value: autoConnect,
              isBusy: _isSavingAutoConnect,
              onChanged: (value) => _updateAutoConnect(value),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateRealtime(bool value) async {
    setState(() => _isSavingRealtime = true);
    try {
      await const RehabFirestore().updatePreferences(
        widget.patientId,
        realTimeSyncing: value,
      );
    } finally {
      if (mounted) {
        setState(() => _isSavingRealtime = false);
      }
    }
  }

  Future<void> _updateAutoConnect(bool value) async {
    setState(() => _isSavingAutoConnect = true);
    try {
      await const RehabFirestore().updatePreferences(
        widget.patientId,
        autoConnect: value,
      );
    } finally {
      if (mounted) {
        setState(() => _isSavingAutoConnect = false);
      }
    }
  }
}

class SettingsActionsSection extends StatelessWidget {
  const SettingsActionsSection({
    super.key,
    required this.patientId,
  });

  final String patientId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: FirebaseBootstrap.isReady
                ? () async {
                    await const RehabFirestore().promoteAvailableDevice(patientId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Paired next available device'),
                        ),
                      );
                    }
                  }
                : null,
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
            onPressed: FirebaseBootstrap.isReady
                ? () async {
                    await const RehabFirestore().refreshDeviceTelemetry(patientId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Connection diagnostics completed'),
                        ),
                      );
                    }
                  }
                : null,
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
    this.isBusy = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isBusy;

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
          if (isBusy)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    this.borderColor,
  });

  final Widget child;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(20),
        border: borderColor == null ? null : Border.all(color: borderColor!),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ProfileCardBody extends StatelessWidget {
  const _ProfileCardBody({
    required this.fullName,
    required this.goal,
    required this.status,
    this.subtitle,
  });

  final String fullName;
  final String goal;
  final String status;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ProfileAvatar(initials: _initialsFromName(fullName)),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Goal: $goal',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.outline,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              _StatusChip(label: status),
            ],
          ),
        ),
      ],
    );
  }
}

class _OfflineSectionPlaceholder extends StatelessWidget {
  const _OfflineSectionPlaceholder({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
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
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFDCE4FF),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          color: AppColors.primary,
        ),
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

String _capitalizeWords(String value) {
  return value
      .split(RegExp(r'[_\s]+'))
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

String _initialsFromName(String name) {
  final parts = name
      .split(' ')
      .where((part) => part.trim().isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty) {
    return 'RS';
  }
  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

String _deviceStatusLabel(String? rawStatus) {
  return _capitalizeWords(rawStatus ?? 'active');
}

String _formatDateTime(dynamic value) {
  DateTime? dateTime;
  if (value is Timestamp) {
    dateTime = value.toDate();
  } else if (value is DateTime) {
    dateTime = value;
  }

  if (dateTime == null) {
    return 'just now';
  }

  final difference = DateTime.now().difference(dateTime);
  if (difference.inMinutes < 1) {
    return 'just now';
  }
  if (difference.inHours < 1) {
    return '${difference.inMinutes} min ago';
  }
  if (difference.inDays < 1) {
    return '${difference.inHours} hr ago';
  }
  return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
}
