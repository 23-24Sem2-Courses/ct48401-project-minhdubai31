import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatelessWidget {
  static const routeName = "/image_view";
  const ImageViewScreen({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo Viewer"),
      ),
      body: PhotoView(
        minScale: PhotoViewComputedScale.contained * 1,
        maxScale: PhotoViewComputedScale.contained * 2.5,
        backgroundDecoration: const BoxDecoration(
          color: Colors.white,
        ),
        imageProvider: CachedNetworkImageProvider(imageUrl),
      ),
    );
  }
}
