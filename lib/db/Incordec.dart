class Incordec {
  int? id;
  int? x;
  int? y;
  double? increasedValue;
  double? decreasedValue;
  String? datetime;

  Incordec(
      this.x, this.y, this.increasedValue, this.decreasedValue, this.datetime);

  Incordec.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.x = map['x'];
    this.y = map['y'];
    this.increasedValue = map['increasedValue'];
    this.decreasedValue = map['decreasedValue'];
    this.datetime = map['datetime'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'x': x,
      'y': y,
      'increasedValue': increasedValue,
      'decreasedValue': decreasedValue,
      'datetime': datetime,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
