import 'package:codertjay_gram/state/post/providers/user_post_providers.dart';
import 'package:codertjay_gram/views/components/animations/empty_content_with_text_animation_view.dart';
import 'package:codertjay_gram/views/components/animations/error_animation_view.dart';
import 'package:codertjay_gram/views/components/animations/loading_animation_view.dart';
import 'package:codertjay_gram/views/components/post/post_grid_view.dart';
import 'package:codertjay_gram/views/components/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserPostView extends ConsumerWidget {
  const UserPostView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(userPostsProvider);
    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(userPostsProvider);
        return Future.delayed(const Duration(seconds: 1));
      },
      child: posts.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const EmptyContentWithTextAnimationView(
                text: Strings.youHaveNoPosts);
          } else {
            return PostGridView(
              posts: posts,
            );
          }
        },
        error: (error, stackTrace) {
          return const ErrorAnimationView();
        },
        loading: () {
          return const LoadingAnimationView();
        },
      ),
    );
  }
}
