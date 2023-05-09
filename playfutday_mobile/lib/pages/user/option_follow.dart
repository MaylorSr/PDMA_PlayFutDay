import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/blocs/follows/follow.dart';
import 'package:playfutday_flutter/blocs/follows/follow_event.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';

import '../../blocs/followers/followers.dart';
import '../../models/user.dart';
import '../../theme/app_theme.dart';
import 'followers_vertical/follower_v_page.dart';
import 'follows_vertical/follow_v_page.dart';

class OptionFollowScreen extends StatefulWidget {
  const OptionFollowScreen(
      {Key? key,
      required this.id,
      required this.username,
      required this.followersView,
      required this.user})
      : super(key: key);
  final String id;
  final String username;
  final bool followersView;
  final User user;

  @override
  State<OptionFollowScreen> createState() => _OptionFollowScreenState();
}

class _OptionFollowScreenState extends State<OptionFollowScreen> {
  late bool showFollowersView;

  late bool showFollowsView;

  @override
  void initState() {
    super.initState();
    showFollowersView = widget.followersView;
    showFollowsView = !showFollowersView;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: const Text('PlayFutDay',
      //       style: TextStyle(
      //           color: AppTheme.primary,
      //           fontStyle: FontStyle.italic,
      //           fontSize: 25,
      //           fontWeight: FontWeight.w600)),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            centerTitle: true,
            title: Text(
              '@${widget.username}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      showFollowersView = true;
                      showFollowsView = false;
                    });
                  },
                  child: Text('Followers',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color:
                              showFollowersView ? Colors.white : Colors.grey))),
              TextButton(
                  onPressed: () {
                    setState(() {
                      showFollowersView = false;
                      showFollowsView = true;
                    });
                  },
                  child: Text('Follows',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color:
                              showFollowersView ? Colors.grey : Colors.white))),
            ],
          ),
          Expanded(
            child: showFollowersView
                ? BlocProvider(
                    create: (_) => FollowerBloc(UserService(), widget.id)
                      ..add(AllFollowerFetched()),
                    child: AllFollowerListVertical(
                      user: widget.user,
                    ))
                : BlocProvider(
                    create: (_) => FollowBloc(UserService(), widget.id)
                      ..add(AllFollowFetched()),
                    child: AllFollowListVertical(
                      user: widget.user,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
