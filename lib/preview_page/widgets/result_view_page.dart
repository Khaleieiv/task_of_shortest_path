import 'package:flutter/material.dart';
import 'package:task_of_shortest_path/common/domain/entities/point.dart';
import 'package:task_of_shortest_path/preview_page/utils/field_checker.dart';

class ResultViewPage extends StatelessWidget {
  final List<Point> field;
  final Point start;
  final Point end;
  final List<String> grid;
  final String shortestPath;

  const ResultViewPage({
    super.key,
    required this.field,
    required this.start,
    required this.end,
    required this.grid,
    required this.shortestPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: grid.length,
                ),
                itemCount: grid.length * grid.length,
                itemBuilder: (context, index) {
                  final row = index ~/ grid.length;
                  final col = index % grid.length;
                  final point = Point(row, col);
                  return buildGridCell(point);
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              shortestPath,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridCell(Point point) {
    Color cellColor = Colors.white;
    Color textColor = Colors.black;

    if (point.x == start.x && point.y == start.y) {
      cellColor = const Color(0xFF64FFDA); // Start cell
    } else if (point.x == end.x && point.y == end.y) {
      cellColor = const Color(0xFF009688); // End cell
    } else if (FieldChecker().isPointInField(point, field)) {
      cellColor = const Color(0xFF4CAF50); // Cell of the shortest path
    } else if (grid[point.x][point.y] == 'X') {
      cellColor = Colors.black; // Locked cell
      textColor = Colors.white; // Change the color of the text to white
    }

    return Container(
      decoration: BoxDecoration(
        color: cellColor,
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Text(
          '(${point.x}.${point.y})',
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
