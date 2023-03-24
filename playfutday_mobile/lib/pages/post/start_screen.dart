import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:playfutday_flutter/pages/pages.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';

import '../../blocs/blocs.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildAvatar(imageUrl: 'https://picsum.photos/200'),
                _buildAvatar(imageUrl: 'https://picsum.photos/200'),
                _buildAvatar(imageUrl: 'https://picsum.photos/200'),
                _buildAvatar(imageUrl: 'https://picsum.photos/200'),
                _buildAvatar(imageUrl: 'https://picsum.photos/200'),
                _buildAvatar(imageUrl: 'https://picsum.photos/200'),
                _buildAvatar(imageUrl: 'https://picsum.photos/200'),
                _buildAvatar(imageUrl: 'https://picsum.photos/200'),
                _buildAvatar(imageUrl: 'https://picsum.photos/200'),
                _buildAvatar(imageUrl: 'https://picsum.photos/200'),
              ],
            ),
          ),
          const Divider(height: 40, color: Colors.black, thickness: 3),
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

  Widget _buildAvatar({required String imageUrl}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(imageUrl),
      ),
    );
  }
}

