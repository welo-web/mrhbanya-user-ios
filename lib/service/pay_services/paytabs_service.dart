// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/book_confirmation_service.dart';
import 'package:qixer/service/booking_services/book_service.dart';
import 'package:qixer/service/booking_services/personalization_service.dart';
import 'package:qixer/service/booking_services/place_order_service.dart';
import 'package:qixer/service/jobs_service/job_request_service.dart';
import 'package:qixer/service/order_details_service.dart';
import 'package:qixer/service/profile_service.dart';
import 'package:qixer/service/wallet_service.dart';
import 'package:qixer/view/payments/paytabs_payment.dart';

class PaytabsService {
  payByPaytabs(BuildContext context,
      {bool isFromOrderExtraAccept = false,
      bool isFromWalletDeposite = false,
      bool isFromHireJob = false}) {
    Provider.of<PlaceOrderService>(context, listen: false).setLoadingFalse();

    var amount;

    String name;
    String phone;
    String email;
    var orderId;
    name = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .userDetails
            .name ??
        'test';
    phone = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .userDetails
            .phone ??
        '111111111';
    email = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .userDetails
            .email ??
        'test@test.com';
    if (isFromOrderExtraAccept == true) {
      Provider.of<PlaceOrderService>(context, listen: false).setLoadingTrue();

      amount = Provider.of<OrderDetailsService>(context, listen: false)
          .selectedExtraPrice;

      orderId = Provider.of<OrderDetailsService>(context, listen: false)
          .selectedExtraId
          .toString();
    } else if (isFromWalletDeposite) {
      amount = Provider.of<WalletService>(context, listen: false).amountToAdd;

      orderId =
          'wallet${Provider.of<WalletService>(context, listen: false).walletHistoryId}';
    } else if (isFromHireJob) {
      amount = Provider.of<JobRequestService>(context, listen: false)
          .selectedJobPrice;

      orderId = 'jobHire$name';
    } else {
      var bcProvider =
          Provider.of<BookConfirmationService>(context, listen: false);
      var pProvider =
          Provider.of<PersonalizationService>(context, listen: false);
      var bookProvider = Provider.of<BookService>(context, listen: false);

      name = bookProvider.name ?? '';
      phone = bookProvider.phone ?? '';
      email = bookProvider.email ?? '';
      orderId = Provider.of<PlaceOrderService>(context, listen: false).orderId;

      if (pProvider.isOnline == 0) {
        amount = bcProvider.totalPriceAfterAllcalculation.toStringAsFixed(2);
      } else {
        amount = bcProvider.totalPriceOnlineServiceAfterAllCalculation
            .toStringAsFixed(2);
      }
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PayTabsPayment(
          amount: amount,
          name: name,
          phone: phone,
          email: email,
          isFromOrderExtraAccept: isFromOrderExtraAccept,
          isFromWalletDeposite: isFromWalletDeposite,
          isFromHireJob: isFromHireJob,
          orderId: orderId,
        ),
      ),
    );
  }
}
