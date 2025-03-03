import 'package:hive/hive.dart';


@HiveType(typeId: 1) // Ensure typeId is unique
class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final int typeId = 1;

  @override
  Duration read(BinaryReader reader) {
    return Duration(milliseconds: reader.readInt());
  }

  @override
  void write(BinaryWriter writer, Duration obj) {
    writer.writeInt(obj.inMilliseconds);
  }
}
