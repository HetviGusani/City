import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';

part 'hive.g.dart';        // 👈 this line is missing!

@HiveType(typeId: 0)
class BookedService extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String category;

  @HiveField(2)
  late String issue;

  @HiveField(3)
  Uint8List? image;

  @HiveField(4)
  late String bookedAt;

  @HiveField(5)
  late String userEmail;
}