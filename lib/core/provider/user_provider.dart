import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/entities/user.dart';

@lazySingleton
class UserNotifier extends StateNotifier<User?> {
  String? _token;

  UserNotifier() : super(null);

  void setUser(User user, String token) {
    _token = token;
    state = user;
  }

  void clearUser() {
    _token = null;
    state = null;
  }

  String? get token => _token;
}

final userProvider =
    StateNotifierProvider<UserNotifier, User?>((ref) => getIt<UserNotifier>());
