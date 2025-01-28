import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Result<User>> login(String email, String password);
}
