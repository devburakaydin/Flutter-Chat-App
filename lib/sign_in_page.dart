import 'package:chat_app/commen_widget/social_log_in_button.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.topCenter,
                end: AlignmentDirectional.bottomCenter,
                //colors: [Colors.yellow, Colors.white,Colors.yellow],
                colors: [Colors.yellow, Colors.white],
              ),
            ),
          ),
          Positioned(
            bottom: -130,
            child: ClipOval(
              child: Container(
                color: Colors.yellow,
                width: MediaQuery.of(context).size.width,
                height: 260,
              ),
            ),
          ),
          Container(
            color: Colors.transparent,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Oturum Açın',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
                SocialLogInButton(
                  butonText: 'Google ile Oturum Aç',
                  onPressed: () async {
                    await _userModel.singInAnonymously();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
