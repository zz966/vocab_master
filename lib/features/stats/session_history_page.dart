import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/session_labels.dart';
import '../../models/learning_session.dart';
import '../../providers/book_provider.dart';
import '../../repositories/book_repository.dart';
import '../../providers/export_refresh_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/stats_provider.dart';
import '../../utils/export_file.dart';
import '../../utils/session_actions.dart';
import '../../utils/session_date_filter.dart';
import '../../utils/session_date_group.dart';
import '../../utils/session_export.dart';
import '../../utils/session_filter_prefs.dart';
import '../../utils/session_filter_summary.dart';
import 'session_detail_page.dart';
import 'widgets/session_filter_summary_bar.dart';
import 'widgets/weekly_report_share_button.dart';

class SessionHistoryPage extends ConsumerStatefulWidget {
  const SessionHistoryPage({
    super.key,
    this.initialDateRange,
    this.initialCustomRange,
    this.initialBookId,
  });

  final SessionDateRange? initialDateRange;
  final DateTimeRange? initialCustomRange;
  final int? initialBookId;

  @override
  ConsumerState<SessionHistoryPage> createState() =>
      _SessionHistoryPageState();
}

class _SessionHistoryPageState extends ConsumerState<SessionHistoryPage> {
  late SessionFilter _filter;
  late SessionDateRange _dateRange;
  DateTimeRange? _customRange;
  int? _bookFilterId;
  bool _selectionMode = false;
  final Set<int> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _filter = SessionFilter.all;
    _dateRange = widget.initialDateRange ?? SessionDateRange.all;
    _customRange = widget.initialCustomRange;
    _bookFilterId = widget.initialBookId;
    _loadSavedFilters();
  }

  Future<void> _loadSavedFilters() async {
    final saved = await SessionFilterPrefs.load();
    if (!mounted || saved == null) {
      return;
    }
    setState(() {
      if (widget.initialDateRange == null) {
        _dateRange = saved.dateRange;
        _customRange = saved.customRange;
      } else if (widget.initialCustomRange == null) {
        _customRange = saved.customRange;
      }
      if (widget.initialBookId == null) {
        _bookFilterId = saved.bookId;
      }
      _filter = saved.typeFilter;
    });
  }

  void _updateFilterState(VoidCallback update) {
    setState(update);
    SessionFilterPrefs.save(
      typeFilter: _filter,
      dateRange: _dateRange,
      bookId: _bookFilterId,
      customRange: _customRange,
    );
  }

  void _resetFilters() {
    SessionFilterPrefs.clear();
    _updateFilterState(() {
      _filter = SessionFilter.all;
      _dateRange = SessionDateRange.all;
      _customRange = null;
      _bookFilterId = null;
    });
  }

  void _removeFilterChip(SessionFilterChipKind kind) {
    _updateFilterState(() {
      switch (kind) {
        case SessionFilterChipKind.type:
          _filter = SessionFilter.all;
        case SessionFilterChipKind.date:
          _dateRange = SessionDateRange.all;
          _customRange = null;
        case SessionFilterChipKind.book:
          _bookFilterId = null;
      }
    });
  }

  String? _bookTitle(List<BookProgress> books) {
    if (_bookFilterId == null) {
      return null;
    }
    for (final progress in books) {
      if (progress.book.id == _bookFilterId) {
        return progress.book.title;
      }
    }
    return null;
  }

  List<LearningSession> _applyFilters(List<LearningSession> sessions) {
    return sessions
        .where(
          (session) => matchesSessionFilters(
            session,
            typeFilter: (item) => matchesSessionTypeFilter(item, _filter),
            dateRange: _dateRange,
            customRange: _customRange,
            bookId: _bookFilterId,
          ),
        )
        .toList();
  }

  Future<void> _pickCustomDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 365 * 3)),
      lastDate: now,
      initialDateRange: _customRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 6)),
            end: now,
          ),
    );
    if (picked == null || !mounted) {
      return;
    }
    _updateFilterState(() {
      _dateRange = SessionDateRange.custom;
      _customRange = picked;
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _selectionMode = false;
      _selectedIds.clear();
    });
  }

  void _toggleSelection(int sessionId) {
    setState(() {
      if (_selectedIds.contains(sessionId)) {
        _selectedIds.remove(sessionId);
      } else {
        _selectedIds.add(sessionId);
      }
    });
  }

  void _selectAllFiltered(List<LearningSession> filtered) {
    setState(() {
      _selectedIds.addAll(filtered.map((session) => session.id));
    });
  }

  void _invertSelection(List<LearningSession> filtered) {
    setState(() {
      for (final session in filtered) {
        if (_selectedIds.contains(session.id)) {
          _selectedIds.remove(session.id);
        } else {
          _selectedIds.add(session.id);
        }
      }
    });
  }

  Future<void> _deleteSelected() async {
    if (_selectedIds.isEmpty) {
      return;
    }
    final count = _selectedIds.length;
    final confirmed = await confirmBulkDelete(
      context,
      title: '批量删除',
      message: '确定删除选中的 $count 条学习记录？',
    );
    if (!confirmed || !mounted) {
      return;
    }
    await deleteSessionRecords(
      ref: ref,
      sessionIds: _selectedIds.toList(),
    );
    if (!mounted) {
      return;
    }
    _exitSelectionMode();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已删除 $count 条记录')),
    );
  }

  Future<void> _exportSessions(
    List<LearningSession> sessions, {
    required String format,
    bool selectedOnly = false,
    bool shareAfter = false,
  }) async {
    if (sessions.isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('没有可导出的记录')),
      );
      return;
    }

    final timestamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final isJson = format == 'json';
    final content = isJson
        ? SessionExportCodec.toJson(sessions)
        : SessionExportCodec.toCsv(sessions);
    final prefix = selectedOnly ? 'vocab_sessions_selected' : 'vocab_sessions';
    final fileName = '${prefix}_$timestamp.${isJson ? 'json' : 'csv'}';
    final path = await saveTextToDocuments(content: content, fileName: fileName);
    if (path != null) {
      bumpExportFilesRevision(ref);
    }
    if (!mounted) {
      return;
    }

    if (path != null && shareAfter) {
      final result = await shareFileAtPath(path, name: fileName);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result == ShareExportResult.shared
                ? '已导出并打开分享'
                : '已导出，分享失败',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          path == null
              ? '${isJson ? 'JSON' : 'CSV'} 已生成（当前平台不支持保存文件）'
              : '已导出至 $path',
        ),
        action: path == null
            ? null
            : SnackBarAction(
                label: '分享',
                onPressed: () => shareFileAtPath(path, name: fileName),
              ),
      ),
    );
  }

  Future<void> _handleMenuAction(
    BuildContext context,
    String action,
    List<LearningSession> sessions,
  ) async {
    switch (action) {
      case 'export_csv':
        await _exportSessions(sessions, format: 'csv');
      case 'export_csv_share':
        await _exportSessions(sessions, format: 'csv', shareAfter: true);
      case 'export_json':
        await _exportSessions(sessions, format: 'json');
      case 'export_json_share':
        await _exportSessions(sessions, format: 'json', shareAfter: true);
      case 'select':
        setState(() => _selectionMode = true);
      case 'share_filter_summary':
        await shareSessionFilterSummary(
          typeFilter: _filter,
          dateRange: _dateRange,
          customRange: _customRange,
          bookTitle: _bookTitle(
            ref.read(booksProvider).valueOrNull ?? [],
          ),
          filteredCount: _applyFilters(sessions).length,
          totalCount: sessions.length,
        );
      case 'reset_filters':
        _resetFilters();
      case 'clear_filtered':
        final ids = _applyFilters(sessions).map((s) => s.id).toList();
        final confirmed = await confirmBulkDelete(
          context,
          title: '清空筛选结果',
          message:
              '确定删除 ${ids.length} 条匹配「${_filter.label}」的学习记录？',
        );
        if (!confirmed || !context.mounted) {
          return;
        }
        await deleteSessionRecords(ref: ref, sessionIds: ids);
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已删除 ${ids.length} 条记录')),
        );
      case 'clear_all':
        final confirmed = await confirmBulkDelete(
          context,
          title: '清空全部记录',
          message: '确定删除全部 ${sessions.length} 条学习记录？此操作不可撤销。',
        );
        if (!confirmed || !context.mounted) {
          return;
        }
        await clearAllSessionRecords(ref: ref);
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('全部记录已清空')),
        );
    }
  }

  Future<void> _handleSelectionAction(
    String action,
    List<LearningSession> filtered,
    List<LearningSession> allSessions,
  ) async {
    switch (action) {
      case 'select_all':
        _selectAllFiltered(filtered);
      case 'invert':
        _invertSelection(filtered);
      case 'export_csv':
        final selected = allSessions
            .where((session) => _selectedIds.contains(session.id))
            .toList();
        await _exportSessions(
          selected,
          format: 'csv',
          selectedOnly: true,
        );
      case 'export_csv_share':
        final selectedShare = allSessions
            .where((session) => _selectedIds.contains(session.id))
            .toList();
        await _exportSessions(
          selectedShare,
          format: 'csv',
          selectedOnly: true,
          shareAfter: true,
        );
      case 'export_json':
        final selected = allSessions
            .where((session) => _selectedIds.contains(session.id))
            .toList();
        await _exportSessions(
          selected,
          format: 'json',
          selectedOnly: true,
        );
      case 'export_json_share':
        final selectedJsonShare = allSessions
            .where((session) => _selectedIds.contains(session.id))
            .toList();
        await _exportSessions(
          selectedJsonShare,
          format: 'json',
          selectedOnly: true,
          shareAfter: true,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(recentSessionsProvider);
    final summaryAsync = ref.watch(sessionSummaryProvider);
    final booksAsync = ref.watch(booksProvider);
    final weekStatsAsync = ref.watch(last7DaysStatsProvider);
    final books = booksAsync.valueOrNull ?? [];
    final allSessions = sessionsAsync.valueOrNull ?? [];
    final filteredSessions = _applyFilters(allSessions);

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectionMode
            ? '已选 ${_selectedIds.length} 条'
            : '学习记录'),
        leading: _selectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _exitSelectionMode,
              )
            : null,
        actions: [
          if (_selectionMode) ...[
            PopupMenuButton<String>(
              onSelected: (value) => _handleSelectionAction(
                value,
                filteredSessions,
                allSessions,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'select_all',
                  child: Text('全选 (${filteredSessions.length})'),
                ),
                const PopupMenuItem(
                  value: 'invert',
                  child: Text('反选'),
                ),
                if (_selectedIds.isNotEmpty) ...[
                  const PopupMenuItem(
                    value: 'export_csv',
                    child: Text('导出选中 CSV'),
                  ),
                  const PopupMenuItem(
                    value: 'export_csv_share',
                    child: Text('导出并分享 CSV'),
                  ),
                  const PopupMenuItem(
                    value: 'export_json',
                    child: Text('导出选中 JSON'),
                  ),
                  const PopupMenuItem(
                    value: 'export_json_share',
                    child: Text('导出并分享 JSON'),
                  ),
                ],
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: '删除选中',
              onPressed:
                  _selectedIds.isEmpty ? null : _deleteSelected,
            ),
          ] else if (allSessions.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (value) => _handleMenuAction(
                context,
                value,
                sessionsAsync.valueOrNull ?? [],
              ),
              itemBuilder: (context) {
                final sessions = sessionsAsync.valueOrNull ?? [];
                final filteredCount = _applyFilters(sessions).length;
                final hasActiveFilter = _filter != SessionFilter.all ||
                    _dateRange != SessionDateRange.all ||
                    _bookFilterId != null;
                final showFiltered = hasActiveFilter && filteredCount > 0;

                return [
                  const PopupMenuItem(
                    value: 'export_csv',
                    child: Text('导出 CSV'),
                  ),
                  const PopupMenuItem(
                    value: 'export_csv_share',
                    child: Text('导出并分享 CSV'),
                  ),
                  const PopupMenuItem(
                    value: 'export_json',
                    child: Text('导出 JSON'),
                  ),
                  const PopupMenuItem(
                    value: 'export_json_share',
                    child: Text('导出并分享 JSON'),
                  ),
                  const PopupMenuItem(
                    value: 'select',
                    child: Text('多选删除'),
                  ),
                  if (hasActiveFilter) ...[
                    const PopupMenuItem(
                      value: 'share_filter_summary',
                      child: Text('分享筛选摘要'),
                    ),
                    const PopupMenuItem(
                      value: 'reset_filters',
                      child: Text('重置筛选'),
                    ),
                  ],
                  if (showFiltered)
                    PopupMenuItem(
                      value: 'clear_filtered',
                      child: Text('清空筛选结果 ($filteredCount)'),
                    ),
                  const PopupMenuItem(
                    value: 'clear_all',
                    child: Text('清空全部记录'),
                  ),
                ];
              },
            ),
        ],
      ),
      floatingActionButton: _selectionMode && _selectedIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _deleteSelected,
              icon: const Icon(Icons.delete),
              label: Text('删除 (${_selectedIds.length})'),
            )
          : null,
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('加载失败: $error')),
        data: (sessions) {
          final filtered = _applyFilters(sessions);
          final groups = groupSessionsByDate(filtered);
          final activeFilters = hasActiveSessionFilters(
            typeFilter: _filter,
            dateRange: _dateRange,
            bookId: _bookFilterId,
          );

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(recentSessionsProvider);
              ref.invalidate(sessionSummaryProvider);
              await ref.read(recentSessionsProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (!_selectionMode)
                  summaryAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                    data: (summary) {
                      final settings =
                          ref.watch(settingsProvider).valueOrNull;
                      final masteredWords = books.fold<int>(
                        0,
                        (sum, item) => sum + item.masteredWords,
                      );
                      return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '近 7 日汇总',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                ),
                                WeeklyReportShareButton(
                                  summary: summary,
                                  masteredWords: masteredWords,
                                  currentStreak:
                                      settings?.currentStreak ?? 0,
                                  weekStats: weekStatsAsync.valueOrNull,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _SummaryRow(
                              label: '学习次数',
                              value: '${summary.totalSessions} 次',
                            ),
                            _SummaryRow(
                              label: '学习词数',
                              value: '${summary.totalWordsStudied} 词',
                            ),
                            _SummaryRow(
                              label: '平均正确率',
                              value:
                                  '${(summary.accuracy * 100).round()}%',
                            ),
                          ],
                        ),
                      ),
                    );
                    },
                  ),
                if (!_selectionMode) const SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: SessionFilter.values.map((filter) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter.label),
                          selected: _filter == filter,
                          onSelected: (_) =>
                              _updateFilterState(() => _filter = filter),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final range in SessionDateRange.values)
                        if (range != SessionDateRange.custom)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(range.label),
                              selected: _dateRange == range,
                              onSelected: (_) => _updateFilterState(() {
                                _dateRange = range;
                                if (range != SessionDateRange.custom) {
                                  _customRange = null;
                                }
                              }),
                            ),
                          ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            _dateRange == SessionDateRange.custom &&
                                    _customRange != null
                                ? '${DateFormat('M/d').format(_customRange!.start)}-'
                                    '${DateFormat('M/d').format(_customRange!.end)}'
                                : SessionDateRange.custom.label,
                          ),
                          selected: _dateRange == SessionDateRange.custom,
                          onSelected: (_) => _pickCustomDateRange(),
                        ),
                      ),
                    ],
                  ),
                ),
                if (books.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: const Text('全部单词书'),
                            selected: _bookFilterId == null,
                            onSelected: (_) => _updateFilterState(
                              () => _bookFilterId = null,
                            ),
                          ),
                        ),
                        for (final progress in books)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(progress.book.title),
                              selected: _bookFilterId == progress.book.id,
                              onSelected: (_) => _updateFilterState(
                                () => _bookFilterId = progress.book.id,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                if (!_selectionMode && activeFilters) ...[
                  const SizedBox(height: 12),
                  SessionFilterSummaryBar(
                    chips: buildActiveSessionFilterChips(
                      typeFilter: _filter,
                      dateRange: _dateRange,
                      customRange: _customRange,
                      bookTitle: _bookTitle(books),
                    ),
                    filteredCount: filtered.length,
                    totalCount: sessions.length,
                    onRemoveChip: _removeFilterChip,
                    onClearAll: _resetFilters,
                    onShare: () => shareSessionFilterSummary(
                      typeFilter: _filter,
                      dateRange: _dateRange,
                      customRange: _customRange,
                      bookTitle: _bookTitle(books),
                      filteredCount: filtered.length,
                      totalCount: sessions.length,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: Text('暂无匹配的学习记录')),
                  )
                else
                  ...groups.expand((group) sync* {
                    yield Padding(
                      padding: const EdgeInsets.only(bottom: 8, top: 8),
                      child: Text(
                        group.label,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                    for (final session in group.sessions) {
                      yield _SessionTile(
                        session: session,
                        selectionMode: _selectionMode,
                        selected: _selectedIds.contains(session.id),
                        onToggleSelect: () => _toggleSelection(session.id),
                      );
                    }
                  }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SessionTile extends ConsumerWidget {
  const _SessionTile({
    required this.session,
    required this.selectionMode,
    required this.selected,
    required this.onToggleSelect,
  });

  final LearningSession session;
  final bool selectionMode;
  final bool selected;
  final VoidCallback onToggleSelect;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await confirmDeleteSession(context);
    if (!confirmed || !context.mounted) {
      return;
    }
    await deleteSessionRecord(ref: ref, sessionId: session.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('记录已删除')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accuracy = session.wordsStudied == 0
        ? 0
        : (session.wordsCorrect / session.wordsStudied * 100).round();
    final completed = session.completedAt != null;
    final timeLabel = DateFormat('HH:mm').format(session.startedAt);

    final tile = Card(
      child: ListTile(
        leading: selectionMode
            ? Checkbox(
                value: selected,
                onChanged: (_) => onToggleSelect(),
              )
            : CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  completed ? Icons.check : Icons.hourglass_empty,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ),
        title: Text(sessionTypeLabel(session.sessionType)),
        subtitle: Text(
          '$timeLabel · ${session.wordsStudied} 词 · 正确率 $accuracy%',
        ),
        trailing: selectionMode
            ? null
            : PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    _delete(context, ref);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline),
                        SizedBox(width: 8),
                        Text('删除'),
                      ],
                    ),
                  ),
                ],
              ),
        onTap: () {
          if (selectionMode) {
            onToggleSelect();
            return;
          }
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => SessionDetailPage(sessionId: session.id),
            ),
          );
        },
      ),
    );

    if (selectionMode) {
      return tile;
    }

    return Dismissible(
      key: ValueKey(session.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Theme.of(context).colorScheme.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) => confirmDeleteSession(context),
      onDismissed: (_) async {
        await deleteSessionRecord(ref: ref, sessionId: session.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('记录已删除')),
          );
        }
      },
      child: tile,
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

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