import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/word.dart';
import '../../providers/book_provider.dart';
import '../../providers/study_provider.dart';
import '../../providers/word_provider.dart';
import '../../repositories/book_repository.dart';
import '../../services/ai_service.dart';
import '../../widgets/feedback_banner.dart';

class AddWordPage extends ConsumerStatefulWidget {
  const AddWordPage({
    super.key,
    required this.bookId,
    this.word,
  });

  final String bookId;
  final Word? word;

  bool get isEditing => word != null;

  @override
  ConsumerState<AddWordPage> createState() => _AddWordPageState();
}

class _AddWordPageState extends ConsumerState<AddWordPage> {
  late final TextEditingController _englishController;
  late final TextEditingController _chineseController;
  late final TextEditingController _phoneticController;
  late final TextEditingController _posController;
  late final TextEditingController _examplesController;
  bool _saving = false;
  bool _generatingExamples = false;

  @override
  void initState() {
    super.initState();
    final word = widget.word;
    _englishController = TextEditingController(text: word?.english ?? '');
    _chineseController = TextEditingController(text: word?.chinese ?? '');
    _phoneticController = TextEditingController(text: word?.phonetic ?? '');
    _posController = TextEditingController(text: word?.partOfSpeech ?? '');
    _examplesController = TextEditingController(
      text: word?.examples?.join('\n') ?? '',
    );
  }

  @override
  void dispose() {
    _englishController.dispose();
    _chineseController.dispose();
    _phoneticController.dispose();
    _posController.dispose();
    _examplesController.dispose();
    super.dispose();
  }

  List<String>? _parseExamples() {
    final lines = _examplesController.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    return lines.isEmpty ? null : lines;
  }

  void _invalidate() {
    invalidateStudyData(ref);
    ref.invalidate(bookWordsProvider(widget.bookId));
    ref.invalidate(bookProgressProvider(widget.bookId));
  }

  void _clearForm() {
    _englishController.clear();
    _chineseController.clear();
    _phoneticController.clear();
    _posController.clear();
    _examplesController.clear();
  }

  Future<void> _generateExamples() async {
    final english = _englishController.text.trim();
    final chinese = _chineseController.text.trim();
    if (english.isEmpty || chinese.isEmpty) {
      showFeedbackBanner(
        context,
        message: '请先填写英文和中文',
        type: FeedbackType.error,
      );
      return;
    }

    setState(() => _generatingExamples = true);
    final examples = await AiService.instance.generateExamples(
      english: english,
      chinese: chinese,
      partOfSpeech: _posController.text.trim().isEmpty
          ? null
          : _posController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    setState(() => _generatingExamples = false);

    if (examples == null || examples.isEmpty) {
      showFeedbackBanner(
        context,
        message: 'AI 例句功能即将上线（Grok API）',
        type: FeedbackType.info,
      );
      return;
    }

    _examplesController.text = examples.join('\n');
    showFeedbackBanner(context, message: '已生成 ${examples.length} 条例句');
  }

  Future<bool> _save({bool addAnother = false}) async {
    final english = _englishController.text.trim();
    final chinese = _chineseController.text.trim();
    if (english.isEmpty || chinese.isEmpty) {
      showFeedbackBanner(
        context,
        message: '请填写英文和中文释义',
        type: FeedbackType.error,
      );
      return false;
    }

    setState(() => _saving = true);

    final phonetic = _phoneticController.text.trim();
    final pos = _posController.text.trim();
    final examples = _parseExamples();

    try {
      if (widget.isEditing) {
        await ref.read(wordRepositoryProvider).updateWordFields(
              widget.word!,
              english: english,
              chinese: chinese,
              phonetic: phonetic.isEmpty ? null : phonetic,
              partOfSpeech: pos.isEmpty ? null : pos,
              examples: examples,
            );
      } else {
        await ref.read(bookRepositoryProvider).addWordToBook(
              bookId: widget.bookId,
              english: english,
              chinese: chinese,
              phonetic: phonetic.isEmpty ? null : phonetic,
              partOfSpeech: pos.isEmpty ? null : pos,
              examples: examples,
            );
      }

      _invalidate();

      if (!mounted) {
        return false;
      }

      setState(() => _saving = false);
      showFeedbackBanner(
        context,
        message: widget.isEditing ? '单词已更新' : '单词已添加',
      );

      if (addAnother && !widget.isEditing) {
        _clearForm();
        return true;
      }

      Navigator.of(context).pop();
      return true;
    } catch (error) {
      if (mounted) {
        setState(() => _saving = false);
        showFeedbackBanner(
          context,
          message: '保存失败: $error',
          type: FeedbackType.error,
        );
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? '编辑单词' : '添加单词'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _englishController,
            decoration: const InputDecoration(
              labelText: '英文 *',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.none,
            autocorrect: false,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _chineseController,
            decoration: const InputDecoration(
              labelText: '中文释义 *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phoneticController,
            decoration: const InputDecoration(
              labelText: '音标（可选）',
              border: OutlineInputBorder(),
              hintText: '/ˈwɜːrd/',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _posController,
            decoration: const InputDecoration(
              labelText: '词性（可选）',
              border: OutlineInputBorder(),
              hintText: 'n. / v. / adj.',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _examplesController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: '例句（可选，每行一句）',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: _generatingExamples ? null : _generateExamples,
              icon: _generatingExamples
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome, size: 18),
              label: const Text('AI 生成例句'),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : () => _save(),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.isEditing ? '保存' : '添加单词'),
          ),
          if (!widget.isEditing) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _saving ? null : () => _save(addAnother: true),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('添加并继续'),
            ),
          ],
        ],
      ),
    );
  }
}