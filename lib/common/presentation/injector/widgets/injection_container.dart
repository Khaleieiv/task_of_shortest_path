import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_of_shortest_path/common/data/repositories/shortest_path_data_repository_iml.dart';
import 'package:task_of_shortest_path/common/presentation/state/shortest_path_data_provider.dart';

class InjectionContainer extends StatefulWidget {
  final Widget child;

  const InjectionContainer({super.key, required this.child});

  @override
  State<InjectionContainer> createState() => _InjectionContainerState();
}

class _InjectionContainerState extends State<InjectionContainer> {
  ShortestPathDataProvider? _dataProvider;

  @override
  void initState() {
    final dataRepository = ShortestPathDataRepositoryIml();
    _dataProvider = ShortestPathDataProvider(
      repository: dataRepository,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _dataProvider),
      ],
      child: widget.child,
    );
  }
}
