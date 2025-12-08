import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:test0001/core/utils/file_utils.dart';

import '../../core/constants/api_constants.dart';
import '../../providers/file_providers.dart';

class MusicTab extends ConsumerStatefulWidget {
  //final List<Map<String, String>> musicList;

  //const MusicTab({Key? key, required this.musicList}) : super(key: key);
  const MusicTab({super.key});

  @override
  ConsumerState<MusicTab> createState() => _MusicTabState();
}

class _MusicTabState extends ConsumerState<MusicTab>  {

  // 本地状态：从服务同步
  String? currentPlaying;
  PlayerState playerState = PlayerState.stopped;

  @override
  void initState() {
    super.initState();
    // 获取音频服务实例
    final audioService = ref.read(audioPlayerServiceProvider);

    // 注册状态变化回调
    audioService.onPlayerStateChanged = (state) {
      setState(() {
        playerState = state;
      });
    };

    audioService.onCurrentPlayingChanged = (filename) {
      setState(() {
        currentPlaying = filename;
      });
    };
  }


  @override
  Widget build(BuildContext context) {
    // 监听音乐列表状态
    final getMusicListAsync = ref.watch(fileMusicListProvider);
    // 获取音频服务实例
    final audioService = ref.read(audioPlayerServiceProvider);

    return getMusicListAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $error', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: ()  => ref.refresh(fileMusicListProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
      data: (musics) =>
          ListView.builder(
            itemCount: musics.length,
            itemBuilder: (context, index) {
              final music = musics[index];
              final isPlaying = currentPlaying == music.name &&
                  playerState == PlayerState.playing;

              return ListTile(
                leading: Icon(Icons.music_note, color: Colors.blue),
                title: Text(music.name),
                subtitle: Text(FileUtils.formatFileSize(music.size)),
                trailing: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: isPlaying ? Colors.red : Colors.green,
                  ),
                  onPressed: () => audioService.togglePlay(music.name, context),
                ),
                onTap: () => audioService.togglePlay(music.name, context),
              );
            },
          ),
    );
  }
}