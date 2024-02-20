import 'dart:developer';

import 'package:chat_app_mozz_test/repositories/auth_repo.dart';
import 'package:chat_app_mozz_test/screens/chat_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  AuthRepository authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SignInButton(
          buttonType: ButtonType.google,
          onPressed: () async {
            await authRepository.signInWithGoogle(context).then((value){
              log('\nUser: $value');
            });
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            print('${sharedPreferences.get('uid')}  user id');
          },
        ),
      ),
    );
  }
}
