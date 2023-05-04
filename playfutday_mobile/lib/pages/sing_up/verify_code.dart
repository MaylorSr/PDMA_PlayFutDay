import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:playfutday_flutter/pages/login_page.dart';
import 'package:playfutday_flutter/theme/app_theme.dart';

import '../../blocs/blocs.dart';
import '../../blocs/sing_up/sing_up_form_bloc.dart';
import '../../main.dart';
import '../../models/sing_up.dart';
import '../../services/post_service/post_service.dart';
import '../home_page.dart';

class VeriFyCodeScreen extends StatefulWidget {
  const VeriFyCodeScreen({super.key, required this.jsonRegisterRequest});

  final String jsonRegisterRequest;
  @override
  State<VeriFyCodeScreen> createState() => _VeriFyCodeScreenState();
}

class _VeriFyCodeScreenState extends State<VeriFyCodeScreen> {
  TextEditingController textEditingController = TextEditingController();

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String messageError = "";
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  late final RegisterRequest valueRequest;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    valueRequest =
        RegisterRequest.fromJson(jsonDecode(widget.jsonRegisterRequest));

    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  snackBar(String? message) {
    return EasyLoading.showSuccess(
        duration: const Duration(seconds: 3),
        dismissOnTap: true,
        message.toString(),
        maskType: EasyLoadingMaskType.black);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 5,
          title: const Text("Code Verification"),
          backgroundColor: const Color.fromARGB(255, 6, 49, 122)),
      backgroundColor: AppTheme.primary,
      body: GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(
                child: Image.asset('assets/images/logo.png', height: 230),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: valueRequest.email,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: const TextStyle(
                        color: Color.fromARGB(255, 6, 49, 122),
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: false,
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length != 6) {
                          return "Put the 6 code here";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        debugPrint(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*$messageError" : "",
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive the code? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () {
                      ValidationSingUpForm().resendCode(valueRequest);
                      setState(
                        () {
                          hasError = false;
                          snackBar("The code was sent again!");
                        },
                      );
                    },
                    child: const Text(
                      "RESEND",
                      style: TextStyle(
                          color: Color.fromARGB(255, 6, 49, 122),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 6, 49, 122),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ButtonTheme(
                  height: 50,
                  child: TextButton(
                    onPressed: () async {
                      formKey.currentState!.validate();
                      final message =
                          await ValidationSingUpForm().veriFyCode(currentText);

                      if (currentText.length != 6 || message != null) {
                        errorController!.add(ErrorAnimationType.shake);
                        setState(
                            () => {hasError = true, messageError = "$message"});
                      } else {
                        setState(
                          () {
                            hasError = false;
                            snackBar("Account Verified!!");
                            Future.delayed(const Duration(seconds: 3), () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BlocBuilder<
                                              AuthenticationBloc,
                                              AuthenticationState>(
                                            builder: (context, state) {
                                              GlobalContext.ctx = context;
                                              if (state
                                                  is AuthenticationAuthenticated) {
                                                // show home page with authenticated user
                                                return HomePage(
                                                    postService: PostService());
                                              }
                                              // otherwise show login page
                                              // ignore: prefer_const_constructors
                                              return LoginPage();
                                            },
                                          )));
                            });
                          },
                        );
                      }
                    },
                    child: Center(
                        child: Text(
                      "VERIFY".toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: TextButton(
                    child: const Text("Clear"),
                    onPressed: () {
                      textEditingController.clear();
                    },
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
