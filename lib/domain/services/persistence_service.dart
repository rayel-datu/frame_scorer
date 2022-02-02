import 'package:frame_scorer/domain/interfaces/local_repository.dart';
import 'package:frame_scorer/entities/frame.dart';
import 'package:frame_scorer/entities/game.dart';

class PersistenceService {
  PersistenceService(this._localRepository);

  final LocalRepository _localRepository;

  Future<void> saveGame(Game game, List<Frame> frames) async {
    await _localRepository.saveObject('${game.id}', game.toJson());
    for (var frame in frames) {
      await _localRepository.saveObject('${frame.id}', frame.toJson());
    }
  }
}
