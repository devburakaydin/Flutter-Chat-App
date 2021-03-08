import 'package:chat_app/app/konusma_page.dart';
import 'package:chat_app/models/kullanici.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatefulWidget {
  @override
  _KullanicilarPageState createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    _userModel.getAllUser();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
        title: Text("Kullanicilar"),
      ),
      body: FutureBuilder<List<Kullanici>>(
        future: _userModel.getAllUser(),
        builder: (context, sonuc) {
          if (sonuc.hasData) {
            var tumKullanicilar = sonuc.data;
            if (tumKullanicilar.length - 1 > 0) {
              return RefreshIndicator(
                onRefresh: _kullanicilarListesiniYenile,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var secilenUser = tumKullanicilar[index];
                    if (secilenUser.userName != _userModel.kullanici.userName) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                              builder: (context) => KonusmaPage(
                                    currentUser: _userModel.kullanici,
                                    sohbetEdilenUser: secilenUser,
                                  )));
                        },
                        child: ListTile(
                          title: Text(secilenUser.userName),
                          subtitle: Text(secilenUser.email),
                          leading: secilenUser.profilURL == null
                              ? CircleAvatar(backgroundImage: AssetImage("assets/images/profil.jpeg"))
                              : CircleAvatar(backgroundImage: NetworkImage(secilenUser.profilURL)),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                  itemCount: tumKullanicilar.length,
                ),
              );
            } else {
              return RefreshIndicator(
                  onRefresh: _kullanicilarListesiniYenile,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.supervised_user_circle,
                              color: Theme.of(context).primaryColor,
                              size: 120,
                            ),
                            Text(
                              "Kullanıcı Yok",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 36),
                            )
                          ],
                        ),
                      ),
                      height: MediaQuery.of(context).size.height - 150,
                    ),
                  ));
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<void> _kullanicilarListesiniYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
