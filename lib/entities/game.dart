import 'package:freezed_annotation/freezed_annotation.dart';

part 'game.g.dart';

@JsonSerializable()
class Games {
  const Games({required this.id, this.totalScore});

  factory Games.fromJson(Map<String, dynamic> json) => _$GamesFromJson(json);
  Map<String, dynamic> toJson() => _$GamesToJson(this);

  final int id;
  final int? totalScore;
}
