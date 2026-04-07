import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rehab/src/firebase/firebase_bootstrap.dart';

class RehabFirestore {
  const RehabFirestore();

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get patientProfiles =>
      _db.collection('patient_profiles');

  CollectionReference<Map<String, dynamic>> get rehabSessions =>
      _db.collection('rehab_sessions');

  CollectionReference<Map<String, dynamic>> get deviceConfigs =>
      _db.collection('device_configs');

  Future<void> saveDemoDeviceConfig() async {
    if (!FirebaseBootstrap.isReady) {
      throw StateError('Firebase is not initialized.');
    }

    await deviceConfigs.doc('default').set({
      'updatedAt': FieldValue.serverTimestamp(),
      'realTimeSyncing': true,
      'autoConnect': true,
      'primaryDevice': 'Knee Kinematics v2',
      'availableDevice': 'Elbow Sleeve 1.0',
    }, SetOptions(merge: true));
  }
}
