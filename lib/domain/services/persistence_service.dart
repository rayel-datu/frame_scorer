import 'package:frame_scorer/domain/interfaces/local_repository.dart';
import 'package:frame_scorer/entities/frame.dart';
import 'package:frame_scorer/entities/game.dart';

class PersistenceService {
  PersistenceService(this._localRepository);

  final LocalRepository _localRepository;

  Future<void> saveGame(Game game, List<Frame> frames) async {
    await _localRepository.saveObject('game.${game.id}', game.toJson());
    for (var frame in frames) {
      await _localRepository.saveObject('frame.${frame.id}', frame.toJson());
    }
  }

  Future<List<Game>> getAllGames() async {
    List<Map<String, dynamic>?> mappedGames =
        await _localRepository.getObjects('game');
    List<Game> games = mappedGames.map((e) => Game.fromJson(e!)).toList();

    return games;
  }

  Future<List<Frame>> getAllFramesByGameId(int gameId) async {
    List<Map<String, dynamic>?> mappedFrames =
        await _localRepository.getObjects('frame');

    List<Frame> frames = mappedFrames
        .map((e) => Frame.fromJson(e!))
        .toList()
        .where((element) => element.gameId == gameId)
        .toList();

        return frames;
  }
}
