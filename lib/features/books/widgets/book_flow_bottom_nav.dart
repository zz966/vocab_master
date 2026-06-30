import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router.dart';
import '../../../providers/study_provider.dart';

class BookFlowBottomNav extends ConsumerWidget {
  const BookFlowBottomNav({
    super.key,
    this.selectedIndex = AppTab.books,
  });

  final int selectedIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        ref.read(navigationIndexProvider.notifier).setIndex(index);
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: '首页',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book),
          label: '单词书',
        ),
        NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: '查单词',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: '我的',
        ),
      ],
    );
  }
}