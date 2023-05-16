// ignore_for_file: use_key_in_widget_constructors

import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:playfutday_flutter/theme/app_theme.dart';

import 'package:playfutday_flutter/rest/rest.dart';
import 'package:readmore/readmore.dart';
import '../../blocs/userProfile/user_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/models/allPost.dart';
import 'package:playfutday_flutter/blocs/userProfile/user_profile_event.dart';

import 'package:playfutday_flutter/pages/pages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';

import '../../models/user.dart';
import '../user/user_page.dart';
import 'commentaries/commentary_post.dart';

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

  late int _commentariesCount;

  void changeCountCommentaries(int newCommentarie) {
    setState(() {
      _commentariesCount += newCommentarie;
    });
  }

  @override
  void initState() {
    super.initState();
    _isLiked =
        widget.post.likesByAuthor?.contains(widget.user.username) ?? false;
    _likesCount = widget.post.countLikes!;

    _commentariesCount =
        widget.post.commentaries != null ? widget.post.commentaries!.length : 0;
  }

  @override
  Widget build(BuildContext context) {
    void displayDialogAndroid(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: AppTheme.mediumHeight),
                Text(
                  'Are you sure to delete this post?',
                  style: AppTheme.deleteSure,
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            actions: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'cancel',
                      style: AppTheme.deleteSure,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onDeletePressed(widget.post.id);
                    },
                    child: Text('delete', style: AppTheme.deleteSured),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    void displayDialogIos(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            insetAnimationDuration: const Duration(seconds: 3),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: AppTheme.mediumHeight),
                const Text('Are you sure to delete this post?')
              ],
            ),
            actions: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'cancel',
                      style: AppTheme.deleteSure,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onDeletePressed(widget.post.id);
                    },
                    child: Text('delete', style: AppTheme.deleteSured),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    return Card(
      margin: EdgeInsets.all(AppTheme.mediumMargin),
      borderOnForeground: true,
      elevation: 0.0,
      semanticContainer: true,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: AppTheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ElevatedButton(
                style: const ButtonStyle(
                  elevation: MaterialStatePropertyAll(0),
                  backgroundColor: MaterialStatePropertyAll(AppTheme.primary),
                ),
                onPressed: () {
                  if (widget.post.idAuthor.toString() !=
                      widget.user.id.toString()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return BlocProvider(
                            create: (_) => UserProfileBloc(UserService())
                              ..add(UserProfileFetched(widget.post.idAuthor)),
                            child: FadeInLeft(
                                duration: const Duration(milliseconds: 500),
                                child: UserProfilePage(user: widget.user)),
                          );
                        },
                      ),
                    );
                  }
                },
                child: Hero(
                    tag: widget.post.idAuthor,
                    transitionOnUserGestures: true,
                    child: ImageAuthorPost(urlBase: urlBase, widget: widget)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.author,
                      style: AppTheme.nameUsersStyle.copyWith(
                          color: AppTheme.blackSolid,
                          fontSize: 25,
                          fontWeight: FontWeight.w300),
                    ),
                    Text(
                      widget.post.uploadDate.toString(),
                      style: AppTheme.errorMessageStyle.copyWith(
                          color: AppTheme.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: widget.user.id == widget.post.idAuthor,
                child: PopupMenuButton(
                  color: AppTheme.transparent,
                  elevation: 0,
                  enableFeedback: true,
                  icon: const Icon(Icons.more_horiz_sharp,
                      color: AppTheme.blackSolid, size: 30),
                  itemBuilder: (BuildContext bc) {
                    List<PopupMenuItem> items = [];
                    items.add(
                      PopupMenuItem(
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Platform.isAndroid
                                ? displayDialogAndroid(context)
                                : displayDialogIos(context);
                          },
                          icon: Icon(
                            Platform.isAndroid
                                ? Icons.cancel_outlined
                                : Icons.close_rounded,
                            color: const Color.fromARGB(255, 131, 10, 2),
                            size: 30,
                          ),
                          label: Text(
                            'Delete',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.tittleApp.copyWith(
                              color: AppTheme.blackSolid,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                    return items;
                  },
                ),
              ),
            ],
          ),
          ContainerPost(urlBase: urlBase, widget: widget),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.post.tag != null)
                  Text(
                    'Tag: ${widget.post.tag}',
                    style: AppTheme.tittleApp.copyWith(
                        fontSize: 17,
                        color: AppTheme.blackSolid,
                        fontWeight: FontWeight.w900),
                  ),
                SizedBox(height: AppTheme.minHeight),
                if (widget.post.description != null)
                  ReadMoreText(
                    '${widget.post.author}: ${widget.post.description!}',
                    delimiter: "...",
                    trimLength: 80,
                    colorClickableText: AppTheme.grey.withBlue(10),
                    delimiterStyle: AppTheme.tittleApp.copyWith(
                        fontSize: 15,
                        color: AppTheme.blackSolid,
                        fontWeight: FontWeight.w600),
                    style: AppTheme.tittleApp.copyWith(
                        fontSize: 15,
                        color: AppTheme.blackSolid,
                        fontWeight: FontWeight.w600),
                    trimCollapsedText: " read more.",
                    trimExpandedText: " show less.",
                  ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: AppTheme.mediumMargin),
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
                    widget.onLikePressed(widget.post.id);
                  },
                  icon: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked
                        ? const Color.fromARGB(255, 177, 13, 2)
                        : AppTheme.blackSolid,
                  ),
                  label: Text(
                    '$_likesCount',
                    style: AppTheme.nameUsersStyle
                        .copyWith(color: AppTheme.blackSolid, fontSize: 20),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentaryScreen(
                          widget.post, widget.user,
                          onCommentPressed: widget.onCommentPressed,
                          updateComments: changeCountCommentaries),
                    ),
                  ),
                  icon: const Icon(Icons.chat,
                      color: AppTheme.blackSolid, size: 22),
                  label: Text(
                    _commentariesCount.toString(),
                    style: AppTheme.nameUsersStyle
                        .copyWith(color: AppTheme.blackSolid, fontSize: 20),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ContainerPost extends StatelessWidget {
  const ContainerPost({
    super.key,
    required this.urlBase,
    required this.widget,
  });

  final String urlBase;
  final CardScreenPost widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 300,
      child: Card(
        elevation: 5.0,
        margin: const EdgeInsets.all(5.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: CachedNetworkImage(
            placeholderFadeInDuration: const Duration(seconds: 5),
            placeholder: (context, url) =>
                Image.asset('assets/images/reload.gif'),
            errorWidget: (context, url, error) =>
                Image.asset('assets/images/image_notfound.png'),
            imageUrl: '$urlBase/download/${widget.post.image}'),
      ),
    );
  }
}

class ImageAuthorPost extends StatelessWidget {
  const ImageAuthorPost({
    super.key,
    required this.urlBase,
    required this.widget,
  });

  final String urlBase;
  final CardScreenPost widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        maxRadius: 25,
        child: ClipOval(
          child: CachedNetworkImage(
            useOldImageOnUrlChange: true,
            placeholderFadeInDuration: const Duration(seconds: 15),
            placeholder: (context, url) =>
                Image.asset('assets/images/reload.gif'),
            imageUrl: '$urlBase/download/${widget.post.authorFile}',
            width: double.infinity,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) =>
                Image.asset('assets/images/image_notfound.png'),
          ),
        ),
      ),
    );
  }
}
