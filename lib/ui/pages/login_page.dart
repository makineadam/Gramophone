import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import '../../app/resources/constant/named_routes.dart';
import 'package:social_media_app/app/configs/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
    } on FirebaseAuthException catch (e) {
      // WRONG EMAIL
      if (e.code == 'user-not-found') {
        // show error to user
        return 'User not found!';
      }

      // WRONG PASSWORD
      else if (e.code == 'wrong-password') {
        // show error to user
        return 'Wrong Password!';
      }
    }
    return null;
  }

  Future<String?>? _signupUser(SignupData data) async {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data.name!, password: data.password!);
    return null;
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      theme: LoginTheme(
        cardTopPosition: 250,
        primaryColor: AppColors.primaryColor2,
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 35,
        ),
      ),
      title: 'Gramophone',
      logo: 'assets/images/gramophone.png',
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushNamed(NamedRoutes.homeScreen);
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
