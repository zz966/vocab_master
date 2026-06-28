import 'package:flutter/material.dart';

import '../../../models/word.dart';
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
    final examples = word.structuredExamples ?? const <WordExample>[];
    if (examples.isEmpty) {
      return const _EmptyContent(message: '暂无例句');
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
      return const _EmptyContent(message: '暂无常用短语');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: phrases.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final phrase = phrases[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          tileColor: Theme.of(context).colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  phrase.phrase,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              TtsSpeakButton(
                text: phrase.phrase,
                tooltip: '朗读短语',
                icon: Icons.volume_up_outlined,
              ),
            ],
          ),
          subtitle: Text(phrase.translation),
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
    final synonyms = WordEnrichment.buildSynonyms(word, peerWords);
    if (synonyms.isEmpty) {
      return const _EmptyContent(message: '暂无近义词');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: synonyms.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = synonyms[index];
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
          subtitle: Text(item.explanation),
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
    final definitions = word.definitions ?? const <WordDefinition>[];
    final examples = word.structuredExamples ?? const <WordExample>[];

    if (definitions.isEmpty) {
      return _EmptyContent(
        message: 'No English definition available.',
        child: Text(
          word.english,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: definitions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final definition = definitions[index];
        final matchedExample = examples
            .where(
              (example) =>
                  example.partOfSpeech == definition.partOfSpeech &&
                  example.meaning == definition.meaning,
            )
            .map((example) => example.english)
            .firstOrNull;

        final englishText = matchedExample ??
            'The word "${word.english}" (${definition.partOfSpeech}) '
                'expresses the meaning of "${definition.meaning}".';

        return Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  definition.partOfSpeech,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  englishText,
                  style: Theme.of(context).textTheme.bodyLarge,
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
    if (etymology == null || etymology.isEmpty) {
      return const _EmptyContent(message: '暂无词根词缀信息');
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
              etymology,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }
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