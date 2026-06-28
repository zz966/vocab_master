import 'package:isar/isar.dart';

part 'word_book.g.dart';

@collection
class WordBook {
  Id id = Isar.autoIncrement;

  late String title;
  String? description;
  late String category;
  int totalWords = 0;
  String? coverColor;
  DateTime createdAt = DateTime.now();
}