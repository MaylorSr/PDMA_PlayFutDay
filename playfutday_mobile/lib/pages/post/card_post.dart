// ignore_for_file: use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playfutday_flutter/models/allPost.dart';
import 'package:playfutday_flutter/rest/rest.dart';
import 'package:playfutday_flutter/theme/app_theme.dart';

import '../../models/user.dart';

class CardScreenPost extends StatelessWidget {
  CardScreenPost(
      {required this.post, required this.user, required this.onDeletePressed});
  final User user;
  final Post post;
  final urlBase = ApiConstants.baseUrl;
  final void Function(int idPost) onDeletePressed;

  @override
  Widget build(BuildContext context) {
    void displayDialogAndroid(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              elevation: 5,
              content: Column(mainAxisSize: MainAxisSize.min, children: const [
                SizedBox(height: 10),
                Text('Are you sure to delete this post?')
              ]),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'cancel',
                      style: TextStyle(color: AppTheme.primary),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onDeletePressed(post.id);
                    },
                    child: const Text('delete',
                        style:
                            TextStyle(color: Color.fromARGB(255, 194, 20, 7))))
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
                Text('Are you sure to delete this post?')
              ]),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('cancel',
                        style: TextStyle(color: AppTheme.primary))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onDeletePressed(post.id);
                    },
                    child: const Text('delete',
                        style:
                            TextStyle(color: Color.fromARGB(255, 194, 20, 7))))
              ],
            );
          });
    }

    return Container(
      margin: const EdgeInsets.only(left: 10, bottom: 35),
      width: 380,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: AppTheme.primary),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  maxRadius: 30,
                  child: ClipOval(
                    child: Image.network(
                      '$urlBase/download/${post.authorFile}',
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/images/image_notfound.png'),
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                Column(
                  children: [
                    Text(
                      post.author,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    Text(post.uploadDate,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic)),
                  ],
                ),
                const SizedBox(width: 60),
                Visibility(
                  visible: post.author == user.username,
                  child: ElevatedButton(
                    onPressed: () => Platform.isAndroid
                        ? displayDialogAndroid(context)
                        : displayDialogIos(context),
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    child: Icon(
                      Platform.isAndroid
                          ? Icons.delete_outline_outlined
                          : Icons.close_rounded,
                      color: const Color.fromARGB(255, 131, 10, 2),
                      size: 40,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.black12,
            height: 360,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 0, right: 40, left: 40),
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.network(
                fit: BoxFit.contain,
                alignment: Alignment.center,
                '$urlBase/download/${post.image}',
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/images/image_notfound.png'),
              ),
            ),
          ),
          Container(
            width: 360,
            child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [

              const Text('data', style: TextStyle(color: Colors.black)),
              Row(
                children: [
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () {},
                      child: const Icon(
                        Icons.favorite_outline,
                        color: Colors.black,
                      )),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () {},
                      child: const Icon(
                        Icons.insert_comment_outlined,
                        color: Colors.black,
                      ))
                ],
              )
            ]),
          )
        ],
      ),
    );
  }
}
