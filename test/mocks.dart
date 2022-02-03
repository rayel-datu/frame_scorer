import 'package:frame_scorer/domain/interfaces/local_repository.dart';
import 'package:frame_scorer/domain/repository/local_repository_impl.dart';
import 'package:frame_scorer/domain/services/persistence_service.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockPersistenceService extends Mock implements PersistenceService {}

class MockLocalRepository extends Mock implements LocalRepositoryImpl {}

class MockSharedPreferences extends Mock implements SharedPreferences {}
