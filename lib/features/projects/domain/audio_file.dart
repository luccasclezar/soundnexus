import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_file.freezed.dart';
part 'audio_file.g.dart';

@freezed
class AudioFile with _$AudioFile {
  const factory AudioFile({
    required String id,
    required String name,
    required String path,
    required int positionX,
    required int positionY,
    required double volume,
    @Default(false) bool loop,
    @Default('') String shortcut,
  }) = _AudioFile;

  const AudioFile._();

  factory AudioFile.fromJson(Map<String, dynamic> map) =>
      _$AudioFileFromJson(map);

  String get positionId => '$positionX:$positionY';
}
