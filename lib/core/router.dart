import 'package:flutter/material.dart';

import '../features/books/books_page.dart';
import '../features/books/challenge_levels_page.dart';
import '../features/books/level_selection_page.dart';
import '../features/books/quick_browse_page.dart';
import '../features/home/home_page.dart';
import '../features/shell/main_shell.dart';
import '../features/stats/me_page.dart';
import '../features/search/word_lookup_page.dart';
import '../features/study/word_detail_page.dart';

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
  static const bookLevels = '/books/levels';
  static const quickBrowse = '/books/quick-browse';
  static const challengeLevels = '/books/challenge';
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
      AppRoutes.quickBrowse => MaterialPageRoute<void>(
          builder: (_) {
            final args = settings.arguments;
            if (args is Map<String, String>) {
              return QuickBrowsePage(
                bookId: args['bookId']!,
                bookTitle: args['bookTitle'] ?? '速刷模式',
              );
            }
            return const Scaffold(
              body: Center(child: Text('缺少单词书参数')),
            );
          },
        ),
      AppRoutes.challengeLevels => MaterialPageRoute<void>(
          builder: (_) {
            final args = settings.arguments;
            if (args is Map<String, String>) {
              return ChallengeLevelsPage(
                bookId: args['bookId']!,
                bookTitle: args['bookTitle'] ?? '挑战模式',
              );
            }
            return const Scaffold(
              body: Center(child: Text('缺少单词书参数')),
            );
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

  static Future<void> pushQuickBrowse(
    BuildContext context, {
    required String bookId,
    required String bookTitle,
  }) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => QuickBrowsePage(
          bookId: bookId,
          bookTitle: bookTitle,
        ),
      ),
    );
  }

  static Future<void> pushChallengeLevels(
    BuildContext context, {
    required String bookId,
    required String bookTitle,
  }) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ChallengeLevelsPage(
          bookId: bookId,
          bookTitle: bookTitle,
        ),
      ),
    );
  }

  static Future<void> pushWordDetail(
    BuildContext context, {
    required String wordId,
    String? bookId,
    String? bookTitle,
    List<String>? wordIds,
    int? levelIndex,
    int? initialMaxWordIndex,
  }) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => WordDetailPage(
          wordId: wordId,
          bookId: bookId,
          bookTitle: bookTitle,
          wordIds: wordIds,
          levelIndex: levelIndex,
          initialMaxWordIndex: initialMaxWordIndex,
        ),
      ),
    );
  }
}