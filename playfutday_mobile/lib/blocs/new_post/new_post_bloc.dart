import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../services/services.dart';

class SubmissionErrorToFieldFormBloc extends FormBloc<String, String> {
  final PostService postService;

  final tag = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final description = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  SubmissionErrorToFieldFormBloc(this.postService) {
    addFieldBlocs(
      fieldBlocs: [tag, description],
    );
  }

  @override
  void onSubmitting() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    print("The file is: ");
    emitSuccess();
    //   var response =
    //       await postService.newPost(tag.value, description.value, image);
    //   if (response.statusCode == 200) {
    //     await Future<void>.delayed(const Duration(seconds: 1));
    //     tag.clear;
    //     description.clear;
    //     image.delete;
    //     emitSuccess();
    //   } else {
    //     Error error = Error.fromJson(jsonDecode(response.body));
    //     error.subErrors?.forEach((subError) {
    //       switch (subError.field) {
    //         case "tag":
    //           tag.addFieldError(subError.message.toString());
    //           break;
    //         case "description":
    //           description.addFieldError(subError.message.toString());
    //           break;
    //       }
    //     });
    //     await Future<void>.delayed(const Duration(seconds: 1));
    //     emitFailure(failureResponse: "We have a problem in the answers");
    //   }
    // }
  }
}
