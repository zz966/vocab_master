import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/database/seed_data.dart';
import 'package:vocab_master/services/tts_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('flutter_tts');
  final calls = <String>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      switch (call.method) {
        case 'setLanguage':
        case 'setSpeechRate':
        case 'setPitch':
        case 'setVolume':
        case 'speak':
        case 'stop':
          return 1;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('TtsService', () {
    test('singleton instance is stable', () {
      expect(identical(TtsService.instance, TtsService.instance), isTrue);
    });

    test('init configures en-US voice at learning-friendly rate', () async {
      await TtsService.instance.init();

      expect(calls, contains('setLanguage'));
      expect(calls, contains('setSpeechRate'));
      expect(calls, contains('setPitch'));
      expect(calls, contains('setVolume'));
    });

    test('speak handles empty text gracefully', () async {
      final speakCallsBefore = calls.where((c) => c == 'speak').length;
      await TtsService.instance.speak('');
      await TtsService.instance.speak('   ');
      final speakCallsAfter = calls.where((c) => c == 'speak').length;
      expect(speakCallsAfter, speakCallsBefore);
    });

    test('speak at least 5 seed words and their examples', () async {
      final samples = SeedData.wordsForBook('seed_basic', 'basic');
      expect(samples.length, greaterThanOrEqualTo(5));

      for (final word in samples.take(5)) {
        await TtsService.instance.speak(word.english);
        if (word.examples != null) {
          for (final example in word.examples!) {
            await TtsService.instance.speak(example);
          }
        }
      }

      final speakCount = calls.where((c) => c == 'speak').length;
      expect(speakCount, greaterThanOrEqualTo(5));
    });

    test('stop invokes platform channel', () async {
      await TtsService.instance.stop();
      expect(calls, contains('stop'));
    });
  });
}