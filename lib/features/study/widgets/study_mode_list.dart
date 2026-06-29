import 'package:flutter/material.dart';

import '../../../core/study_mode.dart';

class StudyModeList extends StatelessWidget {
  const StudyModeList({super.key, required this.onModeSelected});

  final ValueChanged<StudyMode> onModeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: StudyMode.values.map((mode) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ModeCard(
            icon: switch (mode) {
              StudyMode.quiz => Icons.quiz_outlined,
              StudyMode.spelling => Icons.spellcheck,
              StudyMode.listening => Icons.hearing,
            },
            title: mode.title,
            subtitle: mode.subtitle,
            onTap: () => onModeSelected(mode),
          ),
        );
      }).toList(),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
