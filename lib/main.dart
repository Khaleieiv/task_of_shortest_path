import 'package:flutter/material.dart';
import 'package:task_of_shortest_path/common/presentation/injector/widgets/injection_container.dart';
import 'package:task_of_shortest_path/home/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const InjectionContainer(
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
