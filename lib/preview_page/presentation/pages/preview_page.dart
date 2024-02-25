import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_of_shortest_path/common/presentation/state/shortest_path_data_provider.dart';
import 'package:task_of_shortest_path/preview_page/widgets/result_view_page.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shortestPathProvider = Provider.of<ShortestPathDataProvider>(context);
    final data = shortestPathProvider.currentResultLData;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Preview Screen",
        ),
        backgroundColor: Colors.blue,
      ),
      body: ResultViewPage(
        start: data!.start,
        end: data.end,
        grid: data.field,
        field: data.steps,
        shortestPath: data.path,
      ),
    );
  }
}
