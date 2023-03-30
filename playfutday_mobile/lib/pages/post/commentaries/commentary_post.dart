import 'package:flutter/material.dart';
import 'package:playfutday_flutter/theme/app_theme.dart';

import '../../../models/models.dart';
import '../../../rest/rest.dart';

class CommentaryScreen extends StatelessWidget {
  final Post post;
  final User user;
  final void Function(int idPost, String message) onCommentPressed;

  const CommentaryScreen(this.post, this.user,
      {super.key, required this.onCommentPressed});

  @override
  Widget build(BuildContext context) {
    final urlBase = ApiConstants.baseUrl;
    final commentController = TextEditingController();

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: size.width * 0.20,
        leading: ElevatedButton.icon(
            style: const ButtonStyle(
                elevation: MaterialStatePropertyAll(0),
                backgroundColor: MaterialStatePropertyAll(Colors.transparent)),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_sharp, size: 30),
            label: const Text('')),
        elevation: 0,
        title: const Text(
          'Commentaries',
          style: TextStyle(fontSize: 25, color: AppTheme.primary),
        ),
        centerTitle: true,
      ),
      body: Column(children: [
        const Divider(color: AppTheme.primary, height: 30, thickness: 1),
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(
                parent: BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.fast)),
            scrollDirection: Axis.vertical,
            itemCount: int.parse(
                '${post.commentaries != null ? post.commentaries!.length : 0}'),
            itemBuilder: (context, index) => buildCommentary(
              urlBase: urlBase,
              commentaries: post.commentaries![index],
            ),
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.white),
          ),
        ),
        FormFieldCommentary(
          commentController: commentController,
          user: user,
          urlBase: urlBase,
          post: post,
          onCommentPressed: onCommentPressed,
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
  })  : _commentController = commentController,
        super(key: key);

  final User user;
  final Post post;
  final void Function(int idPost, String message) onCommentPressed;

  final String urlBase;
  final TextEditingController _commentController;

  void sendCommentaryNow() {
    final String message = _commentController.value.text;
    if (message.isNotEmpty) {
      onCommentPressed(post.id, message);
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
                child: Image.network(
                  '$urlBase/download/${user.avatar}',
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset('assets/images/reload.gif'),
                ),
              )),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            autofocus: true,
            controller: _commentController,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            maxLength: 50,
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
              child: Image.network(
                '$urlBase/download/${commentaries.authorFile}',
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
