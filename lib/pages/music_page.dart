// lib/pages/music_page.dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import '../services/file_service.dart';

class MusicPage extends StatefulWidget {
  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  List<FileInfo> musics = [];
  bool isLoading = true;
  AudioPlayer audioPlayer = AudioPlayer();
  String? currentPlaying;
  PlayerState playerState = PlayerState.stopped;
  @override
  void initState() {
    super.initState();
    _loadMusics();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        playerState = state;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  _loadMusics() async {
    final musicList = await FileService.getMusics();
    setState(() {
      musics = musicList;
      isLoading = false;
    });
  }

// 修改 lib/pages/music_page.dart 中的 _playMusic 方法
  _playMusic(String filename) async {
    try {
      print('尝试播放: $filename');

      if (currentPlaying == filename ) {
        // 暂停播放
        print('暂停播放');
        await audioPlayer.pause();
      } else {
        if (currentPlaying != filename) {
          // 播放新音乐
          print('开始播放新音乐');

          // 先停止当前播放
          await audioPlayer.stop();

          // 构建播放URL（使用文件名）
          String musicUrl = FileService.getMusicUrl(filename);
          print('音乐播放URL: $musicUrl');

          // 先验证URL是否可以访问
          print('验证URL访问...');
          final response = await http.head(Uri.parse(musicUrl));
          print('URL验证状态: ${response.statusCode}');

          if (response.statusCode == 200) {
            print('URL验证成功，开始播放...');
            await audioPlayer.play(UrlSource(musicUrl));

            setState(() {
              currentPlaying = filename;
            });

            print('播放指令已发送');
          } else {
            print('URL验证失败，状态码: ${response.statusCode}');
            throw Exception('无法访问音乐文件，服务器返回状态码: ${response.statusCode}');
          }
        } else {
          // 恢复播放
          print('恢复播放');
          await audioPlayer.resume();
        }
      }
    } catch (e) {
      print('播放音乐时出错: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('播放失败: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  _formatFileSize(int size) {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('音乐库'),
              actions:[
                IconButton(
                  icon: Icon(Icons.library_music),
                  onPressed: () async {
                    String testUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
                    await audioPlayer.play(UrlSource(testUrl));
                  },
                )
              ] ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : musics.isEmpty
          ? Center(child: Text('没有找到音乐文件'))
          : ListView.builder(
        itemCount: musics.length,
        itemBuilder: (context, index) {
          final music = musics[index];
          final isPlaying = currentPlaying == music.name &&
              playerState == PlayerState.playing;

          return ListTile(
            leading: Icon(Icons.music_note, color: Colors.blue),
            title: Text(music.name),
            subtitle: Text(_formatFileSize(music.size)),
            trailing: IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: isPlaying ? Colors.red : Colors.green,
              ),
              onPressed: () => _playMusic(music.name),
            ),
            onTap: () => _playMusic(music.name),
          );
        },
      ),
    );
  }
}