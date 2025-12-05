// lib/pages/photos_page.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import '../services/file_service.dart';


class PhotosPage extends StatefulWidget {
  @override
  _PhotosPageState createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  List<FileInfo> photos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  _loadPhotos() async {
    final photoList = await FileService.getPhotos();
    setState(() {
      photos = photoList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('照片库')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : photos.isEmpty
          ? Center(child: Text('没有找到照片'))
          : GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoDetailPage(
                    imageUrl: FileService.getPhotoUrl(photos[index].name),
                  ),
                ),
              );
            },
            child: CachedNetworkImage(
              imageUrl: FileService.getPhotoUrl(photos[index].name),
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: Icon(Icons.photo, color: Colors.grey[600]),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          );
        },
      ),
    );
  }
}

class PhotoDetailPage extends StatelessWidget {
  final String imageUrl;

  PhotoDetailPage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PhotoView(
              imageProvider: NetworkImage(imageUrl),
              backgroundDecoration: BoxDecoration(color: Colors.black),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}