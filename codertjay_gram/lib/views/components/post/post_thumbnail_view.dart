import 'package:codertjay_gram/state/post/models/post.dart';
import 'package:flutter/material.dart';

class PostThumbnailView extends StatelessWidget {
  final Post post;
  final VoidCallback onTapped;

  const PostThumbnailView({required this.post, required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onTapped,
      child: Image.network(
        post.thumbnailUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
