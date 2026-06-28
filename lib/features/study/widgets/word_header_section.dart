import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/word.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/study_provider.dart';

class WordHeaderSection extends ConsumerStatefulWidget {
  const WordHeaderSection({
    super.key,
    required this.word,
    this.showDefinitions = true,
  });

  final Word word;
  final bool showDefinitions;

  @override
  ConsumerState<WordHeaderSection> createState() => _WordHeaderSectionState();
}

class _WordHeaderSectionState extends ConsumerState<WordHeaderSection> {
  String? _selectedPartOfSpeech;

  @override
  Widget build(BuildContext context) {
    final definitions = widget.word.definitions ?? [];
    final parts = definitions.map((item) => item.partOfSpeech).toList();
    final selected = _selectedPartOfSpeech ??
        (parts.isNotEmpty ? parts.first : widget.word.partOfSpeech);
    final matchedDefinitions =
        definitions.where((item) => item.partOfSpeech == selected);
    final selectedMeaning = matchedDefinitions.isEmpty
        ? null
        : matchedDefinitions.first.meaning;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.word.english,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (widget.word.phonetic != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.word.phonetic!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            FilledButton.icon(
              onPressed: () => _speak(widget.word.english, 'en-US'),
              icon: const Icon(Icons.volume_up),
              label: const Text('美式'),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () => _speak(widget.word.english, 'en-GB'),
              icon: const Icon(Icons.record_voice_over_outlined),
              label: const Text('英式'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (parts.length > 1)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: parts.map((part) {
              return ChoiceChip(
                label: Text(part),
                selected: selected == part,
                onSelected: (_) => setState(() => _selectedPartOfSpeech = part),
              );
            }).toList(),
          )
        else if (widget.word.partOfSpeech != null)
          Chip(label: Text(widget.word.partOfSpeech!)),
        if (widget.showDefinitions) ...[
          const SizedBox(height: 12),
          Text(
            selectedMeaning ?? widget.word.chinese,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ],
    );
  }

  Future<void> _speak(String text, String accent) async {
    final settings = ref.read(settingsProvider).valueOrNull;
    final tts = ref.read(ttsServiceProvider);
    await tts.setAccent(accent);
    await tts.speak(text);
    if (settings != null && settings.ttsAccent != accent) {
      await tts.setAccent(settings.ttsAccent);
    }
  }
}