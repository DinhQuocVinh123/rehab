import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// UUIDs của KNEESENSE3 (FFE0 service, FFE1 notify characteristic)
const _serviceUuid    = '0000ffe0-0000-1000-8000-00805f9b34fb';
const _notifyUuid     = '0000ffe1-0000-1000-8000-00805f9b34fb';
const _deviceName     = 'KNEESENSE3';

// Protocol constants
const _sof  = 0xAA;
const _type = 0x10;
const _eof  = 0x55;

// Header: SOF(1) + Type(1) + FrameCount(1) + Voltage(2) + Current(2) = 7 bytes
const _headerLen = 7;
const _bytesPerSensor = 4; // 2 bytes sensor + 2 bytes encoder

class DaqSensorData {
  const DaqSensorData({
    required this.frameCount,
    required this.encoderValues, // raw encoder ticks per sensor
  });

  final int frameCount;
  final List<int> encoderValues;

  /// Convert encoder[index] to degrees.
  /// [ticksPerDeg] needs calibration (e.g. move joint 90° and measure ticks).
  double angleDeg(int sensorIndex, {double ticksPerDeg = 100.0}) {
    if (sensorIndex >= encoderValues.length) return 0;
    return encoderValues[sensorIndex] / ticksPerDeg;
  }
}

class DaqBleService {
  BluetoothDevice? _device;
  BluetoothCharacteristic? _notifyChar;
  StreamSubscription? _notifySub;

  final _dataController = StreamController<DaqSensorData>.broadcast();
  Stream<DaqSensorData> get dataStream => _dataController.stream;

  bool get isConnected => _device?.isConnected ?? false;

  /// Scan and connect to KNEESENSE3.
  Future<void> connect() async {
    // Request permissions on Android
    if (await FlutterBluePlus.isSupported == false) {
      throw Exception('Bluetooth not supported on this device');
    }

    // Start scan looking for KNEESENSE3
    await FlutterBluePlus.startScan(
      withNames: [_deviceName],
      timeout: const Duration(seconds: 10),
    );

    final result = await FlutterBluePlus.scanResults
        .expand((r) => r)
        .firstWhere((r) => r.device.platformName == _deviceName)
        .timeout(const Duration(seconds: 10));

    await FlutterBluePlus.stopScan();

    _device = result.device;
    await _device!.connect(autoConnect: false);

    // Discover services
    final services = await _device!.discoverServices();
    final service = services.firstWhere(
      (s) => s.uuid.toString().toLowerCase() == _serviceUuid,
      orElse: () => throw Exception('FFE0 service not found'),
    );

    _notifyChar = service.characteristics.firstWhere(
      (c) => c.uuid.toString().toLowerCase() == _notifyUuid,
      orElse: () => throw Exception('FFE1 characteristic not found'),
    );

    await _notifyChar!.setNotifyValue(true);

    _notifySub = _notifyChar!.onValueReceived.listen(_onData);
  }

  Future<void> disconnect() async {
    await _notifySub?.cancel();
    await _device?.disconnect();
    _device = null;
    _notifyChar = null;
  }

  void _onData(List<int> bytes) {
    final data = _parsePacket(Uint8List.fromList(bytes));
    if (data != null) _dataController.add(data);
  }

  DaqSensorData? _parsePacket(Uint8List bytes) {
    // Minimum: header(7) + 1 sensor(4) + EOF(1) = 12 bytes
    if (bytes.length < 12) return null;
    if (bytes[0] != _sof || bytes[1] != _type) return null;
    if (bytes.last != _eof) return null;

    final frameCount = bytes[2];
    final dataBytes  = bytes.length - _headerLen - 1; // exclude header + EOF
    final sensorCount = dataBytes ~/ _bytesPerSensor;

    final encoders = <int>[];
    for (var i = 0; i < sensorCount; i++) {
      final offset = _headerLen + i * _bytesPerSensor;
      // Sensor data: bytes[offset], bytes[offset+1]  (2 bytes, ignored for now)
      // Encoder:     bytes[offset+2], bytes[offset+3] (little-endian uint16)
      final encoder = bytes[offset + 2] | (bytes[offset + 3] << 8);
      encoders.add(encoder);
    }

    return DaqSensorData(frameCount: frameCount, encoderValues: encoders);
  }

  void dispose() {
    disconnect();
    _dataController.close();
  }
}
