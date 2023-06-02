import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:playfutday_flutter/blocs/chat/chat.dart';
import 'package:playfutday_flutter/blocs/messages/messages.dart';
import 'package:playfutday_flutter/pages/pages.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';
import 'package:playfutday_flutter/theme/app_theme.dart';

import '../../blocs/userProfile/user_profile.dart';
import '../../models/models.dart';
import '../../rest/rest.dart';

class ScreenMessage extends StatefulWidget {
  const ScreenMessage(
      {Key? key,
      required this.user,
      required this.otherUser,
      required this.otherUserName,
      // required this.idChat,
      required this.uuidOtherUser})
      : super(key: key);

  final User user;
  final String otherUser;
  // final int idChat;
  final String otherUserName;
  final String uuidOtherUser;
  @override
  State<ScreenMessage> createState() => _ScreenMessageState();
}

class _ScreenMessageState extends State<ScreenMessage> {
  final urlBase = ApiConstants.baseUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.themeD,
      appBar: AppBar(
        // backgroundColor: AppTheme.themeColor,
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
        toolbarHeight: MediaQuery.of(context).size.height * 0.10,
        clipBehavior: Clip.antiAlias,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        title: ElevatedButton(
          autofocus: false,
          clipBehavior: Clip.antiAlias,
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(AppTheme.transparent),
              elevation: MaterialStatePropertyAll(0)),
          onPressed: () {
            if (widget.uuidOtherUser.isNotEmpty &&
                // ignore: unnecessary_null_comparison
                widget.uuidOtherUser != null &&
                widget.otherUserName != "Unknown") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider(
                      create: (_) => UserProfileBloc(
                        UserService(),
                      )..add(
                          UserProfileFetched(widget.uuidOtherUser),
                        ),
                      child: FadeInLeft(
                        duration: const Duration(milliseconds: 500),
                        child: UserProfilePage(user: widget.user),
                      ),
                    );
                  },
                ),
              );
            } else {
              EasyLoading.showError(
                  duration: const Duration(seconds: 1),
                  dismissOnTap: true,
                  "The user not exists!",
                  maskType: EasyLoadingMaskType.black);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                maxRadius: 25,
                child: ClipOval(
                  child: CachedNetworkImage(
                    useOldImageOnUrlChange: true,
                    placeholderFadeInDuration: const Duration(seconds: 15),
                    placeholder: (context, url) =>
                        Image.asset('assets/images/reload.gif'),
                    imageUrl: '$urlBase/download/${widget.otherUser}',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/images/avatar.png'),
                  ),
                ),
              ),
              Text(
                widget.otherUserName.toString(),
                style: AppTheme.tittleApp.copyWith(fontSize: 16),
              )
            ],
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) =>
            MessagesBloc(UserService(), widget.uuidOtherUser.toString())
              ..add(AllMessagesFetched()),
        child: MessagePageScreen(
            user: widget.user, uuid: widget.uuidOtherUser.toString()),
      ),
    );
  }
}
