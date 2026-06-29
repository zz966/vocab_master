import 'package:flutter/material.dart';

import '../features/books/book_detail_page.dart';
import '../features/books/book_selection_page.dart';
import '../features/books/books_page.dart';
import '../features/books/level_selection_page.dart';
import '../features/home/home_page.dart';
import '../features/shell/main_shell.dart';
import '../features/stats/me_page.dart';
import '../features/search/word_lookup_page.dart';
import '../features/study/study_session_page.dart';
import '../core/study_mode.dart';

/// Tab indices for [MainShell] bottom navigation.
abstract final class AppTab {
  static const int home = 0;
  static const int books = 1;
  static const int study = 2;
  static const int me = 3;
}

/// Named routes used by Navigator pushes across the app.
abstract final class AppRoutes {
  static const shell = '/';
  static const home = '/home';
  static const books = '/books';
  static const study = '/study';
  static const me = '/me';
  static const bookSelection = '/books/select';
  static const bookDetail = '/books/detail';
  static const bookLevels = '/books/levels';
  static const studySession = '/study/session';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      AppRoutes.shell => MaterialPageRoute<void>(
          builder: (_) => const MainShell(),
        ),
      AppRoutes.home => MaterialPageRoute<void>(
          builder: (_) => const HomePage(),
        ),
      AppRoutes.books => MaterialPageRoute<void>(
          builder: (_) => const BooksPage(),
        ),
      AppRoutes.study => MaterialPageRoute<void>(
          builder: (_) => const WordLookupPage(),
        ),
      AppRoutes.me => MaterialPageRoute<void>(
          builder: (_) => const MePage(),
        ),
      AppRoutes.bookSelection => MaterialPageRoute<void>(
          builder: (_) => const BookSelectionPage(),
        ),
      AppRoutes.bookDetail => MaterialPageRoute<void>(
          builder: (_) {
            final bookId = settings.arguments as String?;
            if (bookId == null) {
              return const Scaffold(
                body: Center(child: Text('缺少单词书 ID')),
              );
            }
            return BookDetailPage(bookId: bookId);
          },
        ),
      AppRoutes.bookLevels => MaterialPageRoute<void>(
          builder: (_) {
            final args = settings.arguments;
            if (args is Map<String, String>) {
              return LevelSelectionPage(
                bookId: args['bookId']!,
                bookTitle: args['bookTitle'] ?? '关卡列表',
              );
            }
            return const Scaffold(
              body: Center(child: Text('缺少单词书参数')),
            );
          },
        ),
      AppRoutes.studySession => MaterialPageRoute<void>(
          builder: (_) {
            final args = settings.arguments;
            final mode = args is StudyMode ? args : StudyMode.flashcard;
            return StudySessionPage(mode: mode);
          },
        ),
      _ => MaterialPageRoute<void>(
          builder: (_) => const MainShell(),
        ),
    };
  }

  static Future<void> pushBookLevels(
    BuildContext context, {
    required String bookId,
    required String bookTitle,
  }) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => LevelSelectionPage(
          bookId: bookId,
          bookTitle: bookTitle,
        ),
      ),
    );
  }

  static Future<void> pushBookDetail(BuildContext context, String bookId) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => BookDetailPage(bookId: bookId),
      ),
    );
  }

  static Future<void> pushBookSelection(BuildContext context) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const BookSelectionPage(),
      ),
    );
  }

  static Future<void> pushStudySession(
    BuildContext context, {
    required StudyMode mode,
  }) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => StudySessionPage(mode: mode),
      ),
    );
  }
}