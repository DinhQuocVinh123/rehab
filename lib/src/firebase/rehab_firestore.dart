import 'package:rehab/src/firebase/assigned_exercise_schema.dart';
import 'package:rehab/src/firebase/assigned_exercise_seed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rehab/src/firebase/demo_patient_seed.dart';
import 'package:rehab/src/firebase/elbow_firestore_schema.dart';
import 'package:rehab/src/firebase/elbow_rehab_seed.dart';
import 'package:rehab/src/firebase/firebase_bootstrap.dart';
import 'package:rehab/src/firebase/knee_firestore_schema.dart';
import 'package:rehab/src/firebase/knee_rehab_seed.dart';

class RehabFirestore {
  const RehabFirestore();

  static const demoPatientId = DemoPatientSeed.patientId;

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get patients =>
      _db.collection('patients');

  CollectionReference<Map<String, dynamic>> get kneeExercises =>
      _db.collection(KneeFirestoreSchema.kneeExercisesCollection);

  CollectionReference<Map<String, dynamic>> get elbowExercises =>
      _db.collection(ElbowFirestoreSchema.elbowExercisesCollection);

  DocumentReference<Map<String, dynamic>> patientDoc(String patientId) =>
      patients.doc(patientId);

  DocumentReference<Map<String, dynamic>> preferencesDoc(String patientId) =>
      patientDoc(patientId).collection('preferences').doc('config');

  CollectionReference<Map<String, dynamic>> devicesCollection(String patientId) =>
      patientDoc(patientId).collection('devices');

  CollectionReference<Map<String, dynamic>> sessionsCollection(String patientId) =>
      patientDoc(patientId).collection('sessions');

  CollectionReference<Map<String, dynamic>> assignedExercisesCollection(
    String patientId,
  ) => patientDoc(patientId).collection(AssignedExerciseSchema.assignedExercisesCollection);

  CollectionReference<Map<String, dynamic>> kneeSessionsCollection(String patientId) =>
      patientDoc(patientId).collection(KneeFirestoreSchema.kneeSessionsCollection);

  DocumentReference<Map<String, dynamic>> kneeProgressSummaryDoc(String patientId) =>
      patientDoc(patientId)
          .collection(KneeFirestoreSchema.kneeProgressCollection)
          .doc(KneeFirestoreSchema.kneeProgressSummaryDoc);

  CollectionReference<Map<String, dynamic>> elbowSessionsCollection(String patientId) =>
      patientDoc(patientId).collection(ElbowFirestoreSchema.elbowSessionsCollection);

  DocumentReference<Map<String, dynamic>> elbowProgressSummaryDoc(String patientId) =>
      patientDoc(patientId)
          .collection(ElbowFirestoreSchema.elbowProgressCollection)
          .doc(ElbowFirestoreSchema.elbowProgressSummaryDoc);

  Stream<Map<String, dynamic>?> watchPatientProfile(String patientId) {
    return patientDoc(patientId).snapshots().map((snapshot) => snapshot.data());
  }

  Stream<Map<String, dynamic>?> watchPreferences(String patientId) {
    return preferencesDoc(patientId).snapshots().map((snapshot) => snapshot.data());
  }

