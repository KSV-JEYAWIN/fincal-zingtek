class Percentage {
  int? id;
  String? title;
  int? x;
  int? y;
  double? result;
  String? datetime;

  Percentage(this.title, this.x, this.y, this.result, this.datetime);

  Percentage.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.x = map['x'];
    this.y = map['y'];
    this.result = map['value']; // 'value' column name is used in the database
    this.datetime = map['datetime'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'x': x,
      'y': y,
      'value': result, // 'value' column name is used in the database
      'datetime': datetime,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
