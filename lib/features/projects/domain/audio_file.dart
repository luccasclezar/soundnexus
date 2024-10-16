import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_file.freezed.dart';
part 'audio_file.g.dart';

@freezed
class AudioFile with _$AudioFile {
  const factory AudioFile({
    required String path,
    required String name,
    required int positionX,
    required int positionY,
    required double volume,
  }) = _AudioFile;

  factory AudioFile.fromJson(Map<String, dynamic> map) =>
      _$AudioFileFromJson(map);
}
