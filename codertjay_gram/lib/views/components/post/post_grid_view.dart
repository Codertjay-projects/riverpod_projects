import 'package:codertjay_gram/state/post/models/post.dart';
import 'package:codertjay_gram/views/components/post/post_thumbnail_view.dart';
import 'package:flutter/material.dart';

class PostGridView extends StatelessWidget {
  final Iterable<Post> posts;

  const PostGridView({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: 8.0, crossAxisSpacing: 8.0),
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        final post = posts.elementAt(index);
        return PostThumbnailView(
          post: post,
          onTapped: () {},
        );
      },
    );
  }
}
