import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/export_file.dart';

void main() {
  ExportFileInfo file(String name) {
    return ExportFileInfo(
      name: name,
      path: '/tmp/$name',
      sizeBytes: 100,
      modifiedAt: DateTime(2026, 6, 16),
    );
  }

  test('exportFileKindFromName detects file types', () {
    expect(
      exportFileKindFromName('vocab_sessions_20260616.csv'),
      ExportFileKind.csv,
    );
    expect(
      exportFileKindFromName('vocab_master_stats_20260616.json'),
      ExportFileKind.json,
    );
    expect(
      exportFileKindFromName('vocab_weekly_1718534400000.png'),
      ExportFileKind.png,
    );
  });

  test('filterExportFilesByKind filters by selected kind', () {
    final files = [
      file('a.csv'),
      file('b.json'),
      file('c.png'),
    ];

    expect(
      filterExportFilesByKind(files, ExportFileKind.all),
      hasLength(3),
    );
    expect(
      filterExportFilesByKind(files, ExportFileKind.csv).map((f) => f.name),
      ['a.csv'],
    );
    expect(
      filterExportFilesByKind(files, ExportFileKind.png).map((f) => f.name),
      ['c.png'],
    );
  });
}