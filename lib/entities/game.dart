import 'package:freezed_annotation/freezed_annotation.dart';

part 'game.g.dart';

@JsonSerializable()
class Game {
  const Game({required this.id, this.totalScore = 0});

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
  Map<String, dynamic> toJson() => _$GameToJson(this);

  final int id;
  final int totalScore;
}
