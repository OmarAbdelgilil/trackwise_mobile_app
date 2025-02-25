import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:track_wise_mobile_app/core/common/result.dart';
import 'package:track_wise_mobile_app/core/di/di.dart';
import 'package:track_wise_mobile_app/features/Auth/domain/use_cases/register_use_case.dart';

@injectable
class RegisterViewmodel extends StateNotifier<RegisterState> {
  final RegisterUseCase _registerUseCase;
  RegisterViewmodel(this._registerUseCase) : super(RegInitialState());
  void register(String email, String firstName, String lastName,String phoneNumber, String password, String confirmPassword) async {
    state = RegLoadingState();
    final result = await _registerUseCase.register(email, firstName, lastName, phoneNumber, password, confirmPassword);
    switch (result) {
      case Success<void>():
        state = RegSuccessState();
        return;
      case Fail<void>():
        state = RegErrorState(result.exception!);
        return;
    }
  }
  void resetState()
  {
    state = RegInitialState();
  }
}

final registerProvider = StateNotifierProvider<RegisterViewmodel, RegisterState>(
    (ref) => getIt<RegisterViewmodel>());

sealed class RegisterState {}

class RegInitialState extends RegisterState {}

class RegLoadingState extends RegisterState {}

class RegSuccessState extends RegisterState {}

class RegErrorState extends RegisterState {
  final Exception error;
  RegErrorState(this.error);
}
