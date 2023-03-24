// ignore_for_file: use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playfutday_flutter/models/allPost.dart';
import 'package:playfutday_flutter/rest/rest.dart';
import 'package:playfutday_flutter/theme/app_theme.dart';

import '../../models/user.dart';

class CardScreenPost extends StatefulWidget {
  const CardScreenPost(
      {required this.post,
      required this.user,
      required this.onDeletePressed,
      required this.onLikePressed});
  final User user;
  final Post post;
  final void Function(int idPost) onDeletePressed;
  final void Function(int idPost) onLikePressed;

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
              content: const Column(mainAxisSize: MainAxisSize.min, children: [
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
              content: const Column(mainAxisSize: MainAxisSize.min, children: [
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
              Padding(
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
                      widget.post.uploadDate,
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
                      backgroundColor: MaterialStatePropertyAll(Colors.white)),
                  child: Icon(
                    Platform.isAndroid
                        ? Icons.delete_outline_outlined
                        : Icons.close_rounded,
                    color: const Color.fromARGB(255, 131, 10, 2),
                    size: 30,
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('$urlBase/download/${widget.post.image}'),
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
          Row(
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
                onPressed: () {},
                icon: const Icon(Icons.insert_comment_outlined,
                    color: Colors.black),
                label: Text(
                    '${widget.post.commentaries != null ? widget.post.commentaries!.length : 0}',
                    style: const TextStyle(color: Colors.black)),
              ),
            ],
          )
        ],
      ),
    );
  }
}/*
    return Container(
      margin: const EdgeInsets.all(25),
      width: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: AppTheme.primary),
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
                      '$urlBase/download/${widget.post.authorFile}',
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/images/image_notfound.png'),
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                Column(
                  children: [
                    Text(
                      widget.post.author,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    Text(widget.post.uploadDate,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic)),
                  ],
                ),
                const SizedBox(width: 60),
                Visibility(
                  visible: widget.post.author == widget.user.username,
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
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.black12,
            height: 380,
            margin: const EdgeInsets.only(top: 0, right: 40, left: 40),
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.network(
                fit: BoxFit.contain,
                alignment: Alignment.center,
                '$urlBase/download/${widget.post.image}',
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/images/image_notfound.png'),
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: Container(
              width: double.maxFinite,
              margin: const EdgeInsets.only(left: 35, top: 3),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tag: ${widget.post.tag}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          fontStyle: FontStyle.italic),
                    ),
                    Row(
                      children: [
                        Text('@${widget.post.author}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        /*if (widget.post.description != null)*/
                        // ignore: prefer_const_constructors
                        Text(
                            /*' :${widget.post.description!}'*/ 'adlasdnasdnaskdnadknaskdnaskdnaksdnakndknskdnkadnkasdnks',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontStyle: FontStyle.italic)),
                      ],
                    ),
                    Row(
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
                            widget
                                .onLikePressed(int.parse('${widget.post.id}'));
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
                          onPressed: () {},
                          icon: const Icon(Icons.insert_comment_outlined,
                              color: Colors.black),
                          label: Text(
                              '${widget.post.commentaries != null ? widget.post.commentaries!.length : 0}',
                              style: const TextStyle(color: Colors.black)),
                        ),
                      ],
                    )
                  ]),
            ),
          )
        ],
      ),
    );
  }
}*/