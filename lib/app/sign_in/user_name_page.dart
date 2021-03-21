import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserNamePage extends StatefulWidget {
  @override
  _UserNamePageState createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  final _formKey = GlobalKey<FormState>();
  String _userName, _errorText;
  Color _renk = Colors.yellow;
  bool _durum = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            //renk gecişi
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.bottomCenter,
                  colors: [Colors.yellow, Colors.white, Colors.white, Colors.white, Colors.white],
                ),
              ),
            ),
            //renk topu
            Positioned(
              bottom: -MediaQuery.of(context).size.height / 6,
              child: ClipOval(
                child: Container(
                  color: Colors.yellow,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                ),
              ),
            ),
            //form ve google button
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.center,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Bir Kullanıcı Adı Seciniz",
                              style: GoogleFonts.fanwoodText(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.yellow.shade600),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextFormField(
                                maxLength: 15,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  kontrol(value);
                                },
                                onSaved: (String value) {
                                  setState(() {
                                    _userName = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.supervised_user_circle_rounded,
                                      color: _renk,
                                    ),
                                    suffixIcon: _renk == Colors.green
                                        ? Icon(
                                            Icons.done,
                                            color: _renk,
                                          )
                                        : null,
                                    errorText: _errorText,
                                    hintText: 'Email',
                                    enabledBorder:
                                        OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: _renk)),
                                    focusedBorder:
                                        OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: _renk)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.red)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.red))),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                              child: Container(
                                height: 50,
                                width: 400,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.yellow,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))),
                                  onPressed: () {
                                    kaydol();
                                  },
                                  child: Text(
                                    "Kaydol",
                                    //_buttonText,
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void kontrol(String value) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    setState(() {
      _durum = true;
      _errorText = null;
      _renk = Colors.yellow;
    });
    if (value.length <= 6) {
      setState(() {
        _errorText = "6 Karakterden uzun olmalı";
        _durum = false;
      });
    } else if (true) {
      bool sonuc = await _userModel.userNameSearch(value);
      if (!sonuc) {
        setState(() {
          _errorText = "Bu Kullanıcı Adı Kullanımda";
          _durum = false;
        });
      }
    }
    if (_errorText == null) {
      setState(() {
        _renk = Colors.green;
      });
    }
  }

  void kaydol() async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    _formKey.currentState.save();
    if (_durum) {
      await _userModel.userNameUpdate(_userName, _userModel.kullanici.userID);
    }
  }
}
