import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frame_scorer/domain/services/persistence_service.dart';
import 'package:frame_scorer/entities/frame.dart';
import 'package:frame_scorer/entities/game.dart';
import 'package:frame_scorer/presentation/frame/bloc/game_screen_state.dart';
import 'package:frame_scorer/presentation/frame/viewmodel/game_screen_viewmodel.dart';

class GameScreenCubit extends Cubit<GameScreenState> {
  GameScreenCubit(this._persistenceService, {required Game game})
      : super(GameScreenState.initial(GameScreenViewModel(game)));

  final PersistenceService _persistenceService;

  int _roll = 0;

  void roll(int pins) {
    GameScreenViewModel viewModel = state.viewModel;
    int index = viewModel.currentFrame;
    viewModel.getCurrentFrame().scores[_roll] = pins;

    viewModel.shots.add(pins);

    viewModel.totalScore += pins;

    if (_roll == 0 && pins == 10) {
      viewModel.getCurrentFrame().isStrike = true;
    } else {
      if (_roll == 1) {
        int frameScore = (viewModel.getCurrentFrame().scores[0] ?? 0) +
            (viewModel.getCurrentFrame().scores[1] ?? 0);
        if (frameScore == 10) {
          viewModel.getCurrentFrame().isSpare = true;
        }
      }
    }

    if (viewModel.currentFrame > 1) {
      if (viewModel.frames[viewModel.currentFrame - 1].isStrike ||
          viewModel.frames[viewModel.currentFrame - 1].isSpare) {
        viewModel.frames[viewModel.currentFrame - 1].bonus.add(pins);
        viewModel.totalScore += pins;
      }
    }
    if (viewModel.currentFrame > 2) {
      if (viewModel.frames[viewModel.currentFrame - 2].isStrike) {
        viewModel.frames[viewModel.currentFrame - 2].bonus.add(pins);
        viewModel.totalScore += pins;
      }
    }
  }

  void saveGame() {}
}
