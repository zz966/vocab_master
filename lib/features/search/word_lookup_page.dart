import 'package:flutter/material.dart';

class WordLookupPage extends StatelessWidget {
  const WordLookupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('查单词'),
      ),
      body: const SizedBox.shrink(),
    );
  }
}