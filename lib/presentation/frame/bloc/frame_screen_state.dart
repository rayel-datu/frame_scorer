import 'package:frame_scorer/presentation/frame/viewmodel/frame_screen_viewmodel.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'frame_screen_state.freezed.dart';

@freezed
class FrameScreenState with _$FrameScreenState{
  factory FrameScreenState.scored(FrameScreenViewModel viewModel) =
      FrameScreenScoredState;
  factory FrameScreenState.initial(FrameScreenViewModel viewModel) =
      FrameScreenInitialState;
}
