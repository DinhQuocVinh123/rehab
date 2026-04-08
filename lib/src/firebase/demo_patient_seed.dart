abstract final class DemoPatientSeed {
  static const patientId = 'demo_patient_001';

  static const profile = <String, dynamic>{
    'fullName': 'Dr. Elena Vance',
    'goal': 'Full ACL Mobility Restoration',
    'status': 'active',
    'primaryJoint': 'knee',
    'injuryType': 'ACL reconstruction rehab',
    'assignedClinicianId': 'clinician_demo_001',
  };

  static const preferences = <String, dynamic>{
    'realTimeSyncing': true,
    'autoConnect': true,
    'preferredJoint': 'knee',
    'notificationsEnabled': true,
    'units': 'deg',
    'themeMode': 'light',
  };

  static const devices = <String, Map<String, dynamic>>{
    'knee_kinematics_v2': {
      'name': 'Knee Kinematics v2',
      'type': 'knee_sensor',
      'serialNumber': 'RS-9920-KNE',
      'firmwareVersion': 'v2.4.1',
      'batteryLevel': 75,
      'signalStrength': 'Excellent',
      'connectionStatus': 'active',
      'isPrimary': true,
    },
    'elbow_sleeve_1': {
      'name': 'Elbow Sleeve 1.0',
      'type': 'elbow_sensor',
      'serialNumber': 'RS-2210-ELB',
      'firmwareVersion': 'v1.3.0',
      'batteryLevel': 61,
      'signalStrength': 'Good',
      'connectionStatus': 'available',
      'isPrimary': false,
    },
  };

  static const backupDevice = <String, dynamic>{
    'name': 'Backup Mobility Sensor',
    'type': 'generic_sensor',
    'serialNumber': 'RS-NEW-100',
    'firmwareVersion': 'v1.0.0',
    'batteryLevel': 100,
    'signalStrength': 'Excellent',
    'connectionStatus': 'available',
    'isPrimary': false,
  };
}
