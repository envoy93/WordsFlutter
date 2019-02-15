import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

abstract class DatabaseConnection {
  Future<Database> get db;
  Future<bool> open({bool readonly = false});
  Future<bool> close();
}

class DatabaseClient implements DatabaseConnection {
  final int _version = 2;
  Database _db;
  String _path;
  bool _init = false;
  static final DatabaseClient _singleton = new DatabaseClient._create();

  factory DatabaseClient() => _singleton;
  DatabaseClient._create();

  Future<Database> get db async {
    if (_db == null) await open();
    return _db;
  }

  Future _load() async {
    if (_init) return;

    _path = join((await getApplicationDocumentsDirectory()).path, "words.db");

    if (!(await new File(_path).exists())) {
      await _replace();
      print('db file has replaced');
    } else {
      await _open(readonly: false);
      if (await _isOldVersion) {
        await _replace();
        print('db file has replaced');
      }
      await _close();
    }

    await _open(readonly: false);
    if (await _isOldVersion) {
      await _db.setVersion(_version);
    }
    await _close();
    _init = true;
  }

  Future<bool> open({bool readonly = false}) async {
    if (!_init) await _load();
    return await _open(readonly: readonly);
  }

  Future<bool> _open({bool readonly = false}) async {
    if (_db != null) return true;
    this._db = await openDatabase(_path, readOnly: readonly);
    return true;
  }

  Future<bool> _close() async {
    if (_db == null) return true;
    await _db.close();
    _db = null;

    return true;
  }

  Future<bool> close() async {
    if (!_init) await _load();
    return await _close();
  }

  Future _replace() async {
    // delete existing if any
    await deleteDatabase(_path);

    // Copy from asset
    ByteData data = await rootBundle.load(join("assets", "words.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(_path).writeAsBytes(bytes);
  }

  Future<bool> get _isOldVersion async => (await _db.getVersion()) != _version;
}
