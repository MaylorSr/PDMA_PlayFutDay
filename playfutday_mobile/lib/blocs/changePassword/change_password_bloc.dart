import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../services/user_service/user_service.dart';

class ValidationChangePassword extends FormBloc<String, String> {
  final UserService _userService;
  final oldPassword = TextFieldBloc(validators: [FieldBlocValidators.required]);

  final password = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final confirmPassword = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  Validator<String> _confirmPassword(
    TextFieldBloc passwordTextFieldBloc,
  ) {
    return (String? confirmPassword) {
      if (confirmPassword == passwordTextFieldBloc.value) {
        if (confirmPassword == oldPassword.value) {
          return 'The old password cannot be the same as the new one';
        }
        return null;
      }
      return 'Must be equal to password';
    };
  }

  ValidationChangePassword(this._userService) {
    addFieldBlocs(
      fieldBlocs: [oldPassword, password, confirmPassword],
    );

    confirmPassword
      ..addValidators([_confirmPassword(password)])
      ..subscribeToFieldBlocs([password]);
  }

  @override
  void onSubmitting() async {
    debugPrint(password.value);
    debugPrint(oldPassword.value);
    debugPrint(confirmPassword.value);

    await Future<void>.delayed(const Duration(seconds: 1));
    _userService.changePassword(
        oldPassword.value, password.value, confirmPassword.value);
    emitSuccess();
  }
}
