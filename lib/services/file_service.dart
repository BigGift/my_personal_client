// lib/services/file_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/models/file_info.dart';

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

  static String getPhotoUrl(String filename) {
    return '$baseUrl/api/files/photo/$filename';
  }

}

