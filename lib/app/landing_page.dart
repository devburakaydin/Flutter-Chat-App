import 'package:chat_app/app/home_page.dart';
import 'package:chat_app/app/sign_in/sign_in_page.dart';
import 'package:chat_app/app/sign_in/user_name_page.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    if (_userModel.state == ViewState.Idle) {
      if (_userModel.kullanici == null) {
        return SignInPage();
      } else {
        if (_userModel.kullanici.userName != null) {
          return HomePage();
        } else {
          return UserNamePage();
        }
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
