import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_of_shortest_path/common/presentation/state/shortest_path_data_provider.dart';
import 'package:task_of_shortest_path/common/widgets/custom_button.dart';
import 'package:task_of_shortest_path/process_page/widgets/custom_text_style.dart';
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
        foregroundColor: Colors.white,
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
                      const CustomTextStyle(
                        text: 'Counting is in progress',
                      )
                    else if (provider.isPostInProgress &&
                            provider.messageServer == "Internal server error" ||
                        provider.messageServer == "Too many requests")
                      const CustomTextStyle(
                        text: 'Problem with data sending',
                      )
                    else
                      const CustomTextStyle(
                        text:
                            'All calculations has finished, you can send your results',
                      ),
                    if (!provider.isPostInProgress)
                      Text(
                        '${provider.progress * 100}%',
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
              CustomButton(
                onPressed: provider.isPostInProgress
                    ? null
                    : () {
                        setState(() {
                          postDataPressed();
                        });
                      },
                text: 'Send results to server',
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
    if (provider.messageServer == "Success") {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResultListPage()),
      );
    }
  }
}
