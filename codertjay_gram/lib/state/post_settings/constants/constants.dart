import 'package:flutter/foundation.dart' show immutable;

@immutable
class Constants {
  static const allowLikesTitle = "Allow Likes";
  static const allowLikesDescription =
      "By allowing likes, users will be able to press"
      "the like button on your post";
  static const allowLikesStorageKey = "allow_likes";
  static const allowCommentsTitle = "Allow comments";
  static const allowCommentsDescription =
      "By allowing likes, users will be able to press"
      "to comment on your post";
  static const allowCommentsStorageKey = "allow_comments";

  const Constants._();
}
