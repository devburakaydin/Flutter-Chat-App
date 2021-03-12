import 'dart:convert';
import 'dart:io';
import 'package:chat_app/app/konusma_page.dart';
import 'package:chat_app/models/kullanici.dart';
import 'package:chat_app/viewmodel/chat_view_model.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    //final dynamic data = message['data'];
    print("Arka planda gelen data" + message["data"].toString());
    NotificationHandler.showNotification(message);
  }
  /*
  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }
   */

  return Future.value();
}

class NotificationHandler {
  FirebaseMessaging _fcm = FirebaseMessaging();
  static final NotificationHandler _singleton = NotificationHandler._internal();

//Bundan Ne Kadar Nesne Üretirsen üret Tek bir Nesne üzerinden işlem yaparsın
  factory NotificationHandler() {
    return _singleton;
  }

  NotificationHandler._internal();
  BuildContext myContext;

  initializeFCMNotification(BuildContext context) async {
    myContext = context;
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);

    /*
    _fcm.subscribeToTopic("spor");
    String token = await _fcm.getToken();
    print("token :" + token);
     */
    _fcm.onTokenRefresh.listen((newToken) async {
      User _currentUser = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.doc("tokens/" + _currentUser.uid).set({"token": newToken});
    });

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage Tetiklendi : $message");
        showNotification(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch Tetiklendi : $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume Tetiklendi : $message");
      },
    );
  }

  static Future<void> showNotification(Map<String, dynamic> message) async {
    Person mesaj;
    if (message["data"]["profilURL"].toString() != "null") {
      var userURLPath = await _downloadAndSaveImage(message["data"]["profilURL"], 'largeIcon');

      mesaj = Person(
        name: message["data"]["title"],
        key: '1',
        icon: BitmapFilePathAndroidIcon(userURLPath),
      );
    } else {
      mesaj = Person(
        name: message["data"]["title"],
        key: '1',
      );
    }

    var mesajStyle = MessagingStyleInformation(mesaj, messages: [Message(message["data"]["message"], DateTime.now(), mesaj)]);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails('1234', 'Yeni Mesaj', 'your channel description',
        //style: AndroidNotificationStyle.Messaging,
        styleInformation: mesajStyle,
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message["data"]["title"], message["data"]["message"], platformChannelSpecifics,
        payload: jsonEncode(message));
  }

  Future onSelectNotification(String payload) async {
    final _userModel = Provider.of<UserModel>(myContext);

    if (payload != null) {
      // debugPrint('notification payload: ' + payload);

      Map<String, dynamic> gelenBildirim = await jsonDecode(payload);

      Navigator.of(myContext, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => ChatViewModel(
                currentUser: _userModel.kullanici,
                sohbetEdilenUser:
                    Kullanici.idveResim(userID: gelenBildirim["data"]["gonderenUserID"], profilURL: gelenBildirim["data"]["profilURL"])),
            child: KonusmaPage(),
          ),
        ),
      );
    }
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    /*
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: body != null ? Text(body) : null,
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondScreen(payload),
                ),
              );
            },
          )
        ],
      ),
    );
     */
  }

  static _downloadAndSaveImage(String url, String name) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$name';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
