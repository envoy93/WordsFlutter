class Category {
  static final columns = [
    "id",
    "parent_id",
    "title",
    "lvl",
    "position",
    "saved"
  ];
  String title;
  String subTitle;
  int level;
  int id;
  int parentId;
  int position;
  bool isSaved;

  List<Category> childs;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columns[1]: parentId,
      columns[2]: title,
      columns[3]: level,
      columns[4]: position,
      columns[5]: isSaved ? 1 : 0
    };

    if (id != null) {
      map[columns[0]] = id;
    }

    return map;
  }

  static Category fromMap(Map<dynamic, dynamic> map) {
    Category category = new Category();
    category.id = map[columns[0]];
    category.parentId = map[columns[1]];
    category.title = map[columns[2]];
    category.subTitle = map[columns[2]]; //TODO
    category.level = map[columns[3]];
    category.position = map[columns[4]];
    category.isSaved = (map[columns[5]] as int) == 1;
    return category;
  }
}

class Word {
  static final columns = [
    "id",
    "category_id",
    "position",
    "base",
    "title",
    "translate",
    "transcription",
    "example",
    "saved"
  ];
  int id;
  int categoryId;
  int position;
  bool isBase;
  String eng;
  String rus;
  String transcr;
  String example;
  bool isSaved;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columns[1]: categoryId,
      columns[2]: position,
      columns[3]: isBase ? 1 : 0,
      columns[4]: rus,
      columns[5]: eng,
      columns[6]: transcr,
      columns[7]: example,
      columns[8]: isSaved ? 1 : 0
    };

    if (id != null) {
      map[columns[0]] = id;
    }

    return map;
  }

  static Word fromMap(Map<dynamic, dynamic> map) {
    Word word = new Word();
    word.id = map[columns[0]];
    word.categoryId = map[columns[1]];
    word.position = map[columns[2]];
    word.isBase = (map[columns[3]] as int) == 1;
    word.rus = map[columns[4]]; //TODO
    word.eng = map[columns[5]];
    word.transcr = map[columns[6]];
    word.example = map[columns[7]];
    word.isSaved = (map[columns[8]] as int) == 1;

    return word;
  }
}
