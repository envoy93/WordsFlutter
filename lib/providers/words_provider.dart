import 'dart:async';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/db/db.dart';

abstract class IWordsProvider {
  Future<List<Word>> forCategory(int id);
  Future changeSave(Word data);
}

class WordsProvider implements IWordsProvider {
  final DatabaseConnection _connection;
  final String _table = "words";

  WordsProvider(this._connection);

  /*Future<Word> forId(int id) async {
    var db = await _connection.db;

    List<Map> results = await db.query(_table,
        columns: Word.columns,
        where: "id = ?",
        orderBy: "position",
        whereArgs: [id]);
    return Word.fromMap(results[0]);
  }*/

  Future<List<Word>> forCategory(int id) async {
    var db = await _connection.db;

    return (await db.query(_table,
            columns: Word.columns,
            where: "category_id = ?",
            orderBy: "position",
            whereArgs: [id]))
        .map<Word>(Word.fromMap)
        .toList();
  }

  Future changeSave(Word data) async {
    var db = await _connection.db;

    data.isSaved = !data.isSaved;
    await db.update(_table, data.toMap(),
        where: "${Word.columns[0]} = ?", whereArgs: [data.id]);
  }
}

class CachedWordsProvider implements IWordsProvider {
  final Map<int, List<Word>> _cacheByCategory = new Map();
  final IWordsProvider _provider;

  CachedWordsProvider(this._provider);

  Future<List<Word>> forCategory(int id) async {
    if (!_cacheByCategory.containsKey(id)) {
      _cacheByCategory[id] = await _provider.forCategory(id);
    }
    return _cacheByCategory[id];
  }

  Future changeSave(Word data) async {
    await _provider.changeSave(data);
  }
}
