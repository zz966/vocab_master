import 'package:flutter_tts/flutter_tts.dart';

/// Wraps platform text-to-speech. Uses the OS TTS engine — no extra
/// runtime permissions required on Android or iOS.
class TtsService {
  TtsService._();

  static final TtsService instance = TtsService._();

  final FlutterTts flutterTts = FlutterTts();
  bool _initialized = false;
  double _speechRate = 0.45;
  String _accent = 'en-US';

  Future<void> init({double speechRate = 0.45, String accent = 'en-US'}) async {
    _speechRate = speechRate.clamp(0.2, 1.0);
    _accent = _normalizeAccent(accent);
    if (_initialized) {
      await flutterTts.setSpeechRate(_speechRate);
      await flutterTts.setLanguage(_accent);
      return;
    }
    await flutterTts.setLanguage(_accent);
    await flutterTts.setSpeechRate(_speechRate);
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);
    _initialized = true;
  }

  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate.clamp(0.2, 1.0);
    if (!_initialized) {
      await init(speechRate: _speechRate, accent: _accent);
      return;
    }
    await flutterTts.setSpeechRate(_speechRate);
  }

  Future<void> setAccent(String accent) async {
    _accent = _normalizeAccent(accent);
    if (!_initialized) {
      await init(speechRate: _speechRate, accent: _accent);
      return;
    }
    await flutterTts.setLanguage(_accent);
  }

  Future<void> speak(String text, {String? accent}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }
    if (!_initialized) {
      await init(speechRate: _speechRate, accent: _accent);
    }
    if (accent != null) {
      await flutterTts.setLanguage(_normalizeAccent(accent));
    }
    await flutterTts.stop();
    await flutterTts.speak(trimmed);
    if (accent != null) {
      await flutterTts.setLanguage(_accent);
    }
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }

  String _normalizeAccent(String accent) {
    return accent == 'en-GB' ? 'en-GB' : 'en-US';
  }
}