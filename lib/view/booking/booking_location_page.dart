import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:qixer/service/book_steps_service.dart';
import 'package:qixer/service/dropdowns_services/area_dropdown_service.dart';
import 'package:qixer/service/dropdowns_services/state_dropdown_services.dart';
import 'package:qixer/view/auth/signup/components/country_states_dropdowns.dart';
import 'package:qixer/view/booking/delivery_address_page.dart.dart';
import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/constant_styles.dart';
import 'package:qixer/view/utils/others_helper.dart';

import '../../service/dropdowns_services/country_dropdown_service.dart';
import 'components/steps.dart';

class BookingLocationPage extends StatefulWidget {
  const BookingLocationPage({
    super.key,
  });

  @override
  _BookingLocationPageState createState() => _BookingLocationPageState();
}

class _BookingLocationPageState extends State<BookingLocationPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<CountryDropdownService>(context, listen: false)
        .setCountryBasedOnUserProfile(context);
    Provider.of<StateDropdownService>(context, listen: false)
        .setStateBasedOnUserProfile(context);
    Provider.of<AreaDropdownService>(context, listen: false)
        .setAreaBasedOnUserProfile(context);
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: WillPopScope(
        onWillPop: () {
          BookStepsService().decreaseStep(context);
          return Future.value(true);
        },
        child: Scaffold(
          appBar: CommonHelper().appbarForBookingPages(
            "Location",
            context,
          ),
          body: SingleChildScrollView(
            physics: physicsCommon,
            child: Consumer<AppStringService>(
              builder: (context, asProvider, child) => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Circular Progress bar
                      Steps(cc: cc),

                      CommonHelper().titleCommon(
                          asProvider.getString("Booking information's")),

                      const SizedBox(
                        height: 20,
                      ),

                      const CountryStatesDropdowns(),
                      //Login button ==================>
                      const SizedBox(
                        height: 27,
                      ),
                      CommonHelper().buttonOrange(asProvider.getString('Next'),
                          () {
                        var selectedStateId = Provider.of<StateDropdownService>(
                                context,
                                listen: false)
                            .selectedStateId;
                        var selectedAreaId = Provider.of<AreaDropdownService>(
                                context,
                                listen: false)
                            .selectedAreaId;
                        if (selectedStateId == '0' || selectedAreaId == '0') {
                          OthersHelper().showSnackBar(
                              context,
                              asProvider.getString(
                                  'You must select a state and area'),
                              cc.warningColor);
                          return;
                        }

                        //increase page steps by one
                        BookStepsService().onNext(context);
                        // setDefaultPrice ==> Before the user did any quantity increase decrease...etc

                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: const DeliveryAddressPage()));
                      }),

                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
