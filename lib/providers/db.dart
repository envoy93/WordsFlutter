import 'dart:async';
import 'package:flutter/services.dart';
import 'package:hello_world/providers/categories_provider.dart';
import 'package:hello_world/providers/words_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseClient {
  final int version = 1;
  Database db;
  String path;
  WordsProvider wordsProvider;
  CategoriesProvider categoriesProvider;

  Future create() async {
    Directory path1 = await getApplicationDocumentsDirectory();
    path = join(path1.path, "words.db");

    if (!(await new File(path).exists()) || (await _checkVersion() != version)) {
      await _replace();
    }

    await open(readonly: false);
    if ((await db.getVersion()) != version) {
      await db.setVersion(1);
    }
    await close();

    categoriesProvider = CategoriesProvider(this);
    await categoriesProvider.init();
    wordsProvider = WordsProvider(this);
  }

  Future open({bool readonly = true}) async =>
      (this.db = await openDatabase(path, readOnly: readonly));
  Future close() async => db.close();

  Future _replace() async {
    // delete existing if any
    await deleteDatabase(path);

    // Copy from asset
    ByteData data = await rootBundle.load(join("assets", "words.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(path).writeAsBytes(bytes);
  }

  Future _checkVersion() async {
    var d = await openDatabase(path);
    var v = await d.getVersion();
    await d.close();
    return v;
  }
}
