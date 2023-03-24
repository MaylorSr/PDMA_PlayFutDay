// ignore_for_file: no_logic_in_create_state, prefer_const_constructors, unused_field, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';

class NewPostForm extends StatefulWidget {
  const NewPostForm({super.key, required this.postService});

  final PostService postService;

  @override
  // ignore: library_private_types_in_public_api
  _NewPostFormState createState() => _NewPostFormState();
}

class _NewPostFormState extends State<NewPostForm> {
  final kMaxPhotoWidth = 1080;
  final kMaxPhotoHeight = 1350;

  final _formKey = GlobalKey<FormState>();
  String? _tag;
  String? _description;
  final picker = ImagePicker();
  File? _image;

  Future _getImage() async {
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
        (croppedFile.path == ".png" || croppedFile.path == ".jpg")) {
      setState(() {
        _image = croppedFile as File;
      });
    } else {
      // Show an error message if the selected file is not png or jpg
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a PNG or JPG file.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      margin: EdgeInsets.all(25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                decoration: InputDecoration(
                  labelText: 'Tag',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a tag';
                  } else if (value.length > 50) {
                    return 'The max characters is 50';
                  }
                  return null;
                },
                onSaved: (value) {
                  _tag = value;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  } else if (value.length > 200) {
                    return 'The max characters is 200';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  // open gallery to select a photo
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
                },
                child: const Text('Select Photo'),
              ),
              SizedBox(height: 16.0),
              if (_image != null)
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Image.file(_image!),
                    ),
                  ),
                ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_image == null) {
                      // Show an error message if no image is selected
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                        'Please select a photo.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )));
                    } else {
                      _formKey.currentState!.save();
                      widget.postService.newPost(_tag!, _description!, _image);
                      _formKey.currentState!.reset();

                      setState(() {
                        _description = null;
                        _image = null;
                        _tag = null;
                      });
                      // Submit form data
                    }
                  }
                },
                child: Text('Share'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
