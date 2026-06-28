import 'package:intl/intl.dart';

import '../models/learning_session.dart';

class SessionDateGroup {
  const SessionDateGroup({
    required this.label,
    required this.sessions,
  });

  final String label;
  final List<LearningSession> sessions;
}

String formatSessionDateLabel(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(date.year, date.month, date.day);
  final diff = today.difference(day).inDays;

  if (diff == 0) {
    return '今天';
  }
  if (diff == 1) {
    return '昨天';
  }
  if (diff < 7) {
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return weekdays[date.weekday - 1];
  }
  return DateFormat('M月d日').format(date);
}

List<SessionDateGroup> groupSessionsByDate(List<LearningSession> sessions) {
  final groups = <String, List<LearningSession>>{};
  final order = <String>[];

  for (final session in sessions) {
    final key = DateFormat('yyyy-MM-dd').format(session.startedAt);
    if (!groups.containsKey(key)) {
      order.add(key);
      groups[key] = [];
    }
    groups[key]!.add(session);
  }

  return [
    for (final key in order)
      SessionDateGroup(
        label: formatSessionDateLabel(DateTime.parse(key)),
        sessions: groups[key]!,
      ),
  ];
}