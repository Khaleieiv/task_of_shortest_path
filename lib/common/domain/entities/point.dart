class Point {
  final int x;
  final int y;

  Point(this.x, this.y);

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(json['x'], json['y']);
  }

  Map<String, dynamic> toJson() {
    return {
      'x': '$x',
      'y': '$y',
    };
  }
}
