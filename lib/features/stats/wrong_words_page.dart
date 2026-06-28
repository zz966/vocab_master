import 'package:flutter/material.dart';

import 'word_collection_page.dart';

/// Simple wrong-words list (full features in [WordCollectionPage]).
class WrongWordsPage extends StatelessWidget {
  const WrongWordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WordCollectionPage(
      title: '错题本',
      isWrongBook: true,
    );
  }
}