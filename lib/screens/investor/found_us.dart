import 'package:acc/constants/font_family.dart';
import 'package:acc/models/authentication/signup_request_preferences.dart';
import 'package:acc/models/investor/hearaboutus.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/screens/investor/investment_limit.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/ui_widgets.dart';

class InvestorSearchInfo extends StatefulWidget {
  final HearAboutUs _hearAboutUs;

  const InvestorSearchInfo({Key key, HearAboutUs data})
      : _hearAboutUs = data,
        super(key: key);

  @override
  _InvestorSearchInfoState createState() => _InvestorSearchInfoState();
}

class _InvestorSearchInfoState extends State<InvestorSearchInfo> {
  bool _isNameVisible = false;
  bool _isNextVisible = false;
  List<String> infoItemList = [];
  List<Options> hearAboutUsList = [];
  List<TempFoundUsOptions> tempHearAboutUsList = [];
  String firstname = "";
  final firstNameController = TextEditingController();

  void showNameField() {
    setState(() {
      _isNameVisible = false;
      if (infoItemList.contains("Referral")) {
        _isNameVisible = true;
      }
    });
  }

  void showNextButton() {
    setState(() {
      _isNextVisible = true;
      if (infoItemList == null) {
        _isNextVisible = false;
      }
    });
  }

  @override
  void initState() {
    // tempHearAboutUsList = createFoundUsList();
    super.initState();
    hearAboutUsList.addAll(widget._hearAboutUs.data.options);
  }

  @override
  Widget build(BuildContext context) {
    tempHearAboutUsList = createFoundUsList();

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            elevation: 0.0,
            backgroundColor: Color(0xffffffff),
          ),
          bottomNavigationBar: BottomAppBar(),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          size: 30, color: backButtonColor),
                      onPressed: () => {Navigator.pop(context)},
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Where did you\nfind us".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: textBold26(headingBlack),
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height,
                      //color: Colors.amber,
                      child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.max,
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: MediaQuery.removePadding(
                                  removeBottom: true,
                                  context: context,
                                  child:
                                      // GridView.builder(
                                      //   shrinkWrap: true,
                                      //   gridDelegate:
                                      //       SliverGridDelegateWithFixedCrossAxisCount(
                                      //     crossAxisCount: 2,
                                      //     childAspectRatio:
                                      //         (cardWidth / cardHeight),
                                      //     // childAspectRatio: MediaQuery.of(context)
                                      //     //         .size
                                      //     //         .width /
                                      //     //     (MediaQuery.of(context).size.height /
                                      //     //         2),
                                      //     mainAxisSpacing: 0.0,
                                      //     crossAxisSpacing: 0.0,
                                      //   ),
                                      //   itemCount: hearAboutUsList.length,
                                      //   itemBuilder: (context, index) {
                                      //     return _createCell(index);
                                      //   },
                                      // ),
                                      GridView.count(
                                          //   padding: EdgeInsets.zero,
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 1.0,
                                          crossAxisSpacing: 1.0,
                                          // childAspectRatio:
                                          //     MediaQuery.of(context)
                                          //             .size
                                          //             .width /
                                          //         ((MediaQuery.of(context)
                                          //                     .size
                                          //                     .height -
                                          //                 36) /
                                          //             2.1),
                                          shrinkWrap: true,
                                          children: List.generate(
                                              hearAboutUsList.length, (index) {
                                            return _createCell(index);
                                          })),
                                )),
                            SizedBox(height: 25),
                            Visibility(
                              visible: _isNameVisible,
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 25.0, bottom: 5, right: 25.0),
                                    decoration: customDecoration(),
                                    child: TextField(
                                      style: textNormal18(Colors.black),
                                      controller: firstNameController,
                                      onChanged: (value) => {firstname = value},
                                      decoration: _setTextFieldDecoration(
                                          "Name of the person who referred you"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                                visible: _isNextVisible,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(
                                            top: 5.0,
                                            left: 25.0,
                                            bottom: 20,
                                            right: 25.0),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          onTap: () {
                                            // on click
                                            if (infoItemList
                                                    .contains("Referral") &&
                                                _isNameVisible == true) {
                                              if (firstNameController
                                                  .text.isEmpty) {
                                                showSnackBar(context,
                                                    "Please Enter Referral Name");
                                                return;
                                              }
                                            }

                                            final requestModelInstance =
                                                InvestorSignupPreferences
                                                    .instance;
                                            if (infoItemList.isNotEmpty) {
                                              requestModelInstance.hearAboutUs =
                                                  infoItemList.first;
                                            }
                                            if (firstNameController
                                                .text.isNotEmpty) {
                                              requestModelInstance
                                                      .referralName =
                                                  firstNameController.text
                                                      .trim();
                                            }
                                            openInvestmentLimit();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 40, right: 40),
                                            //width: MediaQuery.of(context).size.width,
                                            height: 60,
                                            decoration: appColorButton(context),
                                            child: Center(
                                                child: Text(
                                              "Next",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )),
                                          ),
                                        )),
                                  ],
                                ))
                          ])),
                ],
              ),
            ),
          ),
        ));
  }

  InputDecoration _setTextFieldDecoration(_text) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(10.0),
      labelText: _text,
      labelStyle: new TextStyle(color: Colors.grey[600]),
      border: InputBorder.none,
      focusedBorder: UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent, width: 2.0),
        borderRadius: BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
    );
  }

  InkWell _createCell(int _index) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        print(this.hearAboutUsList[_index].name);
        infoItemList = [];
        infoItemList.add(this.hearAboutUsList[_index].name);
        setState(() {
          showNameField();
          showNextButton();
        });
      },
      child: CachedNetworkImage(
        placeholder: (context, string) => SizedBox(
            height: 50,
            width: 50,
            child: Center(
              child: CircularProgressIndicator(),
            )),
        imageUrl: infoItemList.contains(this.hearAboutUsList[_index].name)
            ? this.hearAboutUsList[_index].imageUrlSelected
            : this.hearAboutUsList[_index].imageUrl,
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  TextStyle setTextStyle(colors) {
    return TextStyle(color: colors, fontSize: 14, fontWeight: FontWeight.w500);
  }

  BoxDecoration customDecoration() {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(const Radius.circular(10.0)),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 2),
          color: Colors.grey[200],
        )
      ],
    );
  }

  void openInvestmentLimit() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return InvestmentLimit();
        },
        transitionDuration: Duration(milliseconds: 2000),
        transitionsBuilder: (context, animation, anotherAnimation, child) {
          animation = CurvedAnimation(
              curve: Curves.fastLinearToSlowEaseIn, parent: animation);
          return SlideTransition(
            position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                .animate(animation),
            child: child,
          );
        }));
  }

  createFoundUsList() {
    List<TempFoundUsOptions> originalList = [
      TempFoundUsOptions(
          "Referral",
          "assets/images/investor/found_us/acc_referal.png",
          "assets/images/investor/found_us/acc_referal_selected.png"),
      TempFoundUsOptions(
          "Internet Browsing",
          "assets/images/investor/found_us/acc_inet_browsing.png",
          "assets/images/investor/found_us/acc_inet_browsing_selected.png"),
      TempFoundUsOptions(
          "Social Media",
          "assets/images/investor/found_us/acc_soc_media.png",
          "assets/images/investor/found_us/acc_soc_media_selected.png"),
      TempFoundUsOptions(
          "Direct Search",
          "assets/images/investor/found_us/acc_search.png",
          "assets/images/investor/found_us/acc_search_selected.png")
    ];

    return originalList;
  }
}
