import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:webview_flutter/webview_flutter.dart';

// ---------------------------------------------------------------------------
// Movement → bone mapping
// ---------------------------------------------------------------------------

class _BoneMove {
  const _BoneMove(this.boneSuffix, {required this.axis, required this.sign});
  final String boneSuffix;
  final String axis; // 'x' | 'y' | 'z'
  final double sign; // +1 or -1
}

const Map<String, _BoneMove> _movementMap = {
  'elbow_flexion':      _BoneMove('rightforearm', axis: 'z', sign:  1),
  'elbow_extension':    _BoneMove('rightforearm', axis: 'z', sign: -1),
  'forearm_pronation':  _BoneMove('rightforearm', axis: 'y', sign:  1),
  'forearm_supination': _BoneMove('rightforearm', axis: 'y', sign: -1),
  'wrist_flexion':      _BoneMove('righthand',    axis: 'x', sign:  1),
  'wrist_extension':    _BoneMove('righthand',    axis: 'x', sign: -1),
  'knee_flexion':       _BoneMove('rightleg',     axis: 'x', sign: -1),
  'knee_extension':     _BoneMove('rightleg',     axis: 'x', sign:  1),
};

// ---------------------------------------------------------------------------
// Controller
// ---------------------------------------------------------------------------

class Character3DController {
  _Character3DViewerState? _state;

  /// Drive the animated bone to [deg] degrees offset from its rest pose.
  void setAngle(double deg) => _state?._setAngle(deg);

  void dispose() => _state = null;
}

// ---------------------------------------------------------------------------
// Widget
// ---------------------------------------------------------------------------

class Character3DViewer extends StatefulWidget {
  const Character3DViewer({
    super.key,
    required this.movementType,
    required this.startAngleDeg,
    required this.endAngleDeg,
    this.controller,
    this.modelPath = 'assets/models/Adam_opt.glb',
    this.debugBones = false,
    this.useBakedPose = false,
    this.modelScaleTarget = 1.8,
    this.modelScale,
    this.cameraPositionY = 1.35,
    this.cameraPositionZ = 2.8,
    this.cameraTargetY = 1.15,
    this.fov = 38,
  });

  final String movementType;
  final double startAngleDeg;
  final double endAngleDeg;
  final Character3DController? controller;
  final String modelPath;
  final bool debugBones;
  final bool useBakedPose;
  /// Target height in world units for auto-scaling the model (default 1.8 for standing).
  final double modelScaleTarget;
  /// Override: set a fixed scale directly, bypassing auto-scale. Null = use auto-scale.
  final double? modelScale;
  final double cameraPositionY;
  final double cameraPositionZ;
  final double cameraTargetY;
  final double fov;

  @override
  State<Character3DViewer> createState() => _Character3DViewerState();
}

