import 'package:chat_app/models/mesaj.dart';
import 'package:chat_app/viewmodel/chat_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class KonusmaPage extends StatefulWidget {
  @override
  _KonusmaPageState createState() => _KonusmaPageState();
}

class _KonusmaPageState extends State<KonusmaPage> {
  var _mesajController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbet"),
      ),
      body: _chatModel.state == ChatViewState.Busy
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                children: <Widget>[
                  _buildMesajListesi(),
                  _buildYeniMesajGir(),
                ],
              ),
            ),
    );
  }

  Widget _buildMesajListesi() {
    return Consumer<ChatViewModel>(
      builder: (context, chatModel, child) {
        return Expanded(
          child: ListView.builder(
            reverse: true,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (chatModel.hasMoreLoading && chatModel.mesajlarListesi.length == index) {
                return _yeniElemanlarYukleniyor();
              } else
                return _konusmaBalonuOlustur(chatModel.mesajlarListesi[index]);
            },
            itemCount: chatModel.hasMoreLoading ? chatModel.mesajlarListesi.length + 1 : chatModel.mesajlarListesi.length,
          ),
        );
      },
    );
  }

  Widget _buildYeniMesajGir() {
    final _chatModel = Provider.of<ChatViewModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.only(bottom: 8, left: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _mesajController,
              cursorColor: Colors.blueGrey,
              style: new TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Mesajınızı Yazın",
                border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(30.0), borderSide: BorderSide.none),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: Colors.yellow,
              child: Icon(
                Icons.navigation,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () async {
                if (_mesajController.text.trim().length > 0) {
                  Mesaj _kaydedilecekMesaj = Mesaj(
                    kimden: _chatModel.currentUser.userID,
                    kime: _chatModel.sohbetEdilenUser.userID,
                    bendenMi: true,
                    konusmaSahibi: _chatModel.currentUser.userID,
                    mesaj: _mesajController.text,
                  );
                  var sonuc = await _chatModel.saveMessage(_kaydedilecekMesaj);
                  if (sonuc) {
                    _mesajController.clear();
                    _scrollController.animateTo(
                      _scrollController.position.minScrollExtent,
                      //curve: Curves.easeOut,
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 10),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _konusmaBalonuOlustur(Mesaj oankiMesaj) {
    Color _gelenMesajRenk = Colors.blue;
    Color _gidenMesajRenk = Colors.yellow.shade200;
    final _chatModel = Provider.of<ChatViewModel>(context, listen: false);
    var _saatDakikaDegeri = "";

    try {
      _saatDakikaDegeri = _saatDakikaGoster(oankiMesaj.date ?? Timestamp(1, 1));
    } catch (e) {
      print("hata var:" + e.toString());
    }

    var _benimMesajimMi = oankiMesaj.bendenMi;
    if (_benimMesajimMi) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gidenMesajRenk,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      oankiMesaj.mesaj,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Text(_saatDakikaDegeri),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.grey.withAlpha(40),
                  backgroundImage: _chatModel.sohbetEdilenUser.profilURL != null
                      ? NetworkImage(_chatModel.sohbetEdilenUser.profilURL)
                      : AssetImage("assets/images/profil.jpeg"),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gelenMesajRenk,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      oankiMesaj.mesaj,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Text(_saatDakikaDegeri),
              ],
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

  String _saatDakikaGoster(Timestamp timestamp) {
    return DateFormat.Hm().format(timestamp.toDate());
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
      eskiMesajlariGetir();
    }
  }

  Future<void> eskiMesajlariGetir() async {
    print("listenin üstündeyiz eski mesajlari Getir");

    if (_isLoading == false) {
      _isLoading = true;
      final _chatModel = Provider.of<ChatViewModel>(context, listen: false);
      await _chatModel.dahaFazlaMesajGetir();
      _isLoading = false;
    }
  }

  _yeniElemanlarYukleniyor() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
