import 'package:frame_scorer/entities/frame.dart';
import 'package:frame_scorer/entities/game.dart';

class GameScreenViewModel {
  GameScreenViewModel(this.game, {this.currentFrame = 0})
      : frames = List.generate(
            10,
            (index) => Frame(
                  id: index,
                  gameId: game.id,
                  isFinal: index == 9,
                  scores: List.generate(
                      3, (index) => 0), // should be true on last item
                ));
  final List<Frame> frames;
  final Game game;
  final int currentFrame;
}
