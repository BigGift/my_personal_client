// lib/pages/music_debug_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MusicDebugPage extends StatefulWidget {
  @override
  _MusicDebugPageState createState() => _MusicDebugPageState();
}

class _MusicDebugPageState extends State<MusicDebugPage> {
  String _log = '';
  bool _isTesting = false;

  void _addLog(String message) {
    print(message);
    setState(() {
      _log = '${DateTime.now()}: $message\n$_log';
    });
  }

  // 测试URL访问
  _testUrlAccess() async {
    _addLog('=== 测试URL访问 ===');
    setState(() => _isTesting = true);

    try {
      const baseUrl = 'http://192.168.50.227:8080';
      const testFilename = '老狼 - 同桌的你.mp3';
      final encodedFilename = Uri.encodeComponent(testFilename);
      final musicUrl = '$baseUrl/api/files/music/$encodedFilename';

      _addLog('测试URL: $musicUrl');

      // 测试HEAD请求
      _addLog('发送HEAD请求...');
      final headResponse = await http.head(Uri.parse(musicUrl));
      _addLog('HEAD响应状态: ${headResponse.statusCode}');
      _addLog('HEAD响应头: ${headResponse.headers}');

      if (headResponse.statusCode == 200) {
        _addLog('✅ HEAD请求成功');

        // 测试GET请求
        _addLog('发送GET请求...');
        final getResponse = await http.get(Uri.parse(musicUrl));
        _addLog('GET响应状态: ${getResponse.statusCode}');
        _addLog('GET内容长度: ${getResponse.bodyBytes.length} bytes');
        _addLog('GET Content-Type: ${getResponse.headers['content-type']}');

        if (getResponse.statusCode == 200) {
          _addLog('✅ GET请求成功，文件可以访问');

          // 检查文件内容
          if (getResponse.bodyBytes.length > 0) {
            _addLog('✅ 文件内容非空');

            // 检查文件头（MP3文件应该有特定的文件头）
            if (getResponse.bodyBytes.length >= 3) {
              final header = getResponse.bodyBytes.sublist(0, 3);
              _addLog('文件头(hex): ${header.map((b) => b.toRadixString(16)).join(' ')}');

              // MP3文件通常以 0xFF 0xFB 或 ID3 开头
              if (header[0] == 0xFF && header[1] == 0xFB) {
                _addLog('✅ 文件头看起来是有效的MP3');
              } else if (header[0] == 0x49 && header[1] == 0x44 && header[2] == 0x33) {
                _addLog('✅ 文件头是ID3格式的MP3');
              } else {
                _addLog('⚠️ 文件头不是标准的MP3格式');
              }
            }
          } else {
            _addLog('❌ 文件内容为空');
          }
        } else {
          _addLog('❌ GET请求失败');
        }
      } else {
        _addLog('❌ HEAD请求失败，服务器返回错误状态');

        // 尝试获取错误信息
        final errorResponse = await http.get(Uri.parse(musicUrl));
        _addLog('错误响应体: ${errorResponse.body}');
      }
    } catch (e) {
      _addLog('❌ 测试过程中出现异常: $e');
    } finally {
      setState(() => _isTesting = false);
    }
  }

  // 测试直接文件下载
  _testFileDownload() async {
    _addLog('=== 测试文件下载 ===');

    try {
      const baseUrl = 'http://192.168.50.227:8080';
      const testFilename = '老狼 - 同桌的你.mp3';
      final encodedFilename = Uri.encodeComponent(testFilename);
      final musicUrl = '$baseUrl/api/files/music/$encodedFilename';

      _addLog('开始下载文件...');
      final request = await http.Client().send(http.Request('GET', Uri.parse(musicUrl)));

      _addLog('响应状态: ${request.statusCode}');
      _addLog('响应头: ${request.headers}');

      final response = await http.get(Uri.parse(musicUrl));
      _addLog('下载完成，文件大小: ${response.bodyBytes.length} bytes');

    } catch (e) {
      _addLog('下载失败: $e');
    }
  }

  // 测试其他音乐文件
  _testOtherFiles() async {
    _addLog('=== 测试其他音乐文件 ===');

    try {
      const baseUrl = 'http://192.168.50.227:8080';
      final testFiles = ['无人之岛.mp3', '恋人.mp3', '跳楼机.mp3'];

      for (final filename in testFiles) {
        _addLog('测试文件: $filename');
        final encodedFilename = Uri.encodeComponent(filename);
        final musicUrl = '$baseUrl/api/files/music/$encodedFilename';

        final response = await http.head(Uri.parse(musicUrl));
        _addLog('$filename 状态: ${response.statusCode}');

        if (response.statusCode == 200) {
          _addLog('✅ $filename 可以访问');
        } else {
          _addLog('❌ $filename 访问失败');
        }
      }
    } catch (e) {
      _addLog('测试其他文件失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('音乐URL调试')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isTesting ? null : _testUrlAccess,
              child: Text('测试URL访问'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isTesting ? null : _testFileDownload,
              child: Text('测试文件下载'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isTesting ? null : _testOtherFiles,
              child: Text('测试其他文件'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(_log),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}