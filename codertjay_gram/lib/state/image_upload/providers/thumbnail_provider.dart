import 'package:codertjay_gram/state/image_upload/exceptions/could_not_build_thumbnail_exception.dart';
import 'package:codertjay_gram/state/image_upload/extensions/get_image_aspect_ratio.dart';
import 'package:codertjay_gram/state/image_upload/models/file_type.dart';
import 'package:codertjay_gram/state/image_upload/models/image_with_aspect_ratio.dart';
import 'package:codertjay_gram/state/image_upload/models/thumbnail_request.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

final thumbnailProvider = FutureProvider.family
    .autoDispose<ImageWithAspectRatio, ThumbnailRequest>(
        (ref, ThumbnailRequest request) async {
  final Image image;
  switch (request.fileType) {
    case FileType.image:
      image = await Image.file(
        request.file,
        fit: BoxFit.fitHeight,
      );
      break;
    case FileType.video:
      final thumb = await VideoThumbnail.thumbnailData(
          video: request.file.path, imageFormat: ImageFormat.JPEG, quality: 75);
      if (thumb == null) {
        throw const CouldNotBuildThumbnailException();
      }
      image = Image.memory(
        thumb,
        fit: BoxFit.fitHeight,
      );
      break;
  }

  final aspectRatio = await image.getAspectRatio();
  return ImageWithAspectRatio(
    image: image,
    aspectRatio: aspectRatio,
  );
});
