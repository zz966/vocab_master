import 'package:flutter/material.dart';

import '../../../models/word.dart';
import '../../../utils/book_content_utils.dart';
import '../../../utils/word_enrichment.dart';
import 'example_sentence_row.dart';
import 'highlighted_text.dart';
import 'tts_speak_button.dart';

enum WordDetailTab {
  examples('例句'),
  phrases('常用短语'),
  synonyms('近义词'),
  englishDefinition('英语释义'),
  etymology('词根词缀');

  const WordDetailTab(this.label);

  final String label;
}

class WordDetailTabContent extends StatelessWidget {
  const WordDetailTabContent({
    super.key,
    required this.word,
    required this.tab,
    this.peerWords = const [],
  });

  final Word word;
  final WordDetailTab tab;
  final List<Word> peerWords;

  @override
  Widget build(BuildContext context) {
    return switch (tab) {
      WordDetailTab.examples => _ExamplesContent(word: word),
      WordDetailTab.phrases => _PhrasesContent(word: word),
      WordDetailTab.synonyms => _SynonymsContent(
          word: word,
          peerWords: peerWords,
        ),
      WordDetailTab.englishDefinition => _EnglishDefinitionContent(word: word),
      WordDetailTab.etymology => _EtymologyContent(word: word),
    };
  }
}

class _ExamplesContent extends StatelessWidget {
  const _ExamplesContent({required this.word});

  final Word word;

  @override
  Widget build(BuildContext context) {
    final examples = word.structuredExamples;
    if (examples.isEmpty) {
      return const _EmptyContent(message: '没有');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: examples.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final example = examples[index];
        return Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: HighlightedText(
                        text: example.english,
                        highlight: word.english,
                      ),
                    ),
                    ExampleSentenceRow(
                      example: example.english,
                      showText: false,
                    ),
                  ],
                ),
                if (example.chinese.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    example.chinese,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PhrasesContent extends StatelessWidget {
  const _PhrasesContent({required this.word});

  final Word word;

  @override
  Widget build(BuildContext context) {
    final phrases = word.collocations ?? const <WordPhrase>[];
    if (phrases.isEmpty) {
      return const _EmptyContent(message: '没有');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: phrases.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final phrase = phrases[index];
        final exampleEnglish = phrase.exampleEnglish?.trim() ?? '';
        final exampleChinese = phrase.exampleChinese?.trim() ?? '';

        return Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        phrase.phrase,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    TtsSpeakButton(
                      text: phrase.phrase,
                      tooltip: '朗读短语',
                      icon: Icons.volume_up_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  phrase.translation,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                if (exampleEnglish.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          exampleEnglish,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      TtsSpeakButton(
                        text: exampleEnglish,
                        tooltip: '朗读例句',
                        icon: Icons.volume_up_outlined,
                      ),
                    ],
                  ),
                  if (exampleChinese.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      exampleChinese,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SynonymsContent extends StatelessWidget {
  const _SynonymsContent({
    required this.word,
    required this.peerWords,
  });

  final Word word;
  final List<Word> peerWords;

  @override
  Widget build(BuildContext context) {
    final synonymItems = _synonymItems(word, peerWords);
    if (synonymItems.isEmpty) {
      return const _EmptyContent(message: '没有');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: synonymItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = synonymItems[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          tileColor: Theme.of(context).colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.word,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              TtsSpeakButton(
                text: item.word,
                tooltip: '朗读近义词',
                icon: Icons.volume_up_outlined,
              ),
            ],
          ),
          subtitle: Text(
            item.explanation.trim().isEmpty ? '没有' : item.explanation,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        );
      },
    );
  }
}

class _EnglishDefinitionContent extends StatelessWidget {
  const _EnglishDefinitionContent({required this.word});

  final Word word;

  @override
  Widget build(BuildContext context) {
    final definitions =
        word.englishDefinitions ?? word.definitions ?? const <WordDefinition>[];

    if (definitions.isEmpty) {
      return const _EmptyContent(message: '没有');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: definitions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final definition = definitions[index];

        return Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (definition.partOfSpeech.trim().isNotEmpty)
                  Text(
                    definition.partOfSpeech,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                if (definition.partOfSpeech.trim().isNotEmpty)
                  const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        definition.meaning,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TtsSpeakButton(
                      text: definition.meaning,
                      tooltip: '朗读英语释义',
                      icon: Icons.volume_up_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EtymologyContent extends StatelessWidget {
  const _EtymologyContent({required this.word});

  final Word word;

  @override
  Widget build(BuildContext context) {
    final etymology = word.memoryTips?.etymology?.trim();
    final root = word.root.trim();
    final text = (etymology != null && etymology.isNotEmpty)
        ? etymology
        : root.isNotEmpty
            ? '词根：$root'
            : null;

    if (text == null) {
      return const _EmptyContent(message: '没有');
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }
}

List<ConfusableWord> _synonymItems(Word word, List<Word> peerWords) {
  if (word.synonymDetails != null && word.synonymDetails!.isNotEmpty) {
    return word.synonymDetails!;
  }
  if (word.synonyms.isNotEmpty) {
    return word.synonyms
        .map(
          (item) => ConfusableWord()
            ..word = item
            ..explanation = '',
        )
        .toList();
  }
  if (isRichBookWord(word)) {
    return const [];
  }
  return WordEnrichment.buildSynonyms(word, peerWords);
}

class _EmptyContent extends StatelessWidget {
  const _EmptyContent({
    required this.message,
    this.child,
  });

  final String message;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (child != null) ...[
              child!,
              const SizedBox(height: 12),
            ],
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}