import 'package:task_of_shortest_path/common/domain/entities/point.dart';

class FieldChecker {
  bool isPointInField(Point pointToCheck, List<Point> field) {
    for (var fieldPoint in field) {
      if (fieldPoint.x == pointToCheck.x && fieldPoint.y == pointToCheck.y) {
        return true;
      }
    }
    return false;
  }
}
