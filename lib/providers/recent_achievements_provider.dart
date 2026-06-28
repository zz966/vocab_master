import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/achievements.dart';
import 'settings_provider.dart';

final recentAchievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final settings = await ref.watch(settingsProvider.future);
  final ids = settings.unlockedAchievementIds;
  if (ids.isEmpty) {
    return [];
  }
  final recentIds = ids.length <= 3 ? ids : ids.sublist(ids.length - 3);
  return achievementsFromIds(recentIds.reversed.toList());
});