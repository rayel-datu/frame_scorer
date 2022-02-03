import 'package:freezed_annotation/freezed_annotation.dart';

part 'frame.g.dart';

@JsonSerializable()
class Frame {
  Frame({
    required this.id,
    required this.gameId,
    required this.scores,
    this.totalScore = 0,
    this.isStrike = false,
    this.isSpare = false,
    this.isFinal = false,
  }) : bonus = [];

  factory Frame.fromJson(Map<String, dynamic> json) => _$FrameFromJson(json);
  Map<String, dynamic> toJson() => _$FrameToJson(this);

  int id;
  int gameId;
  List<int?> scores;
  int totalScore;
  bool isStrike;
  bool isSpare;
  bool isFinal;
  List<int> bonus;

  int getTotalScore() {
    totalScore = 0;
    for (var element in scores) {
      totalScore += element ?? 0;
    }
    return totalScore;
  }
}
