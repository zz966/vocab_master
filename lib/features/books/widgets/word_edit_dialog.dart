import 'package:flutter/material.dart';

import '../../../models/word.dart';

class WordEditResult {
  const WordEditResult({
    required this.english,
    required this.chinese,
    this.phonetic,
    this.partOfSpeech,
  });

  final String english;
  final String chinese;
  final String? phonetic;
  final String? partOfSpeech;
}

Future<WordEditResult?> showWordEditDialog(
  BuildContext context, {
  Word? word,
}) {
  final englishController = TextEditingController(text: word?.english ?? '');
  final chineseController = TextEditingController(text: word?.chinese ?? '');
  final phoneticController = TextEditingController(text: word?.phonetic ?? '');
  final posController =
      TextEditingController(text: word?.partOfSpeech ?? '');

  return showDialog<WordEditResult>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(word == null ? '添加单词' : '编辑单词'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: englishController,
              decoration: const InputDecoration(
                labelText: '英文',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: chineseController,
              decoration: const InputDecoration(
                labelText: '中文',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: phoneticController,
              decoration: const InputDecoration(
                labelText: '音标',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: posController,
              decoration: const InputDecoration(
                labelText: '词性',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            final english = englishController.text.trim();
            final chinese = chineseController.text.trim();
            if (english.isEmpty || chinese.isEmpty) {
              return;
            }
            Navigator.pop(
              context,
              WordEditResult(
                english: english,
                chinese: chinese,
                phonetic: phoneticController.text.trim().isEmpty
                    ? null
                    : phoneticController.text.trim(),
                partOfSpeech: posController.text.trim().isEmpty
                    ? null
                    : posController.text.trim(),
              ),
            );
          },
          child: const Text('保存'),
        ),
      ],
    ),
  ).whenComplete(() {
    englishController.dispose();
    chineseController.dispose();
    phoneticController.dispose();
    posController.dispose();
  });
}