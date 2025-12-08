import 'package:http/http.dart' as http;

/// HTTP 客户端工具类
class MHttpClient {
  static final http.Client _client = http.Client();

  /// 发送 GET 请求
  static Future<http.Response> get(String url) async {
    return await _client.get(Uri.parse(url));
  }

  /// 发送 POST 请求
  static Future<http.Response> post(String url, {Object? body}) async {
    return await _client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }
}