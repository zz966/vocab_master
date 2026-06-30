import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/word.dart';
import '../../../utils/phonetic_utils.dart';
import '../../../utils/word_display_utils.dart';
import '../../study/widgets/tts_speak_button.dart';

class QuickBrowseWordItem extends ConsumerWidget {
  const QuickBrowseWordItem({
    super.key,
    required this.word,
    required this.selected,
    required this.onTap,
    required this.onOpenDetail,
  });

  final Word word;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final definitions = displayDefinitions(word);
    final phonetic = resolvePhoneticUk(
      phoneticUk: word.phoneticUk,
      phoneticUs: word.phoneticUs,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            word.english,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (phonetic.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              phonetic,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        TtsSpeakButton(
                          text: word.english,
                          icon: Icons.volume_up_outlined,
                          iconSize: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if (definitions.isNotEmpty)
                      ...definitions.map(
                        (definition) => Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${definition.partOfSpeech} ',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: definition.meaning,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else if (word.chinese.trim().isNotEmpty)
                      Text.rich(
                        TextSpan(
                          children: [
                            if (word.partOfSpeech.trim().isNotEmpty)
                              TextSpan(
                                text: '${word.partOfSpeech} ',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            TextSpan(
                              text: word.chinese,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onOpenDetail,
                icon: const Icon(Icons.arrow_forward_ios, size: 18),
                tooltip: '查看详情',
              ),
            ],
          ),
        ),
      ),
    );
  }
}