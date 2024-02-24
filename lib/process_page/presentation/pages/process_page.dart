import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_of_shortest_path/common/presentation/state/shortest_path_data_provider.dart';
import 'package:task_of_shortest_path/common/widgets/custom_button.dart';

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
                    if (provider.isLoading)
                      Text(
                        'Counting is in progress ',
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    else
                      Text(
                        'All calculations has finished, you can send your results',
                        style: Theme.of(context).textTheme.titleLarge,
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
            if (provider.isLoading)
              const SizedBox()
            else
              CustomButton(
                onPressed: () {},
                text: 'Send results to server',
              )
          ],
        ),
      ),
    );
  }
}
