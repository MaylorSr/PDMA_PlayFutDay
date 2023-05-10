import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:playfutday_flutter/blocs/new_post/new_post_bloc.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';

import '../../theme/app_theme.dart';

class NewPostForm extends StatefulWidget {
  const NewPostForm({Key? key}) : super(key: key);

  @override
  State<NewPostForm> createState() => _NewPostFormState();
}

class _NewPostFormState extends State<NewPostForm> {
  final picker = ImagePicker();
  File? image;
  final kMaxPhotoWidth = 1080;
  final kMaxPhotoHeight = 1350;

  Future _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
      maxWidth: kMaxPhotoWidth.toInt(),
      maxHeight: kMaxPhotoHeight.toInt(),
      compressQuality: 80,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Edit Post',
            toolbarColor: Colors.blue,
            hideBottomControls: true,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Edit Post',
        )
      ],
    );

    if (croppedFile != null) {
      setState(() {
        image = File(croppedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    displayDialogAndroid(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              elevation: 5,
              // ignore: prefer_const_literals_to_create_immutables
              content: const Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(height: 10),
                Text('Please select a option')
              ]),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              actions: [
                TextButton.icon(
                  onPressed: () async {
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.camera);
                    setState(() {
                      if (pickedFile != null) {
                        image = File(pickedFile.path);
                        _cropImage();
                        Navigator.pop(context);
                      }
                    });
                  },
                  label: const Text('Camara',
                      style: TextStyle(color: AppTheme.primary)),
                  icon: const Icon((Icons.camera_alt_rounded)),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      if (pickedFile != null) {
                        image = File(pickedFile.path);
                        _cropImage();
                      }
                      Navigator.pop(context);
                    });
                  },
                  label: const Text('Gallery',
                      style: TextStyle(color: AppTheme.primary)),
                  icon: const Icon((Icons.photo_library_outlined)),
                )
              ],
            );
          });
    }

    displayDialogIos(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              insetAnimationDuration: const Duration(seconds: 3),
              content: const Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(height: 10),
                Text('Please select a option')
              ]),
              actions: [
                TextButton.icon(
                  onPressed: () async {
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.camera);
                    setState(() {
                      if (pickedFile != null) {
                        image = File(pickedFile.path);
                        _cropImage();
                      }
                      Navigator.pop(context);
                    });
                  },
                  label: const Text('Camara',
                      style: TextStyle(color: AppTheme.primary)),
                  icon: const Icon((Icons.camera_alt_outlined)),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    // assign selected image to the _image field
                    setState(() {
                      if (pickedFile != null) {
                        image = File(pickedFile.path);
                        _cropImage();
                      }
                      Navigator.pop(context);
                    });
                  },
                  label: const Text('Gallery',
                      style: TextStyle(color: AppTheme.primary)),
                  icon: const Icon((Icons.photo_camera_back_outlined)),
                )
              ],
            );
          });
    }

    return BlocProvider(
      create: (context) => ValidationBasedOnNewPostFieldFormBloc(PostService()),
      child: Builder(
        builder: (context) {
          final loginFormBloc =
              context.read<ValidationBasedOnNewPostFieldFormBloc>();

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: FormBlocListener<ValidationBasedOnNewPostFieldFormBloc,
                String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSubmissionFailed: (context, state) {
                LoadingDialog.hide(context);
              },
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    content: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(Icons.check_circle_outline_rounded,
                            color: Colors.white),
                        const SizedBox(width: 8),
                        Text(state.successResponse!,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18)),
                      ],
                    ),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    animation: CurvedAnimation(
                      parent: AnimationController(
                        vsync: Scaffold.of(context),
                        duration: const Duration(milliseconds: 500),
                      )..forward(),
                      curve: Curves.easeOutBack,
                    ),
                  ),
                );
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.failureResponse!)));
              },
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 8.0),
                      formTagWidget(loginFormBloc),
                      formDescriptionWidget(loginFormBloc),
                      ElevatedButton(
                        onPressed: () => Platform.isAndroid
                            ? displayDialogAndroid(context)
                            : displayDialogIos(context),
                        child: const Text('Select Photo'),
                      ),
                      if (image != null)
                        SizedBox(
                            width: 250, height: 250, child: Image.file(image!)),
                      const SizedBox(height: 4.0),
                      ElevatedButton(
                        onPressed: () {
                          if (image != null) {
                            loginFormBloc.image = image!;
                            loginFormBloc.submit();
                          } else {
                            EasyLoading.showInfo(
                                duration: const Duration(seconds: 3),
                                "The post must be not empty or the format must be png or jpg.");
                          }
                        },
                        child: const Text('Share'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  TextFieldBlocBuilder formTagWidget(
      ValidationBasedOnNewPostFieldFormBloc loginFormBloc) {
    return TextFieldBlocBuilder(
      maxLength: 50,
      textColor: const MaterialStatePropertyAll(Colors.black),
      cursorColor: Colors.black,
      textFieldBloc: loginFormBloc.tag,
      animateWhenCanShow: true,
      suffixButton: SuffixButton.asyncValidating,
      decoration: const InputDecoration(
        labelText: 'Tag',
        prefixIcon: Icon(Icons.tag_rounded),
        floatingLabelStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.white),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        filled: true,
        fillColor: Colors.white,
        prefixIconColor: Colors.blue,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        errorMaxLines: 3,
      ),
    );
  }

  TextFieldBlocBuilder formDescriptionWidget(
      ValidationBasedOnNewPostFieldFormBloc loginFormBloc) {
    return TextFieldBlocBuilder(
      maxLength: 200,
      textColor: const MaterialStatePropertyAll(Colors.black),
      cursorColor: Colors.black,
      suffixButton: SuffixButton.asyncValidating,
      animateWhenCanShow: true,
      textFieldBloc: loginFormBloc.description,
      decoration: const InputDecoration(
        labelText: 'Description',
        prefixIcon: Icon(Icons.description_rounded),
        floatingLabelStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.white),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        filled: true,
        fillColor: Colors.white,
        prefixIconColor: Colors.blue,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        errorMaxLines: 10,
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.dotsTriangle(
          color: const Color.fromARGB(255, 6, 49, 122), size: 45),
    );
  }
}
