String sessionTypeLabel(String sessionType) {
  return switch (sessionType) {
    'flashcard' => '选择题',
    'quiz' => '选择题',
    'spelling' => '拼写练习',
    'listening' => '听音选义',
    'review_flashcard' => '复习 · 选择题',
    'review_quiz' => '复习 · 选择题',
    'review_spelling' => '复习 · 拼写',
    'review_listening' => '复习 · 听音选义',
    'wrong_book' => '错题本专项',
    'favorites' => '收藏夹专项',
    final type when type.startsWith('practice_') =>
      '专项 · ${sessionTypeLabel(type.replaceFirst('practice_', ''))}',
    _ => sessionType,
  };
}
