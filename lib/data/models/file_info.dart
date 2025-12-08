//获取小米服务器文件
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