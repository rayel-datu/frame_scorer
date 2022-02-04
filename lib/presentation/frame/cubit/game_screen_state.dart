import 'package:frame_scorer/presentation/frame/viewmodel/game_screen_viewmodel.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_screen_state.freezed.dart';

@freezed
class GameScreenState with _$GameScreenState {
  factory GameScreenState.scored(GameScreenViewModel viewModel) =
      GameScreenScoredState;
  factory GameScreenState.initial(GameScreenViewModel viewModel) =
      GameScreenInitialState;
  factory GameScreenState.selected(GameScreenViewModel viewModel) =
      GameScreenSelectedState;
  factory GameScreenState.finished(GameScreenViewModel viewModel) =
      GameScreenFinishedState;
  factory GameScreenState.error(GameScreenViewModel viewModel, String message) =
      GameScreenErrorState;
}
