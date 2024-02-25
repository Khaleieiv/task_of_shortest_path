import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_of_shortest_path/common/presentation/state/shortest_path_data_provider.dart';
import 'package:task_of_shortest_path/common/utils/check_url.dart';
import 'package:task_of_shortest_path/common/widgets/custom_button.dart';
import 'package:task_of_shortest_path/process_page/presentation/pages/process_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String errorMessage = "";

  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text("Home Page"),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsetsDirectional.only(end: 100.0),
                    child: Text("Set valid API base URL in order continue"),
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.compare_arrows),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _urlController,
                          decoration: InputDecoration(
                            labelText: 'Enter the API URL',
                            errorText:
                                errorMessage.isNotEmpty ? errorMessage : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: CustomButton(
          onPressed: () {
            final url = _urlController.text;
            if (CheckUrl.isURLValid(url)) {
              setState(() {
                getDataPressed();
                errorMessage = "";
              });
            } else {
              setState(() {
                errorMessage = "Invalid URL";
              });
            }
          },
          text: 'Start counting process',
        ),
      ),
    );
  }

  Future<void> getDataPressed() async {
    final dataNotifier =
        Provider.of<ShortestPathDataProvider>(context, listen: false);
    await dataNotifier.fetchShortestPathData(_urlController.text);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProcessPage()),
    );
  }
}
