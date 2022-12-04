import 'dart:collection';

import 'package:codertjay_gram/state/constants/firebase_field.dart';
import 'package:codertjay_gram/state/post/typedefs/user_id.dart';
import "package:flutter/foundation.dart" show immutable;

@immutable
class UserInfoPayload extends MapView<String, String> {
  UserInfoPayload({
    required UserId userId,
    required String? displayName,
    required String? email,
  }) : super({
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.displayName: displayName ?? "",
          FirebaseFieldName.email: email ?? "",
        });


}
