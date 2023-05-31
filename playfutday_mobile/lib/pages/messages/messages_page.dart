import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:playfutday_flutter/theme/app_theme.dart';

import '../../blocs/messages/messages.dart';
import '../../models/models.dart';
import '../../services/user_service/user_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessagePageScreen extends StatefulWidget {
  const MessagePageScreen({Key? key, required this.user, required this.uuid})
      : super(key: key);

  final User user;

  final String uuid;
  @override
  State<MessagePageScreen> createState() => _MessagePageScreenState();
}

class _MessagePageScreenState extends State<MessagePageScreen> {
  final _scrollController = ScrollController();
  // ignore: unused_field
  final _userService = UserService();

  TextEditingController messageController = TextEditingController();

  final errorMessage = "Not found any messages";
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    void displayDialogAndroid(BuildContext context, int idMessage) {
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
                  'Are you sure to delete this message?',
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
                      BlocProvider.of<MessagesBloc>(context).add(
                        OnDeleteMessage(
                          idMessage,
                        ),
                      );
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

    void displayDialogIos(BuildContext context, int idMessage) {
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            insetAnimationDuration: const Duration(seconds: 3),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: AppTheme.mediumHeight),
                const Text('Are you sure to delete this message?')
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
                      BlocProvider.of<MessagesBloc>(context).add(
                        OnDeleteMessage(
                          idMessage,
                        ),
                      );
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

    return BlocBuilder<MessagesBloc, AllMessagesState>(
      builder: (context, state) {
        switch (state.status) {
          case AllMessagesStatus.initial:
            return Center(
              child: LoadingAnimationWidget.twoRotatingArc(
                  color: const Color.fromARGB(255, 6, 49, 122), size: 45),
            );
          case AllMessagesStatus.success:
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    physics: const BouncingScrollPhysics(
                      parent: BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.normal),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (index >= state.allMessages.length) {
                        return LoadingAnimationWidget.twoRotatingArc(
                            color: const Color.fromARGB(255, 6, 49, 122),
                            size: 45);
                      } else {
                        return state.allMessages[index]
                                    .usernameWhoSendMessage ==
                                widget.user.username
                            ? ElevatedButton(
                                clipBehavior: Clip.antiAlias,
                                autofocus: false,
                                style: const ButtonStyle(
                                  elevation: MaterialStatePropertyAll(0),
                                  backgroundColor: MaterialStatePropertyAll(
                                      AppTheme.transparent),
                                ),
                                onPressed: () => Platform.isAndroid
                                    ? displayDialogAndroid(context,
                                        state.allMessages[index].id!.toInt())
                                    : displayDialogIos(context,
                                        state.allMessages[index].id!.toInt()),
                                child: ChatBubble(
                                  clipper: ChatBubbleClipper9(
                                      type: BubbleType.sendBubble),
                                  alignment: Alignment.topRight,
                                  elevation: 2.0,
                                  shadowColor: AppTheme.grey,
                                  margin:
                                      EdgeInsets.only(top: AppTheme.minHeight),
                                  backGroundColor: Colors.blue,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        state.allMessages[index].bodyMessage
                                            .toString(),
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      Text(
                                        textAlign: TextAlign.end,
                                        style: AppTheme.nameUsersStyle.copyWith(
                                            color: AppTheme.blackSolid,
                                            height: 1.5),
                                        getTimeAgo(
                                          state.allMessages[index]
                                              .timeWhoSendMessage
                                              .toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ChatBubble(
                                clipper: ChatBubbleClipper9(
                                    type: BubbleType.receiverBubble),
                                backGroundColor: const Color(0xffE7E7ED),
                                margin:
                                    EdgeInsets.only(top: AppTheme.minHeight),
                                alignment: Alignment.topLeft,
                                elevation: 2.0,
                                shadowColor: AppTheme.grey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      textAlign: TextAlign.start,
                                      state.allMessages[index].bodyMessage
                                          .toString(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      textAlign: TextAlign.end,
                                      style: AppTheme.nameUsersStyle.copyWith(
                                          color: AppTheme.blackSolid,
                                          height: 1.5),
                                      getTimeAgo(
                                        state.allMessages[index]
                                            .timeWhoSendMessage
                                            .toString(),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      }
                    },
                    scrollDirection: Axis.vertical,
                    itemCount: state.hasReachedMax
                        ? state.allMessages.length
                        : state.allMessages.length + 1,
                    controller: _scrollController,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  clipBehavior: Clip.antiAlias,
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    border: Border.all(
                        width: 0.5,
                        strokeAlign: 1,
                        style: BorderStyle.solid,
                        color: AppTheme.grey),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          autofocus: false,
                          clipBehavior: Clip.antiAlias,
                          enableSuggestions: true,
                          minLines: 1,
                          cursorColor: AppTheme.primary,
                          style: const TextStyle(
                              decorationThickness: 0.0,
                              decoration: TextDecoration
                                  .none), // Elimina el subrayado del texto
                          decoration: const InputDecoration(
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Send a message ...',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          String message = messageController.text;

                          if (message.isNotEmpty) {
                            BlocProvider.of<MessagesBloc>(context).add(
                              RefreshMessages(
                                message,
                                widget.uuid,
                              ),
                            );
                          } else {
                            EasyLoading.showError(
                                duration: const Duration(seconds: 1),
                                dismissOnTap: true,
                                "The message must not be blank",
                                maskType: EasyLoadingMaskType.black);
                          }

                          messageController.clear();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          case AllMessagesStatus.failure:
            return Column(
              children: [
                Expanded(
                  child: Container(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  clipBehavior: Clip.antiAlias,
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    border: Border.all(
                        width: 0.5,
                        strokeAlign: 1,
                        style: BorderStyle.solid,
                        color: AppTheme.grey),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          autofocus: false,
                          clipBehavior: Clip.antiAlias,
                          enableSuggestions: true,
                          minLines: 1,
                          cursorColor: AppTheme.primary,
                          style: const TextStyle(
                              decorationThickness: 0.0,
                              decoration: TextDecoration
                                  .none), // Elimina el subrayado del texto
                          decoration: const InputDecoration(
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Send a message ...',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          String message = messageController.text;

                          if (message.isNotEmpty) {
                            BlocProvider.of<MessagesBloc>(context).add(
                              RefreshMessages(
                                message,
                                widget.uuid,
                              ),
                            );
                          } else {
                            EasyLoading.showError(
                                duration: const Duration(seconds: 1),
                                dismissOnTap: true,
                                "The message must not be blank",
                                maskType: EasyLoadingMaskType.black);
                          }

                          messageController.clear();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
        }
      },
    );
  }

  String getTimeAgo(String date) {
    // Obtener la fecha actual
    DateTime now = DateTime.now();

    // Crear un objeto DateFormat para el formato de fecha actual
    DateFormat currentFormat = DateFormat('dd/MM/yyyy HH:mm');

    // Convertir la fecha de creación del chat a DateTime utilizando el formato actual
    DateTime createdAt = currentFormat.parse(date);

    // Calcular la diferencia de tiempo entre la fecha actual y la fecha de creación
    Duration difference = now.difference(createdAt);

    // Utilizar la función format de timeago para formatear el tiempo transcurrido
    String formattedTimeAgo = timeago.format(now.subtract(difference));

    return formattedTimeAgo;
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isTop) context.read<MessagesBloc>().add(AllMessagesFetched());
  }

  // bool get _isBottom {
  //   if (!_scrollController.hasClients) return false;
  //   final maxScroll = _scrollController.position.maxScrollExtent;
  //   final currentScroll = _scrollController.offset;
  //   return currentScroll >= (maxScroll * 0.9);
  // }
  bool get _isTop {
    if (!_scrollController.hasClients) return false;
    final minScroll = _scrollController.position.minScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll <=
        (minScroll +
            100); // Detecta cuando el desplazamiento está cerca de la parte superior
  }
}
