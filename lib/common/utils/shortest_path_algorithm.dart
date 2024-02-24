import 'dart:collection';
import 'package:task_of_shortest_path/common/domain/entities/point.dart';

class ShortestPathAlgorithm {
  final List<String> _field;
  final Point _start;
  final Point _end;
  late List<List<bool>> _visited;
  late List<List<Point>> _parent;
  late List<Point> _path;

  ShortestPathAlgorithm(this._field, this._start, this._end) {
    _visited = List.generate(
      _field.length,
          (_) => List.generate(_field[0].length, (_) => false),
    );
    _parent = List.generate(
      _field.length,
          (_) => List.generate(_field[0].length, (_) => Point(-1, -1)),
    );
    _path = [];
  }

  List<Point> solve() {
    _visited[_start.x][_start.y] = true;
    Queue<Point> queue = Queue();
    queue.add(_start);

    while (queue.isNotEmpty) {
      Point current = queue.removeFirst();
      if (current.x == _end.x && current.y == _end.y) {
        _buildPath();
        break;
      }
      List<Point> neighbors = _getNeighbors(current);
      for (Point neighbor in neighbors) {
        if (!_visited[neighbor.x][neighbor.y]) {
          _visited[neighbor.x][neighbor.y] = true;
          _parent[neighbor.x][neighbor.y] = current;
          queue.add(neighbor);
        }
      }
    }

    return _path.reversed.toList();
  }

  List<Point> _getNeighbors(Point coordinate) {
    List<Point> neighbors = [];
    List<int> dx = [-1, 0, 1, 0, -1, -1, 1, 1];
    List<int> dy = [0, 1, 0, -1, -1, 1, -1, 1];
    for (int i = 0; i < dx.length; i++) {
      int nx = coordinate.x + dx[i];
      int ny = coordinate.y + dy[i];
      if (_isValid(nx, ny)) {
        neighbors.add(Point(nx, ny));
      }
    }
    return neighbors;
  }

  bool _isValid(int x, int y) {
    return x >= 0 && x < _field.length && y >= 0 && y < _field[0].length && !_isBlocked(x, y);
  }

  bool _isBlocked(int x, int y) {
    return _field[x][y] == 'X';
  }

  void _buildPath() {
    Point current = _end;
    while (current.x != -1 && current.y != -1) {
      _path.add(current);
      current = _parent[current.x][current.y];
    }
  }
}
