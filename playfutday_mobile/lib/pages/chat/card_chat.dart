import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:playfutday_flutter/blocs/messages/messages.dart';
import 'package:playfutday_flutter/blocs/messages/messages_bloc.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/pages/pages.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';
import 'package:playfutday_flutter/theme/app_theme.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

import '../../blocs/blocs.dart';
import '../../rest/rest_client.dart';

class CardChatScreen extends StatefulWidget {
  const CardChatScreen({Key? key, required this.chat}) : super(key: key);

  final Chat chat;

  @override
  State<CardChatScreen> createState() => _CardChatScreenState();
}

class _CardChatScreenState extends State<CardChatScreen> {
  final urlBase = ApiConstants.baseUrl;
  String getTimeAgo() {
    // Obtener la fecha actual
    DateTime now = DateTime.now();

    // Crear un objeto DateFormat para el formato de fecha actual
    DateFormat currentFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

    // Convertir la fecha de creación del chat a DateTime utilizando el formato actual
    DateTime createdAt =
        currentFormat.parse(widget.chat.createdChat.toString());

    // Calcular la diferencia de tiempo entre la fecha actual y la fecha de creación
    Duration difference = now.difference(createdAt);

    // Utilizar la función format de timeago para formatear el tiempo transcurrido
    String formattedTimeAgo = timeago.format(now.subtract(difference));

    return formattedTimeAgo;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAlias,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      borderOnForeground: true,
      elevation: 0.5,
      color: AppTheme.transparent,
      shadowColor: AppTheme.grey,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
          maxRadius: 21.5,
          child: ClipOval(
            child: CachedNetworkImage(
              useOldImageOnUrlChange: true,
              placeholderFadeInDuration: const Duration(seconds: 15),
              placeholder: (context, url) =>
                  Image.asset('assets/images/reload.gif'),
              imageUrl: '$urlBase/download/${widget.chat.avatarUserDestinity}',
              width: double.infinity,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/avatar.png'),
            ),
          ),
        ),
        title: Text(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.errorMessageStyle,
          widget.chat.usernameUserDestinity.toString(),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              maxLines: 1,
              style: AppTheme.deleteSure,
              overflow: TextOverflow.ellipsis,
              widget.chat.lastMessage.toString(),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                maxLines: 1,
                style: AppTheme.nameUsersStyle.copyWith(fontSize: 12.0),
                overflow: TextOverflow.ellipsis,
                getTimeAgo(),
              ),
            )
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state is AuthenticationAuthenticated) {
                      return FadeInRight(
                        animate: true,
                        duration: const Duration(milliseconds: 700),
                        child: ScreenMessage(
                          user: state.user,
                          otherUser: widget.chat.avatarUserDestinity.toString(),
                          otherUserName:
                              widget.chat.usernameUserDestinity.toString(),
                          // idChat: widget.chat.id!.toInt(),
                          uuidOtherUser: widget.chat.idUserDestiny.toString(),
                        ),
                      );
                    } else {
                      return const LoginPage();
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
