import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/batch_word_import.dart';

Future<List<BatchWordLine>?> showBatchImportDialog(BuildContext context) {
  final controller = TextEditingController();

  return showDialog<List<BatchWordLine>>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('批量导入单词'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '每行一个单词，支持格式：\n'
              'english,chinese\n'
              'english\tchinese\n'
              'english - chinese',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 8,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'hello,你好\nworld,世界',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final data = await Clipboard.getData(Clipboard.kTextPlain);
            if (data?.text != null) {
              controller.text = data!.text!;
            }
          },
          child: const Text('粘贴'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            final lines = parseBatchWordLines(controller.text);
            if (lines.isEmpty) {
              return;
            }
            Navigator.pop(context, lines);
          },
          child: const Text('导入'),
        ),
      ],
    ),
  ).whenComplete(controller.dispose);
}