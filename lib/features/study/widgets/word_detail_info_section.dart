import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/word.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/study_provider.dart';


class WordDetailInfoSection extends ConsumerWidget {
  const WordDetailInfoSection({super.key, required this.word});

  final Word word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final phonetic = word.phonetic?.trim();
    final definitions = word.definitions ?? const <WordDefinition>[];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            word.english,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (phonetic != null && phonetic.isNotEmpty) ...[
            const SizedBox(height: 12),
            _PhoneticRow(
              label: '英',
              phonetic: phonetic,
              onSpeak: () => _speak(ref, word.english, 'en-GB'),
            ),
            const SizedBox(height: 8),
            _PhoneticRow(
              label: '美',
              phonetic: phonetic,
              onSpeak: () => _speak(ref, word.english, 'en-US'),
            ),
          ] else ...[
            const SizedBox(height: 12),
            Row(
              children: [
                _AccentChip(
                  label: '英',
                  onPressed: () => _speak(ref, word.english, 'en-GB'),
                ),
                const SizedBox(width: 8),
                _AccentChip(
                  label: '美',
                  onPressed: () => _speak(ref, word.english, 'en-US'),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          if (definitions.isNotEmpty)
            ...definitions.map(
              (definition) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${definition.partOfSpeech} ',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: definition.meaning,
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Text.rich(
              TextSpan(
                children: [
                  if (word.partOfSpeech != null &&
                      word.partOfSpeech!.trim().isNotEmpty)
                    TextSpan(
                      text: '${word.partOfSpeech} ',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  TextSpan(
                    text: word.chinese,
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _speak(WidgetRef ref, String text, String accent) async {
    final settings = ref.read(settingsProvider).valueOrNull;
    final tts = ref.read(ttsServiceProvider);
    await tts.setAccent(accent);
    await tts.speak(text);
    if (settings != null && settings.ttsAccent != accent) {
      await tts.setAccent(settings.ttsAccent);
    }
  }
}

class _PhoneticRow extends StatelessWidget {
  const _PhoneticRow({
    required this.label,
    required this.phonetic,
    required this.onSpeak,
  });

  final String label;
  final String phonetic;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onSpeak,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Container(
              width: 28,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                phonetic,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            IconButton(
              onPressed: onSpeak,
              icon: const Icon(Icons.volume_up_outlined),
              tooltip: label == '英' ? '英式发音' : '美式发音',
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}

class _AccentChip extends StatelessWidget {
  const _AccentChip({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text('$label 发音'),
      avatar: const Icon(Icons.volume_up_outlined, size: 18),
      onPressed: onPressed,
    );
  }
}