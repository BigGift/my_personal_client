import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../../core/utils/m_http_client.dart';
import '../../services/file_service.dart';
import '../models/file_info.dart';
import '../models/post_model.dart';


/// 文章数据仓库 - 封装网络请求逻辑
class FileRepository {
  /// 获取单篇文章
  Future<PostModel> fetchPost(int postId) async {
    final url = '${ApiConstants.BASE_URL}${ApiConstants.postsEndpoint}/$postId';
    final response = await MHttpClient.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return PostModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch post: ${response.statusCode}');
    }
  }

  /// 获取文章列表
  Future<List<PostModel>> fetchPostList() async {
    final url = '${ApiConstants.BASE_URL}${ApiConstants.postsEndpoint}';
    final response = await MHttpClient.get(url);

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch posts: ${response.statusCode}');
    }
  }

  //获取音乐列表
  Future<List<FileInfo>> getMusics() async {
    final url = '${ApiConstants.BASE_URL}${ApiConstants.GET_MUSIC_LIST_ENDPOINT}';
    try {
      final response = await MHttpClient.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => FileInfo.fromJson(item)).toList();
      }
      throw Exception('Failed to load musics');
    } catch (e) {
      print('Error loading musics: $e');
      return [];
    }
  }
}