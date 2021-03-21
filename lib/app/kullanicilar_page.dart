import 'package:chat_app/app/konusma_page.dart';
import 'package:chat_app/viewmodel/all_user_view_model.dart';
import 'package:chat_app/viewmodel/chat_view_model.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatefulWidget {
  @override
  _KullanicilarPageState createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*
    //Sayfa yüklenmeden işlem yapma 
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      //getUser();
    });
     */

    _scrollController.addListener((_listeScrollListener));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[],
          title: Text("Kullanicilar"),
        ),
        body: Consumer<AllUserViewModel>(
          builder: (context, model, child) {
            if (model.state == AllUserViewState.Busy) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (model.state == AllUserViewState.Loaded) {
              return RefreshIndicator(
                onRefresh: model.refresh,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: model.hasMoreLoading ? model.kullanicilarListesi.length + 1 : model.kullanicilarListesi.length,
                  itemBuilder: (context, index) {
                    if (model.kullanicilarListesi.length == 1) {
                      return _kullaniciYokUI();
                    } else if (model.hasMoreLoading && index == model.kullanicilarListesi.length) {
                      return _yeniElemanlarYukleniyor();
                    } else {
                      return _userListeElemaniOlustur(index);
                    }
                  },
                ),
              );
            } else {
              return Container();
            }
          },
        ));
  }

  Widget _userListeElemaniOlustur(int index) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    final _tumKullanicilarModel = Provider.of<AllUserViewModel>(context, listen: false);

    var secilenUser = _tumKullanicilarModel.kullanicilarListesi[index];
    if (secilenUser.userName != _userModel.kullanici.userName) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => ChatViewModel(
                  currentUser: _userModel.kullanici,
                  sohbetEdilenUser: secilenUser,
                ),
                child: KonusmaPage(),
              ),
            ),
          );
        },
        child: Container(
          child: ListTile(
            title: Text(secilenUser.name ?? secilenUser.userName),
            subtitle: secilenUser.durum == null
                ? Text("")
                : Text(
                    secilenUser.durum,
                    overflow: TextOverflow.ellipsis,
                  ),
            leading: CircleAvatar(backgroundImage: NetworkImage(secilenUser.profilURL)),
          ),
        ),
      );
    } else {
      return Container();
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

  Widget _kullaniciYokUI() {
    final _tumKullanicilarModel = Provider.of<AllUserViewModel>(context);
    return RefreshIndicator(
      onRefresh: _tumKullanicilarModel.refresh,
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
      ),
    );
  }

  Future<void> dahaFazlaKullaniciGetir() async {
    if (_isLoading == false) {
      _isLoading = true;
      final _tumKullanicilarModel = Provider.of<AllUserViewModel>(context, listen: false);
      await _tumKullanicilarModel.dahaFazlaKullaniciGetir();
      _isLoading = false;
    }
  }

  void _listeScrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
      dahaFazlaKullaniciGetir();
    }
  }
}
