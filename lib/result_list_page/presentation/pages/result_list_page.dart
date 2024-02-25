import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_of_shortest_path/common/presentation/state/shortest_path_data_provider.dart';
import 'package:task_of_shortest_path/preview_page/presentation/pages/preview_page.dart';

class ResultListPage extends StatefulWidget {
  const ResultListPage({super.key});

  @override
  State<ResultListPage> createState() => _ResultListPageState();
}

class _ResultListPageState extends State<ResultListPage> {
  @override
  Widget build(BuildContext context) {
    final shortestPathProvider = Provider.of<ShortestPathDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text("Result List Page"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: shortestPathProvider.resultListData != null
            ? ListView.builder(
                itemCount: shortestPathProvider.resultListData!.length,
                itemBuilder: (context, index) {
                  final resultData =
                      shortestPathProvider.resultListData![index];
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        shortestPathProvider
                            .setCurrentResultListData(resultData);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PreviewPage()),
                        );
                      });
                    },
                    child: Text(
                      resultData.path,
                      style: const TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  );
                },
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
