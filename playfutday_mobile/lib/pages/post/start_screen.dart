import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:playfutday_flutter/blocs/follows/follow_event.dart';
import 'package:playfutday_flutter/models/user.dart';
import 'package:playfutday_flutter/pages/pages.dart';
import 'package:playfutday_flutter/rest/rest.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';

import '../../blocs/blocs.dart';
import '../../blocs/follows/follow_bloc.dart';
import '../user/follows/follow_page.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 0.5),
      child: Column(
        children: [
          Container(
            width: size.width * 1,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                /**ENVOLER EN BLOC PROVIDER */
                SizedBox(
                  width: size.width * 0.15,
                  child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      if (state is AuthenticationAuthenticated) {
                        return _buildAvatar(user: state.user);
                      } else {
                        return const LoginPage();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: size.width * 0.78,
                  child: SizedBox(
                      child: SizedBox(
                    height: 70,
                    child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, state) {
                        if (state is AuthenticationAuthenticated) {
                          return BlocProvider(
                              create: (_) => FollowBloc(
                                  UserService(), state.user.id.toString())
                                ..add(AllFollowFetched()),
                              child: AllFollowList(
                                user: state.user,
                              ));
                        } else {
                          return const LoginPage();
                        }
                      },
                    ),
                  )),
                ),
              ],
            ),
          ),
          const Divider(height: 10, color: Colors.black, thickness: 3),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is AuthenticationAuthenticated) {
                return BlocProvider(
                    create: (_) =>
                        AllPostBloc(PostService())..add(AllPostFetched()),
                    child: AllPostList(
                      user: state.user,
                    ));
              } else {
                return const LoginPage();
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildAvatar({required User user}) {
    final urlBase = ApiConstants.baseUrl;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: CircleAvatar(
            maxRadius: 25,
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
                    Image.asset('assets/images/image_notfound.png'),
              ),
            ),
          ),
        ),
        Text(
          user.username.toString(),
          style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
