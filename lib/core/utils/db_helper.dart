import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart'; // 添加这个导入
import 'package:test0001/core/utils/permission_util.dart';

// 数据库工具类
class DbHelper {
  static Database? _db;
  static const String tableName = "health_data";

  // 初始化数据库
  static Future<Database> getDb() async {
    if (_db != null) return _db!;
    String dbPath = path.join(await getDatabasesPath(), "health_db.db");
    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            temp REAL NOT NULL,
            uricAcid REAL NOT NULL,
            bloodSugar REAL NOT NULL
          )
        ''');
      },
    );
    return _db!;
  }

  // 批量插入 Excel 数据（先清空旧数据，避免重复）
  static Future<int> insertExcelData(List<Map<String, dynamic>> dataList) async {
    Database db = await getDb();
    Batch batch = db.batch();
    await db.delete(tableName); // 可选：保留旧数据则删除此行
    for (var data in dataList) {
      batch.insert(tableName, data);
    }
    List<dynamic> results = await batch.commit();
    return results.length;
  }

  // 查询所有数据（用于图表展示）
  static Future<List<Map<String, dynamic>>> getAllData() async {
    Database db = await getDb();
    return await db.query(tableName, orderBy: "date ASC");
  }
}

// 导入 Excel 并存储到数据库
Future<int> importExcelToDb() async {
  bool hasPermission = await PermissionUtil.requestStoragePermission();
  if (!hasPermission) throw Exception("存储权限被拒绝");

  // 选择 Excel 文件
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ["xlsx", "xls"],
  );
  if (result == null) throw Exception("未选择文件");

  File file = File(result.files.single.path!);
  var bytes = await file.readAsBytes();
  var excel = Excel.decodeBytes(bytes);

  // 解析第一个工作表（假设数据在 Sheet1）
  Sheet sheet = excel.tables[excel.tables.keys.first]!;
  List<Map<String, dynamic>> dataList = [];

  // 跳过表头（第0行），从第1行开始解析
  for (int row = 1; row < sheet.maxRows; row++) {
    var rowData = sheet.row(row);
    if (rowData[0] == null) break; // 空行终止

    dataList.add({
      "date": rowData[0]?.value.toString() ?? "", // 日期
      "temp": double.tryParse(rowData[1]?.value.toString() ?? "0") ?? 0, // 温度
      "uricAcid": double.tryParse(rowData[2]?.value.toString() ?? "0") ?? 0, // 尿酸
      "bloodSugar": double.tryParse(rowData[3]?.value.toString() ?? "0") ?? 0, // 血糖
    });
  }

  // 插入数据库
  return await DbHelper.insertExcelData(dataList);
}

// 数据库数据 → 导出 Excel
// 将 SQLite 中的数据导出为.xlsx 文件，支持指定存储路径：
Future<String> exportDbToExcel() async {
  // 查询数据库所有数据
  List<Map<String, dynamic>> dataList = await DbHelper.getAllData();
  if (dataList.isEmpty) throw Exception("无数据可导出");

  // 创建 Excel 文件
  var excel = Excel.createExcel();
  Sheet sheet = excel['健康数据']; // 创建工作表

  // 设置表头 - 使用新的 API 方式
  sheet.appendRow([
    "日期",
    "温度(℃)",
    "尿酸值(μmol/L)",
    "血糖值(mmol/L)",
  ]);

  // 填充数据 - 使用新的 API 方式
  for (var data in dataList) {
    sheet.appendRow([
      data["date"],
      data["temp"],
      data["uricAcid"],
      data["bloodSugar"],
    ]);
  }

  // 保存文件（移动端存到下载目录，桌面端存到用户选择路径）
  String filePath;
  if (Platform.isAndroid || Platform.isIOS) {
    String downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir = "/storage/emulated/0/Download";
    } else {
      // iOS 使用 documents 目录
      Directory appDocDir = await getApplicationDocumentsDirectory();
      downloadsDir = appDocDir.path;
    }
    filePath = path.join(downloadsDir, "健康数据_${DateTime.now().toString().substring(0, 10)}.xlsx");
  } else {
    String? savePath = await FilePicker.platform.saveFile(
      dialogTitle: "选择导出路径",
      fileName: "健康数据_${DateTime.now().toString().substring(0, 10)}.xlsx",
      type: FileType.custom,
      allowedExtensions: ["xlsx"],
    );
    if (savePath == null) throw Exception("取消导出");
    filePath = savePath;
  }

  // 写入文件
  File file = File(filePath);
  await file.writeAsBytes(excel.encode()!);
  return filePath; // 返回文件路径，用于打开文件
}