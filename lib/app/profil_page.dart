import 'dart:io';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  File _profilFoto;
  bool update = false;

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
      appBar: AppBar(
        title: Text("Profil"),
        actions: <Widget>[
          _cikisButtonu(),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: update == false
                          ? CircleAvatar(
                              radius: 90,
                              backgroundImage: NetworkImage(_userModel.kullanici.profilURL),
                            )
                          : CircleAvatar(
                              radius: 90,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade400,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        iconSize: 30,
                        icon: Icon(Icons.camera_alt_outlined),
                        onPressed: () {
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
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.yellow,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Icon(
                          Icons.person,
                          color: Colors.yellow.shade200,
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Adı",
                              style: TextStyle(color: Colors.black38),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(_userModel.kullanici.name ?? "Lütfen Adınızı Giriniz!", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.black38),
                            onPressed: () {
                              _guncelleData("name");
                            },
                          ),
                          alignment: Alignment.center),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.yellow.shade200,
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Kullanıcı Adı",
                              style: TextStyle(color: Colors.black38),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(_userModel.kullanici.userName, style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.black38),
                            onPressed: () {
                              _guncelleData("userName");
                            },
                          ),
                          alignment: Alignment.center),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Icon(
                          Icons.add,
                          color: Colors.yellow.shade200,
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Durum",
                              style: TextStyle(color: Colors.black38),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(_userModel.kullanici.durum ?? "Müsait", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.black38),
                            onPressed: () {
                              _guncelleData("durum");
                              setState(() {});
                            },
                          ),
                          alignment: Alignment.center),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Icon(
                          Icons.mail,
                          color: Colors.yellow.shade200,
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Email",
                              style: TextStyle(color: Colors.black38),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(_userModel.kullanici.email, style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _profilFotoGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_profilFoto != null) {
      setState(() => update = true);
      await _userModel.uploadFile(_userModel.kullanici.userID, "profil_foto", _profilFoto);
      setState(() => update = false);
    }
  }

  _cikisButtonu() {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    return IconButton(
      icon: Icon(Icons.logout),
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Text(
                  'Çıkış Yap',
                  textAlign: TextAlign.center,
                ),
                content: Text('Çıkış Yapmak İstiyor Musunuz ?'),
                actions: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(shadowColor: Colors.yellow),
                    child: Text("Evet"),
                    onPressed: () async {
                      Navigator.pop(context);
                      await _userModel.signOut();
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(shadowColor: Colors.yellow),
                    child: Text("Hayır"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _guncelleData(String data) {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    String baslik;
    if (data == "name")
      baslik = "Adınızı Girin";
    else if (data == "durum")
      baslik = "Durumunuzu Girin";
    else
      baslik = "Kullanıcı Adınızı Girin";
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheet(
          onClosing: () {},
          builder: (BuildContext context) {
            String gidecekVeri = "";
            String hataMesaj = "";
            return StatefulBuilder(
              builder: (BuildContext context, setState) => Container(
                height: 200,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              baslik,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextField(
                              onChanged: (text) async {
                                hataMesaj = "";
                                gidecekVeri = "";

                                if (text.isEmpty) {
                                  hataMesaj = "Boş Bırakılamaz";
                                } else if (text.length < 6) {
                                  hataMesaj = "6 karakterden az olamaz";
                                } else if (data == "userName") {
                                  bool sonuc = await _userModel.userNameSearch(text);
                                  if (!sonuc) {
                                    hataMesaj = "Bu Kullanıcı Adı Alınamaz";
                                  } else {
                                    gidecekVeri = text;
                                  }
                                } else {
                                  gidecekVeri = text;
                                }
                                setState(() {});
                              },
                              textAlignVertical: TextAlignVertical.bottom,
                              decoration: InputDecoration(errorText: hataMesaj == "" ? null : hataMesaj),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("İPTAL", style: TextStyle(color: Colors.yellow))),
                        TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              if (hataMesaj == "" && gidecekVeri != "") {
                                await _userModel.userUpdate(data, _userModel.kullanici.userID, gidecekVeri);
                              }
                            },
                            child: Text("KAYDET", style: TextStyle(color: Colors.yellow))),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
