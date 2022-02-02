import 'dart:convert';

import 'package:frame_scorer/domain/interfaces/local_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalRepositoryImpl implements LocalRepository {
  LocalRepositoryImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;
  final JsonDecoder decoder = const JsonDecoder();
  final JsonEncoder encoder = const JsonEncoder();

  @override
  Future<Map<String, dynamic>?> getObject(String key) async {
    final String? jsonString = _sharedPreferences.getString(key);
    if (jsonString == null) {
      return null;
    }
    return decoder.convert(jsonString) as Map<String, dynamic>;
  }

  @override
  Future<String?> getString(String key) async {
    return _sharedPreferences.getString(key);
  }

  @override
  Future<void> reset() async {
    _sharedPreferences.clear();
  }

  @override
  Future<void> saveObject(String key, Map<String, dynamic>? object) async {
    await _sharedPreferences.setString(key, encoder.convert(object));
  }

  @override
  Future<void> saveString(String key, String object) async {
    await _sharedPreferences.setString(key, object);
  }

  @override
  Future<List<Map<String, dynamic>?>> getObjects(String key) async {
    final List<Map<String, dynamic>?> items = [];
    final List<String> keys = _sharedPreferences
        .getKeys()
        .where((element) => element.contains(key))
        .toList();

    for (var element in keys) {
      final String? jsonString = _sharedPreferences.getString(element);

      items.add(decoder.convert(jsonString ?? '') as Map<String, dynamic>);
    }

    return items;
  }
}
