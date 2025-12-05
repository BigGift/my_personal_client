// lib/services/file_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class FileService {
  //static const String baseUrl = 'http://192.168.50.227:8080'; // 替换为你的服务器IP

  static const String baseUrl = 'http://192.168.50.227:8080'; // 替换为你的服务器IP

  static Future<List<FileInfo>> getPhotos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/files/photos'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => FileInfo.fromJson(item)).toList();
      }
      throw Exception('Failed to load photos');
    } catch (e) {
      print('Error loading photos: $e');
      return [];
    }
  }

  static Future<List<FileInfo>> getMusics() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/files/musics'));
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

  // 使用文件名而不是完整路径来构建URL
  static String getMusicUrl(String filename) {
    // 对文件名进行URL编码，处理中文和特殊字符
    String encodedFilename = Uri.encodeComponent(filename);
    return '$baseUrl/api/files/music/$encodedFilename';
  }

  static String getPhotoUrl(String filename) {
    return '$baseUrl/api/files/photo/$filename';
  }

  // static String getMusicUrl(String filename) {
  //   return '$baseUrl/api/files/music/$filename';
  // }
}

class FileInfo {
  final String name;
  final String path;
  final int size;

  FileInfo({required this.name, required this.path, required this.size});

  factory FileInfo.fromJson(Map<String, dynamic> json) {
    return FileInfo(
      name: json['name'],
      path: json['path'],
      size: json['size']?.toInt() ?? 0,
    );
  }
}