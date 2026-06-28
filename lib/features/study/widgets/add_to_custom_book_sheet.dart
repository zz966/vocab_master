import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/word.dart';
import '../../../providers/book_provider.dart';
import '../../../providers/study_provider.dart';
import '../../../repositories/book_repository.dart';
import '../../../widgets/feedback_banner.dart';
import '../../books/create_book_page.dart';

Future<void> showAddToCustomBookSheet(
  BuildContext context,
  WidgetRef ref,
  Word word,
) async {
  final books = await ref.read(booksProvider.future);
  final customBooks =
      books.where((progress) => progress.isCustom).toList();

  if (!context.mounted) {
    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '加入自定义单词书',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                '${word.english} · ${word.chinese}',
                style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 12),
              if (customBooks.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    '还没有自定义单词书，先创建一个吧',
                    style: Theme.of(sheetContext).textTheme.bodyMedium,
                  ),
                )
              else
                ...customBooks.map((progress) {
                  final alreadyIn =
                      word.bookIds.contains(progress.book.id);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(
                        int.parse(
                          'FF${(progress.book.coverColor ?? '#607D8B').substring(1)}',
                          radix: 16,
                        ),
                      ),
                      child: Text(
                        progress.book.title.isNotEmpty
                            ? progress.book.title[0]
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(progress.book.title),
                    subtitle: Text(
                      alreadyIn
                          ? '已在本书中'
                          : '${progress.totalWords} 词',
                    ),
                    trailing: alreadyIn
                        ? const Icon(Icons.check, color: Colors.green)
                        : const Icon(Icons.add),
                    onTap: alreadyIn
                        ? null
                        : () async {
                            await ref
                                .read(bookRepositoryProvider)
                                .addWordToBook(
                                  bookId: progress.book.id,
                                  english: word.english,
                                  chinese: word.chinese,
                                  phonetic: word.phonetic,
                                  partOfSpeech: word.partOfSpeech,
                                  examples: word.examples,
                                );
                            invalidateStudyData(ref);
                            if (sheetContext.mounted) {
                              Navigator.pop(sheetContext);
                            }
                            if (context.mounted) {
                              showFeedbackBanner(
                                context,
                                message:
                                    '已加入「${progress.book.title}」',
                              );
                            }
                          },
                  );
                }),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('创建新单词书'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const CreateBookPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}