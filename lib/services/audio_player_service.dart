// lib/services/audio_player_service.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';

/// 音频播放服务 - 封装所有音频相关逻辑
class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentPlaying;
  PlayerState _playerState = PlayerState.stopped;

  // 播放状态变化回调（用于通知 UI 更新）
  Function(PlayerState)? onPlayerStateChanged;
  Function(String?)? onCurrentPlayingChanged;

  AudioPlayerService() {
    // 监听播放器状态变化
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _playerState = state;
      // 通知外部状态变化
      onPlayerStateChanged?.call(state);
    });
  }

  /// 获取当前播放状态
  PlayerState get playerState => _playerState;

  /// 获取当前播放的音乐文件名
  String? get currentPlaying => _currentPlaying;

  /// 播放/暂停音乐
  Future<void> togglePlay(String filename, BuildContext context) async {
    try {
      print('尝试播放: $filename');

      if (_currentPlaying == filename) {
        // 暂停播放
        print('暂停播放');
        await _audioPlayer.pause();
      } else {
        if (_currentPlaying != filename) {
          // 播放新音乐
          print('开始播放新音乐');

          // 先停止当前播放
          await _audioPlayer.stop();

          // 构建播放URL（使用文件名）
          String musicUrl = ApiConstants.getMusicUrl(filename);
          print('音乐播放URL: $musicUrl');

          // 先验证URL是否可以访问
          print('验证URL访问...');
          final response = await http.head(Uri.parse(musicUrl));
          print('URL验证状态: ${response.statusCode}');

          if (response.statusCode == 200) {
            print('URL验证成功，开始播放...');
            await _audioPlayer.play(UrlSource(musicUrl));

            _currentPlaying = filename;
            // 通知外部当前播放音乐变化
            onCurrentPlayingChanged?.call(filename);

            print('播放指令已发送');
          } else {
            print('URL验证失败，状态码: ${response.statusCode}');
            throw Exception('无法访问音乐文件，服务器返回状态码: ${response.statusCode}');
          }
        } else {
          // 恢复播放
          print('恢复播放');
          await _audioPlayer.resume();
        }
      }
    } catch (e) {
      print('播放音乐时出错: $e');
      // 显示错误提示
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('播放失败: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  /// 释放资源
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}