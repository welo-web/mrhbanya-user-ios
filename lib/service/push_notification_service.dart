// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/service/profile_service.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/pusher_helper.dart';

class PushNotificationService with ChangeNotifier {
  bool pusherCredentialLoaded = false;

  //
  sendNotificationToSeller(BuildContext context,
      {required sellerId,
      required title,
      required body,
      type = 'notification'}) async {
    var pUrl = Provider.of<PushNotificationService>(context, listen: false)
        .pusherApiUrl;

    var pToken = Provider.of<PushNotificationService>(context, listen: false)
        .pusherToken;
    var senderId = Provider.of<ProfileService>(context, listen: false)
        .profileDetails
        .userDetails
        .id;
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      // "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $pToken",
    };

    var data = jsonEncode({
      "interests": ["debug-seller$sellerId"],
      "fcm": {
        "notification": {"title": "$title", "body": "$body"},
        "data": {"sender-id": '$senderId', "type": '$type'}
      }
    });

    var response =
        await http.post(Uri.parse(pUrl), headers: header, body: data);

    if (response.statusCode >= 200 && response.statusCode < 300) {
    } else {
      debugPrint(response.body.toString());
    }
  }

  //get pusher credential
  //======================>

  var apiKey;
  var secret;
  var pusherToken;
  var pusherApiUrl;
  var pusherCluster;
  var pusherInstance;

  Future<bool> fetchPusherCredential({context}) async {
    var connection = await checkConnection();
    if (!connection) return false;
    if (pusherCredentialLoaded == true) return false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json"
      "Authorization": "Bearer $token",
    };

    var response = await http.get(
        Uri.parse("$baseApi/user/chat/pusher/credentials"),
        headers: header);
    debugPrint(response.body.toString());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = jsonDecode(response.body);
      pusherCredentialLoaded = true;
      apiKey = jsonData['pusher_app_key'];
      secret = jsonData['pusher_app_secret'];
      pusherToken = jsonData['pusher_app_push_notification_auth_token'];
      pusherApiUrl = jsonData['pusher_app_push_notification_auth_url'];
      pusherCluster = jsonData['pusher_app_cluster'];
      pusherInstance = jsonData['pusher_app_push_notification_instanceId'];

      try {
        if (pusherInstance != null) {
          await PusherBeams.instance.start(pusherInstance);
        }

        PusherHelper().initPusherBeams(context);
      } catch (e) {}
      notifyListeners();
      return true;
    } else {
      debugPrint(response.body.toString());
      return false;
    }
  }
}
