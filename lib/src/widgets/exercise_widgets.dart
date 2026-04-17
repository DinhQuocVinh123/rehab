import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rehab/src/data/elbow_exercise_svg.dart';
import 'package:rehab/src/models/exercise.dart';
import 'package:rehab/src/services/daq_ble_service.dart';
import 'package:rehab/src/theme/app_colors.dart';
import 'package:rehab/src/widgets/character_3d_viewer.dart';

part 'exercise_widgets/assets.dart';
part 'exercise_widgets/cards.dart';
part 'exercise_widgets/showcase.dart';
part 'exercise_widgets/motion_demos.dart';
part 'exercise_widgets/details.dart';
