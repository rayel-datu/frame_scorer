import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frame_scorer/domain/services/persistence_service.dart';
import 'package:frame_scorer/entities/frame.dart';
import 'package:frame_scorer/entities/game.dart';
import 'package:frame_scorer/presentation/frame/cubit/game_screen_state.dart';
import 'package:frame_scorer/presentation/frame/viewmodel/game_screen_viewmodel.dart';

class GameScreenCubit extends Cubit<GameScreenState> {
  GameScreenCubit(this._persistenceService, {required Game game})
      : super(GameScreenState.initial(GameScreenViewModel(game)));

  final PersistenceService _persistenceService;

  int _roll = 0;
  int _totalScore = 0;

  void roll(int pins) {
    GameScreenViewModel viewModel = state.viewModel;
    int index = viewModel.currentFrame;

    if (index < 9) {
      _rollFrame(pins, viewModel);
      return;
    }

    _rollLastFrame(pins, viewModel);
  }

  void _rollFrame(int pins, GameScreenViewModel viewModel) {
    int currentFrameIndex = viewModel.currentFrame;
    Frame currentFrame = viewModel.getCurrentFrame();

    viewModel.shots.add(pins);

    if (_roll == 0) {
      if (pins == 10) {
        // Strike
        currentFrame.scores[0] = pins;
        currentFrame.scores[1] = 0;
        viewModel.shots.add(0);
        viewModel.currentFrame++;
        _roll = 0;
      } else {
        currentFrame.scores[0] = pins;
        _roll++;
      }
    } else if (_roll == 1) {
      final int totalFrameScore = (currentFrame.scores[0] ?? 0) + pins;
      if (totalFrameScore == 10) {
        // Spare
        currentFrame.scores[1] = pins;
      } else {
        // open
        currentFrame.scores[1] = pins;
      }
      _roll = 0;
      viewModel.currentFrame++;
    }
  }

  void _rollLastFrame(int pins, GameScreenViewModel viewModel) {
    int currentFrameIndex = viewModel.currentFrame;
    Frame currentFrame = viewModel.getCurrentFrame();

    if (_roll > 2) {
      // end
      //print('game over');
      return;
    }

    if (_roll == 0 || _roll == 2) {
      currentFrame.scores[_roll] = pins;
      _roll++;
    } else if (_roll == 1) {
      if ((currentFrame.scores[0] ?? 0) + pins == 10 || pins == 10) {
        // Spare
        currentFrame.scores[1] = pins;
        _roll++;
      } else {
        // open
        currentFrame.scores[1] = pins;
        currentFrame.scores[2] = 0;
        _roll = 3;
      }
    }
  }

  void computeScore() {
    GameScreenViewModel viewModel = state.viewModel;
    List<Frame> frames = state.viewModel.frames;

    frames.asMap().forEach((key, element) {
      if (key == frames.length - 1) {
        // print(
        //     'frame [${key + 1}]: ${element.scores[0]}/${element.scores[1]}/${element.scores[2]}');
        // last frame
        int lastFrameScore = (element.scores[0] ?? 0) +
            (element.scores[1] ?? 0) +
            (element.scores[2] ?? 0);

        _totalScore += lastFrameScore;
      } else {
        //print('frame [${key + 1}]: ${element.scores[0]}/${element.scores[1]}');
        //frame 1 - 9
        if (element.scores[0] == 10) {
          int bonus = 0;
          if (frames[key + 1].scores[0] == 10) {
            //next frame is a strike
            bonus += frames[key + 1].scores[0] ?? 0;
            bonus += frames[key + 2].scores[0] ?? 0;
          } else {
            bonus += frames[key + 1].scores[0] ?? 0;
            bonus += frames[key + 1].scores[1] ?? 0;
          }
          _totalScore += (element.scores[0] ?? 0) + bonus;
        } else if ((element.scores[0] ?? 0) + (element.scores[1] ?? 0) == 10) {
          //spare
          int bonus = frames[key + 1].scores[0] ?? 0;
          _totalScore +=
              (element.scores[0] ?? 0) + (element.scores[1] ?? 0) + bonus;
        } else {
          //open
          _totalScore += (element.scores[0] ?? 0) + (element.scores[1] ?? 0);
        }
      }
    });

    state.viewModel.totalScore = _totalScore;
  }

  void saveGame() {}
}
