import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:frame_scorer/domain/interfaces/local_repository.dart';
import 'package:frame_scorer/domain/services/persistence_service.dart';
import 'package:frame_scorer/entities/frame.dart';
import 'package:frame_scorer/entities/game.dart';
import 'package:frame_scorer/presentation/frame/bloc/game_screen_cubit.dart';
import 'package:mockito/mockito.dart';

import '../mocks.dart';

main() {
  int gameId = 0;
  GameScreenCubit gameScreenCubit;
  PersistenceService persistenceService;
  LocalRepository localRepository;

  localRepository = MockLocalRepository();
  persistenceService = MockPersistenceService();

  setUp(() {
    // // Mock repository responses
    // List<Map<String, dynamic>> mappedGames =
    //     List.generate(1, (index) => Game(id: gameId).toJson());

    // when(localRepository.getObjects('game'))
    //     .thenAnswer((realInvocation) => Future.value(mappedGames));

    // List<Map<String, dynamic>> mappedFrames = List.generate(
    //     1, (index) => Frame(id: index, gameId: gameId, scores: []).toJson());

    // when(localRepository.getObjects('frame'))
    //     .thenAnswer((realInvocation) => Future.value(mappedFrames));

    // // Mock service responses
    // when(persistenceService.getAllFramesByGameId(gameId)).thenAnswer((_) =>
    //     Future.value(List.generate(
    //         1, (index) => Frame(id: 0, gameId: gameId, scores: []))));

    // when(persistenceService.getAllGames()).thenAnswer(
    //     (_) => Future.value(List.generate(1, (index) => Game(id: gameId))));
  });

  /// Initial cubit should contain exactly 10 frames
  /// last frame should have a value of isFinal true
  /// game is required
  test('Initialize cubit', () {
    GameScreenCubit cubit =
        GameScreenCubit(persistenceService, game: Game(id: gameId));
    List<Frame> frames = cubit.state.viewModel.frames;
    expect(frames, isNotNull);
    expect(frames.length == 10, true);
    expect(frames.last.isFinal, true);
    expect(cubit.state.viewModel.game, isNotNull);
    frames.asMap().forEach((index, element) {
      expect(element.isFinal, index == 9);
    });
  });
  group('Record Score Tests', () {
    test('Score Strike', () {
      GameScreenCubit gameScreenCubit =
          GameScreenCubit(persistenceService, game: Game(id: gameId));

      gameScreenCubit.roll(10);
      gameScreenCubit.roll(10);
      gameScreenCubit.roll(8);
      gameScreenCubit.roll(2);

      expect(gameScreenCubit.state.viewModel.totalScore, 10,
          reason: '${gameScreenCubit.state.viewModel.totalScore}');
          
    });
    test('Score Spare', () {});
    test('Score Open', () {});
    test('score Frame 10', () {});
  });
  test('Save game', () {});
}
