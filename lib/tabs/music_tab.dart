import 'package:flutter/material.dart';

class MusicTab extends StatelessWidget {
  final List<Map<String, String>> musicList;

  const MusicTab({Key? key, required this.musicList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: musicList.length,
      itemBuilder: (context, index) {
        final music = musicList[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              music['cover']!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(music['title']!),
          subtitle: Text(music['singer']!),
          trailing: const Icon(Icons.play_arrow, color: Color(0xFF6366F1)),
          onTap: () {
            // TODO: 播放音乐逻辑
          },
        );
      },
    );
  }
}