import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';

import '../../blocs/new_post/new_post_bloc.dart';
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

  Future getImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
    }
  }

  Future _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      maxWidth: kMaxPhotoWidth.toInt(),
      maxHeight: kMaxPhotoHeight.toInt(),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blue,
            hideBottomControls: true,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        )
      ],
    );

    if (croppedFile != null &&
        (croppedFile.path.endsWith(".png") ||
            croppedFile.path.endsWith(".jpg"))) {
      setState(() {
        image = croppedFile as File;
      });
    } else {
      // Show an error message if the selected file is not png or jpg
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a PNG or JPG file.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    void displayDialogAndroid(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              elevation: 5,
              // ignore: prefer_const_literals_to_create_immutables
              content: Column(mainAxisSize: MainAxisSize.min, children: const [
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
                      }
                      Navigator.pop(context);
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
                    // assign selected image to the _image field
                    setState(() {
                      if (pickedFile != null) {
                        image = File(pickedFile.path);
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

    void displayDialogIos(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              insetAnimationDuration: const Duration(seconds: 3),
              content: Column(mainAxisSize: MainAxisSize.min, children: const [
                SizedBox(height: 10),
                Text('Please select a option')
              ]),
              actions: [
                TextButton.icon(
                  onPressed: () async {
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.camera);
                    // assign selected image to the _image field
                    setState(() {
                      if (pickedFile != null) {
                        image = File(pickedFile.path);
                      } else {
                        print('No image selected.');
                      }
                    });

                    Navigator.pop(context);
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
                      } else {
                        print('No image selected.');
                      }
                    });
                    Navigator.pop(context);
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
      create: (context) => SubmissionErrorToFieldFormBloc(PostService()),
      child: Builder(
        builder: (context) {
          final formBloc =
              BlocProvider.of<SubmissionErrorToFieldFormBloc>(context);

          return Scaffold(
            body: FormBlocListener<SubmissionErrorToFieldFormBloc, String,
                String>(
              onSubmitting: (context, state) {
                LoadingDialog.hide(context);
              },
              onSubmissionFailed: (context, state) {
                LoadingDialog.hide(context);
              },
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const SuccessScreen(),
                //     ));
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);
                const SizedBox();
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
                      FormTagWidget(formBloc: formBloc),
                      formDescriptionWidget(formBloc),
                      if (image != null)
                        SizedBox(
                            width: 250, height: 250, child: Image.file(image!)),
                      ElevatedButton(
                        onPressed: () => Platform.isAndroid
                            ? displayDialogAndroid(context)
                            : displayDialogIos(context),
                        child: const Text('Select Photo'),
                      ),
                      const SizedBox(height: 4.0),

                      ElevatedButton(
                        onPressed: () {
                          if (image != null) {
                            // ||
                            //   (image!.path.endsWith(".png") ||
                            //       image!.path.endsWith(".jpg"))
                            formBloc.submit();
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

  TextFieldBlocBuilder formDescriptionWidget(
      SubmissionErrorToFieldFormBloc formBloc) {
    return TextFieldBlocBuilder(
      maxLength: 200,
      
      textColor: const MaterialStatePropertyAll(Colors.black),
      cursorColor: Colors.black,
      animateWhenCanShow: true,
      textFieldBloc: formBloc.description,
      autofillHints: const [AutofillHints.name],
      keyboardType: TextInputType.name,
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
        errorMaxLines: 3,
      ),
    );
  }
}

class FormTagWidget extends StatelessWidget {
  const FormTagWidget({
    super.key,
    required this.formBloc,
  });

  final SubmissionErrorToFieldFormBloc formBloc;

  @override
  Widget build(BuildContext context) {
    return TextFieldBlocBuilder(
      maxLength: 50,
      textColor: const MaterialStatePropertyAll(Colors.black),
      cursorColor: Colors.black,
      animateWhenCanShow: true,
      textFieldBloc: formBloc.tag,
      autofillHints: const [AutofillHints.name],
      keyboardType: TextInputType.name,
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

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.tag_faces, size: 100),
            const SizedBox(height: 10),
            const Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const NewPostForm())),
              icon: const Icon(Icons.replay),
              label: const Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
