import 'package:flutter/material.dart';

class DiaryDetailPage extends StatelessWidget {
  final Map<String, String> diary; // 接收单个日记数据

  const DiaryDetailPage({super.key, required this.diary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 透明AppBar，配合背景色，更沉浸
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.pop(context), // 返回上一页
        ),
        actions: [
          // 分享按钮（可根据需求实现功能）
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF1F2937)),
            onPressed: () {
              // 分享逻辑：调用系统分享或自定义分享
            },
          ),
          // 编辑按钮（可选）
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF1F2937)),
            onPressed: () {
              // 编辑逻辑：跳转到编辑页
            },
          ),
        ],
      ),
      // 背景色和列表页呼应，保持一致性
      backgroundColor: const Color(0xFFF5F9FF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white, // 白色卡片，突出内容
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 日记标题
                Text(
                  diary['title']!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                    height: 1.3, // 行高，提升阅读体验
                  ),
                ),
                const SizedBox(height: 16),
                // 日期+分隔线
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, color: Colors.grey[400], size: 16),
                    const SizedBox(width: 8),
                    Text(
                      diary['date']!,
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.grey[100], thickness: 1.5),
                const SizedBox(height: 20),
                // 日记内容（不限制行数，完全显示）
                Text(
                  diary['content']!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF374151),
                    height: 1.8, // 行高1.8，阅读更舒适
                    letterSpacing: 0.3, // 字间距，提升排版质感
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}