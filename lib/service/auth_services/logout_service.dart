import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:qixer/helper/extension/context_extension.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/service/profile_service.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../push_notification_service.dart';

class LogoutService with ChangeNotifier {
  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  logout(BuildContext context) async {
    var connection = await checkConnection();
    if (connection) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        // "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      setLoadingTrue();
      var response = await http.post(
        Uri.parse('$baseApi/user/logout'),
        headers: header,
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        notifyListeners();
        try {
          var pusherInstance =
              Provider.of<PushNotificationService>(context, listen: false)
                  .pusherInstance;

          if (pusherInstance != null) {
            await PusherBeams.instance.clearAllState();
          }
        } catch (e) {}

        // Navigator.pushAndRemoveUntil<dynamic>(
        //   context,
        //   MaterialPageRoute<dynamic>(
        //     builder: (BuildContext context) => const LoginPage(
        //       hasBackButton: false,
        //     ),
        //   ),
        //   (route) => false,
        // );

        // clear profile data =====>
        Provider.of<ProfileService>(context, listen: false)
            .setEverythingToDefault();

        clear();
        setLoadingFalse();
        context.popTrue;
      } else {
        debugPrint(response.body.toString());
        OthersHelper().showToast('Something went wrong', Colors.black);
        setLoadingFalse();
      }
    }
  }

  //clear saved email, pass and token
  clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
