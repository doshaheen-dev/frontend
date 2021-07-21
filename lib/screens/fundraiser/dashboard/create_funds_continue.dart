import 'package:acc/screens/fundraiser/dashboard/success_fund_submit.dart';
import 'package:acc/screens/investor/investment_choices.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/utilites/app_colors.dart';

class CreateFundsContinue extends StatefulWidget {
  @override
  _CreateFundsContinueState createState() => _CreateFundsContinueState();
}

class _CreateFundsContinueState extends State<CreateFundsContinue> {
  int selectedIndex;
  final _fundNameController = TextEditingController();

  bool _isTermsCheck = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0.0,
        backgroundColor: Color(0xffffffff),
      ),
      bottomNavigationBar: BottomAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 25.0, right: 25.0),
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
                      margin: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tell us about your fund",
                              style: textBold(headingBlack, 20)),
                          Text(
                              "What is the Minimum Investment from an investor",
                              style: textNormal(textGrey, 14))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          shrinkWrap: true,
                          childAspectRatio:
                              (MediaQuery.of(context).size.width / 2 / 65),
                          children: List.generate(infoItem.length, (index) {
                            return _createCell(index);
                          })),
                    ),

                    //Fund  General Partner / Managing Partner (GP)
                    Container(
                      margin: const EdgeInsets.only(top: 5.0, bottom: 20),
                      decoration: customDecoration(),
                      child: inputTextField(
                          "Fund  General Partner / Managing Partner (GP)",
                          "Please enter general partner here",
                          _fundNameController),
                    ),

                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Please upload required documents",
                            style: textNormal(textGrey, 14),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _createDocumentUI("Upload Passport / ID here",
                              "Passport/ID of Fund Representataive", "ID"),
                          _createDocumentUI(
                              "Upload Incorporation Doc here",
                              "Fund Company InCorporation Document",
                              "InCorporationD"),
                          _createDocumentUI("Upload Fund Deck",
                              "PDF, JPEG, PNG, JPG, PPT etc.", "Fund Deck"),
                          _createDocumentUI("Upload Fund Brand Image",
                              "JPEG, PNG, JPG.", "Brand Image"),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                "Matchmaker fee for Amicorp",
                                style: textNormal(textGrey, 12),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "5%",
                                style: textNormal(selectedOrange, 18),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  checkColor:
                                      Colors.white, // color of tick Mark
                                  activeColor: kDarkOrange,
                                  value: _isTermsCheck,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _isTermsCheck = value;
                                    });
                                  }),
                              SizedBox(
                                width: 10,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: "By signing in, I agree with ",
                                      style: textNormal(textLightGrey, 14),
                                      children: [
                                        TextSpan(
                                            text: "Terms of Use ",
                                            style: textNormal(Colors.black, 14),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                //openSignIn(context);
                                              }),
                                        TextSpan(
                                          text: "\n and ",
                                          style: textNormal(textLightGrey, 14),
                                        ),
                                        TextSpan(
                                            text: "Privacy Poicy",
                                            style: textNormal(Colors.black, 14),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                //openSignIn(context);
                                              })
                                      ]),
                                ),
                              ),
                            ],
                          ),
                          //NEXT BUTTON
                          Container(
                              margin: const EdgeInsets.only(
                                top: 20,
                                bottom: 20,
                              ),
                              child: ElevatedButton(
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    openSuccesssFundSubmitted();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(0.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18))),
                                  child: Ink(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            kDarkOrange,
                                            kLightOrange
                                          ]),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 60,
                                        alignment: Alignment.center,
                                        child: Text("Submit",
                                            style: textWhiteBold18()),
                                      )))),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell _createDocumentUI(
      String labelText, String description, String docType) {
    return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          setState(() {});
        },
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10),
                width: 20,
                height: 40,
                decoration: BoxDecoration(
                  color: unselectedGray,
                  borderRadius: BorderRadius.all(
                    const Radius.circular(15.0),
                  ),
                ),
                child: Center(
                    child:
                        Text(labelText, style: textNormal(Colors.black, 14))),
              ),
            ),
            Expanded(
                flex: 1,
                child: Text(
                  description,
                  style: textNormal(textGrey, 14),
                )),
          ],
        ));
  }

  TextField inputTextField(text, hint, _controller) {
    return TextField(
        onChanged: (text) {},
        style: textBlackNormal16(),
        controller: _controller,
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            labelText: text,
            hintText: hint,
            hintMaxLines: 2,
            labelStyle: new TextStyle(color: Colors.grey),
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 2.0),
                borderRadius: BorderRadius.all(
                  const Radius.circular(10.0),
                ))));
  }

  List<String> infoItemList = [];
  List<InvestmentLimitItem> infoItem = [
    InvestmentLimitItem('100K\$-200K\$'),
    InvestmentLimitItem('200k\$ - 300K\$'),
    InvestmentLimitItem('300k\$ - 400K\$'),
    InvestmentLimitItem('400k\$ - 500K\$'),
    InvestmentLimitItem('Above 500K\$'),
  ];

  InkWell _createCell(int _index) {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        setState(() {
          selectedIndex = _index;
        });
      },
      child: Container(
        width: 10,
        height: 30,
        decoration: BoxDecoration(
          color: selectedIndex == _index ? selectedOrange : unselectedGray,
          borderRadius: BorderRadius.all(
            const Radius.circular(15.0),
          ),
        ),
        child: Center(
            child: Text(infoItem[_index].header,
                style: textNormal(
                    selectedIndex == _index ? Colors.white : Colors.black,
                    14))),
      ),
    );
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

  void openSuccesssFundSubmitted() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return SuccesssFundSubmitted();
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

class InvestmentLimitItem {
  final String header;

  InvestmentLimitItem(this.header);
}
