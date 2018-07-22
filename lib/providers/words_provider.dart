import 'dart:async';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    try {
      await client.open(readonly: false);
      data.isSaved = !data.isSaved;
      await client.db.update(table, data.toMap(),
          where: "${Word.columns[0]} = ?", whereArgs: [data.id]);
      await client.close();
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> setIsFullList(bool data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('category_words_isfull', data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isFullList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('category_words_isfull') ?? true;
  }
}
