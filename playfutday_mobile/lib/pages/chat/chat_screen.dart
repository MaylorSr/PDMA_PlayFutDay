import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/blocs/chat/chat_bloc.dart';
import 'package:playfutday_flutter/blocs/chat/chat_event.dart';
import 'package:playfutday_flutter/pages/pages.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';
import 'package:playfutday_flutter/theme/app_theme.dart';

class MyChatScreen extends StatelessWidget {
  const MyChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: EdgeInsets.only(top: AppTheme.mediumPadding),
                child: AppBar(
                  backgroundColor: AppTheme.transparent,
                  elevation: 0,
                  centerTitle: true,
                  title: const Text(
                    "Contact",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          ),
          Positioned(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).size.height * 0.21,
            bottom: 0,
            child: Container(
              width: size.width,
              decoration: BoxDecoration(
                color: const Color.fromARGB(134, 0, 0, 0),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    BlocProvider(
                      create: (context) =>
                          ChatBloc(UserService())..add(AllChatFetched()),
                      child: const ChatPage(),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
