import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exportFilesRevisionProvider = StateProvider<int>((ref) => 0);

void bumpExportFilesRevision(WidgetRef ref) {
  ref.read(exportFilesRevisionProvider.notifier).state++;
}

void bumpExportFilesRevisionFromContext(BuildContext context) {
  ProviderScope.containerOf(context)
      .read(exportFilesRevisionProvider.notifier)
      .state++;
}