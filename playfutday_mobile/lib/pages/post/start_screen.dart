import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:playfutday_flutter/blocs/follows/follow_event.dart';
import 'package:playfutday_flutter/models/user.dart';
import 'package:playfutday_flutter/pages/pages.dart';
import 'package:playfutday_flutter/rest/rest.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';
import 'package:playfutday_flutter/theme/app_theme.dart';

import '../../blocs/blocs.dart';
import '../../blocs/follows/follow_bloc.dart';
import '../user/follows/follow_page.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: AppTheme.minHeight),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppTheme.minHeight),
            child: Row(
              children: [
                SizedBox(
                  width: size.width * 0.15,
                  height: 82,
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
                const SizedBox(width: 15),
                SizedBox(
                  width: size.width * 0.78,
                  height: 75,
                  child: SizedBox(child: SizedBox(
                    child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, state) {
                        if (state is AuthenticationAuthenticated) {
                          return BlocProvider(
                            create: (context) => FollowBloc(
                              UserService(),
                              state.user.id.toString(),
                            )..add(
                                AllFollowFetched(),
                              ),
                            child: AllFollowList(
                              user: state.user,
                            ),
                          );
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
          Divider(
              height: AppTheme.minHeight,
              color: AppTheme.primary,
              thickness: 0.5),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is AuthenticationAuthenticated) {
                return BlocProvider(
                  create: (context) => AllPostBloc(PostService())
                    ..add(
                      AllPostFetched(),
                    ),
                  child: AllPostList(
                    user: state.user,
                  ),
                );
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
          padding: EdgeInsets.all(AppTheme.minPadding),
          child: CircleAvatar(
            maxRadius: 25,
            child: ClipOval(
              child: CachedNetworkImage(
                placeholderFadeInDuration: const Duration(seconds: 5),
                placeholder: (context, url) =>
                    Image.asset('assets/images/reload.gif'),
                imageUrl: '$urlBase/download/${user.avatar}',
                width: double.infinity,
                height: 100.0,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/avatar.png'),
              ),
            ),
          ),
        ),
        Text(
          user.username.toString(),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
