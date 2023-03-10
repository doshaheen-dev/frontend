import 'package:acc/models/authentication/signup_request_preferences.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/screens/investor/general_terms_privacy.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:provider/provider.dart';

import '../../providers/product_type_provider.dart' as productProvider;

class InvestmentChoices extends StatefulWidget {
  @override
  _InvestmentChoicesState createState() => _InvestmentChoicesState();
}

class _InvestmentChoicesState extends State<InvestmentChoices> {
  bool _isButtonVisible = false;
  bool _isVisible = false;
  var isSelected = false;
  var mycolor = Colors.white;
  var _isInit = true;
  Future _productTypes;
  List<String> infoItemList = [];

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

  void showToast() {
    setState(() {
      _isButtonVisible = true;
      if (infoItemList.isEmpty) {
        _isButtonVisible = false;
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {});
      _productTypes = _fetchProductTypes(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text("Please click on your Investment Choice(s)",
                            style: textBold26(Colors.black)),
                      ),
                      SizedBox(
                        height: 10,
                      ),

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
                              return Center(child: Text("An error occurred!"));
                            } else {
                              return Consumer<productProvider.ProductTypes>(
                                builder: (ctx, prodTypeData, child) =>
                                    ListView.builder(
                                  itemBuilder: (ctx, index) {
                                    return _buildChoicesList(
                                        prodTypeData.types[index]);
                                  },
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: prodTypeData.types.length,
                                  shrinkWrap: true,
                                ),
                              );
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //NEXT BUTTON
                      Visibility(
                          visible: _isButtonVisible,
                          child: Container(
                              margin: const EdgeInsets.only(
                                  top: 5.0,
                                  left: 25.0,
                                  bottom: 20,
                                  right: 25.0),
                              child: InkWell(
                                  borderRadius: BorderRadius.circular(40),
                                  onTap: () {
                                    // on click
                                    var types = Provider.of<
                                                productProvider.ProductTypes>(
                                            context,
                                            listen: false)
                                        .selectedTypes;
                                    var listIds = [];
                                    types.forEach((item) {
                                      listIds.add(item.id);
                                    });
                                    print(listIds);
                                    if (listIds.isNotEmpty) {
                                      final requestModelInstance =
                                          InvestorSignupPreferences.instance;
                                      requestModelInstance.productIds =
                                          listIds.join(',');
                                    }
                                    openGeneralTermsPrivacy();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 50.0, right: 50.0),
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
                                  ))))
                    ],
                  )
                ])))));
  }

  void toggleSelection() {
    setState(() {
      if (isSelected) {
        mycolor = Theme.of(context).primaryColor;
        isSelected = false;
      } else {
        mycolor = unselectedGray;
        isSelected = true;
      }
    });
  }

  Widget _buildChoicesList(productProvider.InvestmentLimitItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          margin:
              EdgeInsets.only(right: 25.0, top: 10.0, bottom: 10.0, left: 25.0),
          color: infoItemList.contains(item.name)
              ? Theme.of(context).selectedRowColor
              : unselectedGray,
          child: Container(
            child: ExpansionTile(
              iconColor: infoItemList.contains(item.name)
                  ? Colors.black
                  : Colors.white,
              title: Container(
                child: Row(
                  children: [
                    Checkbox(
                        checkColor: Theme.of(context)
                            .selectedRowColor, // color of tick Mark
                        activeColor: Colors.white,
                        value: item.isCheck,
                        onChanged: (bool value) {
                          setState(() {
                            item.isCheck = value;

                            if (!item.isCheck) {
                              infoItemList.remove(item.name);
                              _uncheckOption(item);
                            } else {
                              infoItemList.add(item.name);
                              _checkOption(item);
                            }
                            setState(() {
                              showToast();
                            });
                          });
                        }),
                    Expanded(
                        child: Container(
                      alignment: Alignment.center,
                      child: Center(
                          child: Text(item.name,
                              textAlign: TextAlign.center,
                              style: textNormal18(
                                  infoItemList.contains(item.name)
                                      ? Colors.white
                                      : Theme.of(context).selectedRowColor))),
                    )),
                  ],
                ),
              ),
              children: <Widget>[
                ListTile(
                  onLongPress: toggleSelection,
                  title: Text(item.description,
                      style: textNormal16(infoItemList.contains(item.name)
                          ? Colors.white
                          : Theme.of(context).selectedRowColor)),
                )
              ],
            ),
          ),
        ),
        Visibility(
            visible: _isVisible,
            child: Card(
              color: unselectedGray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              margin: EdgeInsets.only(
                  right: 25.0, top: 5.0, bottom: 10.0, left: 25.0),
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(item.description,
                                textAlign: TextAlign.center,
                                style: textNormal16(Colors.black)))),
                  ],
                ),
              ),
            ))
      ],
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

  void openGeneralTermsPrivacy() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return GeneralTermsPrivacy();
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
