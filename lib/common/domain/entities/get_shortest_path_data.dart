import 'package:task_of_shortest_path/common/domain/entities/point.dart';

class GetShortestPathResponse {
  final bool error;
  final String message;
  final List<ShortestPathData> data;

  GetShortestPathResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  factory GetShortestPathResponse.fromJson(Map<String, dynamic> json) {
    return GetShortestPathResponse(
      error: json['error'],
      message: json['message'],
      data: (json['data'] as List)
          .map((e) => ShortestPathData.fromJson(e))
          .toList(),
    );
  }
}

class ShortestPathData {
  final String id;
  final List<String> field;
  final Point start;
  final Point end;

  ShortestPathData({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  factory ShortestPathData.fromJson(Map<String, dynamic> json) {
    return ShortestPathData(
      id: json['id'],
      field: json['field'].cast<String>(),
      start: Point.fromJson(json['start']),
      end: Point.fromJson(json['end']),
    );
  }
}
