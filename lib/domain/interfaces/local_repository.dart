abstract class LocalRepository {
  Future<void> reset();

  Future<void> saveString(String key, String object);
  Future<String?> getString(String key);

  Future<void> saveObject(String key, Map<String, dynamic>? object);
  Future<Map<String, dynamic>?> getObject(String key);
  Future<List<Map<String, dynamic>?>> getObjects(String key);
}
