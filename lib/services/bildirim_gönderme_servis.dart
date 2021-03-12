import 'package:chat_app/models/kullanici.dart';
import 'package:chat_app/models/mesaj.dart';
import 'package:http/http.dart' as http;

class BildirimGondermeServis {
  Future<bool> bildirimGonder(Mesaj gonderilecekBildirim, Kullanici gonderenUser, String token) async {
    String endURL = "https://fcm.googleapis.com/fcm/send";
    String firebaseKey =
        "AAAAeSqnvMM:APA91bEAbTzRqE9ViwbnqswdO9dp6ZszLgzk2CyLLVzbLNUCqoTyvrgDFC4CFATI_7hMNdd08FOPDbFO-8VlzE2KYQuDl_iCHrPSie02zFwWVwqvJm_5mb5zyFUY9J-Tze_zEnx57-hg";
    Map<String, String> headers = {"Content-type": "application/json", "Authorization": "key=$firebaseKey"};

    String json =
        '{ "to" : "$token", "data" : { "message" : "${gonderilecekBildirim.mesaj}", "title": "${gonderenUser.userName} yeni mesaj", "profilURL": "${gonderenUser.profilURL}", "gonderenUserID" : "${gonderenUser.userID}" } }';

    http.Response response = await http.post(endURL, headers: headers, body: json);

    if (response.statusCode == 200) {
      print("işlem basarılı");
      return true;
    } else {
      print("işlem basarısız:" + response.statusCode.toString());
      //print("jsonumuz:" + json);
      return false;
    }
  }
}
