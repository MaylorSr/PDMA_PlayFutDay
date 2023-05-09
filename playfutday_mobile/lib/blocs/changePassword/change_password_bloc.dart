import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:playfutday_flutter/models/apiError.dart';

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
    var response = await _userService.changePassword(
        oldPassword.value, password.value, confirmPassword.value);
    if (response.statusCode == 200) {
      await Future<void>.delayed(const Duration(seconds: 1));
      emitSuccess();
    } else {
      Error error = Error.fromJson(jsonDecode(response.body));

      error.subErrors == null
          ? oldPassword.addFieldError(error.message.toString())
          : error.subErrors?.forEach((subError) {
              switch (subError.field) {
                case "newPassword":
                  password.addFieldError(subError.message.toString());
                  confirmPassword.addFieldError(subError.message.toString());
                  break;
                case "password":
                  password.addFieldError(subError.message.toString());
                  confirmPassword.addFieldError(subError.message.toString());
                  break;
              }
            });
      await Future<void>.delayed(const Duration(seconds: 1));
      emitFailure(failureResponse: "Hubo un nerror con la respuesta");
    }
  }
}
