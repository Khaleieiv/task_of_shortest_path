import 'dart:convert';
import 'dart:io';

import 'package:task_of_shortest_path/common/domain/entities/get_shortest_path_data.dart';
import 'package:task_of_shortest_path/common/domain/entities/post_shortest_path_data.dart';
import 'package:task_of_shortest_path/common/domain/repositories/shortest_path_data_repository.dart';
import 'package:http/http.dart' as http;

class ShortestPathDataRepositoryIml extends ShortestPathDataRepository {
  final _client = http.Client();

  @override
  Future<GetShortestPathResponse> getShortestPathData(String path) async {
    final uri = Uri.parse(path);
    final response = await _client.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      return GetShortestPathResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to fetch shortest path data: ${response.statusCode}');
    }
  }

  @override
  Future<String> postShortestPathData(
      String path, PostShortestPathResponse result) async {
    final uri = Uri.parse(path);
    final body = [result.toJson()];
    final response = await _client.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == HttpStatus.ok) {
      return 'Success';
    } else if (response.statusCode == HttpStatus.tooManyRequests) {
      return 'Too many requests';
    } else if (response.statusCode == HttpStatus.internalServerError) {
      return 'Internal server error';
    } else {
      throw Exception(
          'Failed to post shortest path data: ${response.statusCode}');
    }
  }
}
