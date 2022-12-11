import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codertjay_gram/state/auth/providers/user_id_provider.dart';
import 'package:codertjay_gram/state/constants/firebase_collection_name.dart';
import 'package:codertjay_gram/state/constants/firebase_field.dart';
import 'package:codertjay_gram/state/post/models/post.dart';
import 'package:codertjay_gram/state/post/models/post_key.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userPostsProvider = StreamProvider.autoDispose<Iterable<Post>>((ref) {
  final userId = ref.watch(userIdProvider);
  final controller = StreamController<Iterable<Post>>();
  controller.onListen = () {
    controller.sink.add([]);
  };
  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.posts)
      .orderBy(
        FirebaseFieldName.createdAt,
        descending: true,
      )
      .where(PostKey.userId, isEqualTo: userId)
      .snapshots()
      .listen((snapshots) {
    final documents = snapshots.docs;
    final posts = documents
        .where(
          (doc) => !doc.metadata.hasPendingWrites,
        )
        .map(
          (doc) => Post(
            postId: doc.id,
            json: doc.data(),
          ),
        );
    controller.sink.add(posts);
  });
  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});
