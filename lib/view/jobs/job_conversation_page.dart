import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:qixer/service/jobs_service/job_conversation_service.dart';
import 'package:qixer/service/rtl_service.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/constant_styles.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

import '../utils/responsive.dart';

class JobConversationPage extends StatefulWidget {
  const JobConversationPage(
      {super.key,
      required this.title,
      required this.jobRequestId,
      required this.sellerId});

  final String title;

  final jobRequestId;
  final sellerId;

  @override
  State<JobConversationPage> createState() => _JobConversationPageState();
}

class _JobConversationPageState extends State<JobConversationPage> {
  bool firstTimeLoading = true;

  TextEditingController sendMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 10,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  FilePickerResult? pickedFile;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.height;
    ConstantColors cc = ConstantColors();

    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(right: 16, left: 8),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: cc.greyParagraph,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "${lnProvider.getString('Job Request ID')}: #${widget.jobRequestId}",
                          style:
                              TextStyle(color: cc.primaryColor, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  // Icon(
                  //   Icons.settings,
                  //   color: Colors.black54,
                  // ),
                ],
              ),
            ),
          ),
        ),
        body: Consumer<AppStringService>(
          builder: (context, ln, child) => Consumer<JobConversationService>(
              builder: (context, provider, child) {
            if (provider.messagesList.isNotEmpty &&
                provider.sendLoading == false) {
              Future.delayed(const Duration(milliseconds: 500), () {
                _scrollDown();
              });
            }
            return Stack(
              children: <Widget>[
                provider.isloading == false
                    ?
                    //chat messages
                    Container(
                        margin: const EdgeInsets.only(bottom: 60),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: provider.messagesList.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          physics: physicsCommon,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: provider.messagesList[index]
                                          ['type'] ==
                                      "seller"
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                //the message
                                Expanded(
                                  child: Consumer<RtlService>(
                                    builder: (context, rtlP, child) =>
                                        Container(
                                      padding: EdgeInsets.only(
                                          left: provider.messagesList[index]
                                                      ['type'] ==
                                                  "seller"
                                              ? rtlP.direction == 'ltr'
                                                  ? 10
                                                  : 90
                                              : rtlP.direction == 'ltr'
                                                  ? 90
                                                  : 10,
                                          right: provider.messagesList[index]
                                                      ['type'] ==
                                                  "seller"
                                              ? rtlP.direction == 'ltr'
                                                  ? 90
                                                  : 10
                                              : rtlP.direction == 'ltr'
                                                  ? 10
                                                  : 90,
                                          top: 10,
                                          bottom: 10),
                                      child: Align(
                                        alignment: (provider.messagesList[index]
                                                    ['type'] ==
                                                "seller"
                                            ? Alignment.topLeft
                                            : Alignment.topRight),
                                        child: Column(
                                          crossAxisAlignment:
                                              (provider.messagesList[index]
                                                          ['type'] ==
                                                      "seller"
                                                  ? CrossAxisAlignment.start
                                                  : CrossAxisAlignment.end),
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: (provider.messagesList[
                                                            index]['type'] ==
                                                        "seller"
                                                    ? Colors.grey.shade200
                                                    : cc.primaryColor),
                                              ),
                                              padding: const EdgeInsets.all(16),
                                              //message =====>
                                              child: Text(
                                                provider.messagesList[index]
                                                    ['message'],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color:
                                                        (provider.messagesList[
                                                                        index]
                                                                    ['type'] ==
                                                                "seller"
                                                            ? Colors.grey[800]
                                                            : Colors.white)),
                                              ),
                                            ),
                                            //Attachment =============>
                                            provider.messagesList[index]
                                                        ['attachment'] !=
                                                    null
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 11),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    height: 50,
                                                    width:
                                                        screenWidth / 3 - 130,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          (provider.messagesList[
                                                                          index]
                                                                      [
                                                                      'type'] ==
                                                                  "seller"
                                                              ? Colors
                                                                  .grey.shade200
                                                              : cc.primaryColor),
                                                    ),
                                                    child: provider.messagesList[
                                                                    index][
                                                                'filePicked'] ==
                                                            false
                                                        ?
                                                        //that means file is fetching from server
                                                        InkWell(
                                                            onTap: () async {
                                                              final url = provider
                                                                  .messagesList[
                                                                      index][
                                                                      'attachment']
                                                                  ?.toString()
                                                                  .replaceAll(
                                                                      "https://",
                                                                      "");

                                                              final Uri
                                                                  launchUri =
                                                                  Uri(
                                                                scheme: 'https',
                                                                path: url,
                                                              );
                                                              await urlLauncher
                                                                  .launchUrl(
                                                                      launchUri);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  ln.getString(
                                                                      'Attachment'),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: (provider.messagesList[index]['type'] ==
                                                                              "seller"
                                                                          ? Colors.grey[
                                                                              800]
                                                                          : Colors
                                                                              .white)),
                                                                ),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .download,
                                                                    size: 17,
                                                                    color: (provider.messagesList[index]['type'] ==
                                                                            "seller"
                                                                        ? Colors.grey[
                                                                            800]
                                                                        : Colors
                                                                            .white))
                                                              ],
                                                            ))

                                                        //local file====>
                                                        : InkWell(
                                                            onTap: () {},
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  ln.getString(
                                                                      'Attachment'),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: (provider.messagesList[index]['type'] ==
                                                                              "seller"
                                                                          ? Colors.grey[
                                                                              800]
                                                                          : Colors
                                                                              .white)),
                                                                ),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .check_box,
                                                                    size: 17,
                                                                    color: (provider.messagesList[index]['type'] ==
                                                                            "seller"
                                                                        ? Colors.grey[
                                                                            800]
                                                                        : Colors
                                                                            .white))
                                                              ],
                                                            )))
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    : OthersHelper().showLoading(cc.primaryColor),

                //write message section
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 20, bottom: 10, top: 10, right: 10),
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        pickedFile != null
                            ? Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: cc.primaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Icon(
                                  Icons.file_copy,
                                  color: Colors.white,
                                  size: 18,
                                ))
                            : Container(),
                        const SizedBox(
                          width: 13,
                        ),
                        Expanded(
                          child: TextField(
                            controller: sendMessageController,
                            decoration: InputDecoration(
                                hintText: ln.getString("Write message..."),
                                hintStyle:
                                    const TextStyle(color: Colors.black54),
                                border: InputBorder.none),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        //pick image =====>
                        IconButton(
                            onPressed: () async {
                              pickedFile = await provider.pickFile();
                              setState(() {});
                            },
                            icon: const Icon(Icons.attachment)),

                        //send message button
                        const SizedBox(
                          width: 13,
                        ),
                        FloatingActionButton(
                          onPressed: () async {
                            if (sendMessageController.text.isNotEmpty) {
                              //hide keyboard
                              FocusScope.of(context).unfocus();
                              //send message
                              provider.sendMessage(
                                  widget.jobRequestId,
                                  sendMessageController.text,
                                  pickedFile?.files.single.path,
                                  context,
                                  sellerId: widget.sellerId);

                              //clear input field
                              sendMessageController.clear();
                              //clear image
                              setState(() {
                                pickedFile = null;
                              });
                            } else {
                              OthersHelper().showToast(
                                  ln.getString('Please write a message first'),
                                  Colors.black);
                            }
                          },
                          backgroundColor: cc.primaryColor,
                          elevation: 0,
                          child: provider.sendLoading == false
                              ? const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : const SizedBox(
                                  height: 14,
                                  width: 14,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1.5,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
