import 'package:shared_preferences/shared_preferences.dart';

abstract class IPreferencesProvider {
  Future updateCurrentTopCategory(int data);
  int get currentTopCategory;
  Future updateIsFullList(bool data);
  bool get isFullList;
}

class PreferencesProvider implements IPreferencesProvider{
  SharedPreferences _prefs;
  static const String _TOP_CATEFORY_KEY = 'category_top_saved';
  static const String _WORDS_IS_FULL_MODE = 'category_words_isfull';

  PreferencesProvider(this._prefs);

  Future updateCurrentTopCategory(int data) async {
    return await _prefs.setInt(_TOP_CATEFORY_KEY, data);
  }

  int get currentTopCategory {
    return _prefs.getInt(_TOP_CATEFORY_KEY) ?? 0;
  }

  Future updateIsFullList(bool data) async {
    return await _prefs.setBool(_WORDS_IS_FULL_MODE, data);
  }

  bool get isFullList {
    return _prefs.getBool(_WORDS_IS_FULL_MODE) ?? true;
  }
}
