import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/export_file.dart';

void main() {
  test('describeExportFileName maps known export prefixes', () {
    expect(
      describeExportFileName('vocab_sessions_20260616_1200.csv'),
      '学习记录',
    );
    expect(
      describeExportFileName('vocab_words_favorites_20260616_1200.csv'),
      '收藏夹',
    );
    expect(
      describeExportFileName('vocab_words_review_20260616_1200.json'),
      '复习队列',
    );
    expect(
      describeExportFileName('vocab_weekly_1718534400000.png'),
      '周报图片',
    );
    expect(describeExportFileName('unknown.txt'), '导出文件');
  });
}