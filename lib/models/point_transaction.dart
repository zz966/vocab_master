import 'package:hive_flutter/hive_flutter.dart';

part 'point_transaction.g.dart';

@HiveType(typeId: 12)
class PointTransaction {
  @HiveField(0)
  String id;

  @HiveField(1)
  int amount;

  @HiveField(2)
  String reason;

  @HiveField(3)
  DateTime createdAt;

  PointTransaction({
    required this.id,
    required this.amount,
    required this.reason,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}