import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/providers/fund_slot_provider.dart';
import 'package:acc/screens/common/profile_picture.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/widgets/image_circle.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:acc/providers/fund_slot_provider.dart' as slotProvider;
import 'package:acc/providers/product_type_provider.dart' as productProvider;

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

  bool isDataChanged = false;
  var selectedInvestmentLimit;
  var selectedProductType;

  final _multiSelectKey = GlobalKey<FormFieldState>();
  List<InvestmentLimitItem> _selectedAnimals3 = [];

  Future<void> _fetchFundSlots(BuildContext context) async {
    await Provider.of<slotProvider.FundSlots>(context, listen: false)
        .fetchAndSetSlots();
  }

  Future<void> _fetchProductTypes(BuildContext context) async {
    await Provider.of<productProvider.ProductTypes>(context, listen: false)
        .fetchAndSetProductTypes();
    Provider.of<productProvider.ProductTypes>(context, listen: false).clear();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _investmentRange = _fetchFundSlots(context);
      _productTypes = _fetchProductTypes(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return Scaffold(
        backgroundColor: Colors.white,
        body: ProgressHUD(
            child: Builder(
          builder: (context) => SingleChildScrollView(
              child: Column(
            children: [
              Container(
                  child: setUserProfileView(context),
                  margin: EdgeInsets.only(
                      top: 50, right: 25.0, left: 25.0, bottom: 10.0)),
            ],
          )),
        )));
  }

  void setUserInformation() {}

  Widget setUserProfileView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(Icons.arrow_back),
            onPressed: () => {Navigator.pop(context)},
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: (UserData.instance.userInfo.firstName == null ||
                          UserData.instance.userInfo.firstName == '')
                      ? Text(
                          'Hello Investor',
                          style: textBold26(headingBlack),
                        )
                      : Text(
                          'Hello ${UserData.instance.userInfo.firstName}',
                          style: textBold26(headingBlack),
                        ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(
                          PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, anotherAnimation) {
                                return ProfilePicScreen(
                                    UserData.instance.userInfo.profileImage);
                              },
                              transitionDuration: Duration(milliseconds: 2000),
                              transitionsBuilder: (context, animation,
                                  anotherAnimation, child) {
                                animation = CurvedAnimation(
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    parent: animation);
                                return SlideTransition(
                                  position: Tween(
                                          begin: Offset(1.0, 0.0),
                                          end: Offset(0.0, 0.0))
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
                      backgroundColor: Theme.of(context).primaryColor,
                      child: (UserData.instance.userInfo.profileImage == null ||
                              UserData.instance.userInfo.profileImage == '')
                          ? ImageCircle(
                              borderRadius: bRadius,
                              image: Image.asset(
                                'assets/images/UserProfile.png',
                                width: iHeight,
                                height: iHeight,
                                fit: BoxFit.fill,
                              ),
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
                ),
              ],
            )),
        SizedBox(
          height: 40,
        ),
        Text(
          "You can edit your preferences here",
          style: textNormal18(headingBlack),
        ),

        Container(
          margin: const EdgeInsets.only(top: 10.0, bottom: 10),
          width: MediaQuery.of(context).size.width,
          height: 80,
          decoration: customDecoration(),
          child: FutureBuilder(
              future: _investmentRange,
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber),
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
              }),
        ),
        SizedBox(
          height: 10,
        ),

        Container(
          margin: const EdgeInsets.only(top: 10.0, bottom: 10),
          width: MediaQuery.of(context).size.width,
          height: 80,
          decoration: customDecoration(),
          child: FutureBuilder(
              future: _productTypes,
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber),
                  ));
                } else {
                  if (dataSnapshot.error != null) {
                    return Center(child: Text("An error occurred!"));
                  } else {
                    return Consumer<productProvider.ProductTypes>(
                      builder: (ctx, data, child) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        // ignore: deprecated_member_use
                        child:
                            //createDropdown(data),

                            investmentChoicesDropDown(data.types
                                .map((info) => {
                                      'text': info.name,
                                      'value': info.name,
                                    })
                                .toList()),
                      ),
                    );
                  }
                }
              }),
        ),
        SizedBox(
          height: 10,
        ),

        //NEXT BUTTON
        Container(
            child: ElevatedButton(
          onPressed: !isDataChanged
              ? null
              : () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  // on click

                  return;
                }
          // showSnackBar(
          //     context, "Please enter any new data for updation.");
          ,
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14))),
          child: Ink(
            decoration: isDataChanged
                ? BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor
                    ]),
                    borderRadius: BorderRadius.circular(10))
                : BoxDecoration(
                    gradient: LinearGradient(colors: [kwhiteGrey, kwhiteGrey]),
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
    );
  }

  // MultiSelectBottomSheetField<InvestmentLimitItem> createDropdown(
  //     productProvider.ProductTypes data) {
  //   var items = data.types
  //       .map((animal) =>
  //           MultiSelectItem<InvestmentLimitItem>(animal, animal.name))
  //       .toList();
  //   return MultiSelectBottomSheetField<InvestmentLimitItem>(
  //     key: _multiSelectKey,
  //     initialChildSize: 0.7,
  //     maxChildSize: 0.95,
  //     title: Text("MultiSelectBottomSheetField"),
  //     buttonText: Text("Favorite Animals"),
  //     items: items,
  //     searchable: false,
  //     validator: (values) {
  //       if (values == null || values.isEmpty) {
  //         return "Required";
  //       }
  //       List<String> names = values.map((e) => e.header).toList();
  //       // if (names.contains("Frog")) {
  //       //   return "Frogs are weird!";
  //       // }
  //       return null;
  //     },
  //     onConfirm: (values) {
  //       setState(() {
  //         _selectedAnimals3 = values;
  //       });
  //       _multiSelectKey.currentState.validate();
  //     },
  //     chipDisplay: MultiSelectChipDisplay(
  //       onTap: (item) {
  //         setState(() {
  //           _selectedAnimals3.remove(item);
  //         });
  //         _multiSelectKey.currentState.validate();
  //       },
  //     ),
  //   );
  // }

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

  // ------------------------------------------------------------------//
  Future<void> submitDetails(BuildContext context) async {}

  Widget getDropDownSearch(List<Map<String, dynamic>> items) {
    return DropdownSearch<Map<String, dynamic>>(
      mode: Mode.MENU,
      showSearchBox: false,
      showSelectedItem: false,
      showClearButton: true,
      items: items,
      itemAsString: (Map<String, dynamic> i) => i['text'],
      hint: "",
      onChanged: (map) {
        setState(() {
          selectedInvestmentLimit = map['value'];
          print(selectedInvestmentLimit);
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
      selectedItem: null,
      maxHeight: 700,
    );
  }

  Widget investmentChoicesDropDown(List<Map<String, dynamic>> items) {
    return DropdownSearch<Map<String, dynamic>>(
      mode: Mode.MENU,
      showSearchBox: false,
      showSelectedItem: false,
      showClearButton: true,
      items: items,
      itemAsString: (Map<String, dynamic> i) => i['text'],
      hint: "",
      onChanged: (map) {
        setState(() {
          selectedProductType = map['value'];
          print(selectedProductType);
        });
      },
      dropdownSearchDecoration: InputDecoration(
        labelText: 'Investment Choices',
        labelStyle: textNormal18(Colors.grey[600]),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(const Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
      selectedItem: null,
      maxHeight: 700,
    );
  }
}
