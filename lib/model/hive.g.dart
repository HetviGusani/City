// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookedServiceAdapter extends TypeAdapter<BookedService> {
  @override
  final int typeId = 0;

  @override
  BookedService read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookedService()
      ..name = fields[0] as String
      ..category = fields[1] as String
      ..issue = fields[2] as String
      ..image = fields[3] as Uint8List?
      ..bookedAt = fields[4] as String
      ..userEmail = fields[5] as String;
  }

  @override
  void write(BinaryWriter writer, BookedService obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.issue)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.bookedAt)
      ..writeByte(5)
      ..write(obj.userEmail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookedServiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
