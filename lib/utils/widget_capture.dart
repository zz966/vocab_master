import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

Future<File?> captureWidgetToPng(
  GlobalKey key, {
  double pixelRatio = 3,
}) async {
  if (kIsWeb) {
    return null;
  }

  final context = key.currentContext;
  if (context == null) {
    return null;
  }

  final boundary = context.findRenderObject();
  if (boundary is! RenderRepaintBoundary) {
    return null;
  }

  final image = await boundary.toImage(pixelRatio: pixelRatio);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) {
    return null;
  }

  final tempDir = await getTemporaryDirectory();
  final file = File(
    '${tempDir.path}/capture_${DateTime.now().millisecondsSinceEpoch}.png',
  );
  await file.writeAsBytes(byteData.buffer.asUint8List());
  return file;
}