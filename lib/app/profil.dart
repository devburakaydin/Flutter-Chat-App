import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatelessWidget {
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
              child: Text("Çıkış"))
        ],
        title: Text("Profil"),
      ),
      body: Center(
        child: Text("Profil Sayfasi"),
      ),
    );
  }
}
