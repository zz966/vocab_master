import 'book_model.dart';

extension BookCompat on Book {
  String get id => bookId;

  String get title => bookName;

  set title(String value) => bookName = value;
}