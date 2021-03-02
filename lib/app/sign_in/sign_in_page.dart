import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';

enum FormType { Register, Login }

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _buttonText, _linkText;
  var _formType = FormType.Login;

  @override
  Widget build(BuildContext context) {
    _buttonText = _formType == FormType.Login ? "Giriş Yap" : "Kayıt Ol";
    _linkText = _formType == FormType.Login ? "Hesabınız Yok Mu? " : "Hesabınız Var Mı? ";
    final _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      body: _userModel.state == ViewState.Idle
          ? SingleChildScrollView(
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
                    alignment: Alignment.center,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 150,
                          ),
                          Text(
                            _buttonText,
                            style: GoogleFonts.orbitron(
                                fontWeight: FontWeight.bold, fontSize: 50, color: Colors.deepOrange),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              //controller: TextEditingController(text: _email),
                              //onChanged: (value) {},
                              onSaved: (String girilenEmail) {
                                _email = girilenEmail;
                              },

                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Email Boş Olamaz';
                                } else if (RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return null;
                                } else {
                                  return 'Email Dogru Degil';
                                }
                              },

                              decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.deepOrange,
                                  ),
                                  hintText: 'Enter Email',
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: Colors.deepOrange)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: Colors.deepOrange)),
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
                              /*
                              controller: TextEditingController(text: _password),
                              onChanged: (value) {
                                print(value);
                              },
                               */
                              onSaved: (String girilenSifre) {
                                _password = girilenSifre;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'şifre boş olamaz';
                                } else if (value.length < 6) {
                                  return 'şifre 6 karakterden az olamaz';
                                }
                                return null;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.deepOrange,
                                  ),
                                  hintText: 'Enter Password',
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: Colors.deepOrange)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: Colors.deepOrange)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: Colors.red)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: Colors.red))),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(55, 16, 16, 0),
                            child: Container(
                              height: 50,
                              width: 400,
                              child: FlatButton(
                                  color: Colors.deepOrange,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                  onPressed: () async {
                                    _formKey.currentState.save();

                                    if (_formKey.currentState.validate()) {
                                      debugPrint("email : " + _email + "sifre :" + _password);
                                      if (_formType == FormType.Login) {
                                        await _userModel.signInWithEmailAndPassword(_email, _password);
                                        debugPrint("sign uıd : " + _userModel.kullanici.userID);
                                      } else {
                                        await _userModel.createUserWithEmailAndPassword(_email, _password);
                                        debugPrint(" create uıd : " + _userModel.kullanici.userID);
                                      }
                                    } else {
                                      print("hatalı");
                                    }
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
                                      });
                                    },
                                    child: Text(
                                      _formType == FormType.Login ? "Kayıt Ol" : "Giriş Yap",
                                      style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
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
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
