import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          //renk gecişi
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
          //renk topu
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
          //form
          Container(
            //color: Colors.transparent,
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
              ],
            ),
          ),
          //google button
          Positioned(
            bottom: 30,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: SignInButton.mini(
                buttonType: ButtonType.google,
                buttonSize: ButtonSize.large,
                onPressed: () {
                  _userModel.signInWithGoogle();
                },

              ),
            ),
          ),
        ],
      ),
    );
  }
}
