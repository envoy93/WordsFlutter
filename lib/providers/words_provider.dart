import 'dart:async';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/db.dart';

class WordsProvider {
  final DatabaseClient client;
  final String table = "words";
  final Map<int, List<Word>> cacheByCategory = new Map();

  WordsProvider(this.client);

  Future<Word> forId(int id) async {
    await client.open();
    List<Map> results = await client.db.query(table,
        columns: Word.columns,
        where: "id = ?",
        orderBy: "position",
        whereArgs: [id]);
    await client.close();
    return Word.fromMap(results[0]);
  }

  Future<List<Word>> forCategory(int id) async {
    if (!cacheByCategory.containsKey(id)) {
      await client.open();
      List<Map> results = await client.db.query(table,
          columns: Word.columns,
          where: "category_id = ?",
          orderBy: "position",
          whereArgs: [id]);
      cacheByCategory[id] = results.map<Word>(Word.fromMap).toList();
      await client.close();
    }

    return cacheByCategory[id];
  }

  Future<bool> changeSave(Word data) async {
    data.isSaved = !data.isSaved; 
    //TODO save to db
    return true;
  }
}
