import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/blocs/blocs.dart';
import 'package:playfutday_flutter/models/searchPost.dart';
import 'package:playfutday_flutter/services/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';
import 'package:playfutday_flutter/theme/app_theme.dart';

import '../blocs/userProfile/user_profile.dart';
import 'pages.dart';
import 'post/new_post.dart';

class HomePage extends StatefulWidget {
  final PostService postService;

  const HomePage({
    super.key,
    required this.postService,
  });
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BottomNavigationBloc _bottomNavigationBloc;
  int _selectedIndex = 0;

  @override
  void initState() {
    _bottomNavigationBloc = BottomNavigationBloc();
    super.initState();
  }

  @override
  void dispose() {
    _bottomNavigationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        backgroundColor: Colors.grey,
        color: Colors.black,
        buttonBackgroundColor: Colors.black,
        height: 50,
        items: const [
          Icon(Icons.home, size: 20, color: Colors.white),
          Icon(Icons.message_outlined, size: 20, color: Colors.white),
          Icon(Icons.add, size: 20, color: Colors.white),
          Icon(Icons.person, size: 20, color: Colors.white)
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _bottomNavigationBloc.setIndex(index);
        },
      ),
      body: StreamBuilder<int>(
        stream: _bottomNavigationBloc.indexStream,
        initialData: 0,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case 0:
              return Scaffold(
                  appBar: AppBar(
                    title: const Text('PlayFutDay',
                        style: TextStyle(
                            color: AppTheme.primary,
                            fontStyle: FontStyle.italic,
                            fontSize: 25,
                            fontWeight: FontWeight.w600)),
                    actions: [
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.transparent)),
                            onPressed: () => showSearch(
                                context: context, delegate: SearchPost()),
                            child: const Icon(Icons.search_outlined)),
                      )
                    ],
                  ),
                  body: const StartScreen());
            case 2:
              return Scaffold(
                appBar: AppBar(
                  title: const Text('PlayFutDay',
                      style: TextStyle(
                          color: AppTheme.primary,
                          fontStyle: FontStyle.italic,
                          fontSize: 25,
                          fontWeight: FontWeight.w600)),
                ),
                body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state is AuthenticationAuthenticated) {
                      return NewPostForm(
                        postService: PostService(),
                      );
                    } else {
                      return const LoginPage();
                    }
                  },
                ),
              );
            case 3:
              return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is AuthenticationAuthenticated) {
                    return BlocProvider(
                        create: (context) => UserProfileBloc(UserService())
                          ..add(UserProfileFetched(state.user.id.toString())),
                        child: UserProfilePage(user: state.user));
                  } else {
                    return const LoginPage();
                  }
                },
              );

            default:
              return Container();
          }
        },
      ),
    );
  }
}
