import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';

import 'export_file.dart';

enum ImageSaveResult {
  savedToGallery,
  savedToDocuments,
  failed,
}

Future<ImageSaveResult> saveImageToGallery(
  File file, {
  String? album,
}) async {
  if (kIsWeb) {
    return ImageSaveResult.failed;
  }

  if (!await file.exists()) {
    return ImageSaveResult.failed;
  }

  try {
    final hasAccess = await Gal.hasAccess();
    if (!hasAccess) {
      await Gal.requestAccess();
    }
    await Gal.putImage(file.path, album: album ?? 'VocabMaster');
    return ImageSaveResult.savedToGallery;
  } catch (_) {
    final bytes = await file.readAsBytes();
    final fileName =
        'vocab_weekly_${DateTime.now().millisecondsSinceEpoch}.png';
    final path = await saveBytesToDocuments(bytes: bytes, fileName: fileName);
    if (path == null) {
      return ImageSaveResult.failed;
    }
    return ImageSaveResult.savedToDocuments;
  }
}