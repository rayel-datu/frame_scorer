import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:frame_scorer/domain/interfaces/local_repository.dart';
import 'package:frame_scorer/domain/services/persistence_service.dart';
import 'package:frame_scorer/entities/frame.dart';
import 'package:frame_scorer/entities/game.dart';
import 'package:frame_scorer/presentation/frame/cubit/game_screen_cubit.dart';
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
  group('Roll Score Tests', () {
    test('Score Strike', () {
      GameScreenCubit gameScreenCubit =
          GameScreenCubit(persistenceService, game: Game(id: gameId));

      gameScreenCubit.roll(10);
      gameScreenCubit.roll(2);
      gameScreenCubit.roll(5);
      gameScreenCubit.computeScore();

      expect(gameScreenCubit.state.viewModel.totalScore, 24);
      expect(gameScreenCubit.state.viewModel.frames[0].scores[1] ?? 0, 0);
    });
    test('Score Spare', () {
      GameScreenCubit gameScreenCubit =
          GameScreenCubit(persistenceService, game: Game(id: gameId));

      gameScreenCubit.roll(8);
      gameScreenCubit.roll(2);
      gameScreenCubit.roll(5);
      gameScreenCubit.roll(1);
      gameScreenCubit.computeScore();

      expect(gameScreenCubit.state.viewModel.totalScore, 21);
      expect(
          (gameScreenCubit.state.viewModel.frames[0].scores[0] ?? 0) +
              (gameScreenCubit.state.viewModel.frames[0].scores[1] ?? 0),
          10);
    });
    test('Score Open', () {
      GameScreenCubit gameScreenCubit =
          GameScreenCubit(persistenceService, game: Game(id: gameId));

      gameScreenCubit.roll(8);
      gameScreenCubit.roll(1);

      gameScreenCubit.computeScore();

      expect(gameScreenCubit.state.viewModel.totalScore, 9);
      expect(
          (gameScreenCubit.state.viewModel.frames[0].scores[0] ?? 0) +
                  (gameScreenCubit.state.viewModel.frames[0].scores[1] ?? 0) <
              10,
          true);
    });
  });
  group('Score Game Tests', () {
    test('Complete Game Score Test first 2 roll is spare', () {
      GameScreenCubit gameScreenCubit =
          GameScreenCubit(persistenceService, game: Game(id: gameId));

      gameScreenCubit.roll(10);

      gameScreenCubit.roll(10);

      gameScreenCubit.roll(8);
      gameScreenCubit.roll(2);

      gameScreenCubit.roll(8);
      gameScreenCubit.roll(1);

      gameScreenCubit.roll(2);
      gameScreenCubit.roll(1);

      gameScreenCubit.roll(10);

      gameScreenCubit.roll(10);

      gameScreenCubit.roll(1);
      gameScreenCubit.roll(1);

      gameScreenCubit.roll(1);
      gameScreenCubit.roll(0);

      gameScreenCubit.roll(1);
      gameScreenCubit.roll(9);
      gameScreenCubit.roll(8);
      gameScreenCubit.computeScore();

      expect(gameScreenCubit.state.viewModel.totalScore, 132);
    });

    test('Complete Game Score Test Last Frame open frame on first 2 roll', () {
      GameScreenCubit gameScreenCubit =
          GameScreenCubit(persistenceService, game: Game(id: gameId));

      gameScreenCubit.roll(10);

      gameScreenCubit.roll(10);

      gameScreenCubit.roll(8);
      gameScreenCubit.roll(2);

      gameScreenCubit.roll(8);
      gameScreenCubit.roll(1);

      gameScreenCubit.roll(2);
      gameScreenCubit.roll(1);

      gameScreenCubit.roll(10);

      gameScreenCubit.roll(10);

      gameScreenCubit.roll(1);
      gameScreenCubit.roll(1);

      gameScreenCubit.roll(1);
      gameScreenCubit.roll(0);

      gameScreenCubit.roll(1);
      gameScreenCubit.roll(8);

      gameScreenCubit.computeScore();

      expect(gameScreenCubit.state.viewModel.totalScore, 123);
      expect(gameScreenCubit.state.viewModel.frames[9].scores[2], 0);
    });

    test('Complete Game Score Test first Strike', () {
      GameScreenCubit gameScreenCubit =
          GameScreenCubit(persistenceService, game: Game(id: gameId));

      gameScreenCubit.roll(10);

      gameScreenCubit.roll(10);

      gameScreenCubit.roll(8);
      gameScreenCubit.roll(2);

      gameScreenCubit.roll(8);
      gameScreenCubit.roll(1);

      gameScreenCubit.roll(2);
      gameScreenCubit.roll(1);

      gameScreenCubit.roll(10);

      gameScreenCubit.roll(10);

      gameScreenCubit.roll(1);
      gameScreenCubit.roll(1);

      gameScreenCubit.roll(1);
      gameScreenCubit.roll(0);

      gameScreenCubit.roll(10);
      gameScreenCubit.roll(10);
      gameScreenCubit.roll(10);

      gameScreenCubit.computeScore();

      expect(gameScreenCubit.state.viewModel.totalScore, 144);
    });
  });
  test('Save game', () {});
}
