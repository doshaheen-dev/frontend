import 'dart:io';

import 'package:acc/constants/font_family.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:acc/screens/investor/welcome.dart';
import 'package:acc/services/AuthenticationService.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../utils/code_utils.dart';
import '../../../providers/country_provider.dart' as countryProvider;
import 'package:acc/models/authentication/signup_request.dart';
import 'package:acc/utils/crypt_utils.dart';

class SignUpDetails extends StatefulWidget {
  final User _user;
  final String _userAvatar;

  const SignUpDetails({
    Key key,
    User user,
    String userAvatar,
  })  : _user = user,
        _userAvatar = userAvatar,
        super(key: key);

  @override
  _SignUpDetailsState createState() => _SignUpDetailsState();
}

class _SignUpDetailsState extends State<SignUpDetails> {
  final _firstNameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  User _user;
  String firstname = "";
  String lastname = "";
  String email = "";
  String country = "";
  String address = "";
  File profilePhoto;

  var progress;
  Future _countries;
  var _isInit = true;

  Future<void> _fetchCountries(BuildContext context) async {
    await Provider.of<countryProvider.Countries>(context, listen: false)
        .fetchAndSetCountries();
  }

  @override
  void initState() {
    _user = widget._user;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {});
      _countries = _fetchCountries(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    void _setFirstAndLastName(int idx, String displayName) {
      _firstNameController.text = (displayName == null ||
              displayName.substring(0, idx).trim() == 'null')
          ? ''
          : displayName.substring(0, idx).trim() ?? '';
      _lastnameController.text = (displayName == null ||
              displayName.substring(idx + 1).trim() == 'null')
          ? ''
          : displayName.substring(idx + 1).trim() ?? '';
    }

    if (_user != null) {
      if (_user.displayName != null &&
          _user.displayName != '' &&
          _user.displayName != 'null') {
        int idx = _user.displayName.indexOf(" ");
        _setFirstAndLastName(idx, _user.displayName);
      }

      _emailController.text =
          (_user.email == null || _user.email == '' || _user.email == 'null')
              ? ''
              : _user.email ?? '';
    }

    void _imgFromCamera() async {
      final ImagePicker _picker = ImagePicker();
      final source = ImageSource.camera;
      final pickedFile = await _picker.getImage(
          source: source, preferredCameraDevice: CameraDevice.rear);

      setState(() {
        profilePhoto = File(pickedFile.path);
      });
    }

    void _imgFromGallery() async {
      final ImagePicker _picker = ImagePicker();
      final source = ImageSource.gallery;
      final pickedFile = await _picker.getImage(
          source: source, preferredCameraDevice: CameraDevice.rear);

      setState(() {
        profilePhoto = File(pickedFile.path);
      });
    }

    void _showPicker(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.photo_library),
                        title: new Text('Photo Library'),
                        onTap: () {
                          _imgFromGallery();
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Camera'),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    }

    Widget getDropDownSearch(List<Map<String, dynamic>> items) {
      return DropdownSearch<Map<String, dynamic>>(
        mode: Mode.BOTTOM_SHEET,
        showSearchBox: true,
        showSelectedItem: false,
        items: items,
        itemAsString: (Map<String, dynamic> i) => i['text'],
        hint: "",
        onChanged: (map) {
          setState(() {
            country = map['value'];
            print(country);
          });
        },
        dropdownSearchDecoration: InputDecoration(
          labelText: 'Country',
          labelStyle: new TextStyle(
            color: Colors.grey[600],
            fontFamily: FontFamilyMontserrat.name,
            fontSize: 18,
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.all(const Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
        selectedItem: null,
        maxHeight: 700,
      );
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
                              fontSize: 26.0,
                              fontFamily: FontFamilyMontserrat.name),
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
                          controller: _firstNameController,
                          onChanged: (value) => {firstname = value},
                          decoration: _setTextFieldDecoration("Firstname"),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                        decoration: customDecoration(),
                        child: TextField(
                          controller: _lastnameController,
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
                          controller: _emailController,
                          style: _setTextFieldStyle(),
                          onChanged: (value) => email = value,
                          decoration: _setTextFieldDecoration("E-mail"),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(
                            top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        decoration: customDecoration(),
                        child: FutureBuilder(
                            future: _countries,
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
                                      child: Text("An error occurred!"));
                                } else {
                                  return Consumer<countryProvider.Countries>(
                                    builder: (ctx, countryData, child) =>
                                        Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: getDropDownSearch(
                                          countryData.countries
                                              .map((info) => {
                                                    'text': info.name,
                                                    'value': info.abbreviation,
                                                  })
                                              .toList()),
                                    ),
                                  );
                                }
                              }
                            }),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                        decoration: customDecoration(),
                        child: TextField(
                          style: _setTextFieldStyle(),
                          controller: _addressController,
                          onChanged: (value) => address = value,
                          decoration: _setTextFieldDecoration("Address"),
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
                            if (_firstNameController.text.isEmpty) {
                              showSnackBar(
                                  context, "Please enter the Firstname.");
                              return;
                            }
                            if (_lastnameController.text.isEmpty) {
                              showSnackBar(
                                  context, "Please enter the Lastname.");
                              return;
                            }
                            if (_emailController.text.isEmpty) {
                              showSnackBar(
                                  context, "Please enter the email id.");
                              return;
                            }
                            if (!CodeUtils.emailValid(_emailController.text)) {
                              showSnackBar(
                                  context, "Please enter a valid email id.");
                              return;
                            }
                            if (country.isEmpty) {
                              showSnackBar(context, "Please select a country.");
                              return;
                            }
                            if (_addressController.text.isEmpty) {
                              showSnackBar(
                                  context, "Please enter the address.");
                              return;
                            }
                            FocusScope.of(context).requestFocus(FocusNode());
                            submitDetails(
                              _firstNameController.text.trim(),
                              _lastnameController.text.trim(),
                              _emailController.text.trim(),
                              country,
                              _addressController.text,
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

  TextField inputTextField(text) {
    return TextField(
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 16.0,
          fontFamily: FontFamilyMontserrat.name),
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
    final requestModelInstance = InvestorSignupRequestModel.instance;
    requestModelInstance.firstName = CryptUtils.encryption(firstName);
    requestModelInstance.lastName = CryptUtils.encryption(lastName);
    requestModelInstance.emailId = CryptUtils.encryption(emailId);
    requestModelInstance.countryCode = countryCode;
    requestModelInstance.address = address;
    openWelcomeInvestor();
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
