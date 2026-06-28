import 'package:flutter/material.dart';

import 'word_collection_page.dart';

/// Simple favorites list (full features in [WordCollectionPage]).
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WordCollectionPage(
      title: '收藏夹',
      isWrongBook: false,
    );
  }
}