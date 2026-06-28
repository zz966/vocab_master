import '../models/word.dart';

enum StudyQueueOrder {
  familiarity('按熟悉度'),
  random('随机');

  const StudyQueueOrder(this.label);

  final String label;
}

/// Builds the active study queue: due words ordered by familiarity or shuffled.
List<Word> buildStudyQueue(List<Word> words, StudyQueueOrder order) {
  final queue = List<Word>.from(words);

  switch (order) {
    case StudyQueueOrder.familiarity:
      queue.sort((a, b) {
        final byFamiliarity = a.familiarity.compareTo(b.familiarity);
        if (byFamiliarity != 0) {
          return byFamiliarity;
        }
        final aDue = a.nextReview?.millisecondsSinceEpoch ?? 0;
        final bDue = b.nextReview?.millisecondsSinceEpoch ?? 0;
        final byDue = aDue.compareTo(bDue);
        if (byDue != 0) {
          return byDue;
        }
        return a.english.compareTo(b.english);
      });
    case StudyQueueOrder.random:
      queue.shuffle();
  }

  return queue;
}