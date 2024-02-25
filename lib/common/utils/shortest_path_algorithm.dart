import 'dart:collection';
import 'package:task_of_shortest_path/common/domain/entities/point.dart';

class Node {
  final Point point;
  int distance;

  Node(this.point, this.distance);
}

class PathFinder {
  final List<String> _field;
  final Point _start;
  final Point _end;

  late List<List<int>> grid;
  late List<List<int>> distances;
  late List<List<bool>> visited;
  late List<List<Point>> previous;

  PathFinder(this._field, this._start, this._end) {
    grid = List<List<int>>.generate(
      _field.length,
          (int row) => List<int>.filled(_field[row].length, 0),
    );

    for (int i = 0; i < _field.length; i++) {
      for (int j = 0; j < _field[i].length; j++) {
        grid[i][j] = _field[i][j] == 'X' ? -1 : 0;
      }
    }
  }

  List<Point> findShortestPath() {
    distances = List<List<int>>.generate(
      _field.length,
          (int row) => List<int>.filled(_field[row].length, 1000000),
    );
    visited = List<List<bool>>.generate(
      _field.length,
          (int row) => List<bool>.filled(_field[row].length, false),
    );
    previous = List<List<Point>>.generate(
      _field.length,
          (int row) => List<Point>.filled(_field[row].length, Point(-1, -1)),
    );

    distances[_start.x][_start.y] = 0;

    Queue<Node> queue = Queue<Node>();
    queue.add(Node(_start, 0));

    while (queue.isNotEmpty) {
      Node current = queue.removeFirst();
      Point point = current.point;

      List<Point> neighbors = getNeighbors(point);
      for (Point neighbor in neighbors) {
        int alt = distances[point.x][point.y] + 1;
        if (alt < distances[neighbor.x][neighbor.y]) {
          distances[neighbor.x][neighbor.y] = alt;
          previous[neighbor.x][neighbor.y] = point;
          queue.add(Node(neighbor, alt));
        }
      }
    }

    return getPath();
  }

  List<Point> getNeighbors(Point point) {
    List<Point> neighbors = [];
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        if (dx == 0 && dy == 0) continue;
        int newX = point.x + dx;
        int newY = point.y + dy;
        if (newX >= 0 &&
            newX < _field.length &&
            newY >= 0 &&
            newY < _field[newX].length &&
            grid[newX][newY] != -1 &&
            !visited[newX][newY]) {
          neighbors.add(Point(newX, newY));
          visited[newX][newY] = true;
        }
      }
    }
    return neighbors;
  }

  List<Point> getPath() {
    List<Point> path = [];
    Point current = _end;
    while (current.x != -1 && current.y != -1) {
      path.add(current);
      current = previous[current.x][current.y];
    }
    path = path.reversed.toList();
    return path;
  }
}


// class ShortestPathAlgorithm {
//   final List<String> _field;
//   final Point _start;
//   final Point _end;
//   late List<List<bool>> _visited;
//   late List<List<Point>> _parent;
//   late List<Point> _path;
//
//   ShortestPathAlgorithm(this._field, this._start, this._end) {
//     _visited = List.generate(
//       _field.length,
//           (_) => List.generate(_field[0].length, (_) => false),
//     );
//     _parent = List.generate(
//       _field.length,
//           (_) => List.generate(_field[0].length, (_) => Point(-1, -1)),
//     );
//     _path = [];
//   }
//
//   List<Point> solve() {
//     _visited[_start.x][_start.y] = true;
//     Queue<Point> queue = Queue();
//     queue.add(_start);
//
//     while (queue.isNotEmpty) {
//       Point current = queue.removeFirst();
//       if (current.x == _end.x && current.y == _end.y) {
//         _buildPath();
//         break;
//       }
//       List<Point> neighbors = _getNeighbors(current);
//       for (Point neighbor in neighbors) {
//         if (!_visited[neighbor.x][neighbor.y]) {
//           _visited[neighbor.x][neighbor.y] = true;
//           _parent[neighbor.x][neighbor.y] = current;
//           queue.add(neighbor);
//         }
//       }
//     }
//
//     return _path.reversed.toList();
//   }
//
//   List<Point> _getNeighbors(Point coordinate) {
//     List<Point> neighbors = [];
//     List<int> dx = [0, 1, 0, -1]; // Порядок: вверх, вправо, вниз, влево
//     List<int> dy = [-1, 0, 1, 0];
//     for (int i = 0; i < dx.length; i++) {
//       int nx = coordinate.x + dx[i];
//       int ny = coordinate.y + dy[i];
//       if (_isValid(nx, ny)) {
//         neighbors.add(Point(nx, ny));
//       }
//     }
//     return neighbors;
//   }
//
//   bool _isValid(int x, int y) {
//     return x >= 0 && x < _field.length && y >= 0 && y < _field[0].length && !_isBlocked(x, y);
//   }
//
//   bool _isBlocked(int x, int y) {
//     return _field[x][y] == 'X';
//   }
//
//   void _buildPath() {
//     Point current = _end;
//     while (current.x != -1 && current.y != -1) {
//       _path.add(current);
//       current = _parent[current.x][current.y];
//     }
//   }
// }
