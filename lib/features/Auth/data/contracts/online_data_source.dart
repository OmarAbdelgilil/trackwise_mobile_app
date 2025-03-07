import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/entities/user.dart';

abstract class OnlineDataSource {
  Future<Result<(User, String)>> login(String eamil, String password);
  Future<Result<void>> register(String email, String firstName, String lastName,String phoneNumber, String password, String confirmPassword);
}
