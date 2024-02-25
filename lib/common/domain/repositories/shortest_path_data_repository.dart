import 'package:task_of_shortest_path/common/domain/entities/get_shortest_path_data.dart';
import 'package:task_of_shortest_path/common/domain/entities/post_shortest_path_data.dart';

abstract class ShortestPathDataRepository {
  Future<GetShortestPathResponse> getShortestPathData(String path);

  Future<String> postShortestPathData(
    String path,
    PostShortestPathResponse result,
  );
}
