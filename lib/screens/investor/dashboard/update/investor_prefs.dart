import 'dart:convert';

import 'package:acc/models/authentication/signup_request_preferences.dart';
import 'package:acc/models/authentication/signup_response.dart';
import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/models/fundslot/fundslot.dart';
import 'package:acc/screens/common/profile_picture.dart';
import 'package:acc/services/fund_slot_service.dart';
import 'package:acc/services/product_type_service.dart';
import 'package:acc/services/signup_service.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:acc/utils/class_navigation.dart';
import 'package:acc/widgets/app_progressbar.dart';
import 'package:acc/widgets/image_circle.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:acc/providers/fund_slot_provider.dart' as slotProvider;
import 'package:acc/providers/product_type_provider.dart' as productProvider;
import 'package:shared_preferences/shared_preferences.dart';

class InvestorPreferences extends StatefulWidget {
  InvestorPreferences({Key key}) : super(key: key);

  @override
  _InvestorPreferencesState createState() => _InvestorPreferencesState();
}

class _InvestorPreferencesState extends State<InvestorPreferences> {
  final double bRadius = 60;
  final double iHeight = 65;
  var _isInit = true;
  Future _investmentRange;
  Future _productTypes;
  var selectedInvestmentLimit;
  var selectedProductType;
  List<String> infoItemList = [];
  bool isUpdateActivated = false;
  Map<String, dynamic> selectedItem;

  String slotId = UserData.instance.userInfo.slotId.toString();
  String productId = UserData.instance.userInfo.productIds;
  List<productProvider.InvestmentLimitItem> localItemList = [];
  List<OptionsData> localInvestmentRange = [];
  List<String> productsList = [];

  Future<void> _fetchFundSlots(BuildContext context) async {
    await Provider.of<slotProvider.FundSlots>(context, listen: false)
        .fetchAndSetSlots();
  }

  Future<void> _fetchProductTypes(BuildContext context) async {
    await Provider.of<productProvider.ProductTypes>(context, listen: false)
        .fetchAndSetProductTypes();
    Provider.of<productProvider.ProductTypes>(context, listen: false).clear();
  }

  void _checkOption(productProvider.InvestmentLimitItem option) {
    Provider.of<productProvider.ProductTypes>(context, listen: false)
        .checkOption(option);
  }

  void _uncheckOption(productProvider.InvestmentLimitItem option) {
    Provider.of<productProvider.ProductTypes>(context, listen: false)
        .uncheckOption(option);
  }

