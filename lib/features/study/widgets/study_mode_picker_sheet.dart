import 'package:flutter/material.dart';

import '../../../core/study_mode.dart';
import 'study_mode_list.dart';

Future<StudyMode?> showStudyModePicker(BuildContext context) {
  return showModalBottomSheet<StudyMode>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('选择学习模式', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                StudyModeList(
                  onModeSelected: (mode) => Navigator.of(context).pop(mode),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
