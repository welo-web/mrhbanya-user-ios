import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qixer/model/shedule_model.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/view/utils/others_helper.dart';

class SheduleService with ChangeNotifier {
  var schedules;

  int totalDay = 0;

  bool isloading = true;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  fetchShedule(sellerId, selectedWeek) async {
    setLoadingTrue();
    var connection = await checkConnection();
    if (connection) {
      //internet connection is on
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        // "Content-Type": "application/json"
      };

      var response = await http.get(
          Uri.parse(
              '$baseApi/service-list/service-schedule/$selectedWeek/$sellerId'),
          headers: header);

      if ((response.statusCode >= 200 && response.statusCode < 300) &&
          response.body.contains('day')) {
        var data = SheduleModel.fromJson(jsonDecode(response.body));
        totalDay = data.day.totalDay ?? 0;
        schedules = data;

        // var data = ServiceDetailsModel.fromJson(jsonDecode(response.body));

        notifyListeners();
        setLoadingFalse();
      } else {
        debugPrint(response.body.toString());
        schedules = 'nothing';
        setLoadingFalse();
        notifyListeners();
      }
    }
  }
}
