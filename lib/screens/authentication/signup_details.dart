import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:portfolio_management/models/profile/basic_details.dart';
import 'package:portfolio_management/screens/investor/welcome.dart';
import 'package:portfolio_management/services/NewAuthenticationService.dart';
import 'package:portfolio_management/services/ProfileService.dart';
import 'package:portfolio_management/utilites/app_colors.dart';
import 'package:portfolio_management/utilites/ui_widgets.dart';

class SignUpDetails extends StatefulWidget {
  final User _user;
  const SignUpDetails({Key key, User user})
      : _user = user,
        super(key: key);

  @override
  _SignUpDetailsState createState() => _SignUpDetailsState();
}

class _SignUpDetailsState extends State<SignUpDetails> {
  User _user;
  String firstname = "";
  String lastname = "";
  String email = "";
  String country = 'IND';
  String address = "";

  var progress;

  @override
  void initState() {
    _user = widget._user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    final firstNameController = TextEditingController();
    final lastnameController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();
    print("info, ${_user}");
    if (_user != null) {
      int idx = _user.displayName.indexOf(" ");
      // Or check if appState.username != null or what ever your use case is.
      firstNameController.text =
          _user.displayName.substring(0, idx).trim() ?? '';
      lastnameController.text =
          _user.displayName.substring(idx + 1).trim() ?? '';
      emailController.text = _user.email ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0.0,
        backgroundColor: Color(0xffffffff),
      ),
      bottomNavigationBar: BottomAppBar(),
      backgroundColor: Colors.white,
      body: ProgressHUD(
        child: Builder(
          builder: (context) => SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, size: 30),
                      onPressed: () {
                        Authentication.signOut();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 10.0, left: 25.0),
                        child: Text(
                          "Personal details here",
                          style: TextStyle(
                              color: headingBlack,
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0,
                              fontFamily: 'Poppins-Light'),
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                        decoration: customDecoration(),
                        child: TextField(
                          style: _setTextFieldStyle(),
                          controller: firstNameController,
                          onChanged: (value) => {firstname = value},
                          decoration: _setTextFieldDecoration("Firstname"),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                        decoration: customDecoration(),
                        child: TextField(
                          controller: lastnameController,
                          style: _setTextFieldStyle(),
                          onChanged: (value) => lastname = value,
                          decoration: _setTextFieldDecoration("Lastname"),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                        decoration: customDecoration(),
                        child: TextField(
                          controller: emailController,
                          style: _setTextFieldStyle(),
                          onChanged: (value) => email = value,
                          decoration: _setTextFieldDecoration("E-mail"),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(
                            top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                        decoration: customDecoration(),
                        child: DropdownButtonFormField(
                            decoration: InputDecoration(
                                labelText: 'Code',
                                labelStyle:
                                    new TextStyle(color: Colors.grey[600]),
                                enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent))),
                            value: country,
                            items: [
                              DropdownMenuItem(
                                child: Text("INDIA"),
                                value: 'IND',
                              ),
                              DropdownMenuItem(
                                child: Text("DUBAI"),
                                value: 'UAE',
                              ),
                              DropdownMenuItem(
                                child: Text("SINGAPORE"),
                                value: 'SGP',
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                country = value;
                              });
                            }),
                      ),

                      Container(
                        margin: const EdgeInsets.only(
                            top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                        decoration: customDecoration(),
                        child: TextField(
                          style: _setTextFieldStyle(),
                          controller: addressController,
                          onChanged: (value) => address = value,
                          decoration: _setTextFieldDecoration("Address 1"),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      //NEXT BUTTON
                      Container(
                        margin: const EdgeInsets.only(
                            top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(40),
                          onTap: () {
                            // on click
                            if (firstNameController.text.isEmpty) {
                              showSnackBar(
                                  context, "Please enter the Firstname.");
                              return;
                            }
                            if (lastnameController.text.isEmpty) {
                              showSnackBar(
                                  context, "Please enter the Lastname.");
                              return;
                            }
                            if (emailController.text.isEmpty) {
                              showSnackBar(
                                  context, "Please enter the email id.");
                              return;
                            }
                            FocusScope.of(context).requestFocus(FocusNode());
                            progress = ProgressHUD.of(context);
                            progress?.showWithText('Uploading Details...');
                            submitDetails(
                              firstNameController.text.trim(),
                              lastnameController.text.trim(),
                              emailController.text.trim(),
                              country,
                              addressController.text,
                            );
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
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

  TextStyle _setTextFieldStyle() {
    return TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: 18.0,
        fontFamily: 'Poppins-Regular');
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

  TextField inputTextField(text) {
    return TextField(
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 16.0,
          fontFamily: 'Poppins-Regular'),
      decoration: new InputDecoration(
        contentPadding: EdgeInsets.all(10.0),
        labelText: text,
        labelStyle: new TextStyle(color: Colors.grey[600]),
        border: InputBorder.none,
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 2.0),
          borderRadius: BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Future<void> submitDetails(
    String firstName,
    String lastName,
    String emailId,
    String countryCode,
    String address,
  ) async {
    UpdateBasicDetails basicDetails = await ProfileService.updateBasicDetails(
        firstName, lastName, emailId, countryCode, address);
    print('BD type: ${basicDetails.type}');
    print('BD status: ${basicDetails.status}');
    print('BD message: ${basicDetails.message}');
    progress.dismiss();
    if (basicDetails.type == "success") {
      openWelcomeInvestor();
    } else {
      showSnackBar(context, "Something went wrong");
    }
  }

  void openWelcomeInvestor() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return WelcomeInvestor();
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
