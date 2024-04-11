import 'package:cached_network_image/cached_network_image.dart';
import 'package:ct484_project/models/post.dart';
import 'package:flutter/material.dart';

class PostPreviewTile extends StatefulWidget {
  const PostPreviewTile({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  State<PostPreviewTile> createState() => _PostPreviewTileState();
}

class _PostPreviewTileState extends State<PostPreviewTile>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: CachedNetworkImage(
        imageUrl: widget.post.imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
