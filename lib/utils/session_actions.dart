import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/stats_provider.dart';
import '../providers/study_provider.dart';
import '../repositories/session_repository.dart';

Future<bool> confirmDeleteSession(BuildContext context) {
  return confirmBulkDelete(
    context,
    title: '删除学习记录',
    message: '确定删除这条学习记录？此操作不可撤销。',
  );
}

Future<bool> confirmBulkDelete(
  BuildContext context, {
  required String title,
  required String message,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('删除'),
        ),
      ],
    ),
  ).then((value) => value ?? false);
}

Future<void> _refreshSessionData(WidgetRef ref) async {
  ref.invalidate(recentSessionsProvider);
  ref.invalidate(sessionSummaryProvider);
  ref.invalidate(last7DaysStatsProvider);
  invalidateStudyData(ref);
}

Future<void> deleteSessionRecord({
  required WidgetRef ref,
  required String sessionId,
}) async {
  await ref.read(sessionRepositoryProvider).deleteSession(sessionId);
  await _refreshSessionData(ref);
}

Future<void> deleteSessionRecords({
  required WidgetRef ref,
  required List<String> sessionIds,
}) async {
  if (sessionIds.isEmpty) {
    return;
  }
  await ref.read(sessionRepositoryProvider).deleteSessions(sessionIds);
  await _refreshSessionData(ref);
}

Future<void> clearAllSessionRecords({required WidgetRef ref}) async {
  await ref.read(sessionRepositoryProvider).clearAllSessions();
  await _refreshSessionData(ref);
}