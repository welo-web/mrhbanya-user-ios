// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:qixer/service/jobs_service/job_request_service.dart';
import 'package:qixer/service/order_details_service.dart';
import 'package:qixer/service/profile_service.dart';
import 'package:qixer/service/wallet_service.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/responsive.dart';
import 'package:webview_flutter/webview_flutter.dart';

// import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../service/booking_services/place_order_service.dart';
import '../../service/payment_gateway_list_service.dart';
import '../utils/common_helper.dart';
import '../utils/others_helper.dart';

class RazorpayPaymentPage extends StatelessWidget {
  RazorpayPaymentPage({
    super.key,
    required this.amount,
    required this.name,
    required this.phone,
    required this.email,
    required this.isFromOrderExtraAccept,
    required this.isFromWalletDeposite,
    required this.isFromHireJob,
  });

  final amount;
  final name;
  final phone;
  final email;
  final isFromOrderExtraAccept;
  final isFromWalletDeposite;
  final isFromHireJob;
  String? url;
  String? paymentID;
  final WebViewController _controller = WebViewController();
  @override
  Widget build(BuildContext context) {
    final pgProvider = Provider.of<PaymentGatewayListService>(
      context,
      listen: false,
    );
    final piProvider = Provider.of<ProfileService>(context, listen: false);
    return Scaffold(
      appBar: CommonHelper().appbarCommon('Payfast', context, () {
        Provider.of<PlaceOrderService>(
          context,
          listen: false,
        ).doNext(context, 'failed', paymentFailed: true);
      }),
      body: WillPopScope(
        onWillPop: () async {
          bool canGoBack = await _controller.canGoBack();
          if (canGoBack) {
            _controller.goBack();
            return false;
          }
          _handlePaymentError(context);
          return false;
        },
        child: FutureBuilder(
          future: waitForIt(
            pgProvider.publicKey,
            pgProvider.secretKey,
            DateTime.now().millisecondsSinceEpoch,
            piProvider.profileDetails.userDetails.name,
            piProvider.profileDetails.userDetails.email,
            piProvider.profileDetails.userDetails.phone,
            amount,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      height: 60,
                      child: OthersHelper().showLoading(cc.primaryColor),
                    ),
                  ),
                ],
              );
            }
            if (snapshot.hasData) {}
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            _controller
              ..loadRequest(Uri.parse(url ?? ''))
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setNavigationDelegate(
                NavigationDelegate(
                  onProgress: (int progress) {},
                  onPageStarted: (String url) async {
                    final uri = Uri.parse(url);
                    final response = await http.get(uri);
                    bool paySuccess = response.body.contains('status":"paid');
                    if (paySuccess) {
                      _handlePaymentSuccess(context);
                    }
                  },
                  onPageFinished: (String url) async {},
                  onWebResourceError: (WebResourceError error) {},
                  onNavigationRequest: (request) {
                    return NavigationDecision.navigate;
                  },
                ),
              );
            return WebViewWidget(controller: _controller);
          },
        ),
      ),
    );
  }

  Future waitForIt(
    apiKey,
    apiSecret,
    orderId,
    userName,
    userEmail,
    userPhone,
    num amount,
  ) async {
    final uri = Uri.parse('https://api.razorpay.com/v1/payment_links');
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}';
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": basicAuth,
    };
    final response = await http.post(
      uri,
      headers: header,
      body: jsonEncode({
        "amount": amount * 100,
        "currency": "INR",
        "accept_partial": false,
        "reference_id": orderId.toString(),
        "description": "Qixer payment",
        "customer": {
          "name": userName,
          "contact": userPhone,
          "email": userEmail,
        },
        "notes": {"policy_name": "Qixer"},
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      url = jsonDecode(response.body)['short_url'];
      paymentID = jsonDecode(response.body)['id'];
      print(url);
      return;
    }
    lnProvider.getString("Something went wrong!").showToast();
    return 'failed';
  }

  void _handlePaymentSuccess(BuildContext context) {
    if (isFromOrderExtraAccept == true) {
      Provider.of<OrderDetailsService>(
        context,
        listen: false,
      ).acceptOrderExtra(context);
    }
    if (isFromWalletDeposite) {
      Provider.of<WalletService>(
        context,
        listen: false,
      ).makeDepositeToWalletSuccess(context);
    } else if (isFromHireJob) {
      Provider.of<JobRequestService>(
        context,
        listen: false,
      ).goToJobSuccessPage(context);
    } else {
      Provider.of<PlaceOrderService>(
        context,
        listen: false,
      ).makePaymentSuccess(context);
    }

    //     "${response.orderId} \n${response.paymentId} \n${response.signature}");
  }

  void _handlePaymentError(BuildContext context) {
    Provider.of<PlaceOrderService>(
      context,
      listen: false,
    ).doNext(context, 'failed', paymentFailed: true);
  }
}
