class Film {
  final String id;
  final String title;
  final String descr;

  Film({this.id, this.title, this.descr});

  factory Film.fromJson(Map<String, dynamic> json) {
    return new Film(id: json['id'], title: json['title'], descr: json['description']);
  }
}