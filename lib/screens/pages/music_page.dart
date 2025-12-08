// lib/pages/music_page.dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import '../../data/models/file_info.dart';
import '../../data/repositories/file_repository.dart';
import '../../services/file_service.dart';

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
    //_loadMusics();
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

  // _loadMusics() async {
  //   final musicList = await FileRepository.getMusics();
  //   setState(() {
  //     musics = musicList;
  //     isLoading = false;
  //   });
  // }

// 修改 lib/pages/music_page.dart 中的 _playMusic 方法




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
            // subtitle: Text(formatFileSize(music.size)),
            // trailing: IconButton(
            //   icon: Icon(
            //     isPlaying ? Icons.pause : Icons.play_arrow,
            //     color: isPlaying ? Colors.red : Colors.green,
            //   ),
            //   onPressed: () => _playMusic(music.name),
            // ),
            // onTap: () => _playMusic(music.name),
          );
        },
      ),
    );
  }
}