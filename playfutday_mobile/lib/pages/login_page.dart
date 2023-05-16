// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:playfutday_flutter/pages/general_error/general_error.dart';
import 'package:playfutday_flutter/pages/sing_up/sing_up.dart';
import 'package:playfutday_flutter/theme/app_theme.dart';
import '../blocs/authentication/authentication.dart';
import '../blocs/login/login.dart';
import '../config/locator.dart';
import '../services/services.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body:
          SafeArea(child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          final authBloc = BlocProvider.of<AuthenticationBloc>(context);
          if (state is AuthenticationNotAuthenticated) {
            return _AuthForm();
          }
          if (state is AuthenticationFailure || state is SessionExpiredState) {
            var msg = (state as AuthenticationFailure).message;

            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Column(
                      children: [
                        ErrorScreen(
                            errorMessage: msg,
                            icon: Icons.mood_bad_outlined,
                            size: 55),
                        ElevatedButton(
                          onPressed: () => authBloc.add(AppLoaded()),
                          child: Text(
                            "Try again",
                            style: AppTheme.errorMessageStyle,
                          ),
                        )
                      ],
                    ),
                    onPressed: () {
                      authBloc.add(AppLoaded());
                    },
                  ),
                ],
              ),
            );

            // return Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: <Widget>[
            //       Text(msg),
            //       TextButton(
            //         child: Text('Retry'),
            //         onPressed: () {
            //           authBloc.add(AppLoaded());
            //         },
            //       )
            //     ],
            //   ),
            // );
          }
          return Center(
            child: LoadingAnimationWidget.dotsTriangle(
                color: const Color.fromARGB(255, 6, 49, 122), size: 45),
          );
        },
      )),
    );
  }
}

class _AuthForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final authService = RepositoryProvider.of<AuthenticationService>(context);
    final authService = getIt<JwtAuthenticationService>();
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Container(
      alignment: Alignment.center,
      child: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authBloc, authService),
        child: _SignInForm(),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  @override
  __SignInFormState createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    // ignore: no_leading_underscores_for_local_identifiers
    _onLoginButtonPressed() {
      if (_key.currentState!.validate()) {
        loginBloc.add(LoginInWithUserNameButtonPressed(
            username: _usernameController.text,
            password: _passwordController.text));
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          _showError(state.error);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(
              child: LoadingAnimationWidget.prograssiveDots(
                  color: Color.fromARGB(255, 6, 49, 122), size: 45),
            );
          }
          return Form(
            key: _key,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          color: Color(0xFF00446A),
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: double.infinity,
                              color: AppTheme.primary,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.3,
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(125),
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(top: AppTheme.maxMargin),
                              padding: EdgeInsets.symmetric(horizontal: 40.0),
                              child: Column(
                                children: [
                                  Text(
                                    'PLAYFUTDAY',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 6, 49, 122),
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 35,
                                  ),
                                  TextFormField(
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      labelText: 'Username',
                                      filled: true,
                                      isDense: true,
                                    ),
                                    controller: _usernameController,
                                    keyboardType: TextInputType.name,
                                    autocorrect: false,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'username is required.';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 35,
                                  ),
                                  TextFormField(
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      filled: true,
                                      isDense: true,
                                    ),
                                    obscureText: true,
                                    controller: _passwordController,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Password is required.';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 35,
                                  ),
                                  //RaisedButton(
                                  ElevatedButton(
                                    style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              Color.fromARGB(255, 6, 49, 122)),
                                    ),
                                    // ignore: sort_child_properties_last
                                    child: Text(
                                      'LOG IN',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    onPressed: state is LoginLoading
                                        ? () {}
                                        : _onLoginButtonPressed,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration:
                                              const Duration(milliseconds: 300),
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              SingUpPage(),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            return SlideTransition(
                                              position: Tween<Offset>(
                                                      begin: const Offset(1, 0),
                                                      end: Offset.zero)
                                                  .animate(animation),
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'You do not have count? register now',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 139, 13, 3),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // child: Container(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showError(String error) {
    EasyLoading.showError(
        duration: const Duration(seconds: 3),
        dismissOnTap: true,
        error,
        maskType: EasyLoadingMaskType.black);
  }
}
