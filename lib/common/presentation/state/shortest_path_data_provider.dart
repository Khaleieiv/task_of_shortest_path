import 'package:flutter/material.dart';
import 'package:task_of_shortest_path/common/domain/entities/get_shortest_path_data.dart';
import 'package:task_of_shortest_path/common/domain/entities/post_shortest_path_data.dart';
import 'package:task_of_shortest_path/common/domain/repositories/shortest_path_data_repository.dart';
import 'package:task_of_shortest_path/common/utils/custom_exception.dart';
import 'package:task_of_shortest_path/common/utils/shortest_path_algorithm.dart';

import 'loading_state_notifier..dart';

class ShortestPathDataProvider extends ChangeNotifier
    with LoadingStateNotifier {
  GetShortestPathResponse? _getShortestPathResponse;
  List<PostShortestPathResponse>? _postShortestPathResponseList;

  final ShortestPathDataRepository repository;

  ShortestPathDataProvider({required this.repository});

  String? _path;

  GetShortestPathResponse? get getShortestPathResponse =>
      _getShortestPathResponse;

  List<PostShortestPathResponse>? get postShortestPathResponseList =>
      _postShortestPathResponseList;

  CustomException _shortestPathDataException = CustomException(null);

  CustomException get authException => _shortestPathDataException;

  double _progress = 0.0;

  double get progress => _progress;

  void setProgress(double value) {
    _progress = value;
    notifyListeners();
  }

  Future<void> fetchShortestPathData(String path) async {
    if (isLoading) return;

    setLoadingState(value: true);
    try {
      final response = await repository.getShortestPathData(path);
      _getShortestPathResponse = response;
      _path = path;
      notifyListeners();
    } on CustomResponseException catch (e) {
      _handleShortestPathDataError(e);
      rethrow;
    } finally {
      setLoadingState(value: false);
    }
  }

  Future<void> postShortestPathData() async {
    final path = _path;
    final shortestPathList = _postShortestPathResponseList;
    if (isLoading || path == null || shortestPathList == null) return;

    setLoadingState(value: true);
    try {
      _progress = 0.0;
      await repository.postShortestPathData(path, shortestPathList);
      notifyListeners();
      setProgress(progress * 100);
      await Future.delayed(const Duration(milliseconds: 1000));
    } on CustomResponseException catch (e) {
      _handleShortestPathDataError(e);
      rethrow;
    } finally {
      setLoadingState(value: false);
    }
  }

  Future<void> calculationShortestPath() async {
    if (isLoading) return;

    setLoadingState(value: true);

    try {
      final data = _getShortestPathResponse!.data;

      _postShortestPathResponseList = [];

      for (var i = 0; i < data.length; i++) {
        final task = data[i];
        final field = task.field;
        final start = task.start;
        final end = task.end;

        final shortestPathAlgorithm = ShortestPathAlgorithm(field, start, end);
        final shortestPath = shortestPathAlgorithm.solve();
        final pathString = shortestPath.map((point) => '(${point.x},${point.y})').join('->');

        _postShortestPathResponseList?.add(
          PostShortestPathResponse(
            id: task.id,
            steps: shortestPath,
            path: pathString,
          ),
        );
        notifyListeners();

        final progress = (i + 1) / data.length;
        setProgress(progress * 100);
        await Future.delayed(const Duration(milliseconds: 1000));

      }
    } on CustomResponseException catch (e) {
      _handleShortestPathDataError(e);
      rethrow;
    } finally {
      setLoadingState(value: false);
    }
  }


  void _handleShortestPathDataError(Exception? exception) {
    _shortestPathDataException = CustomException(exception);
  }
}
