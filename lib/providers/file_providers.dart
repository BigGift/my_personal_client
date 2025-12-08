import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test0001/data/models/file_info.dart';

import '../data/models/post_model.dart';
import '../data/repositories/file_repository.dart';
import '../services/audio_player_service.dart';


/// 文章仓库提供者（单例）
final fileRepositoryProvider = Provider<FileRepository>((ref) {
  return FileRepository();
});

/// 音乐列表状态提供者
final fileMusicListProvider = FutureProvider<List<FileInfo>>((ref) async {
  final repository = ref.read(fileRepositoryProvider);
  return repository.getMusics();
});

/// 音频播放服务提供者（单例）
final audioPlayerServiceProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService();
  // 当 Provider 销毁时释放资源
  ref.onDispose(() => service.dispose());
  return service;
});

/// 单篇文章状态提供者（支持动态 ID）
final singlePostProvider = FutureProvider.family<PostModel, int>((ref, postId) async {
  final repository = ref.read(fileRepositoryProvider);
  return repository.fetchPost(postId);
});

/// 文章筛选状态提供者（示例：用于本地筛选）
final filteredPostsProvider = StateProvider<List<PostModel>>((ref) {
  return [];
});