import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../blocs/sing_up/sing_up_form_bloc.dart';
import '../../theme/app_theme.dart';
import 'verify_code.dart';

class SingUpPage extends StatefulWidget {
  const SingUpPage({Key? key}) : super(key: key);

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ValidationSingUpForm(),
      child: Builder(
        builder: (context) {
          final loginFormBloc = context.read<ValidationSingUpForm>();
          return Scaffold(
            backgroundColor: AppTheme.primary,
            body: FormBlocListener<ValidationSingUpForm, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSubmissionFailed: (context, state) {
                LoadingDialog.hide(context);
              },
              onSuccess: (
                context,
                state,
              ) {
                LoadingDialog.hide(context);

                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => VeriFyCodeScreen(
                          jsonRegisterRequest: state.successResponse.toString(),
                        )));
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);
                const SizedBox();
              },
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Stack(
                          children: [
                            Container(
                              color: const Color(0xFF00446A),
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: AppBar(
                                  leading: IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: Icon(
                                        Platform.isAndroid
                                            ? Icons.arrow_back_rounded
                                            : Icons.arrow_back_ios_new_rounded,
                                        size: 25),
                                  ),
                                  centerTitle: true,
                                  title: Text("SING UP",
                                      style: AppTheme.tittleApp),
                                ),
                              ),
                            ),
                            Positioned(
                              height: MediaQuery.of(context).size.height -
                                  MediaQuery.of(context).size.height * 0.16,
                              // top: MediaQuery.of(context).size.height * 0.16,
                              bottom: 0,
                              child: Container(
                                // height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.topCenter,
                                padding:
                                    EdgeInsets.all(AppTheme.mediumPadding + 15),
                                decoration: const BoxDecoration(
                                  color: AppTheme.primary,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(100),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      emailWidget(loginFormBloc),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      userNameWidget(loginFormBloc),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      phoneNumberWidget(loginFormBloc),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      passwordWidget(loginFormBloc),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      verifyPasswordWidget(loginFormBloc),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: loginFormBloc.submit,
                                        child: const Text('SING UP'),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  TextFieldBlocBuilder verifyPasswordWidget(
      ValidationSingUpForm loginFormBloc) {
    return TextFieldBlocBuilder(
      textColor: const MaterialStatePropertyAll(Colors.black),
      cursorColor: Colors.black,
      animateWhenCanShow: true,
      obscureText: !_showConfirmPassword,
      textFieldBloc: loginFormBloc.confirmPassword,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        prefixIcon: const Icon(Icons.lock),
        floatingLabelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.white),
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        filled: true, // habilitar el relleno
        fillColor: Colors.white,
        prefixIconColor: Colors.blue,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _showConfirmPassword = !_showConfirmPassword;
            });
          },
          icon: Icon(
            _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
        errorMaxLines: 3,
      ),
    );
  }

  TextFieldBlocBuilder passwordWidget(ValidationSingUpForm loginFormBloc) {
    return TextFieldBlocBuilder(
      textColor: const MaterialStatePropertyAll(Colors.black),
      cursorColor: Colors.black,
      animateWhenCanShow: true,
      obscureText: !_showPassword,
      textFieldBloc: loginFormBloc.password,
      autofillHints: const [AutofillHints.password],
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock),
        floatingLabelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.white),
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        filled: true, // habilitar el relleno
        fillColor: Colors.white,
        prefixIconColor: Colors.blue,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
          icon: Icon(
            _showPassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
        errorMaxLines: 3,
      ),
    );
  }

  TextFieldBlocBuilder phoneNumberWidget(ValidationSingUpForm loginFormBloc) {
    return TextFieldBlocBuilder(
      textColor: const MaterialStatePropertyAll(Colors.black),
      cursorColor: Colors.black,
      animateWhenCanShow: true,
      suffixButton: SuffixButton.asyncValidating,
      textFieldBloc: loginFormBloc.phone,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        prefixIcon: Icon(Icons.phone),
        floatingLabelStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.white),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        filled: true,
        fillColor: Colors.white,
        prefixIconColor: Colors.blue,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        errorMaxLines: 3,
      ),
    );
  }

  TextFieldBlocBuilder userNameWidget(ValidationSingUpForm loginFormBloc) {
    return TextFieldBlocBuilder(
      textColor: const MaterialStatePropertyAll(Colors.black),
      cursorColor: Colors.black,
      animateWhenCanShow: true,
      textFieldBloc: loginFormBloc.username,
      suffixButton: SuffixButton.asyncValidating,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Username',
        prefixIcon: Icon(Icons.person),
        floatingLabelStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.white),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        filled: true, // habilitar el relleno
        fillColor: Colors.white,
        prefixIconColor: Colors.blue,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        errorMaxLines: 3,
      ),
    );
  }

  TextFieldBlocBuilder emailWidget(ValidationSingUpForm loginFormBloc) {
    return TextFieldBlocBuilder(
        textColor: const MaterialStatePropertyAll(Colors.black),
        cursorColor: Colors.black,
        animateWhenCanShow: true,
        suffixButton: SuffixButton.asyncValidating,
        textFieldBloc: loginFormBloc.email,
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [
          AutofillHints.email,
        ],
        decoration: const InputDecoration(
          labelText: 'Email',
          prefixIcon: Icon(Icons.email),
          floatingLabelStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.white),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          filled: true, // habilitar el relleno
          fillColor: Colors.white,
          prefixIconColor: Colors.blue,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          errorMaxLines: 3,
        ));
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.dotsTriangle(
          color: const Color.fromARGB(255, 6, 49, 122), size: 45),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.tag_faces, size: 100),
            const SizedBox(height: 10),
            const Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const SingUpPage())),
              icon: const Icon(Icons.replay),
              label: const Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
