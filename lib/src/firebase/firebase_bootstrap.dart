import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:rehab/firebase_options.dart';

enum FirebaseBootstrapStatus {
  initialized,
  notConfigured,
  unsupportedPlatform,
}

class FirebaseBootstrap {
  static FirebaseBootstrapStatus _status =
      FirebaseBootstrapStatus.notConfigured;
  static Object? _error;

  static FirebaseBootstrapStatus get status => _status;
  static Object? get error => _error;
  static bool get isReady => _status == FirebaseBootstrapStatus.initialized;

  static Future<void> initialize() async {
    if (!_supportsFirebaseOnCurrentPlatform()) {
      _status = FirebaseBootstrapStatus.unsupportedPlatform;
      return;
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _status = FirebaseBootstrapStatus.initialized;
      _error = null;
    } catch (error) {
      _status = FirebaseBootstrapStatus.notConfigured;
      _error = error;
    }
  }

  static bool _supportsFirebaseOnCurrentPlatform() {
    if (kIsWeb) {
      return true;
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.android => true,
      TargetPlatform.iOS => true,
      TargetPlatform.macOS => true,
      _ => false,
    };
  }
}
