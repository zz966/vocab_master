import '../utils/level_challenge.dart';

String sessionTypeLabel(String sessionType) {
  final challenge = parseLevelChallengeSessionType(sessionType);
  if (challenge != null) {
    final modeLabel = switch (challenge.mode.name) {
      'quiz' => '选择题',
      'spelling' => '拼写练习',
      'listening' => '听音选义',
      _ => challenge.mode.name,
    };
    return '关卡 ${challenge.levelIndex + 1} · $modeLabel';
  }

  return switch (sessionType) {
    'quiz' => '选择题',
    'spelling' => '拼写练习',
    'listening' => '听音选义',
    _ => sessionType,
  };
}