  Stream<List<Map<String, dynamic>>> watchDevices(String patientId) {
    return devicesCollection(patientId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => {
                  'id': doc.id,
                  ...doc.data(),
                },
              )
              .toList()
            ..sort(_sortDevices),
        );
  }

  Stream<List<Map<String, dynamic>>> watchKneeExercises() {
    return kneeExercises
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList()
            ..sort(_sortByTitle),
        );
  }

  Stream<List<Map<String, dynamic>>> watchElbowExercises() {
    return elbowExercises
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList()
            ..sort(_sortByTitle),
        );
  }

  Stream<List<Map<String, dynamic>>> watchAssignedExercises(
    String patientId, {
    String? joint,
  }) {
    final stream = assignedExercisesCollection(patientId).snapshots();
    return stream.map((snapshot) {
      final assignments = snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .where(
            (assignment) =>
                joint == null || assignment['joint'] == joint,
          )
          .toList()
        ..sort(_sortAssignments);
      return assignments;
    });
  }

  Stream<Map<String, dynamic>?> watchKneeProgressSummary(String patientId) {
    return kneeProgressSummaryDoc(patientId)
        .snapshots()
        .map((snapshot) => snapshot.data());
  }

  Stream<Map<String, dynamic>?> watchElbowProgressSummary(String patientId) {
    return elbowProgressSummaryDoc(patientId)
        .snapshots()
        .map((snapshot) => snapshot.data());
  }

  Stream<Map<String, dynamic>?> watchLatestKneeSession(String patientId) {
    return kneeSessionsCollection(patientId)
        .doc('latest')
        .snapshots()
        .map((snapshot) => snapshot.data());
  }

  Stream<Map<String, dynamic>?> watchLatestElbowSession(String patientId) {
    return elbowSessionsCollection(patientId)
        .doc('latest')
        .snapshots()
        .map((snapshot) => snapshot.data());
  }

  Future<void> ensurePatientSetup(String patientId) async {
    _ensureReady();

    final batch = _db.batch();

    batch.set(
      patientDoc(patientId),
      _withTimestamps(DemoPatientSeed.profile, includeCreatedAt: true),
      SetOptions(merge: true),
    );

    batch.set(
      preferencesDoc(patientId),
      _withTimestamps(DemoPatientSeed.preferences),
      SetOptions(merge: true),
    );

    for (final entry in DemoPatientSeed.devices.entries) {
      batch.set(
        devicesCollection(patientId).doc(entry.key),
        _withDeviceTimestamps(entry.value),
        SetOptions(merge: true),
      );
    }

    for (final entry in KneeRehabSeed.exercises.entries) {
      batch.set(
        kneeExercises.doc(entry.key),
        _withTimestamps(entry.value, includeCreatedAt: true),
        SetOptions(merge: true),
      );
    }

    batch.set(
      kneeProgressSummaryDoc(patientId),
      _withTimestamps(KneeRehabSeed.kneeProgressSummary, includeCreatedAt: true),
      SetOptions(merge: true),
    );

    batch.set(
      kneeSessionsCollection(patientId).doc('latest'),
      _withSessionTimestamps(KneeRehabSeed.latestKneeSession),
      SetOptions(merge: true),
    );

    for (final entry in ElbowRehabSeed.exercises.entries) {
      batch.set(
        elbowExercises.doc(entry.key),
        _withTimestamps(entry.value, includeCreatedAt: true),
        SetOptions(merge: true),
      );
    }

    batch.set(
      elbowProgressSummaryDoc(patientId),
      _withTimestamps(ElbowRehabSeed.elbowProgressSummary, includeCreatedAt: true),
      SetOptions(merge: true),
    );

    batch.set(
      elbowSessionsCollection(patientId).doc('latest'),
      _withSessionTimestamps(ElbowRehabSeed.latestElbowSession),
      SetOptions(merge: true),
    );

    for (final entry in AssignedExerciseSeed.assignments.entries) {
      batch.set(
        assignedExercisesCollection(patientId).doc(entry.key),
        _withAssignmentTimestamps(entry.value, includeCreatedAt: true),
        SetOptions(merge: true),
      );
    }

    await batch.commit();
    await _cleanupLegacyPatientExerciseCollections(patientId);
  }

  Future<void> updatePreferences(
    String patientId, {
    bool? realTimeSyncing,
    bool? autoConnect,
    String? preferredJoint,
  }) async {
    _ensureReady();

    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (realTimeSyncing != null) {
      updates['realTimeSyncing'] = realTimeSyncing;
    }
    if (autoConnect != null) {
      updates['autoConnect'] = autoConnect;
    }
    if (preferredJoint != null) {
      updates['preferredJoint'] = preferredJoint;
    }

    await preferencesDoc(patientId).set(updates, SetOptions(merge: true));
  }

  Future<void> promoteAvailableDevice(String patientId) async {
    _ensureReady();

    final snapshot = await devicesCollection(patientId).get();
    if (snapshot.docs.isEmpty) {
      await ensurePatientSetup(patientId);
      return;
    }

    final activeDoc = snapshot.docs.cast<QueryDocumentSnapshot<Map<String, dynamic>>?>().firstWhere(
          (doc) => doc != null && (doc.data()['isPrimary'] == true),
          orElse: () => null,
        );

    final availableDoc = snapshot.docs.cast<QueryDocumentSnapshot<Map<String, dynamic>>?>().firstWhere(
          (doc) => doc != null && (doc.data()['isPrimary'] != true),
          orElse: () => null,
        );

    if (availableDoc == null) {
      await devicesCollection(patientId).doc('sensor_backup').set(
            _withDeviceTimestamps(DemoPatientSeed.backupDevice),
            SetOptions(merge: true),
          );
      return;
    }

    final batch = _db.batch();

    if (activeDoc != null) {
      batch.set(activeDoc.reference, {
        'isPrimary': false,
        'connectionStatus': 'available',
        'lastSeenAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    batch.set(availableDoc.reference, {
      'isPrimary': true,
      'connectionStatus': 'active',
      'lastSeenAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await batch.commit();
  }

  Map<String, dynamic> _withTimestamps(
    Map<String, dynamic> source, {
    bool includeCreatedAt = false,
  }) {
    return {
      ...source,
      if (includeCreatedAt) 'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> _withDeviceTimestamps(Map<String, dynamic> source) {
    return {
      ...source,
      'lastSeenAt': FieldValue.serverTimestamp(),
      'pairedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> _withSessionTimestamps(Map<String, dynamic> source) {
    return {
      ...source,
      'startedAt': FieldValue.serverTimestamp(),
      'endedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> _withAssignmentTimestamps(
    Map<String, dynamic> source, {
    bool includeCreatedAt = false,
  }) {
    return {
      ...source,
      if (includeCreatedAt) 'assignedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Future<void> refreshDeviceTelemetry(String patientId) async {
    _ensureReady();

    final snapshot = await devicesCollection(patientId).get();
    final batch = _db.batch();

    for (final doc in snapshot.docs) {
      final isPrimary = doc.data()['isPrimary'] == true;
      batch.set(doc.reference, {
        'batteryLevel': isPrimary ? 74 : 60,
        'signalStrength': isPrimary ? 'Excellent' : 'Good',
        'connectionStatus': isPrimary ? 'active' : 'available',
        'lastSeenAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    await batch.commit();
  }

  Future<void> saveDemoDeviceConfig() async {
    await ensurePatientSetup(demoPatientId);
  }

  Future<void> _cleanupLegacyPatientExerciseCollections(String patientId) async {
    await _deleteCollection(
      patientDoc(patientId).collection(KneeFirestoreSchema.kneeExercisesCollection),
    );
    await _deleteCollection(
      patientDoc(patientId).collection(ElbowFirestoreSchema.elbowExercisesCollection),
    );
  }

  Future<void> _deleteCollection(
    CollectionReference<Map<String, dynamic>> collection,
  ) async {
    final snapshot = await collection.get();
    if (snapshot.docs.isEmpty) {
      return;
    }

    final batch = _db.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  void _ensureReady() {
    if (!FirebaseBootstrap.isReady) {
      throw StateError('Firebase is not initialized.');
    }
  }

  static int _sortDevices(
    Map<String, dynamic> a,
    Map<String, dynamic> b,
  ) {
    final aPrimary = a['isPrimary'] == true ? 1 : 0;
    final bPrimary = b['isPrimary'] == true ? 1 : 0;
    if (aPrimary != bPrimary) {
      return bPrimary.compareTo(aPrimary);
    }

    final aName = (a['name'] as String? ?? '').toLowerCase();
    final bName = (b['name'] as String? ?? '').toLowerCase();
    return aName.compareTo(bName);
  }

  static int _sortByTitle(
    Map<String, dynamic> a,
    Map<String, dynamic> b,
  ) {
    final aTitle = (a['title'] as String? ?? '').toLowerCase();
    final bTitle = (b['title'] as String? ?? '').toLowerCase();
    return aTitle.compareTo(bTitle);
  }

  static int _sortAssignments(
    Map<String, dynamic> a,
    Map<String, dynamic> b,
  ) {
    final statusOrder = {
      'active': 0,
      'assigned': 1,
      'paused': 2,
      'completed': 3,
    };
    final aStatus = statusOrder[a['status']] ?? 99;
    final bStatus = statusOrder[b['status']] ?? 99;
    if (aStatus != bStatus) {
      return aStatus.compareTo(bStatus);
    }

    final aId = (a['exerciseId'] as String? ?? '').toLowerCase();
    final bId = (b['exerciseId'] as String? ?? '').toLowerCase();
    return aId.compareTo(bId);
  }
}
