import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';
import 'package:playfutday_flutter/models/apiError.dart';

class ValidationBasedOnNewPostFieldFormBloc extends FormBloc<String, String> {
  final PostService postService;
  File? image;

  final tag = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final description = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  ValidationBasedOnNewPostFieldFormBloc(this.postService) {
    addFieldBlocs(
      fieldBlocs: [tag, description],
    );
  }

  @override
  void onSubmitting() async {
    var jsonResponse = await postService.newPost(tag.value, description.value, image);
    print(jsonResponse);
    await Future<void>.delayed(const Duration(seconds: 1));
    emitSuccess(successResponse: "The post was save!", canSubmitAgain: true);

    // var response =
    //     await PostService().newPost(tag.value, description.value, image);
    // debugPrint(response);
    // if (response.statusCode == 400) {
    //   Error error = Error.fromJson(jsonDecode(response.body));
    //   error.subErrors?.forEach((subError) {
    //     switch (subError.field) {
    //       case "tag":
    //         tag.addFieldError(subError.message.toString());
    //         break;
    //       case "description":
    //         description.addFieldError(subError.message.toString());
    //         break;
    //     }
    //   });
    //   await Future<void>.delayed(const Duration(seconds: 1));
    //   emitFailure(failureResponse: "We have a problem in the answers");
    // } else {
    //   await Future<void>.delayed(const Duration(seconds: 1));
    //   emitSuccess(successResponse: "The post was save!", canSubmitAgain: true);
    // }
  }
}
