import 'package:freezed_annotation/freezed_annotation.dart';

part 'frame.g.dart';

@JsonSerializable()
class Frame {
  const Frame({
    required this.id,
    required this.gameId,
    required this.scores,
    this.totalScore = 0,
    this.isFinal = false,
  });

  factory Frame.fromJson(Map<String, dynamic> json) => _$FrameFromJson(json);
  Map<String, dynamic> toJson() => _$FrameToJson(this);

  final int id;
  final int gameId;
  final List<int> scores;
  final int totalScore;
  final bool isFinal;
}
