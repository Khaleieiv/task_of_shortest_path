import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_of_shortest_path/common/presentation/state/shortest_path_data_provider.dart';
import 'package:task_of_shortest_path/common/widgets/custom_button.dart';
import 'package:task_of_shortest_path/result_list_page/presentation/pages/result_list_page.dart';

class ProcessPage extends StatefulWidget {
  const ProcessPage({super.key});

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShortestPathDataProvider>().calculationShortestPath();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShortestPathDataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Process Screen",
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Center(
          child: Consumer<ShortestPathDataProvider>(
            builder: (context, provider, _) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (provider.isCalculationInProgress ||
                        provider.isPostInProgress)
                      Text(
                        'Counting is in progress ',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      )
                    else if (provider.isPostInProgress &&
                        provider.messageServer == "Internal server error")
                      Text(
                        'Internal Server Error',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      )
                    else
                      Text(
                        'All calculations has finished, you can send your results',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    Text(
                      '${provider.progress}%',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(
                        value: provider.progress,
                        strokeAlign: 15,
                        color: Colors.blue,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Column(
          children: [
            if (provider.isCalculationInProgress)
              const SizedBox()
            else
              GestureDetector(
                onTap: () => provider.isPostInProgress,
                child: CustomButton(
                  onPressed: () {
                    setState(() {
                      postDataPressed();
                    });
                  },
                  text: 'Send results to server',
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> postDataPressed() async {
    final provider =
        Provider.of<ShortestPathDataProvider>(context, listen: false);
    await provider.postShortestPathData();
    if (!mounted) return;
    if (provider.messageServer == "Internal server error") {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResultListPage()),
      );
    }
  }
}
