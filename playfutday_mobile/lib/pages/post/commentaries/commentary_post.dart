import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
import 'package:playfutday_flutter/theme/app_theme.dart';

import '../../../models/models.dart';
import '../../../rest/rest.dart';

class CommentaryScreen extends StatelessWidget {
  final Post post;
  final User user;
  final void Function(int idPost, String message) onCommentPressed;
  final void Function(int) updateComments;

  const CommentaryScreen(this.post, this.user,
      {super.key,
      required this.onCommentPressed,
      required this.updateComments});

  @override
  Widget build(BuildContext context) {
    final urlBase = ApiConstants.baseUrl;
    final commentController = TextEditingController();

    // final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
              Platform.isAndroid
                  ? Icons.arrow_back_rounded
                  : Icons.arrow_back_ios_new_rounded,
              size: 25),
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Commentaries",
          style: AppTheme.tittleApp,
        ),
      ),
      body: Column(children: [
        Divider(
            color: AppTheme.primary, height: AppTheme.minHeight, thickness: 1),
        Expanded(
          child: ScrollWrapper(
            promptAlignment: Alignment.topCenter,
            promptAnimationCurve: Curves.elasticInOut,
            promptDuration: const Duration(milliseconds: 400),
            enabledAtOffset: 300,
            scrollOffsetUntilVisible: 500,
            promptTheme: const PromptButtonTheme(
                icon: Icon(Icons.arrow_circle_up,
                    color: AppTheme.primary, size: 30),
                color: AppTheme.grey,
                elevation: 5.0,
                iconPadding: EdgeInsets.all(10),
                padding: EdgeInsets.all(32)),
            builder: (context, properties) => ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(
                parent: BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.fast),
              ),
              scrollDirection: Axis.vertical,
              controller: properties.scrollController,
              itemCount: int.parse(
                  '${post.commentaries != null ? post.commentaries!.length : 0}'),
              itemBuilder: (context, index) => buildCommentary(
                urlBase: urlBase,
                commentaries: post.commentaries![index],
              ),
              separatorBuilder: (context, index) =>
                  const Divider(color: AppTheme.primary),
            ),
          ),
        ),
        FormFieldCommentary(
          commentController: commentController,
          user: user,
          urlBase: urlBase,
          post: post,
          onCommentPressed: onCommentPressed,
          updateComments: updateComments,
        )
      ]),
    );
  }
}

class FormFieldCommentary extends StatelessWidget {
  const FormFieldCommentary({
    Key? key,
    required TextEditingController commentController,
    required this.user,
    required this.urlBase,
    required this.post,
    required this.onCommentPressed,
    required this.updateComments,
  })  : _commentController = commentController,
        super(key: key);

  final User user;
  final Post post;
  final void Function(int idPost, String message) onCommentPressed;

  final void Function(int numberToAdd) updateComments;

  final String urlBase;
  final TextEditingController _commentController;

  void sendCommentaryNow() {
    final String message = _commentController.value.text;
    if (message.isNotEmpty) {
      onCommentPressed(post.id, message);
      updateComments(1);
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5, left: 5),
          child: CircleAvatar(
              radius: 20,
              child: ClipOval(
                child: CachedNetworkImage(
                  useOldImageOnUrlChange: true,
                  placeholderFadeInDuration: const Duration(seconds: 15),
                  placeholder: (context, url) =>
                      Image.asset('assets/images/reload.gif'),
                  imageUrl: '$urlBase/download/${user.avatar}',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/avatar.png'),
                ),
              )),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            autofocus: true,
            controller: _commentController,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            maxLength: 80,
            textInputAction: TextInputAction.send,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              hintText: 'Add a comment...',
              hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xfff5f5f5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => sendCommentaryNow(),
              ),
            ),
            onSubmitted: (_) => sendCommentaryNow(),
          ),
        ),
      ],
    );
  }
}

Widget buildCommentary(
    {required String urlBase, required Commentaries commentaries}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: CircleAvatar(
            maxRadius: 20,
            child: ClipOval(
              child: CachedNetworkImage(
                placeholderFadeInDuration: const Duration(seconds: 10),
                placeholder: (context, url) =>
                    Image.asset('assets/images/reload.gif'),
                imageUrl: '$urlBase/download/${commentaries.authorFile}',
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/avatar.png'),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('@${commentaries.authorName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  )),
              const SizedBox(
                height: 1,
              ),
              Text(commentaries.message.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.primary,
                  )),
              const SizedBox(
                height: 4,
              ),
              Text(commentaries.uploadCommentary.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.primary,
                  )),
            ],
          ),
        ),
      ],
    ),
  );
}