  void activateUpdate(bool isActivated) {
    setState(() {
      isUpdateActivated = isActivated;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _investmentRange = _fetchFundSlots(context);
      _productTypes = _fetchProductTypes(context);
      getSelectedRange(slotId, productId);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void getSelectedRange(String _selectedRange, String _productId) {
    var range = FundSlotService.fetchFundSlots();
    range.then((result) {
      setState(() {
        final requestModel = InvestorSignupPreferences.instance;
        requestModel.slotId = '$_selectedRange';
        localInvestmentRange = result.data.options;
        for (var i = 0; i < result.data.options.length; i++) {
          if (result.data.options[i].id.toString() == _selectedRange) {
            selectedItem = {
              'text': result.data.options[i].range,
              'value': result.data.options[i].range
            };
            break;
          }
        }
      });
    });

    if (_productId != null) {
      productsList = _productId.split(',');
      infoItemList.clear();
      var choice = ProductTypeService.fetchProductTypes();
      choice.then((result) {
        setState(() {
          for (var i = 0; i < result.data.options.length; i++) {
            for (var j = 0; j < productsList.length; j++) {
              if (result.data.options[i].id.toString() == productsList[j]) {
                infoItemList.add(result.data.options[i].name);
                var limit = result.data.options[i];
                localItemList.add(productProvider.InvestmentLimitItem(limit.id,
                    limit.name, limit.desc, limit.placementFee, false, false));

                break;
              }
            }
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: AppProgressBar(
                child: Builder(
              builder: (context) => SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: setUserProfileView(context),
                      margin: EdgeInsets.only(top: 10, bottom: 10.0)),
                ],
              )),
            ))));
  }

  Widget setUserProfileView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(top: 40.0, left: 10.0),
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Icon(Icons.arrow_back_ios,
                    size: 30, color: backButtonColor),
                onPressed: () => {Navigator.pop(context)},
              ),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(top: 40.0),
              child: (UserData.instance.userInfo.firstName == null ||
                      UserData.instance.userInfo.firstName == '')
                  ? Text('Hello Investor',
                      style: textBold26(Theme.of(context).accentColor))
                  : Text(
                      'Hello ${UserData.instance.userInfo.firstName}',
                      style: textBold26(Theme.of(context).accentColor),
                    ),
            ),
            SizedBox(width: 10),
            Container(
              margin: EdgeInsets.only(top: 40.0, right: 20),
              child: openProfilePicture(context),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(
            top: 30.0,
            right: 25.0,
            left: 25.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You can edit your preferences here",
                style: textNormal18(headingBlack),
              ),

              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 10),
                width: MediaQuery.of(context).size.width,
                height: 80,
                decoration: customDecoration(),
                child: setInvestmentLimit(context),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: customDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                        visible: infoItemList.isEmpty ? false : true,
                        child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Investment Choices",
                              style: textNormal12(Colors.grey),
                            ))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                            visible: infoItemList.isEmpty ? true : false,
                            child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text("Investment Choices",
                                    style: textNormal18(Colors.grey[600])))),
                        Visibility(
                            visible: infoItemList.isEmpty ? false : true,
                            child: Container(
                              width: 260,
                              child: newSetChipList(),
                            )),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              openInvestmentList();
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: Icon(Icons.arrow_drop_down))
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),

              //NEXT BUTTON
              Container(
                  margin: EdgeInsets.only(top: 10.0, left: 40.0, right: 40.0),
                  child: ElevatedButton(
                    onPressed: !isUpdateActivated
                        ? null
                        : () async {
                            // on click
                            var listIds = [];
                            if (localItemList.isEmpty &&
                                productsList.isNotEmpty) {
                              for (int i = 0; i < productsList.length; i++) {
                                listIds.add(productsList[i]);
                              }
                            } else {
                              for (int i = 0; i < localItemList.length; i++) {
                                for (int j = 0; j < infoItemList.length; j++) {
                                  if (localItemList[i].name ==
                                      infoItemList[j]) {
                                    listIds.add(localItemList[i].id);
                                    break;
                                  }
                                }
                              }
                            }
                            if (listIds.isNotEmpty) {
                              final requestModel =
                                  InvestorSignupPreferences.instance;
                              requestModel.productIds = listIds.join(',');
                            }

                            var progress = AppProgressBar.of(context);
                            progress?.showWithText('Updating Preferences...');
                            await submitPreference(progress, context);
                            return;
                          },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14))),
                    child: Ink(
                      decoration: isUpdateActivated
                          ? BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10))
                          : BoxDecoration(
                              color: kwhiteGrey,
                              borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text("Update", style: textWhiteBold16()),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  GestureDetector openProfilePicture(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(
              PageRouteBuilder(
                  pageBuilder: (context, animation, anotherAnimation) {
                    return ProfilePicScreen(
                        UserData.instance.userInfo.profileImage);
                  },
                  transitionDuration: Duration(milliseconds: 2000),
                  transitionsBuilder:
                      (context, animation, anotherAnimation, child) {
                    animation = CurvedAnimation(
                        curve: Curves.fastLinearToSlowEaseIn,
                        parent: animation);
                    return SlideTransition(
                      position:
                          Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                              .animate(animation),
                      child: child,
                    );
                  }),
            )
            .then((_) => setState(() {}));
      },
      child: Container(
        height: 70,
        width: 70,
        child: CircleAvatar(
          radius: bRadius,
          backgroundColor: Theme.of(context).accentColor,
          child: (UserData.instance.userInfo.profileImage == null ||
                  UserData.instance.userInfo.profileImage == '')
              ? Image.asset(
                  'assets/images/UserProfile.png',
                  height: 70,
                  width: 70,
                  fit: BoxFit.fitHeight,
                )
              : ImageCircle(
                  borderRadius: bRadius,
                  image: Image.network(
                    UserData.instance.userInfo.profileImage,
                    width: iHeight,
                    height: iHeight,
                    fit: BoxFit.fill,
                  )),
        ),
      ),
    );
  }

  FutureBuilder<dynamic> setInvestmentLimit(BuildContext context) {
    return FutureBuilder(
        future: _investmentRange,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ));
          } else {
            if (dataSnapshot.error != null) {
              return Center(child: Text("An error occurred!"));
            } else {
              return Consumer<slotProvider.FundSlots>(
                builder: (ctx, data, child) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: getDropDownSearch(data.slotLineItems
                      .map((info) => {
                            'text': info.header,
                            'value': info.header,
                          })
                      .toList()),
                ),
              );
            }
          }
        });
  }

  Widget getDropDownSearch(List<Map<String, dynamic>> items) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: DropdownSearch<Map<String, dynamic>>(
        mode: Mode.BOTTOM_SHEET,
        showSearchBox: false,
        showSelectedItem: false,
        showClearButton: false,
        items: items,
        itemAsString: (Map<String, dynamic> i) => i['text'],
        hint: "",
        onChanged: (map) {
          setState(() {
            selectedItem = map;
            selectedInvestmentLimit = map['value'];

            for (var i = 0; i < localInvestmentRange.length; i++) {
              if (localInvestmentRange[i].range == selectedInvestmentLimit) {
                slotId = localInvestmentRange[i].id.toString();
              }
            }
            if (selectedItem.isNotEmpty) {
              activateUpdate(true);
            } else {
              activateUpdate(false);
            }
            final requestModel = InvestorSignupPreferences.instance;
            requestModel.slotId = '$slotId';
          });
        },
        dropdownSearchDecoration: InputDecoration(
          labelText: 'Investment Range',
          labelStyle: textNormal18(Colors.grey[600]),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.all(const Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
        selectedItem: selectedItem,
        maxHeight: 700,
      ),
    );
  }

  // ------------------------------------------------------------------//
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

  void openInvestmentList() {
    showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Scaffold(
                    body: SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Row(children: [
                                      Text(
                                        "Choose your invesment choices",
                                        textAlign: TextAlign.start,
                                        style: textBold16(headingBlack),
                                      ),
                                      Spacer(),
                                      InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Done",
                                            style: textNormal16(headingBlack),
                                          ))
                                    ])),
                                FutureBuilder(
                                    future: _productTypes,
                                    builder: (ctx, dataSnapshot) {
                                      if (dataSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator(
                                          color: Theme.of(context).primaryColor,
                                        ));
                                      } else {
                                        if (dataSnapshot.error != null) {
                                          return Center(
                                              child:
                                                  Text("An error occurred!"));
                                        } else {
                                          return Consumer<
                                              productProvider.ProductTypes>(
                                            builder: (ctx, data, child) =>
                                                ListView.builder(
                                              itemBuilder: (ctx, index) {
                                                checkData(data, index);
                                                return Container(
                                                    child: _createItemCell(
                                                        data.types[index]));
                                              },
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: data.types.length,
                                              shrinkWrap: true,
                                            ),
                                          );
                                        }
                                      }
                                    })
                              ],
                            )))));
          });
        });
  }

  void checkData(productProvider.ProductTypes data, int index) {
    if (data.types != null) {
      localItemList.clear();
      localItemList = (data.types);
    }
  }

  _createItemCell(productProvider.InvestmentLimitItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {
              itemSelection(infoItemList, item);
            });
          },
          child: Container(
              height: 50.0,
              color: infoItemList.contains(item.name)
                  ? Theme.of(context).selectedRowColor
                  : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Text(item.name,
                      textAlign: TextAlign.center,
                      style: textNormal18(infoItemList.contains(item.name)
                          ? Colors.white
                          : Theme.of(context).selectedRowColor)),
                  Spacer(),
                  Visibility(
                      visible: infoItemList.contains(item.name) ? true : false,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              itemSelection(infoItemList, item);
                            });
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ))
                ]),
              )),
        )
      ],
    );
  }

  int tag = -1;
  Widget newSetChipList() {
    return ChipsChoice<int>.single(
      value: tag,
      onChanged: (val) => setState(() => {
            for (var i = 0; i < localItemList.length; i++)
              {
                if (localItemList[i].name == infoItemList[val])
                  {
                    _uncheckOption(localItemList[i]),
                  }
              },
            infoItemList.remove(infoItemList[val]),
            if (infoItemList.isNotEmpty)
              {
                activateUpdate(true),
              }
            else
              {activateUpdate(false)},
          }),
      choiceItems: C2Choice.listFrom<int, String>(
        source: infoItemList,
        value: (i, v) => i,
        label: (i, v) => v,
      ),
      choiceStyle: const C2ChoiceStyle(
        color: const Color(0XFF179FA1),
        brightness: Brightness.dark,
        showCheckmark: false,
      ),
      choiceAvatarBuilder: (data) {
        return Icon(Icons.close, color: Colors.white);
      },
      wrapped: true,
    );
  }

  Future<void> submitPreference(progress, BuildContext context) async {
    Future.delayed(Duration(seconds: 2), () async {
      final requestModel = InvestorSignupPreferences.instance;
      requestModel.hearAboutUs = UserData.instance.userInfo.hearAboutUs;
      requestModel.referralName = UserData.instance.userInfo.referralName;
      User signedUpUser =
          await SignUpService.updateUserPreferences(requestModel);
      progress.dismiss();
      activateUpdate(false);

      if (signedUpUser.type == 'success') {
        requestModel.clear();
        UserData userData = UserData(
          UserData.instance.userInfo.token,
          signedUpUser.data.firstName,
          "",
          signedUpUser.data.lastName,
          signedUpUser.data.mobileNo,
          signedUpUser.data.emailId,
          signedUpUser.data.userType,
          "",
          "",
          "",
          signedUpUser.data.address,
          signedUpUser.data.countryCode,
          signedUpUser.data.hearAboutUs,
          signedUpUser.data.referralName,
          signedUpUser.data.slotId,
          signedUpUser.data.productIds,
          signedUpUser.data.emailVerified,
        );
        final prefs = await SharedPreferences.getInstance();
        final userJson = jsonEncode(userData);
        prefs.setString('UserInfo', userJson);
        UserData.instance.userInfo = userData;

        getSelectedRange(
            signedUpUser.data.slotId.toString(), signedUpUser.data.productIds);
      } else if (signedUpUser.status == 400 &&
          signedUpUser.message.contains("expired")) {
        _openDialog(context, signedUpUser.message);
      }
      showSnackBar(context, signedUpUser.message);
    });
  }

  _openDialog(BuildContext context, String message) {
    // set up the buttons
    Widget positiveButton = TextButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('UserInfo', '');
          Navigation.openOnBoarding(context);
        },
        child: Text(
          "Login",
          textScaleFactor: 1.0,
          style: textNormal16(Color(0xff00A699)),
        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(message, textScaleFactor: 1.0),
      actions: [
        positiveButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void itemSelection(
      List<String> infoItemList, productProvider.InvestmentLimitItem item) {
    if (infoItemList.contains(item.name)) {
      infoItemList.remove(item.name);
      _uncheckOption(item);
    } else {
      infoItemList.add(item.name);
      _checkOption(item);
    }
    if (infoItemList.isNotEmpty) {
      activateUpdate(true);
    } else {
      activateUpdate(false);
    }
  }
}
