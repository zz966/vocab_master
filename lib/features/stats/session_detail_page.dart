import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/session_labels.dart';
import '../../providers/session_detail_provider.dart';
import '../../utils/session_actions.dart';
import '../../utils/session_detail_share.dart';
import '../../utils/study_quality.dart';
import '../study/word_detail_page.dart';

class SessionDetailPage extends ConsumerWidget {
  const SessionDetailPage({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(sessionDetailProvider(sessionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('学习详情'),
        actions: [
          detailAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (detail) {
              if (detail == null) {
                return const SizedBox.shrink();
              }

              return PopupMenuButton<String>(
                tooltip: '分享记录',
                onSelected: (value) async {
                  switch (value) {
                    case 'share_text':
                      await shareSessionText(
                        session: detail.session,
                        entries: detail.entries,
                      );
                    case 'export_csv':
                      if (!context.mounted) {
                        return;
                      }
                      await exportSession(
                        context: context,
                        session: detail.session,
                        format: 'csv',
                        shareAfter: false,
                      );
                    case 'export_csv_share':
                      if (!context.mounted) {
                        return;
                      }
                      await exportSession(
                        context: context,
                        session: detail.session,
                        format: 'csv',
                      );
                    case 'export_json':
                      if (!context.mounted) {
                        return;
                      }
                      await exportSession(
                        context: context,
                        session: detail.session,
                        format: 'json',
                        shareAfter: false,
                      );
                    case 'export_json_share':
                      if (!context.mounted) {
                        return;
                      }
                      await exportSession(
                        context: context,
                        session: detail.session,
                        format: 'json',
                      );
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'share_text',
                    child: Text('分享文字摘要'),
                  ),
                  PopupMenuItem(
                    value: 'export_csv',
                    child: Text('导出 CSV'),
                  ),
                  PopupMenuItem(
                    value: 'export_csv_share',
                    child: Text('导出并分享 CSV'),
                  ),
                  PopupMenuItem(
                    value: 'export_json',
                    child: Text('导出 JSON'),
                  ),
                  PopupMenuItem(
                    value: 'export_json_share',
                    child: Text('导出并分享 JSON'),
                  ),
                ],
              );
            },
          ),
          IconButton(
            tooltip: '删除记录',
            onPressed: () async {
              final confirmed = await confirmDeleteSession(context);
              if (!confirmed || !context.mounted) {
                return;
              }
              await deleteSessionRecord(ref: ref, sessionId: sessionId);
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('记录已删除')),
                );
              }
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('加载失败: $error')),
        data: (detail) {
          if (detail == null) {
            return const Center(child: Text('记录不存在'));
          }

          final session = detail.session;
          final accuracy = session.wordsStudied == 0
              ? 0
              : (session.wordsCorrect / session.wordsStudied * 100).round();
          final duration =
              session.completedAt?.difference(session.startedAt);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sessionTypeLabel(session.sessionType),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        label: '开始时间',
                        value: DateFormat('yyyy-MM-dd HH:mm')
                            .format(session.startedAt),
                      ),
                      if (session.completedAt != null)
                        _InfoRow(
                          label: '完成时间',
                          value: DateFormat('yyyy-MM-dd HH:mm')
                              .format(session.completedAt!),
                        ),
                      if (duration != null)
                        _InfoRow(
                          label: '学习时长',
                          value: _formatDuration(duration),
                        ),
                      _InfoRow(
                        label: '学习词数',
                        value: '${session.wordsStudied} 词',
                      ),
                      _InfoRow(
                        label: '正确率',
                        value: '$accuracy%',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '单词列表',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (detail.entries.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: Text('暂无单词记录')),
                )
              else
                ...detail.entries.map((entry) {
                  final quality =
                      StudyQuality.fromValue(entry.record.quality);
                  return Card(
                    child: ListTile(
                      title: Text(entry.word.english),
                      subtitle: Text(entry.word.chinese),
                      trailing: quality == null
                          ? null
                          : Chip(
                              label: Text(
                                quality.label,
                                style: TextStyle(
                                  color: quality.color,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor:
                                  quality.color.withValues(alpha: 0.12),
                              visualDensity: VisualDensity.compact,
                            ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                WordDetailPage(wordId: entry.word.id),
                          ),
                        );
                      },
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes < 1) {
      return '${duration.inSeconds} 秒';
    }
    if (duration.inHours < 1) {
      return '${duration.inMinutes} 分钟';
    }
    return '${duration.inHours} 小时 ${duration.inMinutes % 60} 分钟';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}