class _Character3DViewerState extends State<Character3DViewer> {
  HttpServer? _server;
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
    if (!Platform.isWindows) _start();
  }

  @override
  void dispose() {
    widget.controller?._state = null;
    _server?.close(force: true);
    super.dispose();
  }

  void _setAngle(double deg) {
    _controller?.runJavaScript('window.setAngle($deg)');
  }

  Future<void> _start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server = server;
    final url = 'http://127.0.0.1:${server.port}/';

    unawaited(_serve(server));

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..loadRequest(Uri.parse(url));

    if (mounted) setState(() => _controller = controller);
  }

  Future<void> _serve(HttpServer server) async {
    await for (final req in server) {
      _handleRequest(req);
    }
  }

  Future<void> _handleRequest(HttpRequest req) async {
    final res = req.response;
    try {
      final path = req.uri.path;
      if (path == '/' || path == '/index.html') {
        final html = _buildHtml();
        res
          ..statusCode = HttpStatus.ok
          ..headers.add('Content-Type', 'text/html;charset=UTF-8')
          ..add(utf8.encode(html));
      } else if (path == '/model') {
        final data = await rootBundle.load(widget.modelPath);
        final bytes = data.buffer.asUint8List();
        res
          ..statusCode = HttpStatus.ok
          ..headers.add('Content-Type', 'application/octet-stream')
          ..headers.add('Content-Length', bytes.length.toString())
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..add(bytes);
      } else if (path == '/three.min.js' ||
          path == '/GLTFLoader.js' ||
          path == '/OrbitControls.js') {
        final assetPath = 'assets/js$path';
        final data = await rootBundle.load(assetPath);
        final bytes = data.buffer.asUint8List();
        res
          ..statusCode = HttpStatus.ok
          ..headers.add(
            'Content-Type',
            'application/javascript;charset=UTF-8',
          )
          ..headers.add('Content-Length', bytes.length.toString())
          ..add(bytes);
      } else {
        res.statusCode = HttpStatus.notFound;
      }
    } finally {
      await res.close();
    }
  }

  String _buildHtml() {
    final config = _movementMap[widget.movementType];
    final suffix = config?.boneSuffix ?? '';
    final axis = config?.axis ?? 'z';
    final sign = config?.sign ?? 1.0;
    final startRad = widget.startAngleDeg * 3.14159265 / 180 * sign;
    final endRad = widget.endAngleDeg * 3.14159265 / 180 * sign;
    final debug = widget.debugBones ? 'true' : 'false';
    final scaleTarget = widget.modelScaleTarget;
    final fixedScale = widget.modelScale != null ? widget.modelScale.toString() : 'null';
    final camY = widget.cameraPositionY;
    final camZ = widget.cameraPositionZ;
    final tgtY = widget.cameraTargetY;
    final fov = widget.fov;

    return '''<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { background: transparent; overflow: hidden; width: 100vw; height: 100vh; }
  canvas { display: block; width: 100% !important; height: 100% !important; }
</style>
</head>
<body>
<script src="three.min.js"></script>
<script src="GLTFLoader.js"></script>
<script src="OrbitControls.js"></script>
<script>
(function() {
  var scene = new THREE.Scene();
  scene.background = null;

  var w = window.innerWidth, h = window.innerHeight;
  var camera = new THREE.PerspectiveCamera($fov, w / h, 0.01, 200);
  camera.position.set(0, $camY, $camZ);

  var renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
  renderer.setSize(w, h);
  renderer.outputEncoding = THREE.sRGBEncoding;
  document.body.appendChild(renderer.domElement);

  var controls = new THREE.OrbitControls(camera, renderer.domElement);
  controls.target.set(0, $tgtY, 0);
  controls.enablePan = false;
  controls.enableDamping = true;
  controls.dampingFactor = 0.08;
  controls.rotateSpeed = 0.6;
  controls.update();

  // Lighting
  var ambient = new THREE.AmbientLight(0xffffff, 0.6);
  scene.add(ambient);
  var dirLight = new THREE.DirectionalLight(0xffffff, 1.2);
  dirLight.position.set(2, 4, 3);
  scene.add(dirLight);

  // -- Animation params
  var SUFFIX          = '$suffix';
  var AXIS            = '$axis';
  var SIGN            = $sign;
  var START           = $startRad;
  var END             = $endRad;
  var DURATION        = 2800;
  var ARM_DOWN        = -1.5708;
  var IS_KNEE         = SUFFIX.indexOf('leg') !== -1;
  var DEBUG           = $debug;

  // For knee exercises, camera goes to the side (+X axis) for a profile view
  if (IS_KNEE) {
    camera.position.set($camZ, $camY, 0);
    controls.target.set(0, $tgtY, 0);
    controls.update();
  }

  var targetBones = [];
  var boneMap     = Object.create(null);
  var startTime   = null;
  var boneBaseRot = {};

  // Called from Flutter: sets the animated bone to [deg] degrees from rest pose
  window.setAngle = function(deg) {
    var rad = deg * Math.PI / 180 * SIGN;
    for (var i = 0; i < targetBones.length; i++) {
      targetBones[i].rotation[AXIS] = (boneBaseRot[i] || 0) + rad;
    }
  };

  // -- Easing
  function ease(t) {
    return t < 0.5 ? 4*t*t*t : 1 - Math.pow(-2*t+2,3)/2;
  }

  // Set all 3 rotation axes on a bone found by name suffix
  function poseBone(suffix, x, y, z) {
    for (var k in boneMap) {
      if (k.length >= suffix.length && k.slice(-suffix.length) === suffix) {
        boneMap[k].rotation.set(x, y, z); return;
      }
    }
  }

  function applyKneePose() {
    poseBone('rightarm',    0, 0, -1.5708);
    poseBone('leftarm',     0, 0,  1.5708);
    poseBone('rightupleg',  1.5708, 0, 0);
    poseBone('leftupleg',   1.5708, 0, 0);
    poseBone('leftleg',     1.5708, 0, 0);
    poseBone('leftfoot',   -0.5,   0, 0);
  }

  function poseBoneQuat(suffix, x, y, z, w) {
    for (var k in boneMap) {
      if (k.indexOf(suffix) !== -1) {
        boneMap[k].quaternion.set(x, y, z, w);
        return;
      }
    }
  }

  function applyShannonSeatedPose() {
    poseBoneQuat('hips', -0.0753, -0.0098, 0.0193, 0.9969);
    poseBoneQuat('spine', 0.1069, -0.0052, -0.0354, 0.9936);
    poseBoneQuat('spine1', 0.0254, -0.0005, -0.0034, 0.9997);
    poseBoneQuat('spine2', 0.0155, -0.0005, -0.0035, 0.9999);
    poseBoneQuat('leftupleg', 0.0823, 0.6964, 0.7074, -0.0889);
    poseBoneQuat('leftleg', -0.7106, 0.0215, -0.0930, 0.6971);
    poseBoneQuat('leftfoot', 0.4360, -0.0251, 0.0927, 0.8948);
    poseBoneQuat('rightupleg', -0.0481, 0.7124, 0.6976, 0.0588);
    poseBoneQuat('rightleg', -0.7360, 0.0738, -0.0321, 0.6722);
    poseBoneQuat('rightfoot', 0.4699, 0.0235, -0.1260, 0.8734);
    poseBoneQuat('leftarm', 0.3270, -0.0329, 0.1865, 0.9258);
    poseBoneQuat('leftforearm', 0.0463, -0.0014, 0.4554, 0.8891);
    poseBoneQuat('rightarm', 0.2796, 0.0176, -0.3194, 0.9053);
    poseBoneQuat('rightforearm', 0.0290, 0.0017, -0.2899, 0.9566);
  }

  function applyStandingPose() {
    poseBoneQuat('hips', -0.0080, -0.0497, -0.0267, 0.9984);
    poseBoneQuat('spine', -0.0199, 0.0028, 0.0127, 0.9997);
    poseBoneQuat('spine1', 0.0197, 0.0050, 0.0273, 0.9994);
    poseBoneQuat('spine2', 0.0197, 0.0050, 0.0273, 0.9994);
    poseBoneQuat('leftshoulder', 0.6469, 0.3303, -0.5927, 0.3480);
    poseBoneQuat('leftarm', 0.3943, 0.1905, 0.0691, 0.8964);
    poseBoneQuat('leftforearm', 0.0064, -0.0044, 0.1181, 0.9930);
    poseBoneQuat('lefthand', -0.0887, -0.1386, 0.0911, 0.9821);
    poseBoneQuat('rightshoulder', 0.6193, -0.3573, 0.6050, 0.3504);
    poseBoneQuat('rightarm', 0.3822, -0.2687, -0.0377, 0.8834);
    poseBoneQuat('rightforearm', 0.0081, 0.0041, -0.1491, 0.9888);
    poseBoneQuat('righthand', -0.1787, 0.2564, -0.0486, 0.9487);
    poseBoneQuat('leftupleg', 0.0227, 0.1227, 0.9892, -0.0773);
    poseBoneQuat('leftleg', -0.1631, -0.0006, -0.0120, 0.9865);
    poseBoneQuat('leftfoot', 0.4550, -0.1841, 0.0930, 0.8663);
    poseBoneQuat('rightupleg', -0.0582, -0.0008, 0.9968, -0.0549);
    poseBoneQuat('rightleg', -0.0714, -0.0001, 0.0089, 0.9974);
    poseBoneQuat('rightfoot', 0.5011, 0.1025, -0.1151, 0.8515);
  }

  // -- Load model
  var loader = new THREE.GLTFLoader();
  loader.load('/model', function(gltf) {
    var model = gltf.scene;

    var box = new THREE.Box3().setFromObject(model);
    var height = box.max.y - box.min.y;
    var fixedScale = $fixedScale;
    var finalScale = fixedScale !== null ? fixedScale : (height > 0 ? $scaleTarget / height : 1);
    model.scale.setScalar(finalScale);

    scene.add(model);

    box.setFromObject(model);
    var center = box.getCenter(new THREE.Vector3());
    model.position.x -= center.x;
    model.position.z -= center.z;
    model.position.y -= box.min.y;

    // Build bone map + collect target bones
    model.traverse(function(obj) {
      if (!obj.isBone) return;
      var n = obj.name.toLowerCase();
      boneMap[n] = obj;
      if (SUFFIX && n.indexOf(SUFFIX) !== -1) targetBones.push(obj);
      if (DEBUG) console.log('Bone:', obj.name);
    });

    if (IS_KNEE) {
      applyShannonSeatedPose();
    } else {
      applyStandingPose();
    }

    // Capture rest rotation for each animated bone (used by window.setAngle)
    for (var i = 0; i < targetBones.length; i++) {
      boneBaseRot[i] = targetBones[i].rotation[AXIS];
    }

    if (DEBUG) console.log('Target bones found:', targetBones.length);
  }, undefined, function(err) {
    console.error('GLTFLoader error:', err);
  });

  // -- Render loop
  function animate(ts) {
    requestAnimationFrame(animate);

    if (false && targetBones.length > 0) {
      if (!startTime) startTime = ts;
      var elapsed = (ts - startTime) % (DURATION * 2);
      var raw = elapsed < DURATION ? elapsed / DURATION : 2 - elapsed / DURATION;
      var angle = START + (END - START) * ease(raw);
      for (var i = 0; i < targetBones.length; i++) {
        targetBones[i].rotation[AXIS] = angle;
      }
    }

    controls.update();
    renderer.render(scene, camera);
  }
  requestAnimationFrame(animate);

  window.addEventListener('resize', function() {
    var w = window.innerWidth, h = window.innerHeight;
    camera.aspect = w / h;
    camera.updateProjectionMatrix();
    renderer.setSize(w, h);
  });
})();
</script>
</body>
</html>''';
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      return Container(
        color: const Color(0xFF1A1A2E),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.view_in_ar, size: 48, color: Colors.white38),
              SizedBox(height: 12),
              Text(
                '3D Viewer không hỗ trợ trên Windows\nVui lòng test trên Android',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }
    if (_controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return WebViewWidget(
      controller: _controller!,
      gestureRecognizers: {
        Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer()),
      },
    );
  }
}