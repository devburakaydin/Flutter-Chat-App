import 'dart:io';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  File _profilFoto;

  void _kameradanFotoCek() async {
    var pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _profilFoto = File(pickedFile.path);
        _profilFotoGuncelle(context);
      } else {
        print('No image selected.');
      }
      Navigator.of(context).pop();
    });
  }

  void _galeridenResimSec() async {
    var pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profilFoto = File(pickedFile.path);
        _profilFotoGuncelle(context);
      } else {
        print('No image selected.');
      }
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipPath(
                    clipper: MyCustomClipper(),
                    child: Container(
                      color: Colors.yellow,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: 160,
                                        child: Column(
                                          children: <Widget>[
                                            ListTile(
                                              leading: Icon(Icons.camera),
                                              title: Text("Kameradan Çek"),
                                              onTap: () {
                                                _kameradanFotoCek();
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.image),
                                              title: Text("Galeriden Seç"),
                                              onTap: () {
                                                _galeridenResimSec();
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: CircleAvatar(
                                radius: 75,
                                backgroundColor: Colors.red,
                                backgroundImage: _profilFoto == null ? null : FileImage(_profilFoto),

                                /*
                      backgroundImage: _profilFoto == null
                          ? NetworkImage(_userModel.user.profilURL)
                          : FileImage(_profilFoto),
                       */
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            _userModel.kullanici.userName,
                            style: TextStyle(
                                fontSize: _userModel.kullanici.userName.length > 9 ? 15 : 25,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 10,
                      right: 10,
                      child: FlatButton(
                          onPressed: () async {
                            await _userModel.signOut();
                          },
                          child: Text("Çıkış")))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  //initialValue: _userModel.user.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Emailiniz",
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  //controller: _controllerUserName,
                  decoration: InputDecoration(
                    labelText: "User Name",
                    hintText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              /*
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SocialLoginButton(
                  butonText: "Değişiklikleri Kaydet",
                  onPressed: () {
                    _userNameGuncelle(context);
                    _profilFotoGuncelle(context);
                  },
                ),
              ),
               */
            ],
          ),
        ),
      ),
    );
  }

  void _profilFotoGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_profilFoto != null) {
      await _userModel.uploadFile(_userModel.kullanici.userID, "profil_foto", _profilFoto);
    }
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height - 70);
    path.lineTo(size.width, 0.0);
    return path;
  }

  @override
  bool shouldReclip(MyCustomClipper oldClipper) => false;
}
