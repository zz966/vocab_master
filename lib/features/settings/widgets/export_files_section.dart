import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../providers/export_refresh_provider.dart';
import '../../../utils/export_file.dart';

class ExportFilesSection extends ConsumerStatefulWidget {
  const ExportFilesSection({super.key});

  @override
  ConsumerState<ExportFilesSection> createState() => _ExportFilesSectionState();
}

class _ExportFilesSectionState extends ConsumerState<ExportFilesSection> {
  Future<List<ExportFileInfo>>? _filesFuture;
  Future<String?>? _dirFuture;
  ExportFileKind _kindFilter = ExportFileKind.all;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _filesFuture = listVocabExportFiles();
      _dirFuture = getDocumentsDirectoryPath();
    });
  }

  Future<void> _openDirectory(BuildContext context) async {
    final opened = await openDocumentsDirectory();
    if (!context.mounted) {
      return;
    }
    if (opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已打开导出目录')),
      );
      return;
    }

    final path = await getDocumentsDirectoryPath();
    if (path != null) {
      await copyExportPath(path);
    }
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          path == null ? '当前平台不支持打开目录' : '目录路径已复制到剪贴板',
        ),
      ),
    );
  }

  Future<void> _shareFile(BuildContext context, ExportFileInfo file) async {
    final result = await shareExportFile(file);
    if (!context.mounted) {
      return;
    }
    final message = switch (result) {
      ShareExportResult.shared => '已打开系统分享',
      ShareExportResult.contentCopied => '文件内容已复制，可粘贴分享',
      ShareExportResult.pathCopied => '文件路径已复制，可通过文件管理器分享',
      ShareExportResult.failed => '分享失败',
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _kindFilterLabel(ExportFileKind kind) {
    return switch (kind) {
      ExportFileKind.all => '全部',
      ExportFileKind.csv => 'CSV',
      ExportFileKind.json => 'JSON',
      ExportFileKind.png => '图片',
    };
  }

  Future<void> _deleteAllFiles(
    BuildContext context,
    List<ExportFileInfo> files,
  ) async {
    if (files.isEmpty) {
      return;
    }

    final count = files.length;
    final typeLabel = _kindFilter == ExportFileKind.all
        ? '全部'
        : _kindFilterLabel(_kindFilter);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('清空导出文件'),
        content: Text('确定删除 $typeLabel 类型下的 $count 个导出文件？'),
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
    );
    if (confirmed != true || !context.mounted) {
      return;
    }

    var deleted = 0;
    for (final file in files) {
      if (await deleteExportFile(file.path)) {
        deleted++;
      }
    }
    if (!context.mounted) {
      return;
    }
    _refresh();
    bumpExportFilesRevision(ref);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已删除 $deleted 个文件')),
    );
  }

  Future<void> _deleteFile(BuildContext context, ExportFileInfo file) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除导出文件'),
        content: Text('确定删除「${file.name}」？'),
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
    );
    if (confirmed != true || !context.mounted) {
      return;
    }

    final deleted = await deleteExportFile(file.path);
    if (!context.mounted) {
      return;
    }
    if (deleted) {
      _refresh();
      bumpExportFilesRevision(ref);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('文件已删除')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('删除失败')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(exportFilesRevisionProvider, (previous, next) {
      if (previous != next) {
        _refresh();
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<String?>(
          future: _dirFuture,
          builder: (context, snapshot) {
            final path = snapshot.data;
            return Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.folder_outlined,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '导出文件位置',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      path ?? '当前平台不支持本地文件导出',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (path != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '学习记录、复习队列、收藏夹、错题本、搜索结果均可导出；'
                        '设置页可导出完整学习数据；'
                        '周报图片保存后也会出现在此列表。',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _openDirectory(context),
                            icon: const Icon(Icons.folder_open, size: 18),
                            label: const Text('打开目录'),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () async {
                              await copyExportPath(path);
                              if (!context.mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('路径已复制')),
                              );
                            },
                            icon: const Icon(Icons.copy, size: 18),
                            label: const Text('复制路径'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: ExportFileKind.values.map((kind) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(_kindFilterLabel(kind)),
                  selected: _kindFilter == kind,
                  onSelected: (_) => setState(() => _kindFilter = kind),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<ExportFileInfo>>(
          future: _filesFuture,
          builder: (context, snapshot) {
            final allFiles = snapshot.data ?? [];
            final files =
                filterExportFilesByKind(allFiles, _kindFilter);
            final count = files.length;
            final total = allFiles.length;
            final countLabel = _kindFilter == ExportFileKind.all
                ? (count > 0 ? ' ($count)' : '')
                : (total > 0 ? ' ($count/$total)' : '');

            return Row(
              children: [
                Text(
                  '已导出文件$countLabel',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                if (count > 0)
                  TextButton(
                    onPressed: () => _deleteAllFiles(context, files),
                    child: const Text('清空列表'),
                  ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: '刷新列表',
                  onPressed: _refresh,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 4),
        FutureBuilder<List<ExportFileInfo>>(
          future: _filesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final allFiles = snapshot.data ?? [];
            final files =
                filterExportFilesByKind(allFiles, _kindFilter);
            if (allFiles.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '暂无导出文件',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }

            if (files.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '当前筛选下暂无文件',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }

            return Card(
              child: Column(
                children: [
                  for (var i = 0; i < files.length; i++) ...[
                    if (i > 0) const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        files[i].name.endsWith('.csv')
                            ? Icons.table_chart_outlined
                            : files[i].name.endsWith('.png')
                                ? Icons.image_outlined
                                : Icons.data_object,
                      ),
                      title: Text(files[i].name),
                      subtitle: Text(
                        '${describeExportFileName(files[i].name)} · '
                        '${formatExportFileSize(files[i].sizeBytes)} · '
                        '${DateFormat('yyyy-MM-dd HH:mm').format(files[i].modifiedAt)}',
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          switch (value) {
                            case 'share':
                              await _shareFile(context, files[i]);
                            case 'copy':
                              await copyExportPath(files[i].path);
                              if (!context.mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('文件路径已复制')),
                              );
                            case 'delete':
                              await _deleteFile(context, files[i]);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'share',
                            child: Text('系统分享'),
                          ),
                          PopupMenuItem(
                            value: 'copy',
                            child: Text('复制路径'),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('删除'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}