import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/data/built_in_books.dart';
import 'package:vocab_master/features/books/books_page.dart';
import 'package:vocab_master/features/books/widgets/book_card.dart';
import 'package:vocab_master/models/word_book.dart';
import 'package:vocab_master/providers/book_provider.dart';
import 'package:vocab_master/repositories/book_repository.dart';
import 'package:vocab_master/utils/kylebing_vocab_codec.dart';

class _FakeBooksNotifier extends BooksNotifier {
  _FakeBooksNotifier(this._list);

  final List<BookProgress> _list;

  @override
  Future<List<BookProgress>> build() async => _list;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('built-in KyleBing assets decode to vocabulary lists', () async {
    for (final definition in BuiltInBooks.books) {
      final json = await rootBundle.loadString(definition.assetPath);
      final words = KyleBingVocabCodec.decode(json);

      expect(words, isNotEmpty, reason: definition.assetPath);
      expect(words.first.english, isNotEmpty);
      expect(words.first.chinese, isNotEmpty);
    }
  });

  test('BuiltInBooks metadata matches app categories', () {
    expect(BuiltInBooks.books, hasLength(5));
    expect(
      BuiltInBooks.books.map((book) => book.category).toSet(),
      {'basic', 'cet4', 'cet6', 'ielts', 'toefl'},
    );
  });

  testWidgets('BooksPage shows built-in book titles from provider', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final progressList = BuiltInBooks.books
        .map(
          (definition) => BookProgress(
            book: WordBook()
              ..title = definition.title
              ..description = definition.description
              ..category = definition.category
              ..coverColor = definition.coverColor
              ..totalWords = 120,
            totalWords: 120,
            masteredWords: 0,
            learnedWords: 0,
          ),
        )
        .toList();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          booksProvider.overrideWith(
            () => _FakeBooksNotifier(progressList),
          ),
        ],
        child: const MaterialApp(home: BooksPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(BookCard), findsNWidgets(BuiltInBooks.books.length));

    for (final definition in BuiltInBooks.books) {
      expect(find.text(definition.title), findsOneWidget);
    }
  });
}