import 'package:flutter/foundation.dart' show immutable;

@immutable
class Strings {
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

  static const comments = 'Comments';
  static const loading = 'loading';
  static const person = 'person';
  static const people = 'people';
  static const likedThis = 'Liked this';
  static const delete = 'Delete';
  static const areYouSureYouWantToDeleteThis =
      'Are you sure you want to delete this';
  static const cancel = "Cancel";



  const Strings._();
}
