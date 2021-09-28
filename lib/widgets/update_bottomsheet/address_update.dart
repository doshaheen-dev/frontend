import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class AddressUpdate extends StatefulWidget {
  String address = "";

  Function(String) callback;
  AddressUpdate(this.address, this.callback);

  @override
  _AddressUpdateState createState() => new _AddressUpdateState();
}

class _AddressUpdateState extends State<AddressUpdate> {
  String address = "";
  String newAddress = "";

  TextEditingController _addressController = TextEditingController();
  TextEditingController _newAddressController = TextEditingController();

  @override
  void initState() {
    _addressController.text = widget.address;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Stack(
          children: [
            TextField(
                enabled: false,
                keyboardType: TextInputType.multiline,
                maxLength: null,
                maxLines: null,
                style: textBlackNormal16(),
                onChanged: (value) => address = value,
                controller: _addressController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: "Address",
                    labelStyle: textNormal14(Colors.grey[600]),
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.transparent, width: 2.0),
                      borderRadius: BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ))),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(left: 25.0, right: 20.0, top: 15.0),
                child: InkWell(
                    onTap: () {
                      // open Bottom sheet
                      showAddressUpdationView();
                    },
                    child: Text(
                      "Update",
                      style: textNormal12(Colors.blue),
                    )),
              ),
            ),
          ],
        ));
  }

  final GlobalKey<ScaffoldState> _addressScaffoldKey =
      GlobalKey<ScaffoldState>();
  void showAddressUpdationView() {
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
                    key: _addressScaffoldKey,
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Text(
                                  "Update Your Address",
                                  textAlign: TextAlign.start,
                                  style: textBold16(headingBlack),
                                ),
                                Spacer(),
                                InkWell(
                                    onTap: () {
                                      _newAddressController.clear();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Close",
                                      style: textNormal16(headingBlack),
                                    ))
                              ]),
                            ),
                            Container(
                              decoration: customDecoration(),
                              margin: EdgeInsets.only(
                                  left: 15.0, right: 15.0, top: 10.0),
                              width: MediaQuery.of(context).size.width,
                              child: TextField(
                                  style: textBlackNormal16(),
                                  keyboardType: TextInputType.multiline,
                                  maxLength: null,
                                  maxLines: null,
                                  onChanged: (value) => newAddress = value,
                                  controller: _newAddressController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      labelText: "Address",
                                      labelStyle: new TextStyle(
                                          color: Colors.grey[600]),
                                      border: InputBorder.none,
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 2.0),
                                        borderRadius: BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                      ))),
                            ),
                            Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(
                                    top: 20.0, bottom: 20),
                                child: ElevatedButton(
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());

                                      if (_newAddressController.text.isEmpty) {
                                        _addressScaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                                duration: Duration(seconds: 1),
                                                content: Text(
                                                    "Please enter your address.")));
                                        return;
                                      }
                                      if (_newAddressController.text
                                              .toLowerCase() !=
                                          _addressController.text
                                              .toLowerCase()) {
                                        _addressController.text =
                                            _newAddressController.text;
                                        this.widget.callback(
                                            _newAddressController.text.trim());
                                        // updateAddress(
                                        //     _newAddressController.text.trim());
                                        Future.delayed(
                                            Duration(milliseconds: 2),
                                            () async {
                                          _newAddressController.clear();
                                          Navigator.pop(context);
                                        });
                                        return;
                                      }
                                      _addressScaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text(
                                                  "Please enter new address.")));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(0.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18))),
                                    child: Ink(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              Theme.of(context).primaryColor,
                                              Theme.of(context).primaryColor
                                            ]),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Container(
                                            width: 240,
                                            height: 45,
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Update New Address",
                                              style: textWhiteBold16(),
                                            ))))),
                          ],
                        ),
                      ),
                    )));
          });
        });
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
