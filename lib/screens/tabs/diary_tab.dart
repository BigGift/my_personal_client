import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/file_providers.dart';
import '../pages/DiaryDetailPage.dart';

class DiaryTab extends ConsumerWidget  {
  final List<Map<String, String>> diaryList;

  const DiaryTab({Key? key, required this.diaryList}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // 监听文章列表状态
   // final postListAsync = ref.watch(postListProvider);

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: diaryList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final diary = diaryList[index];
        return GestureDetector(
          // 点击跳转
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (context, animation, secondaryAnimation) => DiaryDetailPage(diary: diary),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
                    return FadeTransition(opacity: fade, child: child);
                  },
                ),
              );
            },

        child:  Card(
          elevation: 2, // 降低阴影，更柔和
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.white12, width: 1), // 细白边，提升精致感
          ),
          color: const Color(0xFF90CAF9), // 推荐的淡天蓝背景
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  diary['title']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937), // 深色文字，提高对比度
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  diary['content']!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4B5563), // 中深色文字，比原来更清晰
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    diary['date']!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        );
      },
    );
  }
}