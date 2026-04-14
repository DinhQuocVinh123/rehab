import 'dart:async';
import 'dart:io';

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
  'elbow_flexion':      _BoneMove('rightforearm', axis: 'x', sign:  1),
  'elbow_extension':    _BoneMove('rightforearm', axis: 'x', sign: -1),
  'forearm_pronation':  _BoneMove('rightforearm', axis: 'y', sign:  1),
  'forearm_supination': _BoneMove('rightforearm', axis: 'y', sign: -1),
  'wrist_flexion':      _BoneMove('righthand',    axis: 'x', sign:  1),
  'wrist_extension':    _BoneMove('righthand',    axis: 'x', sign: -1),
  'knee_flexion':       _BoneMove('rightleg',     axis: 'x', sign: -1),
  'knee_extension':     _BoneMove('rightleg',     axis: 'x', sign:  1),
};

// ---------------------------------------------------------------------------
// Widget
// ---------------------------------------------------------------------------

class Character3DViewer extends StatefulWidget {
  const Character3DViewer({
    super.key,
    required this.movementType,
    required this.startAngleDeg,
    required this.endAngleDeg,
    this.modelPath = 'assets/models/Adam_opt.glb',
    this.debugBones = false,
    this.cameraPositionY = 1.35,
    this.cameraPositionZ = 2.8,
    this.cameraTargetY = 1.15,
    this.fov = 38,
  });

  final String movementType;
  final double startAngleDeg;
  final double endAngleDeg;
  final String modelPath;
  final bool debugBones;
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
    _start();
  }

  @override
  void dispose() {
    _server?.close(force: true);
    super.dispose();
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
          ..add(html.codeUnits);
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

  // ── Animation params ──────────────────────────────────────────────────
  var SUFFIX   = '$suffix';
  var AXIS     = '$axis';
  var START    = $startRad;
  var END      = $endRad;
  var DURATION = 2800;
  var ARM_DOWN = -1.5708; // -π/2
  var DEBUG    = $debug;

  var targetBones = [];
  var startTime   = null;

  // ── Easing ────────────────────────────────────────────────────────────
  function ease(t) {
    return t < 0.5 ? 4*t*t*t : 1 - Math.pow(-2*t+2,3)/2;
  }

  // ── Load model ────────────────────────────────────────────────────────
  var loader = new THREE.GLTFLoader();
  loader.load('/model', function(gltf) {
    var model = gltf.scene;

    // Auto-scale: normalize height to 1.8 world units
    var box = new THREE.Box3().setFromObject(model);
    var height = box.max.y - box.min.y;
    if (height > 0) model.scale.setScalar(1.8 / height);

    scene.add(model);

    // Place feet at y=0, center x/z
    box.setFromObject(model);
    var center = box.getCenter(new THREE.Vector3());
    model.position.x -= center.x;
    model.position.z -= center.z;
    model.position.y -= box.min.y;

    // Collect bones + setup pose
    model.traverse(function(obj) {
      if (!obj.isBone) return;
      var n = obj.name.toLowerCase();

      if (DEBUG) console.log('Bone:', obj.name);

      // Arms down from T-pose
      if (n.indexOf('rightarm') !== -1 && n.indexOf('forearm') === -1 && n.indexOf('hand') === -1) {
        obj.rotation.set(0, 0, ARM_DOWN);
      }
      if (n.indexOf('leftarm') !== -1 && n.indexOf('forearm') === -1 && n.indexOf('hand') === -1) {
        obj.rotation.set(0, 0, -ARM_DOWN);
      }

      // Target bones for animation
      if (SUFFIX && n.indexOf(SUFFIX) !== -1) {
        targetBones.push(obj);
        if (DEBUG) console.log('Target bone:', obj.name);
      }
    });

    if (DEBUG) console.log('Target bones found:', targetBones.length);
  }, undefined, function(err) {
    console.error('GLTFLoader error:', err);
  });

  // ── Render loop ───────────────────────────────────────────────────────
  function animate(ts) {
    requestAnimationFrame(animate);

    if (targetBones.length > 0) {
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
    if (_controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return WebViewWidget(controller: _controller!);
  }
}
