// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:playfutday_flutter/services/services.dart';
import 'package:playfutday_flutter/theme/app_theme.dart';

import 'blocs/authentication/authentication.dart';
import 'config/locator.dart';
import 'pages/pages.dart';

void main() async {
  setupAsyncDependencies();
  configureDependencies();

  runApp(BlocProvider<AuthenticationBloc>(
    create: (context) {
      final authService = getIt<JwtAuthenticationService>();
      return AuthenticationBloc(authService)..add(AppLoaded());
    },
    child: MyApp(),
  ));
}

class GlobalContext {
  static late BuildContext ctx;
}

class MyApp extends StatelessWidget {
  //static late  AuthenticationBloc _authBloc;

  static late MyApp _instance;

  static Route route() {
    print("Enrutando al login");
    return MaterialPageRoute<void>(builder: (context) {
      var authBloc = BlocProvider.of<AuthenticationBloc>(context);
      authBloc.add(SessionExpiredEvent());
      return _instance;
    });
  }

  MyApp({super.key}) {
    _instance = this;
  }

  @override
  Widget build(BuildContext context) {
    //GlobalContext.ctx = context;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Authentication Demo',
        theme: AppTheme.darkTheme,
        builder: EasyLoading.init(),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            GlobalContext.ctx = context;
            if (state is AuthenticationAuthenticated) {
              // show home page with authenticated user
              return HomePage(postService: PostService());
            }
            // otherwise show login page
            // ignore: prefer_const_constructors
            return LoginPage();
          },
        ));
  }
}
