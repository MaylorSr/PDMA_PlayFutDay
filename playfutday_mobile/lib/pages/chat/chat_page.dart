import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:playfutday_flutter/blocs/chat/chat.dart';
import 'package:playfutday_flutter/pages/pages.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';
import 'package:playfutday_flutter/theme/app_theme.dart';
import 'package:playfutday_flutter/pages/general_error/general_error.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _scrollController = ScrollController();
  // ignore: unused_field
  final _userService = UserService();

  final errorMessage = "Not found any chat";
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, AllChatState>(
      builder: (context, state) {
        switch (state.status) {
          case AllChatStatus.failure:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  widthFactor: MediaQuery.of(context).size.width,
                  child: const ErrorScreen(
                      errorMessage: "You don't have any open chats",
                      icon: Icons.error_outline_outlined,
                      size: 120),
                ),
              ],
            );
          case AllChatStatus.success:
            if (state.allChat.isEmpty) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: ErrorScreen(
                        errorMessage: "You don't have any open chats",
                        icon: Icons.error_outline_outlined,
                        size: 120),
                  ),
                ],
              );
            }
            return Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: AppTheme.primary,
                  indent: 15,
                  endIndent: 15,
                  thickness: 0.5,
                ),
                physics: const BouncingScrollPhysics(
                  parent: BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.normal),
                ),
                itemBuilder: (BuildContext context, int index) {
                  return index >= state.allChat.length
                      ? LoadingAnimationWidget.twoRotatingArc(
                          color: const Color.fromARGB(255, 6, 49, 122),
                          size: 45)
                      : CardChatScreen(
                          chat: state.allChat[index],
                        );
                },
                scrollDirection: Axis.vertical,
                itemCount: state.hasReachedMax
                    ? state.allChat.length
                    : state.allChat.length + 1,
                controller: _scrollController,
              ),
            );
          case AllChatStatus.initial:
            return Center(
              child: LoadingAnimationWidget.twoRotatingArc(
                  color: const Color.fromARGB(255, 6, 49, 122), size: 45),
            );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<ChatBloc>().add(AllChatFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
