import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import '../../core/utils/db_helper.dart';
import '../health_chart.dart';

class ExcelHealthPage extends StatefulWidget {
  const ExcelHealthPage({super.key});

  @override
  State<ExcelHealthPage> createState() => _ExcelHealthPageState();
}

class _ExcelHealthPageState extends State<ExcelHealthPage> {
  List<Map<String, dynamic>> _dataList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDataFromDb(); // 初始化加载数据库数据
  }

  // 从数据库加载数据
  Future<void> _loadDataFromDb() async {
    setState(() => _isLoading = true);
    _dataList = await DbHelper.getAllData();
    setState(() => _isLoading = false);
  }

  // 导入Excel并刷新数据
  Future<void> _importExcel() async {
    try {
      int count = await importExcelToDb();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("导入成功！共${count}条数据")));
      await _loadDataFromDb();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("导入失败：$e")));
    }
  }

  // 导出Excel
  Future<void> _exportExcel() async {
    try {
      String filePath = await exportDbToExcel();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("导出成功！路径：$filePath")));
      await OpenFilex.open(filePath); // 自动打开导出的文件
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("导出失败：$e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("健康数据管理")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 导入/导出按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _importExcel,
                  icon: const Icon(Icons.upload_file),
                  label: const Text("导入Excel"),
                ),
                ElevatedButton.icon(
                  onPressed: _dataList.isEmpty ? null : _exportExcel,
                  icon: const Icon(Icons.download),
                  label: const Text("导出Excel"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 图表展示（无数据时显示提示）
            _dataList.isEmpty
                ? const Expanded(child: Center(child: Text("暂无数据，请导入Excel文件")))
                : Expanded(child: HealthChart(dataList: _dataList)),
          ],
        ),
      ),
    );
  }
}