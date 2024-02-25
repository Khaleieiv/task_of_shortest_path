import 'package:flutter/material.dart';
import 'package:task_of_shortest_path/common/domain/entities/get_shortest_path_data.dart';
import 'package:task_of_shortest_path/common/domain/entities/post_shortest_path_data.dart';
import 'package:task_of_shortest_path/common/domain/entities/result_list_data.dart';
import 'package:task_of_shortest_path/common/domain/repositories/shortest_path_data_repository.dart';
import 'package:task_of_shortest_path/common/utils/custom_exception.dart';
import 'package:task_of_shortest_path/common/utils/shortest_path_algorithm.dart';

import 'loading_state_notifier..dart';

class ShortestPathDataProvider extends ChangeNotifier
    with LoadingStateNotifier {
  GetShortestPathResponse? _getShortestPathResponse;

  List<PostShortestPathResponse>? _postShortestPathResponseList;

  List<ResultListData>? _resultListData;

  ResultListData? _currentResultLData;

  String? _messageServer;

  final ShortestPathDataRepository repository;

  ShortestPathDataProvider({required this.repository});

  GetShortestPathResponse? get getShortestPathResponse =>
      _getShortestPathResponse;

  List<PostShortestPathResponse>? get postShortestPathResponseList =>
      _postShortestPathResponseList;

  List<ResultListData>? get resultListData => _resultListData;

  ResultListData? get currentResultLData => _currentResultLData;

  String? get messageServer => _messageServer;

  CustomException _shortestPathDataException = CustomException(null);

  CustomException get authException => _shortestPathDataException;

  String? _path;

  double _progress = 0.0;

  double get progress => _progress;

  void setProgress(double value) {
    _progress = value;
    notifyListeners();
  }

  void setCurrentResultListData(ResultListData? dataList) {
    _currentResultLData = dataList;
    notifyListeners();
  }

  Future<void> fetchShortestPathData(String path) async {
    try {
      final response = await repository.getShortestPathData(path);
      _getShortestPathResponse = response;
      _path = path;
      notifyListeners();
    } on CustomResponseException catch (e) {
      _handleShortestPathDataError(e);
      rethrow;
    }
  }

  Future<void> postShortestPathData() async {
    final path = _path;
    final shortestPathList = _postShortestPathResponseList;

    if (isPostInProgress || path == null || shortestPathList == null) return;

    setLoading(value: true, loadingType: 'post');
    try {

      final response = await repository.postShortestPathData(path, shortestPathList);
      _messageServer = response;
      notifyListeners();

    } on CustomResponseException catch (e) {
      _handleShortestPathDataError(e);
      rethrow;
    } finally {
      setLoading(value: false, loadingType: 'post');
    }
  }

  Future<void> calculationShortestPath() async {
    if (isCalculationInProgress) return;

    setLoading(value: true, loadingType: 'calculation');

    try {
      final data = _getShortestPathResponse!.data;

      _messageServer = "";
      _postShortestPathResponseList = [];
      _resultListData = [];

      for (var i = 0; i < data.length; i++) {
        final task = data[i];
        final field = task.field;
        final start = task.start;
        final end = task.end;

        final shortestPathAlgorithm = ShortestPathAlgorithm(field, start, end);
        final shortestPath = shortestPathAlgorithm.findShortestPath();
        final pathString =
            shortestPath.map((point) => '(${point.x},${point.y})').join('->');

        _postShortestPathResponseList?.add(
          PostShortestPathResponse(
            id: task.id,
            steps: shortestPath,
            path: pathString,
          ),
        );
        _resultListData?.add(
          ResultListData(
            id: task.id,
            field: field,
            start: start,
            end: end,
            steps: shortestPath,
            path: pathString,
          ),
        );

        notifyListeners();

        final progress = (i + 1) / data.length;
        setProgress(progress);
        await Future.delayed(const Duration(milliseconds: 1000));
      }
    } on CustomResponseException catch (e) {
      _handleShortestPathDataError(e);
      rethrow;
    } finally {
      setLoading(value: false, loadingType: 'calculation');
    }
  }

  void _handleShortestPathDataError(Exception? exception) {
    _shortestPathDataException = CustomException(exception);
  }
}
