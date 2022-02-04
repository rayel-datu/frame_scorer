import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frame_scorer/domain/services/persistence_service.dart';
import 'package:frame_scorer/entities/frame.dart';
import 'package:frame_scorer/entities/game.dart';
import 'package:frame_scorer/presentation/frame/cubit/game_screen_state.dart';
import 'package:frame_scorer/presentation/frame/viewmodel/game_screen_viewmodel.dart';

class GameScreenCubit extends Cubit<GameScreenState> {
  GameScreenCubit({required Game game})
      : super(GameScreenState.initial(GameScreenViewModel(game)));

  int _roll = 0;
  int _totalScore = 0;

  void setRoll(int pin) {
    state.viewModel.selected = pin;

    emit(GameScreenSelectedState(state.viewModel));
    emit(GameScreenInitialState(state.viewModel));
  }

  bool roll(int pins) {
    GameScreenViewModel viewModel = state.viewModel;
    int index = viewModel.currentFrame;
    print('current Frame: ${index + 1}');
    if (index < 9) {
      if (viewModel
              .getCurrentFrame()
              .scores
              .where((element) => element != null)
              .toList()
              .length ==
          1) {
        int frameScore = (viewModel.getCurrentFrame().scores[0] ?? 0) + pins;

        if (frameScore > 10) {
          emit(GameScreenErrorState(
              viewModel, 'Frame Score must not be above 10!'));
          emit(GameScreenInitialState(viewModel));
          return false;
        }
      }

      _rollFrame(pins, viewModel);

      return true;
    }

    _rollLastFrame(pins, viewModel);

    return true;
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
        //computeScore();
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
      //computeScore();
    }

    emit(GameScreenScoredState(viewModel));
    emit(GameScreenInitialState(viewModel));
  }

  void _rollLastFrame(int pins, GameScreenViewModel viewModel) {
    int currentFrameIndex = viewModel.currentFrame;
    Frame currentFrame = viewModel.getCurrentFrame();

    print('last frame pin: $pins');

    if (_roll > 2) {
      // end
      //print('game over');
      return;
    }

    if (_roll == 0 || _roll == 2) {
      currentFrame.scores[_roll] = pins;
      _roll++;
    } else if (_roll == 1) {
      if ((currentFrame.scores[0] ?? 0) + pins >= 10 || pins == 10) {
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

    emit(GameScreenScoredState(viewModel));
    emit(GameScreenInitialState(viewModel));

    if (_roll > 2) {
      computeScore();
      emit(GameScreenFinishedState(viewModel));
      return;
    }
  }

  void computeScore() {
    GameScreenViewModel viewModel = state.viewModel;
    List<Frame> frames = state.viewModel.frames;

    print('length : ${frames.length}');

    frames.asMap().forEach((key, element) {
      if (key >= frames.length - 1) {
        print(
            'frame [${key}]: ${element.scores[0]}/${element.scores[1]}/${element.scores[2]}');
        // last frame
        int lastFrameScore = (element.scores[0] ?? 0) +
            (element.scores[1] ?? 0) +
            (element.scores[2] ?? 0);

        _totalScore += lastFrameScore;
      } else {
        print('frame [${key}]: ${element.scores[0]}/${element.scores[1]}');
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
          print('spare');
          int bonus = frames[key + 1].scores[0] ?? 0;
          print('$bonus');
          print('$_totalScore');
          print(
              '${(element.scores[0] ?? 0) + (element.scores[1] ?? 0) + bonus}');
          _totalScore +=
              (element.scores[0] ?? 0) + (element.scores[1] ?? 0) + bonus;
        } else {
          //open
          _totalScore += (element.scores[0] ?? 0) + (element.scores[1] ?? 0);
        }
      }
    });

    state.viewModel.totalScore = _totalScore;

    emit(GameScreenScoredState(viewModel));
    emit(GameScreenInitialState(viewModel));
  }

  void reset() {
    print('reset');
    GameScreenViewModel newViewModel = GameScreenViewModel(Game(id: 2));
    _roll = 0;
    _totalScore = 0;
    emit(GameScreenScoredState(newViewModel));
    emit(GameScreenInitialState(newViewModel));
  }
}
