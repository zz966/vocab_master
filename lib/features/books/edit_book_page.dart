import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/word_book.dart';
import '../../providers/study_provider.dart';
import '../../repositories/book_repository.dart';

class EditBookPage extends ConsumerStatefulWidget {
  const EditBookPage({super.key, required this.book});

  final WordBook book;

  @override
  ConsumerState<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends ConsumerState<EditBookPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late String _coverColor;
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
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _descController =
        TextEditingController(text: widget.book.description);
    _coverColor = widget.book.coverColor;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      return;
    }

    setState(() => _saving = true);
    widget.book
      ..title = title
      ..description = _descController.text.trim()
      ..coverColor = _coverColor;

    await ref.read(bookRepositoryProvider).updateBook(widget.book);
    invalidateStudyData(ref);

    if (mounted) {
      setState(() => _saving = false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('编辑单词书')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: '书名',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: '描述',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: _colors.map((hex) {
              final color = Color(int.parse('FF${hex.substring(1)}', radix: 16));
              return GestureDetector(
                onTap: () => setState(() => _coverColor = hex),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: color,
                  child: _coverColor == hex
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const CircularProgressIndicator(strokeWidth: 2)
                : const Text('保存'),
          ),
        ],
      ),
    );
  }
}