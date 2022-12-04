import 'package:codertjay_gram/state/auth/providers/auth_state_provider.dart';
import 'package:codertjay_gram/state/post/typedefs/user_id.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userIdProvider = Provider<UserId?>(
  (ref) => ref.watch(authStateProvider).userId,
);

