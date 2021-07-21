import 'package:acc/constants/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/screens/investor/general_terms_privacy.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:provider/provider.dart';

import '../../providers/product_type_provider.dart' as productProvider;
import 'package:acc/models/authentication/signup_request.dart';

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

    return Scaffold(
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
                      "Please click on your Investment Choice(s)",
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

                  FutureBuilder(
                    future: _productTypes,
                    builder: (ctx, dataSnapshot) {
                      if (dataSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        if (dataSnapshot.error != null) {
                          return Center(child: Text("An error occurred!"));
                        } else {
                          return Consumer<productProvider.ProductTypes>(
                            builder: (ctx, prodTypeData, child) =>
                                ListView.builder(
                              itemBuilder: (ctx, index) {
                                return _buildPlayerModelList(
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
                            top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(40),
                          onTap: () {
                            // on click
                            var types =
                                Provider.of<productProvider.ProductTypes>(
                                        context,
                                        listen: false)
                                    .selectedTypes;
                            var listIds = [];
                            types.forEach((item) {
                              listIds.add(item.id);
                            });
                            // print('Checked Count: ${types.length}');
                            print(listIds);
                            if (listIds.isNotEmpty) {
                              final requestModelInstance =
                                  InvestorSignupRequestModel.instance;
                              requestModelInstance.productIds =
                                  listIds.join(',');
                            }
                            openGeneralTermsPrivacy();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: appColorButton(),
                            child: Center(
                                child: Text(
                              "Next",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                          ),
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> infoItemList = [];
  // List<InvestmentLimitItem> infoItem = [
  //   InvestmentLimitItem(
  //       'Angel Funds',
  //       'Angel funds invest in very early-stage businesses providing capital for start up or expansion.',
  //       false,
  //       false),
  //   InvestmentLimitItem(
  //       'Venture Capital',
  //       'Angel funds invest in very early-stage businesses providing capital for start up or expansion.',
  //       false,
  //       false),
  //   InvestmentLimitItem(
  //       'Listed Equities',
  //       'Angel funds invest in very early-stage businesses providing capital for start up or expansion.',
  //       false,
  //       false),
  //   InvestmentLimitItem(
  //       'Fixed Income',
  //       'Angel funds invest in very early-stage businesses providing capital for start up or expansion.',
  //       false,
  //       false),
  //   InvestmentLimitItem(
  //       'Structured Products',
  //       'Angel funds invest in very early-stage businesses providing capital for start up or expansion.',
  //       false,
  //       false),
  //   InvestmentLimitItem(
  //       'CryptoCurrencies',
  //       'Angel funds invest in very early-stage businesses providing capital for start up or expansion.',
  //       false,
  //       false),
  // ];

  // Widget _createExpanded(BuildContext context, int _index) {
  //   return Card(
  //       shape:
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  //       margin:
  //           EdgeInsets.only(right: 25.0, top: 10.0, bottom: 10.0, left: 25.0),
  //       child: Padding(
  //           padding: EdgeInsets.all(20.0),
  //           child: ExpansionPanelList(
  //               expansionCallback: (int index, bool isExpanded) {
  //                 setState(() {
  //                   infoItem[index].isExpanded = !infoItem[index].isExpanded;
  //                 });
  //               },
  //               children: infoItem.map((InvestmentLimitItem order) {
  //                 return ExpansionPanel(
  //                   headerBuilder: (context, isExpanded) {
  //                     return InkWell(
  //                       onTap: () {
  //                         //on click
  //                         infoItemList = [];
  //                         infoItemList.add(infoItem[_index].header);
  //                         setState(() {});
  //                         print(infoItem[_index].header);
  //                       },
  //                       child: Center(
  //                         child: Text(
  //                           order.header,
  //                           style: TextStyle(
  //                               color: Colors.black,
  //                               fontSize: 18,
  //                               fontWeight: FontWeight.bold),
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                   isExpanded: order.isExpanded,
  //                   body: Container(
  //                     padding: EdgeInsets.symmetric(horizontal: 15),
  //                     width: MediaQuery.of(context).size.width,
  //                     height: 100,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                     ),
  //                     child: Text(
  //                       order.description,
  //                       style: TextStyle(
  //                         fontFamily: 'Poppins',
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               }).toList())));
  // }

  // Widget _createCell(BuildContext context, int _index) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Card(
  //           color: infoItemList.contains(infoItem[_index].header)
  //               ? selectedOrange
  //               : unselectedGray,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10.0)),
  //           margin: EdgeInsets.only(
  //               right: 25.0, top: 10.0, bottom: 10.0, left: 25.0),
  //           child: InkWell(
  //             highlightColor: Colors.transparent,
  //             borderRadius: BorderRadius.circular(40),
  //             onTap: () {
  //               print(infoItem[_index].header);
  //               infoItemList = [];
  //               infoItemList.add(infoItem[_index].header);
  //               setState(() {
  //                 showToast();
  //               });
  //             },
  //             child: Container(
  //               height: 50,
  //               child: Row(
  //                 children: [
  //                   Spacer(flex: 3),
  //                   Center(
  //                       child: Text(infoItem[_index].header,
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               color: infoItemList
  //                                       .contains(infoItem[_index].header)
  //                                   ? Colors.white
  //                                   : Colors.black,
  //                               fontWeight: FontWeight.normal,
  //                               fontSize: 18.0,
  //                               fontFamily: FontFamilyMontserrat.name))),
  //                   new Spacer(
  //                     flex: 3,
  //                   ), // I just added one line
  //                   InkWell(
  //                       onTap: () {
  //                         print(infoItem[_index].header);
  //                         new Tooltip(
  //                             message: "Hello World", child: new Text("foo"));
  //                       },
  //                       child: Padding(
  //                         padding: EdgeInsets.only(right: 10.0),
  //                         child: Icon(
  //                           Icons.navigate_next,
  //                           color:
  //                               infoItemList.contains(infoItem[_index].header)
  //                                   ? Colors.white
  //                                   : Colors.black,
  //                         ),
  //                       )),
  //                 ],
  //               ),
  //             ),
  //           )),
  //       Visibility(
  //           visible: _isVisible,
  //           child: Card(
  //             color: unselectedGray,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10.0)),
  //             margin: EdgeInsets.only(
  //                 right: 25.0, top: 5.0, bottom: 10.0, left: 25.0),
  //             child: Container(
  //               alignment: Alignment.center,
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Expanded(
  //                       child: Padding(
  //                           padding: EdgeInsets.all(10.0),
  //                           child: Text(infoItem[_index].description,
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                   color: Colors.black,
  //                                   fontWeight: FontWeight.normal,
  //                                   fontSize: 16.0,
  //                                   fontFamily: FontFamilyMontserrat.name)))),
  //                 ],
  //               ),
  //             ),
  //           ))
  //     ],
  //   );
  // }

  void toggleSelection() {
    setState(() {
      if (isSelected) {
        mycolor = selectedOrange;
        isSelected = false;
      } else {
        mycolor = unselectedGray;
        isSelected = true;
      }
    });
  }

  Widget _buildPlayerModelList(productProvider.InvestmentLimitItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          margin:
              EdgeInsets.only(right: 25.0, top: 10.0, bottom: 10.0, left: 25.0),
          color: infoItemList.contains(item.name)
              ? selectedOrange
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
                        checkColor: Colors.orange, // color of tick Mark
                        activeColor: Colors.white,
                        value: item.isCheck,
                        onChanged: (bool value) {
                          setState(() {
                            //infoItemList = [];
                            item.isCheck = value;

                            if (!item.isCheck) {
                              infoItemList.remove(item.name);
                              _uncheckOption(item);
                            } else {
                              infoItemList.add(item.name);
                              _checkOption(item);
                            }
                            print(item.isCheck);
                            print(infoItemList.length);
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
                            style: TextStyle(
                                color: infoItemList.contains(item.name)
                                    ? Colors.white
                                    : headingBlack,
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0,
                                fontFamily: FontFamilyMontserrat.name)),
                      ),
                    )),
                  ],
                ),
              ),
              children: <Widget>[
                ListTile(
                  onLongPress: toggleSelection,
                  title: Text(
                    item.description,
                    style: TextStyle(
                        color: infoItemList.contains(item.name)
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                        fontFamily: FontFamilyMontserrat.name),
                  ),
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
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    fontFamily: FontFamilyMontserrat.name)))),
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
