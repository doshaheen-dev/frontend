import 'package:acc/constants/font_family.dart';
import 'package:acc/models/authentication/signup_request_preferences.dart';
import 'package:acc/models/investor/hearaboutus.dart';
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
  String firstname = "";
  final firstNameController = TextEditingController();
  Future _fundSlots;

  // Future<void> fetchFoundUs() async {
  //   final provider = Provider.of<HearAboutUsProvider>(context, listen: false);
  //   provider.fetchAppPlatforms();
  // }

  void showNameField() {
    setState(() {
      _isNameVisible = false;
      //print("infoItemList => $infoItemList");
      if (infoItemList.contains("Referral")) {
        _isNameVisible = true;
      }
    });
  }

  void showNextButton() {
    setState(() {
      _isNextVisible = true;
      // print("infoItemList => $infoItemList");
      if (infoItemList == null) {
        _isNextVisible = false;
      }
    });
  }

  // var _isInit = true;
  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {});
  //     _fundSlots = fetchFoundUs();
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    super.initState();
    hearAboutUsList.addAll(widget._hearAboutUs.data.options);
  }

  @override
  Widget build(BuildContext context) {
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
                      icon: Icon(Icons.arrow_back, size: 30),
                      onPressed: () => {Navigator.pop(context)},
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                            top: 10.0, left: 25.0, right: 25.0),
                        child: Text(
                          "How did you find us ?",
                          style: TextStyle(
                              color: headingBlack,
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0,
                              fontFamily: FontFamilyMontserrat.name),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: const EdgeInsets.only(
                              top: 30.0, left: 25.0, right: 25.0),
                          // child: FutureBuilder(
                          //     future: _fundSlots,
                          //     builder: (ctx, dataSnapshot) {
                          //       if (dataSnapshot.connectionState ==
                          //           ConnectionState.waiting) {
                          //         return Center(
                          //             child: CircularProgressIndicator(
                          //           color: Theme.of(context).primaryColor,
                          //         ));
                          //       } else {
                          //         if (dataSnapshot.error != null) {
                          //           return Center(
                          //               child: Text("An error occurred!"));
                          //         } else {
                          //           return Consumer<HearAboutUsProvider>(
                          //               builder: (ctx, slotData, child) =>
                          //                   GridView.count(
                          //                       crossAxisCount: 2,
                          //                       crossAxisSpacing: 10.0,
                          //                       mainAxisSpacing: 10.0,
                          //                       shrinkWrap: true,
                          //                       children: List.generate(
                          //                           slotData.data.length,
                          //                           (index) {
                          //                         return _createCell(
                          //                             slotData.data[index]);
                          //                       })));
                          //         }
                          //       }
                          //     })),
                          child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              shrinkWrap: true,
                              children: List.generate(hearAboutUsList.length,
                                  (index) {
                                return _createCell(index);
                              }))),
                      Visibility(
                        visible: _isNameVisible,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 5.0,
                                  left: 25.0,
                                  bottom: 20,
                                  right: 25.0),
                              decoration: customDecoration(),
                              child: TextField(
                                style: _setTextFieldStyle(),
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
                                    borderRadius: BorderRadius.circular(40),
                                    onTap: () {
                                      // on click
                                      final requestModelInstance =
                                          InvestorSignupPreferences.instance;
                                      if (infoItemList.isNotEmpty) {
                                        requestModelInstance.hearAboutUs =
                                            infoItemList.first;
                                      }
                                      if (firstNameController.text.isNotEmpty) {
                                        requestModelInstance.referralName =
                                            firstNameController.text.trim();
                                      }
                                      openInvestmentLimit();
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  TextStyle _setTextFieldStyle() {
    return TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: 18.0,
        fontFamily: FontFamilyMontserrat.name);
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

  // InkWell _createCell(Options citi) {
  //   return InkWell(
  //     highlightColor: Colors.transparent,
  //     borderRadius: BorderRadius.circular(40),
  //     onTap: () {
  //       print(citi.name);
  //       infoItemList = [];
  //       infoItemList.add(citi.name);
  //       setState(() {
  //         showNameField();
  //         showNextButton();
  //       });
  //     },
  //     child: Container(
  //       width: 200,
  //       height: 200,
  //       decoration: BoxDecoration(
  //         color: infoItemList.contains(citi.name)
  //             ? Theme.of(context).primaryColor
  //             : unselectedGray,
  //         borderRadius: BorderRadius.all(
  //           const Radius.circular(15.0),
  //         ),
  //       ),
  //       child: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             CachedNetworkImage(
  //               imageUrl: citi.imageUrl,
  //               progressIndicatorBuilder: (context, url, downloadProgress) =>
  //                   CircularProgressIndicator(value: downloadProgress.progress),
  //               errorWidget: (context, url, error) => Icon(Icons.error),
  //             ),
  //             SizedBox(
  //               height: 10.0,
  //             ),
  //             Text(citi.name,
  //                 style: TextStyle(
  //                     color: infoItemList.contains(citi.name)
  //                         ? Colors.white
  //                         : Colors.black,
  //                     fontWeight: FontWeight.normal,
  //                     fontSize: 16.0,
  //                     fontFamily: FontFamilyMontserrat.name))
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  InkWell _createCell(int _index) {
    return InkWell(
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(40),
      onTap: () {
        print(this.hearAboutUsList[_index].name);
        infoItemList = [];
        infoItemList.add(this.hearAboutUsList[_index].name);
        setState(() {
          showNameField();
          showNextButton();
        });
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: infoItemList.contains(this.hearAboutUsList[_index].name)
              ? Theme.of(context).primaryColor
              : unselectedGray,
          borderRadius: BorderRadius.all(
            const Radius.circular(15.0),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                height: 100.0,
                width: 100,
                placeholder: (context, string) => SizedBox(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    )),
                imageUrl: this.hearAboutUsList[_index].imageUrl,
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(this.hearAboutUsList[_index].name,
                  style: TextStyle(
                      color: infoItemList
                              .contains(this.hearAboutUsList[_index].name)
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                      fontFamily: FontFamilyMontserrat.name))
            ],
          ),
        ),
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
}
