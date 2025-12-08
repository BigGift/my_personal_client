import 'package:flutter/material.dart';

class PhotoTab extends StatelessWidget {
  final List<String> photoList;

  const PhotoTab({Key? key, required this.photoList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: photoList.map((photo) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              photo,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 40,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFF6366F1)),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}