// ignore_for_file: use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/blocs/userProfile/user_profile_event.dart';
import 'package:playfutday_flutter/models/allPost.dart';
import 'package:playfutday_flutter/pages/post/commentaries/commentary_post.dart';
import 'package:playfutday_flutter/rest/rest.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';
import 'package:playfutday_flutter/theme/app_theme.dart';

import '../../blocs/userProfile/user_profile_bloc.dart';
import '../../models/user.dart';
import '../user/user_page.dart';

class CardScreenPost extends StatefulWidget {
  const CardScreenPost({
    required this.post,
    required this.user,
    required this.onDeletePressed,
    required this.onLikePressed,
    required this.onCommentPressed,
  });
  final User user;
  final Post post;
  final void Function(int idPost) onDeletePressed;
  final void Function(int idPost) onLikePressed;
  final void Function(int idPost, String message) onCommentPressed;

  @override
  State<CardScreenPost> createState() => _CardScreenPostState();
}

class _CardScreenPostState extends State<CardScreenPost> {
  final urlBase = ApiConstants.baseUrl;

  late bool _isLiked;

  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _isLiked =
        widget.post.likesByAuthor?.contains(widget.user.username) ?? false;
    _likesCount = widget.post.countLikes!;
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
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(height: 10),
                const Text('Are you sure to delete this post?')
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
                      widget.onDeletePressed(widget.post.id);
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
                      widget.onDeletePressed(widget.post.id);
                    },
                    child: const Text('delete',
                        style:
                            TextStyle(color: Color.fromARGB(255, 194, 20, 7))))
              ],
            );
          });
    }

    return Card(
      margin: const EdgeInsets.all(25),
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ElevatedButton(
                style: const ButtonStyle(
                    elevation: MaterialStatePropertyAll(0),
                    backgroundColor:
                        MaterialStatePropertyAll(AppTheme.primary)),
                onPressed: () {
                  if (widget.post.idAuthor.toString() !=
                      widget.user.id.toString()) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return BlocProvider(
                            create: (_) => UserProfileBloc(UserService())
                              ..add(UserProfileFetched(widget.post.idAuthor)),
                            child: UserProfilePage(user: widget.user));
                      },
                    ));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    maxRadius: 25,
                    child: ClipOval(
                      child: Image.network(
                        '$urlBase/download/${widget.post.authorFile}',
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/images/image_notfound.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.author,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      widget.post.uploadDate ?? 'no tiene fecha de subida',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: widget.post.author == widget.user.username,
                child: ElevatedButton(
                  onPressed: () => Platform.isAndroid
                      ? displayDialogAndroid(context)
                      : displayDialogIos(context),
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      elevation: MaterialStatePropertyAll(0)),
                  child: Icon(
                    Platform.isAndroid
                        ? Icons.cancel_outlined
                        : Icons.close_rounded,
                    color: const Color.fromARGB(255, 131, 10, 2),
                    size: 30,
                  ),
                ),
              )
            ],
          ),
          Container(
            alignment: Alignment.center,
            height: 300,
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.network(
                '$urlBase/download/${widget.post.image}',
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/images/image_notfound.png'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              margin: const EdgeInsets.only(left: 30, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    'Tag: ${widget.post.tag}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    overflow: TextOverflow.fade,
                    widget.post.description != null
                        ? '${widget.post.author}: ${widget.post.description!}'
                        : '',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isLiked = !_isLiked;
                      if (_isLiked) {
                        _likesCount++;
                      } else {
                        _likesCount--;
                      }
                    });
                    widget.onLikePressed(int.parse('${widget.post.id}'));
                  },
                  icon: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked
                        ? const Color.fromARGB(255, 177, 13, 2)
                        : Colors.black,
                  ),
                  label: Text('$_likesCount',
                      style: const TextStyle(color: Colors.black)),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommentaryScreen(
                                widget.post,
                                widget.user,
                                onCommentPressed: widget.onCommentPressed,
                              ))),
                  icon: const Icon(Icons.insert_comment_outlined,
                      color: Colors.black),
                  label: Text(
                      '${widget.post.commentaries != null ? widget.post.commentaries!.length : 0}',
                      style: const TextStyle(color: Colors.black)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
