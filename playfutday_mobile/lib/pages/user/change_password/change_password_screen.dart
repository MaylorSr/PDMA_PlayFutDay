import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:playfutday_flutter/models/infoUser.dart';
import 'package:playfutday_flutter/rest/rest.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';

import '../../../blocs/blocs.dart';
import '../../../theme/app_theme.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key, required this.user}) : super(key: key);
  final UserInfo user;

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _showOldPassword = true;
  bool _showPassword = true;
  bool _showConfirmPassword = true;
  @override
  Widget build(BuildContext context) {
    final urlBase = ApiConstants.baseUrl;
    return BlocProvider(
      create: (context) => ValidationChangePassword(UserService()),
      child: Builder(
        builder: (context) {
          final loginFormBloc = context.read<ValidationChangePassword>();

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text(
                'PlayFutDay',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontStyle: FontStyle.italic,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: FormBlocListener<ValidationChangePassword, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSubmissionFailed: (context, state) {
                LoadingDialog.hide(context);
              },
              onSuccess: (context, state) {
                LoadingDialog.hide(context);

                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => SuccessScreen(widget.user)));
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.failureResponse!)));
              },
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: loginFormBloc.submit,
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        maxRadius: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholderFadeInDuration:
                                  const Duration(seconds: 12),
                              placeholder: (context, url) =>
                                  Image.asset('assets/images/reload.gif'),
                              errorWidget: (context, url, error) => Image.asset(
                                  'assets/images/image_notfound.png'),
                              imageUrl:
                                  '$urlBase/download/${widget.user.avatar}',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '@${widget.user.username}',
                        style: const TextStyle(
                          fontSize: 25,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 50),
                      TextFieldBlocBuilder(
                        textColor: const MaterialStatePropertyAll(Colors.black),
                        cursorColor: Colors.black,
                        textFieldBloc: loginFormBloc.oldPassword,
                        autofocus: true,
                        animateWhenCanShow: true,
                        obscureText: !_showOldPassword,
                        decoration: InputDecoration(
                          labelText: 'Old Password',
                          prefixIcon: const Icon(Icons.lock),
                          floatingLabelStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.white),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIconColor: Colors.blue,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showOldPassword = !_showOldPassword;
                              });
                            },
                            icon: Icon(
                              _showOldPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      TextFieldBlocBuilder(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
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
                                _showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            )),
                      ),
                      TextFieldBlocBuilder(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
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
                                _showConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(12.0),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen(this.user, {Key? key}) : super(key: key);
  final UserInfo user;
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
              'Password Changed Successfully',
              style: TextStyle(fontSize: 30, color: AppTheme.primary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.replay),
              label: const Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
