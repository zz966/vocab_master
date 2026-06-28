import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/category_labels.dart';
import '../../providers/study_provider.dart';
import '../../repositories/book_repository.dart';
import '../../widgets/feedback_banner.dart';
import 'add_word_page.dart';

class CreateBookPage extends ConsumerStatefulWidget {
  const CreateBookPage({super.key});

  @override
  ConsumerState<CreateBookPage> createState() => _CreateBookPageState();
}

class _CreateBookPageState extends ConsumerState<CreateBookPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _coverColor = '#607D8B';
  bool _saving = false;

  static const _colors = [
    '#607D8B',
    '#4CAF50',
    '#2196F3',
    '#9C27B0',
    '#FF9800',
    '#F44336',
    '#009688',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      showFeedbackBanner(
        context,
        message: '请输入单词书名称',
        type: FeedbackType.error,
      );
      return;
    }

    setState(() => _saving = true);
    final book = await ref.read(bookRepositoryProvider).createBook(
          title: title,
          description: _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          coverColor: _coverColor,
        );
    invalidateStudyData(ref);

    if (!mounted) {
      return;
    }

    setState(() => _saving = false);
    showFeedbackBanner(context, message: '「$title」创建成功');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => AddWordPage(bookId: book.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('创建单词书')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: '书名 *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              avatar: const Icon(Icons.edit_note, size: 18),
              label: Text(categoryLabel('custom')),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: '描述（可选）',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Text('封面颜色', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _colors.map((hex) {
              final color = Color(int.parse('FF${hex.substring(1)}', radix: 16));
              final selected = _coverColor == hex;
              return GestureDetector(
                onTap: () => setState(() => _coverColor = hex),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: color,
                  child: selected
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: _saving ? null : _create,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('创建并添加单词'),
          ),
        ],
      ),
    );
  }
}