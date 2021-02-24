import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
              onPressed: () async {
                await _userModel.signOut();
              },
              child: Text("Back"))
        ],
      ),
      body: Center(
        child: Text("Ana Sayfa"),
      ),
    );
  }
}
