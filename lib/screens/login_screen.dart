import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lively_studio/network/callback.dart';
import 'package:lively_studio/network/request_route.dart';
import 'package:lively_studio/utils/general.dart';
import 'package:lively_studio/utils/shared_preference.dart';
import 'package:lively_studio/widgets/snackbar.dart';
import 'package:sizer/sizer.dart';

import '../app_color.dart';
import '../style.dart';
import '../widgets/loader.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;
  RequestRouter requestRouter = RequestRouter();
  late GeneralSnackBar _generalSnackBar;

  @override
  initState() {
    _generalSnackBar = GeneralSnackBar(context);
    super.initState();
  }

  _validateUser(String username, String password) {
    if (_formKey.currentState?.validate() ?? false) {
      final requestBody = {
        'email': username,
        'password': password,
      };
      Loader.show(context);
      requestRouter.validateUser(
          requestBody,
          RequestCallbacks(onSuccess: (response) {
            SharedPreferenceUtility.storeUser(jsonEncode(jsonDecode(response)['user']))
                .then((value) => {
                      if (!value)
                        {
                          _generalSnackBar
                              .showWarningSnackBar("Cant able to save")
                        },
                      context.go('/dashboard')
                    });
          }, onError: (error) {
            _generalSnackBar.showErrorSnackBar("Authentication failed");
          }));
    }
  }

  _togglePassword() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: 20.h,
                        child: Image.asset(
                            'assets/logo/lively-logo.png'), // Replace with your image asset path
                      ),
                    ),

                    Text(
                      'Login',
                      style: heading2,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: textWhiteGrey,
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: TextFormField(
                              controller: usernameController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'Registered email id',
                                hintStyle: heading6.copyWith(color: textGrey),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter email id';
                                } else if (!EmailValidator.validate(
                                    value.toString())) {
                                  return 'Please enter valid email id';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: textWhiteGrey,
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: _passwordVisible,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: heading6.copyWith(color: textGrey),
                                suffixIcon: IconButton(
                                  color: textGrey,
                                  splashRadius: 1,
                                  icon: Icon(_passwordVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                  onPressed: () => _togglePassword(),
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter password';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    SizedBox(
                        width: 100.w,
                        child: FilledButton(
                          onPressed: () {
                            _validateUser(usernameController.text,
                                passwordController.text);
                          },
                          child: const Text('Login'),
                        )),

                    // CustomPrimaryButton(
                    //   buttonColor: primaryBlue,
                    //   textValue: 'Login',
                    //   textColor: Colors.white,
                    //   callback: movedashboard,
                    // ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'version 1.1.0',
                    style: generalText,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
