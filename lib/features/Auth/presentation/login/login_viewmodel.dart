import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/entities/user.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/use_cases/login_use_case.dart';

@injectable
class LoginViewmodel extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginViewmodel(this._loginUseCase) : super(InitialState());
  void login(String email, String password) async {
    state = LoadingState();
    final result = await _loginUseCase.login(email, password).timeout(
        const Duration(seconds: 7),
        onTimeout: () =>
            Fail<User>(Exception("something went wrong try again")));
    switch (result) {
      case Success<User>():
        state = SuccessState(result.data!);
        return;
      case Fail<User>():
        state = ErrorState(result.exception!);
        return;
    }
  }

  void resetState() {
    state = InitialState();
  }
}

final loginProvider = StateNotifierProvider<LoginViewmodel, LoginState>(
    (ref) => getIt<LoginViewmodel>());

sealed class LoginState {}

class InitialState extends LoginState {}

class LoadingState extends LoginState {}

class SuccessState extends LoginState {
  final User user;
  SuccessState(this.user);
}

class ErrorState extends LoginState {
  final Exception error;
  ErrorState(this.error);
}
