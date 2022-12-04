import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codertjay_gram/state/constants/firebase_collection_name.dart';
import 'package:codertjay_gram/state/constants/firebase_field.dart';
import 'package:codertjay_gram/state/post/typedefs/user_id.dart';
import 'package:codertjay_gram/state/user_info/models/user_info_payload.dart';
import "package:flutter/foundation.dart" show immutable;

@immutable
class UserInfoStorage {
  const UserInfoStorage();

  Future<bool> saveUserInfo({
    required UserId userId,
    required String displayName,
    required String? email,
  }) async {
    try {
      final userInfo = await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.users,
          )
          .where(FirebaseFieldName.userId, isEqualTo: userId)
          .limit(1)
          .get();

      if (userInfo.docs.isNotEmpty) {
        /*We already get the user info */
        await userInfo.docs.first.reference.update({
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email ?? "",
        });
        return true;
      }
      /* we don't have this user from before*/
      final payload = UserInfoPayload(
        userId: userId,
        displayName: displayName,
        email: email ?? "",
      );
      await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.users,
          )
          .add(payload);
      return true;
    } catch (error) {
      return false;
    }
  }
//
}
