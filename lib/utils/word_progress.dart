import '../models/word.dart';

void resetWordLearningState(Word word) {
  word
    ..familiarity = 0
    ..nextReview = null
    ..reviewCount = 0
    ..correctStreak = 0
    ..easeFactor = 2.5
    ..sm2Interval = 0
    ..inWrongBook = false;
}