import 'dart:collection';
import 'package:task_of_shortest_path/common/domain/entities/point.dart';

// PathFinder class responsible for finding the shortest path between two points on a grid
class ShortestPathAlgorithm {
  final List<String> _field;
  final Point _start;
  final Point _end;

  late List<List<int>> grid;       // Represents the grid with obstacles marked as -1
  late List<List<int>> distances;  // Represents the distances from the starting point to each point on the grid
  late List<List<bool>> visited;   // Represents whether a point has been visited during traversal
  late List<List<Point>> previous; // Represents the previous point on the shortest path to each point

  ShortestPathAlgorithm(this._field, this._start, this._end) {
    // Initialize the grid with obstacle values (-1)
    grid = List<List<int>>.generate(
      _field.length,
          (int row) => List<int>.filled(_field[row].length, 0),
    );

    // Populate the grid based on the input field
    for (int i = 0; i < _field.length; i++) {
      for (int j = 0; j < _field[i].length; j++) {
        grid[i][j] = _field[i][j] == 'X' ? -1 : 0;
      }
    }
  }

  // Method to find the shortest path using Breadth-First Search algorithm
  List<Point> findShortestPath() {
    // Initialize distance and visited arrays
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

    distances[_start.x][_start.y] = 0; // Set the distance of the starting point to 0

    Queue<Node> queue = Queue<Node>();
    queue.add(Node(_start, 0)); // Add the starting point to the queue

    // Perform Breadth-First Search
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

    return getPath(); // Return the shortest path
  }

  // Method to retrieve the neighboring points of a given point
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

  // Method to reconstruct the shortest path from the 'previous' array
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

// Node class represents a point with a distance value
class Node {
  final Point point;
  int distance;

  Node(this.point, this.distance);
}
