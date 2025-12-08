/// API 常量配置
class ApiConstants {
  static const String BASE_URL = 'http://192.168.50.227:8080';


  static const String GET_MUSIC_LIST_ENDPOINT = '/api/files/musics';

  static const String postsEndpoint = '/posts';

  // 使用文件名而不是完整路径来构建URL
  static String getMusicUrl(String filename) {
    // 对文件名进行URL编码，处理中文和特殊字符
    String encodedFilename = Uri.encodeComponent(filename);
    return '$BASE_URL/api/files/music/$encodedFilename';
  }

}