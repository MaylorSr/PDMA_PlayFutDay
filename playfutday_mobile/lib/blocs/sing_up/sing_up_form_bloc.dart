import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:playfutday_flutter/models/apiError.dart';
import 'package:playfutday_flutter/models/sing_up.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';

class ValidationSingUpForm extends FormBloc<String, String> {
  final password = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );
  final confirmPassword = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );
  final username = TextFieldBloc(validators: [FieldBlocValidators.required]);

  final email = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );

  final phone = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      (value) {
        if (value.isNotEmpty) {
          if (value.length == 9) {
            return null;
          }
        }
        return 'Phone number must be 9 digits';
      }
    ],
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

  ValidationSingUpForm() {
    addFieldBlocs(
      fieldBlocs: [email, username, phone, password, confirmPassword],
    );

    confirmPassword
      ..addValidators([_confirmPassword(password)])
      ..subscribeToFieldBlocs([password]);
  }

  Future<dynamic> veriFyCode(String code) async {
    var response = await UserService().verifyCode(code);
    Error error = Error.fromJson(jsonDecode(response.body));

    if (response.statusCode != 200) {
      return error.message;
    } else {
      return null;
    }
  }

  void resendCode(RegisterRequest body) async {
    await UserService().singUp(body);
  }

  @override
  void onSubmitting() async {
    RegisterRequest body = RegisterRequest(
      username: username.value,
      email: email.value,
      password: password.value,
      phone: phone.value,
      verifyPassword: confirmPassword.value,
    );

    var response = await UserService().singUp(body);

    if (response.statusCode == 400) {
      Error error = Error.fromJson(jsonDecode(response.body));
      error.subErrors?.forEach((subError) {
        switch (subError.field) {
          case "email":
            email.addFieldError(subError.message.toString());
            break;
          case "username":
            username.addFieldError(subError.message.toString());
            break;
          case "phone":
            phone.addFieldError(subError.message.toString());
            break;
          case "password":
            password.addFieldError(subError.message.toString());
            break;
          case "verifyPassword":
            confirmPassword.addFieldError(subError.message.toString());
            break;
        }
      });
      await Future<void>.delayed(const Duration(seconds: 1));
      emitFailure(failureResponse: 'We have a problem with your data...');
    } else {
      final jsonString = json.encode(body.toJson());
      await Future<void>.delayed(const Duration(seconds: 1));
      emitSuccess(successResponse: jsonString);
    }
  }
}
