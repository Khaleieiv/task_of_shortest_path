import 'package:task_of_shortest_path/common/domain/entities/point.dart';

class PostShortestPathResponse {
  final String id;
  final List<Point> steps;
  final String path;

  PostShortestPathResponse({
    required this.id,
    required this.steps,
    required this.path,
  });

  factory PostShortestPathResponse.fromJson(Map<String, dynamic> json) {
    return PostShortestPathResponse(
      id: json['id'],
      steps: (json['result']['steps'] as List)
          .map((e) => Point.fromJson(e))
          .toList(),
      path: json['result']['path'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'result': {
      'steps': steps.map((e) => e.toJson()).toList(),
      'path': path,
    },
  };
}
