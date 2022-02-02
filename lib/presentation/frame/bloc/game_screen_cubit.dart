import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frame_scorer/domain/services/persistence_service.dart';
import 'package:frame_scorer/entities/game.dart';
import 'package:frame_scorer/presentation/frame/bloc/game_screen_state.dart';
import 'package:frame_scorer/presentation/frame/viewmodel/game_screen_viewmodel.dart';

class GameScreenCubit extends Cubit<GameScreenState> {
  GameScreenCubit(this._persistenceService, {required Game game})
      : super(GameScreenState.initial(GameScreenViewModel(game)));

  final PersistenceService _persistenceService;
  void recordScore() {}

  void saveGame() {}
}
