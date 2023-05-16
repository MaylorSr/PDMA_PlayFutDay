import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playfutday_flutter/blocs/userProfile/user_profile.dart';
import 'package:playfutday_flutter/models/apiError.dart';
import 'package:playfutday_flutter/models/editProfile.dart';
import 'package:playfutday_flutter/models/infoUser.dart';
import 'package:playfutday_flutter/pages/user/change_password/change_password_screen.dart';
import 'package:playfutday_flutter/rest/rest.dart';
import '../../../theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);
  final UserInfo user;

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final picker = ImagePicker();
  bool showErrorPhone = false;
  String error = "";
  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.user.biography ?? '';
    _birthDateController.text = widget.user.birthday ?? '';
    _phoneController.text = widget.user.phone ?? '';
  }

  void saveChange(BuildContext context) {
    if (_phoneController.text.length != 9) {
      setState(() {
        error = "The phone must be required and 9 digits!";
        showErrorPhone = true;
      });
    } else if (_phoneController.text == widget.user.phone) {
      BlocProvider.of<UserProfileBloc>(context).add(
        UpdateUser(
            EditDataUser(
                phone: _phoneController.text,
                birthday: _birthDateController.text,
                biography: _descriptionController.text,
                avatar: image),
            widget.user),
      );
    } else {
      void actualizar = setState(() {
        showErrorPhone = true;
        error = "The number of phone exits!";
      });

      BlocProvider.of<UserProfileBloc>(context)
          .updatePhoneNumber(_phoneController.text)
          .then(
            (value) => {
              if (value)
                {actualizar}
              else
                {
                  BlocProvider.of<UserProfileBloc>(context).add(
                    UpdateUser(
                        EditDataUser(
                            phone: _phoneController.text,
                            birthday: _birthDateController.text,
                            biography: _descriptionController.text,
                            avatar: image),
                        widget.user),
                  )
                },
            },
          );
    }
  }

  File? image;
  final kMaxPhotoWidth = 1080;
  final kMaxPhotoHeight = 1350;

  Future _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      compressQuality: 100,
      cropStyle: CropStyle.circle,
      maxHeight: kMaxPhotoHeight,
      maxWidth: kMaxPhotoWidth,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Editar imagen',
          toolbarColor: AppTheme.darkTheme.primaryColorDark,
          hideBottomControls: true,
          toolbarWidgetColor: AppTheme.primary,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
          showCropGrid: true,
        ),
        IOSUiSettings(
          title: 'Editar imagen',
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
    final urlBase = ApiConstants.baseUrl;
    displayDialogAndroid(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              elevation: 5,
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(height: AppTheme.minHeight),
                Text(
                  'Please select a option:',
                  style: AppTheme.nameUsersStyle,
                )
              ]),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.camera);
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
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery);
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
                  ),
                ),
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
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(height: AppTheme.minHeight),
                Text(
                  'Please select a option:',
                  style: AppTheme.nameUsersStyle,
                )
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width * 0.25,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            // ignore: invalid_use_of_visible_for_testing_member
            onPressed: () => BlocProvider.of<UserProfileBloc>(context).emit(
              const UserProfileState().copyWith(
                  status: UserProfileStatus.success, user: widget.user),
            ),
            child: const Text('Cancel'),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: AppTheme.tittleApp,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => saveChange(context),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        // backgroundColor: Colors.black,
                        maxRadius: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: ClipOval(
                            child: Container(
                              child: image == null
                                  ? CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 100.0,
                                      placeholderFadeInDuration:
                                          const Duration(seconds: 12),
                                      placeholder: (context, url) =>
                                          Image.asset(
                                              'assets/images/reload.gif'),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                              'assets/images/image_notfound.png'),
                                      imageUrl:
                                          '$urlBase/download/${widget.user.avatar}',
                                    ) // set a placeholder image when no photo is set
                                  : Image.file(
                                      image!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 100.0,
                                      // color: Colors.transparent,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 55,
                        bottom: 60,
                        child: IconButton(
                          focusColor: Colors.black,
                          splashColor: Colors.black,
                          icon: const Icon(
                            Icons.edit,
                            size: 40,
                            color: AppTheme.primary,
                          ),
                          onPressed: () => Platform.isAndroid
                              ? displayDialogAndroid(context)
                              : displayDialogIos(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '@${widget.user.username}',
                    style: const TextStyle(
                      fontSize: 25,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Biography',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: TextFormField(
                      maxLength: 200,
                      style: const TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      maxLines: 5,
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Writte about you',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phone',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      minLines: 1,
                      autocorrect: true,
                      maxLines: 1,
                      maxLength: 9,
                      style: const TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      decoration: InputDecoration(
                        errorText: showErrorPhone ? error : null,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        filled: true, // habilitar el relleno
                        fillColor: Colors.white,
                        hintText: 'Put your phone number',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Birthday',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          cursorColor: Colors.black,
                          readOnly: true,
                          controller: _birthDateController,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            filled: true, // habilitar el relleno
                            fillColor: Colors.white,
                            hintText: 'Select your birthday',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          onTap: () {
                            DatePicker.showDatePicker(
                              context,
                              minDateTime: DateTime(1900, 1, 1),
                              pickerTheme: const DateTimePickerTheme(
                                backgroundColor: Colors.brown,
                                itemTextStyle:
                                    TextStyle(color: AppTheme.primary),
                                cancelTextStyle: TextStyle(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                                confirmTextStyle: TextStyle(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                                showTitle: true,
                              ),
                              maxDateTime: DateTime.now(),
                              onChange: (dateTime, selectedIndex) {},
                              onConfirm: (dateTime, selectedIndex) {
                                setState(() {
                                  _birthDateController.text =
                                      DateFormat('dd/MM/yyyy').format(dateTime);
                                });
                              },
                              initialDateTime: DateTime.now(),
                              pickerMode: DateTimePickerMode.date,
                              locale: DateTimePickerLocale.es,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChangePasswordScreen(user: widget.user),
                            )),
                        child: const Text(
                          'Change Password',
                          style: TextStyle(fontSize: 18),
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
