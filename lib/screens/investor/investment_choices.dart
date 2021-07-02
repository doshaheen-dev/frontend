import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_management/screens/investor/general_terms_privacy.dart';
import 'package:portfolio_management/utilites/app_colors.dart';
import 'package:portfolio_management/utilites/ui_widgets.dart';

class InvestmentChoices extends StatefulWidget {
  @override
  _InvestmentChoicesState createState() => _InvestmentChoicesState();
}

class _InvestmentChoicesState extends State<InvestmentChoices> {
  bool _isButtonVisible = false;
  bool _isVisible = false;
  var isSelected = false;
  var mycolor = Colors.white;

  void showToast() {
    setState(() {
      _isButtonVisible = true;
      if (infoItemList.isEmpty) {
        _isButtonVisible = false;
      }
    });
  }

  // void showDescription() {
  //   setState(() {
  //     _isVisible = true;
  //     if (infoItemList.isEmpty) {
  //       _isVisible = false;
  //     }
  //   });
  // }

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
                          fontSize: 28.0,
                          fontFamily: 'Poppins-Light'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: infoItem.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildPlayerModelList(infoItem[index]);
                      }), //),

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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GeneralTermsPrivacy()));
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
  List<InvestmentLimitItem> infoItem = [
    InvestmentLimitItem(
        'Angel Funds',
        'Angel funds invest in very early-stage businesses providing capital for start up or expansion.',
        false,
        false),
    InvestmentLimitItem(
        'Venture Capital',
        'Angel funds invest in very early-stage businesses providing capital for start up or expansion.',
        false,
        false),
    InvestmentLimitItem(
        'Listed Equities',
        'Angel funds invest in very early-stage businesses providing capital for start up or expansion.',
        false,
        false),
    InvestmentLimitItem(
        'Fixed Income',
        'Angel funds invest in very early-stage businesses providing capital for start up or expansion.',
        false,
        false),
    InvestmentLimitItem(
        'Structured Products',
        'Angel funds invest in very early-stage businesses providing capital for start up or expansion.',
        false,
        false),
    InvestmentLimitItem(
        'CryptoCurrencies',
        'Angel funds invest in very early-stage businesses providing capital for start up or expansion.',
        false,
        false),
  ];

  Widget _createExpanded(BuildContext context, int _index) {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin:
            EdgeInsets.only(right: 25.0, top: 10.0, bottom: 10.0, left: 25.0),
        child: Padding(
            padding: EdgeInsets.all(20.0),
            child: ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    infoItem[index].isExpanded = !infoItem[index].isExpanded;
                  });
                },
                children: infoItem.map((InvestmentLimitItem order) {
                  return ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return InkWell(
                        onTap: () {
                          //on click
                          infoItemList = [];
                          infoItemList.add(infoItem[_index].header);
                          setState(() {});
                          print(infoItem[_index].header);
                        },
                        child: Center(
                          child: Text(
                            order.header,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                    isExpanded: order.isExpanded,
                    body: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        order.description,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList())));
  }

  Widget _createCell(BuildContext context, int _index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
            color: infoItemList.contains(infoItem[_index].header)
                ? selectedOrange
                : unselectedGray,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            margin: EdgeInsets.only(
                right: 25.0, top: 10.0, bottom: 10.0, left: 25.0),
            child: InkWell(
              highlightColor: Colors.transparent,
              borderRadius: BorderRadius.circular(40),
              onTap: () {
                print(infoItem[_index].header);
                infoItemList = [];
                infoItemList.add(infoItem[_index].header);
                setState(() {
                  showToast();
                });
              },
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    Spacer(flex: 3),
                    Center(
                        child: Text(infoItem[_index].header,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: infoItemList
                                        .contains(infoItem[_index].header)
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0,
                                fontFamily: 'Poppins-Light'))),
                    new Spacer(
                      flex: 3,
                    ), // I just added one line
                    InkWell(
                        onTap: () {
                          print(infoItem[_index].header);
                          new Tooltip(
                              message: "Hello World", child: new Text("foo"));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Icon(
                            Icons.navigate_next,
                            color:
                                infoItemList.contains(infoItem[_index].header)
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        )),
                  ],
                ),
              ),
            )),
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
                            child: Text(infoItem[_index].description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    fontFamily: 'Poppins-Light')))),
                  ],
                ),
              ),
            ))
      ],
    );
  }

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

  Widget _buildPlayerModelList(InvestmentLimitItem items) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          margin:
              EdgeInsets.only(right: 25.0, top: 10.0, bottom: 10.0, left: 25.0),
          color: infoItemList.contains(items.header)
              ? selectedOrange
              : unselectedGray,
          child: Container(
            child: ExpansionTile(
              iconColor: infoItemList.contains(items.header)
                  ? Colors.black
                  : Colors.white,
              title: Container(
                child: Row(
                  children: [
                    Checkbox(
                        checkColor: Colors.orange, // color of tick Mark
                        activeColor: Colors.white,
                        value: items.isCheck,
                        onChanged: (bool value) {
                          setState(() {
                            //infoItemList = [];
                            items.isCheck = value;

                            if (!items.isCheck) {
                              infoItemList.remove(items.header);
                            } else {
                              infoItemList.add(items.header);
                            }
                            print(items.isCheck);
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
                        child: Text(items.header,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: infoItemList.contains(items.header)
                                    ? Colors.white
                                    : headingBlack,
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0,
                                fontFamily: 'Poppins-Light')),
                      ),
                    )),
                  ],
                ),
              ),
              children: <Widget>[
                ListTile(
                  onLongPress: toggleSelection,
                  title: Text(
                    items.description,
                    style: TextStyle(
                        color: infoItemList.contains(items.header)
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0,
                        fontFamily: 'Poppins-Light'),
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
                            child: Text(items.description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    fontFamily: 'Poppins-Light')))),
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
}

class InvestmentLimitItem {
  final String header;
  final String description;
  bool isExpanded = false;
  bool isCheck = false;

  InvestmentLimitItem(
      this.header, this.description, this.isExpanded, this.isCheck);
}
