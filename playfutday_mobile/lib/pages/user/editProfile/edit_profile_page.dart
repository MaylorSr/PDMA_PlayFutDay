import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playfutday_flutter/blocs/userProfile/user_profile.dart';
import 'package:playfutday_flutter/models/editProfile.dart';
import 'package:playfutday_flutter/models/infoUser.dart';
import 'package:playfutday_flutter/pages/user/change_password/change_password_screen.dart';
import 'package:playfutday_flutter/rest/rest.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
  File? _image;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.user.biography ?? '';
    _birthDateController.text = widget.user.birthday ?? '';
    _phoneController.text = widget.user.phone ?? '';
  }

  void saveChange(BuildContext context) {
    EditDataUser userEdit = EditDataUser(
        phone: _phoneController.text,
        birthday: _birthDateController.text,
        biography: _descriptionController.text,
        avatar: _image);

    BlocProvider.of<UserProfileBloc>(context)
        .add(UpdateUser(userEdit, widget.user));
  }

  @override
  Widget build(BuildContext context) {
    final String urlBase = ApiConstants.baseUrl;

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
                    // assign selected image to the _image field
                    setState(() {
                      if (pickedFile != null) {
                        _image = File(pickedFile.path);
                      } else {
                        print('No image selected.');
                      }
                    });

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
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
                        _image = File(pickedFile.path);
                      } else {
                        print('No image selected.');
                      }
                    });
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
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
                        _image = File(pickedFile.path);
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
                        _image = File(pickedFile.path);
                      } else {
                        print('No image selected.');
                      }
                    });
                    Navigator.pop(context);
                  },
                  label: const Text('Gallery',
                      style: TextStyle(color: AppTheme.primary)),
                  icon: Icon((Icons.photo_camera_back_outlined)),
                )
              ],
            );
          });
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'PlayFutDay',
            style: TextStyle(
              color: AppTheme.primary,
              fontStyle: FontStyle.italic,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => saveChange(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => saveChange(context),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            maxRadius: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: ClipOval(
                                child: Container(
                                  child: _image == null
                                      ? CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          width: double.infinity,
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
                                          _image!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
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
                                color: Colors.black,
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
                        '@${widget.user!.username}',
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            filled: true, // habilitar el relleno
                            fillColor:
                                Colors.white, // establecer el color de fondo
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
                          maxLength: 9,
                          style: const TextStyle(color: Colors.black),
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.phone,
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
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
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime(1900, 1, 1),
                                    theme: const DatePickerTheme(
                                        backgroundColor: Colors.brown,
                                        itemStyle:
                                            TextStyle(color: AppTheme.primary),
                                        cancelStyle: TextStyle(
                                            color: AppTheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                        doneStyle: TextStyle(
                                            color: AppTheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic)),
                                    maxTime: DateTime.now(), onChanged: (date) {
                                  print('change $date');
                                }, onConfirm: (date) {
                                  setState(() {
                                    _birthDateController.text =
                                        DateFormat('dd/MM/yyyy').format(date);
                                  });
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.es);
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
                  )
                ]))));
  }
}
