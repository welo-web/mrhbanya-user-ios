import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qixer/helper/extension/context_extension.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:qixer/service/book_steps_service.dart';
import 'package:qixer/service/booking_services/book_service.dart';
import 'package:qixer/service/booking_services/coupon_service.dart';
import 'package:qixer/service/booking_services/shedule_service.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/service/rtl_service.dart';
import 'package:qixer/view/auth/login/login.dart';
import 'package:qixer/view/booking/booking_location_page.dart';
import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/constant_styles.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:qixer/view/utils/responsive.dart';

import '../../service/profile_service.dart';
import 'components/steps.dart';

class ServiceSchedulePage extends StatefulWidget {
  const ServiceSchedulePage({super.key});

  @override
  _ServiceSchedulePageState createState() => _ServiceSchedulePageState();
}

class _ServiceSchedulePageState extends State<ServiceSchedulePage> {
  @override
  void initState() {
    super.initState();
  }

  int selectedShedule = 0;
  var _selectedWeekday = firstThreeLetter(
      DateTime.now().toLocal(), rtlProvider.langSlug.substring(0, 2));
  var _monthAndDate = getMonthAndDate(
      DateTime.now().toLocal(), rtlProvider.langSlug.substring(0, 2));
  var _selectedTime;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    final rtlPorvider = Provider.of<RtlService>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        BookStepsService().decreaseStep(context);
        //set coupon value to default again
        Provider.of<CouponService>(context, listen: false).setCouponDefault();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarForBookingPages('Schedule', context,
            extraFunction: () {
          //set coupon value to default again
          Provider.of<CouponService>(context, listen: false).setCouponDefault();
        }),
        body: Consumer<AppStringService>(
          builder: (context, asProvider, child) => Consumer<SheduleService>(
            builder: (context, provider, child) {
              //if user didnt select anything then go with the default value
              if (provider.isloading == false &&
                  provider.schedules != 'nothing' &&
                  _selectedTime == null) {
                _selectedTime = provider.schedules.schedules[0].schedule;
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {});
                });
              }
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: physicsCommon,
                      child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Circular Progress bar
                              Steps(cc: cc),
                              // CommonHelper().borderButtonOrange(
                              //     _selectedDate == null
                              //         ? asProvider.getString('Select Date')
                              //         : "${firstThreeLetter(_selectedDate, rtlProvider.langSlug.substring(0, 2)) ?? ''}",
                              //     () {
                              //   final now = DateTime.now();
                              //   showDatePicker(
                              //           context: context,
                              //           initialDate: now,
                              //           firstDate: now,
                              //           lastDate:
                              //               now.add(const Duration(days: 365)))
                              //       .then((value) {
                              //     if (value == null) {
                              //       return;
                              //     }
                              //     setState(() {
                              //       _selectedWeekday =
                              //           firstThreeLetter(value, null);
                              //       _monthAndDate =
                              //           getMonthAndDate(value, null);
                              //       _selectedDate = value;
                              //     });

                              //     //fetch shedule
                              //     provider.fetchShedule(
                              //         Provider.of<BookService>(context,
                              //                 listen: false)
                              //             .sellerId,
                              //         _selectedWeekday);
                              //   });
                              // }),

                              DatePicker(
                                DateTime.now(),
                                height: 100,
                                locale: rtlPorvider.langSlug,
                                initialSelectedDate: DateTime.now(),
                                daysCount: 30,
                                selectionColor: cc.primaryColor,
                                selectedTextColor: Colors.white,
                                onDateChange: (value) {
                                  // New date selected

                                  setState(() {
                                    _selectedWeekday =
                                        firstThreeLetter(value, null);
                                    _monthAndDate =
                                        getMonthAndDate(value, null);
                                    _selectedDate = value;
                                  });

                                  //fetch shedule
                                  provider.fetchShedule(
                                      Provider.of<BookService>(context,
                                              listen: false)
                                          .sellerId,
                                      _selectedWeekday);
                                },
                              ),

                              // Time =============================>
                              const SizedBox(
                                height: 30,
                              ),
                              CommonHelper().titleCommon(
                                  '${asProvider.getString('Available time')}:'),

                              const SizedBox(
                                height: 17,
                              ),
                              provider.isloading == false
                                  ? provider.schedules != 'nothing'
                                      ? GridView.builder(
                                          clipBehavior: Clip.none,
                                          gridDelegate:
                                              FlutterzillaFixedGridView(
                                                  crossAxisCount: 2,
                                                  mainAxisSpacing: 19,
                                                  crossAxisSpacing: 19,
                                                  height: screenWidth <
                                                          fourinchScreenWidth
                                                      ? 75
                                                      : 60),
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          itemCount: provider
                                              .schedules.schedules.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () {
                                                setState(() {
                                                  selectedShedule = index;
                                                  _selectedTime = provider
                                                      .schedules
                                                      .schedules[index]
                                                      .schedule;
                                                });
                                              },
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: selectedShedule ==
                                                                    index
                                                                ? cc
                                                                    .primaryColor
                                                                : cc
                                                                    .borderColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 13,
                                                        vertical: 15),
                                                    child: Text(
                                                      provider
                                                          .schedules
                                                          .schedules[index]
                                                          .schedule,
                                                      style: TextStyle(
                                                        color: cc.greyFour,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  selectedShedule == index
                                                      ? Positioned(
                                                          right: -7,
                                                          top: -7,
                                                          child: CommonHelper()
                                                              .checkCircle())
                                                      : Container()
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      : Text(
                                          asProvider.getString(
                                              'No shedule available on this date'),
                                          style:
                                              TextStyle(color: cc.primaryColor),
                                        )
                                  : OthersHelper().showLoading(cc.primaryColor),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          )),
                    ),
                  ),

                  //  bottom container
                  Container(
                    padding: EdgeInsets.only(
                        left: screenPadding, top: 20, right: screenPadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 8,
                          blurRadius: 17,
                          offset:
                              const Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // CommonHelper().titleCommon('Scheduling for:'),
                          // const SizedBox(
                          //   height: 15,
                          // ),
                          // BookingHelper().rowLeftRight(
                          //     'assets/svg/calendar.svg',
                          //     'Date',
                          //     'Friday, 18 March 2022'),
                          // const SizedBox(
                          //   height: 14,
                          // ),
                          // BookingHelper().rowLeftRight(
                          //     'assets/svg/clock.svg',
                          //     'Time',
                          //     '02:00 PM -03:00 PM'),
                          // const SizedBox(
                          //   height: 23,
                          // ),
                          Consumer<ProfileService>(
                              builder: (context, ps, child) {
                            return CommonHelper().buttonOrange(
                                ps.profileDetails == null ||
                                        ps.profileDetails is String
                                    ? "Sing In"
                                    : asProvider.getString('Next'), () {
                              if (ps.profileDetails == null ||
                                  ps.profileDetails is String) {
                                context.toPage(const LoginPage());

                                return;
                              }
                              if (_selectedTime != null &&
                                  _selectedWeekday != null) {
                                //increase page steps by one
                                BookStepsService().onNext(context);
                                //set selected shedule so that we can use it later
                                Provider.of<BookService>(context, listen: false)
                                    .setDateTime(_monthAndDate, _selectedTime,
                                        _selectedWeekday,
                                        date: _selectedDate);
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: const BookingLocationPage()));
                              }
                            });
                          }),
                          const SizedBox(
                            height: 30,
                          ),
                        ]),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
