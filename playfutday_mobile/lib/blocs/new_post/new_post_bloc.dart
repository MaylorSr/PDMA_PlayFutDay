import 'dart:convert';
import 'dart:io';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';
import 'package:playfutday_flutter/models/apiError.dart';

class ValidationBasedOnNewPostFieldFormBloc extends FormBloc<String, String> {
  final PostService postService;
  File? image;

  final tag = TextFieldBloc(
    validators: [],
  );

  final description = TextFieldBloc(
    validators: [],
  );

  ValidationBasedOnNewPostFieldFormBloc(this.postService) {
    addFieldBlocs(
      fieldBlocs: [tag, description],
    );
  }

  @override
  void onSubmitting() async {
    var jsonResponse =
        await postService.newPost(tag.value, description.value, image);
    // await Future<void>.delayed(const Duration(seconds: 1));
    // emitSuccess(successResponse: "The post was save!", canSubmitAgain: true);
    if (jsonResponse.statusCode == 201) {
      await Future<void>.delayed(const Duration(seconds: 1));
      emitSuccess(successResponse: "The post was save!");
    } else {
      var responseJson = jsonResponse.stream.bytesToString();
      Error error = Error.fromJson(jsonDecode(responseJson.body));
      error.subErrors?.forEach((subError) {
        switch (subError.field) {
          case "tag":
            tag.addFieldError(subError.message.toString());
            break;
          case "description":
            description.addFieldError(subError.message.toString());
            break;
        }
      });
      await Future<void>.delayed(const Duration(seconds: 1));
      emitFailure(failureResponse: "We have a problem in the answers");
    }
  }
}
