import 'package:task_of_shortest_path/common/domain/entities/point.dart';

class ResultListData {
  final String id;
  final List<String> field;
  final Point start;
  final Point end;
  final List<Point> steps;
  final String path;

  ResultListData({
    required this.field,
    required this.start,
    required this.end,
    required this.id,
    required this.steps,
    required this.path,
  });
}
