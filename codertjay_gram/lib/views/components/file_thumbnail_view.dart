import 'package:codertjay_gram/state/image_upload/models/thumbnail_request.dart';
import 'package:codertjay_gram/state/image_upload/providers/thumbnail_provider.dart';
import 'package:codertjay_gram/views/components/animations/error_animation_view.dart';
import 'package:codertjay_gram/views/components/animations/loading_animation_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FileThumbnailView extends ConsumerWidget {
  final ThumbnailRequest thumbnailRequest;

  const FileThumbnailView({
    Key? key,
    required this.thumbnailRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumbnail = ref.watch(thumbnailProvider(
      thumbnailRequest,
    ));
    return thumbnail.when(
        error: (error, stackTrace) => const ErrorAnimationView(),
        loading: () => const LoadingAnimationView(),
        data: (imageWithAspectRatio) {
          return AspectRatio(
            aspectRatio: imageWithAspectRatio.aspectRatio,
            child: imageWithAspectRatio.image,
          );
        });
  }
}
