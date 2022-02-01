import 'package:freezed_annotation/freezed_annotation.dart';

part 'frame.g.dart';

@JsonSerializable()
class Frame {
  const Frame({
    required this.id,
    required this.gameId,
    this.downedPins,
    this.score,
    this.isFinal,
  });

  factory Frame.fromJson(Map<String, dynamic> json) => _$FrameFromJson(json);
  Map<String, dynamic> toJson() => _$FrameToJson(this);

  final int id;
  final int gameId;
  final int? downedPins;
  final int? score;
  final bool? isFinal;
}
