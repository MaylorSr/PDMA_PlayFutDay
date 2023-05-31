import 'package:animate_do/animate_do.dart';
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
        backgroundColor: AppTheme.primary,
        color: AppTheme.blackSolid,
        buttonBackgroundColor: AppTheme.blackSolid,
        height: AppTheme.mediumHeight,
        items: const [
          Icon(Icons.home, size: 20, color: AppTheme.primary),
          Icon(Icons.message_outlined, size: 20, color: AppTheme.primary),
          Icon(Icons.add, size: 20, color: AppTheme.primary),
          Icon(Icons.person, size: 20, color: AppTheme.primary)
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
                  title: Text('PlayFutDay', style: AppTheme.tittleApp),
                  actions: [
                    ElevatedButton(
                      autofocus: false,
                      style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(0),
                        overlayColor:
                            MaterialStatePropertyAll(AppTheme.transparent),
                        backgroundColor:
                            MaterialStatePropertyAll(AppTheme.transparent),
                      ),
                      onPressed: () => showSearch(
                        context: context,
                        delegate: SearchPost(),
                      ),
                      child: const Icon(
                        Icons.search_outlined,
                        color: AppTheme.primary,
                        size: 30.0,
                      ),
                    )
                  ],
                ),
                body: FadeInUpBig(
                  from: 5.0,
                  duration: const Duration(milliseconds: 700),
                  child: const StartScreen(),
                ),
              );

            case 1:
              return FadeInDownBig(
                animate: true,
                from: 3.0,
                duration: const Duration(milliseconds: 500),
                child: const MyChatScreen(),
              );
            case 2:
              return Scaffold(
                appBar: AppBar(
                  title: Text('PlayFutDay', style: AppTheme.tittleApp),
                ),
                body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state is AuthenticationAuthenticated) {
                      return FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        child: const NewPostForm(),
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
                      create: (context) => UserProfileBloc(
                        UserService(),
                      )..add(
                          UserProfileFetched(
                            state.user.id.toString(),
                          ),
                        ),
                      child: FadeInRight(
                        duration: const Duration(milliseconds: 500),
                        child: UserProfilePage(user: state.user),
                      ),
                    );
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
