class Incordec {
  int? id;
  String? title;
  int? x;
  int? y;
  double? increasedValue;
  double? decreasedValue;
  String? datetime;

  Incordec({
    this.id,
    this.title,
    this.x,
    this.y,
    this.increasedValue,
    this.decreasedValue,
    this.datetime,
  });

  Incordec.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    x = map['x'];
    y = map['y'];
    increasedValue = map['increasedValue'];
    decreasedValue = map['decreasedValue'];
    datetime = map['datetime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'x': x,
      'y': y,
      'increasedValue': increasedValue,
      'decreasedValue': decreasedValue,
      'datetime': datetime,
    };
  }
}
