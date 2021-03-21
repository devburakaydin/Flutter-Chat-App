import 'package:chat_app/app/konusma_page.dart';
import 'package:chat_app/models/kullanici.dart';
import 'package:chat_app/models/sohbet.dart';
import 'package:chat_app/viewmodel/chat_view_model.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SohbetPage extends StatefulWidget {
  @override
  _SohbetPageState createState() => _SohbetPageState();
}

class _SohbetPageState extends State<SohbetPage> {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbet"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _sohbetlerimListesiYenile();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Sohbet>>(
        future: _userModel.getAllSohbetler(_userModel.kullanici.userID),
        builder: (context, sohbetListesi) {
          if (sohbetListesi.hasData) {
            var tumKonusmalar = sohbetListesi.data;

            if (tumKonusmalar.length > 0) {
              return RefreshIndicator(
                onRefresh: _sohbetlerimListesiYenile,
                child: ListView.builder(
                  itemCount: tumKonusmalar.length,
                  itemBuilder: (context, index) {
                    var oankiKonusma = tumKonusmalar[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (BuildContext context) => ChatViewModel(
                                currentUser: _userModel.kullanici,
                                sohbetEdilenUser: Kullanici.idveResim(
                                    userID: oankiKonusma.kimleKonusuyor,
                                    profilURL: oankiKonusma.konusulanUserProfilURL,
                                    name: oankiKonusma.name,
                                    userName: oankiKonusma.konusulanUserName),
                              ),
                              child: KonusmaPage(),
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(oankiKonusma.konusulanUserName),
                            Text(oankiKonusma.aradakiFark),
                          ],
                        ),
                        subtitle: Text(
                          oankiKonusma.sonYollananMesaj,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.withAlpha(40),
                          backgroundImage: oankiKonusma.konusulanUserProfilURL != null
                              ? NetworkImage(oankiKonusma.konusulanUserProfilURL)
                              : AssetImage("assets/images/profil.jpeg"),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _sohbetlerimListesiYenile,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.chat,
                            color: Theme.of(context).primaryColor,
                            size: 120,
                          ),
                          Text(
                            "Henüz Konusma Yapılmamış",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 36),
                          )
                        ],
                      ),
                    ),
                    height: MediaQuery.of(context).size.height - 150,
                  ),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<void> _sohbetlerimListesiYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
/*
StreamBuilder<List<Sohbet>>(
        stream: _userModel.getStreamAllSohbetler(_userModel.kullanici.userID),
        builder: (context, streamSohbetlerim) {
          if (streamSohbetlerim.hasData) {
            var tumSohbetListesi = streamSohbetlerim.data;
            return ListView.builder(
                itemCount: tumSohbetListesi.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 50,
                    width: 50,
                    color: Colors.yellow,
                    child: Center(child: Text(index.toString())),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      )
 */
/*

 */
