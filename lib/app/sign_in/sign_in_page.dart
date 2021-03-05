import 'package:chat_app/viewmodel/user_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';

enum FormType { Register, Login }
enum FormDurum { Dolu, Bos }

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _buttonText, _linkText, _titleText, _errorTextEmail, _errorTextSifre;
  var _formType = FormType.Login;
  var _formDurum = FormDurum.Bos;

  @override
  Widget build(BuildContext context) {
    _titleText = _formType == FormType.Login ? "Giriş" : "Kayıt";
    _buttonText = _formType == FormType.Login ? "Giriş Yap" : "Kayıt Ol";
    _linkText = _formType == FormType.Login ? "Hesabınız Yok Mu? " : "Hesabınız Var Mı? ";
    final _userModel = Provider.of<UserModel>(context);
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
                              _titleText,
                              style: GoogleFonts.fanwoodText(
                                  fontWeight: FontWeight.bold, fontSize: 50, color: Colors.yellow.shade600),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (String girilenEmail) {
                                  _email = girilenEmail;
                                },
                                validator: (value) {
                                  return emailValidatorKontrol(value);
                                },
                                decoration: InputDecoration(
                                    errorText: _errorTextEmail,
                                    icon: Icon(
                                      Icons.email,
                                      color: Colors.yellow,
                                    ),
                                    hintText: 'Email',
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.yellow)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.yellow)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.red)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.red))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextFormField(
                                onSaved: (String girilenSifre) {
                                  _password = girilenSifre;
                                },
                                validator: (value) {
                                  return sifreValidatorKontrol(value);
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    errorText: _errorTextSifre,
                                    icon: Icon(
                                      Icons.vpn_key,
                                      color: Colors.yellow,
                                    ),
                                    hintText: 'Şifre',
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.yellow)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.yellow)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.red)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.red))),
                              ),
                            ),
                            _formDurum == FormDurum.Dolu
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Container(),
                            Padding(
                              padding: EdgeInsets.fromLTRB(55, 16, 16, 0),
                              child: Container(
                                height: 50,
                                width: 400,
                                child: FlatButton(
                                    color: Colors.yellow,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                    onPressed: () {
                                      buttonaBasildi();
                                    },
                                    child: Text(
                                      _buttonText,
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    )),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(95, 20, 0, 0),
                                child: Row(
                                  children: [
                                    Text(
                                      _linkText,
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _formType == FormType.Login
                                              ? _formType = FormType.Register
                                              : _formType = FormType.Login;
                                          _formKey.currentState.reset();
                                          _errorTextEmail = null;
                                          _errorTextSifre = null;
                                        });
                                      },
                                      child: Text(
                                        _formType == FormType.Login ? "Kayıt Ol" : "Giriş Yap",
                                        style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: SignInButton.mini(
                        buttonType: ButtonType.google,
                        buttonSize: ButtonSize.large,
                        onPressed: () async {
                          await _userModel.signInWithGoogle();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String emailValidatorKontrol(String value) {
    if (value.isEmpty) {
      return 'Email Boş Olamaz';
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Email Dogru Degil';
    }
    return null;
  }

  String sifreValidatorKontrol(String value) {
    if (value.isEmpty) {
      return 'Şifre Boş Olamaz';
    } else if (value.length < 6) {
      return 'Şifre 6 Karakterden Az Olamaz';
    }
    return null;
  }

  void durumDegis() {
    setState(() {
      _formDurum == FormDurum.Bos ? _formDurum = FormDurum.Dolu : _formDurum = FormDurum.Bos;
    });
  }

  void hata(String e) {
    setState(() {
      if (e ==
          "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
        _errorTextSifre = "Şifre Geçerli Degil";
      } else if (e ==
          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
        _errorTextEmail = "Email Geçerli Degil";
      } else if (e ==
          "[firebase_auth/emaıl-already-ın-use] The email address is already in use by another account.") {
        _errorTextEmail = "Email Kullanımda";
      } else {
        _errorTextEmail = "Tekrar Deneyin";
      }
    });
  }

  void buttonaBasildi() async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    setState(() {
      _errorTextEmail = null;
      _errorTextSifre = null;
    });
    _formKey.currentState.save();

    if (_formKey.currentState.validate()) {
      durumDegis();
      if (_formType == FormType.Login) {
        try {
          await _userModel.signInWithEmailAndPassword(_email, _password);
        } catch (e) {
          durumDegis();
          hata(e.toString());
        }
      } else {
        try {
          await _userModel.createUserWithEmailAndPassword(_email, _password);
        } catch (e) {
          durumDegis();
          hata(e.toString());
        }
      }
    } else {
      print("hatalı");
    }
  }
}
/*
bool sonuc = await _userModel.emailSearch(_email);
      if (_formType == FormType.Login) {
        if (sonuc) {
          await _userModel.signInWithEmailAndPassword(_email, _password);
        } else {
          setState(() {
            _errorTextEmail = "Bu Email Adresi Kayıtlı Degil";
          });
        }
      } else {
        if (sonuc) {
          setState(() {
            _errorTextEmail = "Bu Email Kullanımda ";
          });
        } else {
          await _userModel.createUserWithEmailAndPassword(_email, _password);
        }
      }
 */
