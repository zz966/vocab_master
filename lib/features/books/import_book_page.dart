import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/study_provider.dart';
import '../../repositories/book_repository.dart';
import '../../utils/export_file.dart';
import 'book_detail_page.dart';

class ImportBookPage extends ConsumerStatefulWidget {
  const ImportBookPage({super.key});

  @override
  ConsumerState<ImportBookPage> createState() => _ImportBookPageState();
}

class _ImportBookPageState extends ConsumerState<ImportBookPage> {
  final _controller = TextEditingController();
  bool _importing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text == null || text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('剪贴板为空')),
        );
      }
      return;
    }
    _controller.text = text;
  }

  Future<void> _import() async {
    final json = _controller.text.trim();
    if (json.isEmpty) {
      return;
    }

    setState(() => _importing = true);
    try {
      final book = await ref.read(bookRepositoryProvider).importBookFromJson(json);
      invalidateStudyData(ref);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => BookDetailPage(bookId: book.id),
        ),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导入失败: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _importing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('导入单词书')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '粘贴 JSON 格式的单词书数据。可从导出的文件中复制内容。',
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _importing ? null : _pasteFromClipboard,
              icon: const Icon(Icons.content_paste),
              label: const Text('从剪贴板粘贴'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '{"version":1,"title":"我的单词书","words":[...]}',
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _importing ? null : _import,
              child: _importing
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : const Text('导入'),
            ),
          ],
        ),
      ),
    );
  }
}

void showExportDialog(
  BuildContext context,
  String json,
  String title, {
  String? savedPath,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('导出 · $title'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: SelectableText(
            json,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
      actions: [
        if (savedPath != null)
          TextButton(
            onPressed: () async {
              final fileName = savedPath.split(RegExp(r'[/\\]')).last;
              final result = await shareFileAtPath(savedPath, name: fileName);
              if (!context.mounted) {
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    result == ShareExportResult.shared
                        ? '已打开分享'
                        : '分享失败',
                  ),
                ),
              );
            },
            child: const Text('分享文件'),
          )
        else
          TextButton(
            onPressed: () async {
              final path = await saveTextToDocuments(
                content: json,
                fileName: 'vocab_export_$title.json',
              );
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      path == null ? '已跳过保存（Web 平台）' : '已保存到 $path',
                    ),
                  ),
                );
              }
            },
            child: const Text('保存文件'),
          ),
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: json));
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('已复制到剪贴板')),
            );
          },
          child: const Text('复制'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('关闭'),
        ),
      ],
    ),
  );
}