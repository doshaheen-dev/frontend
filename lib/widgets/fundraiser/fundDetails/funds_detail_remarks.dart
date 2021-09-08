import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/material.dart';

class FundsRemark extends StatefulWidget {
  final String likedFunds;

  FundsRemark(
    this.likedFunds,
  );

  @override
  _FundsRemarkState createState() => _FundsRemarkState();
}

class _FundsRemarkState extends State<FundsRemark> {
  bool _isFundDcoumentVisible = false;
  var _selectedTextColor = Colors.black;
  var _changeBgColor = unselectedGray;

  _displayFundsDocument() {
    if (_isFundDcoumentVisible == true) {
      setState(() {
        _isFundDcoumentVisible = false;
        _changeBgColor = unselectedGray;
        _selectedTextColor = Colors.black;
      });
    } else {
      setState(() {
        _isFundDcoumentVisible = true;
        _changeBgColor = Theme.of(context).primaryColor;
        _selectedTextColor = Colors.white;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
        color: _changeBgColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Remarks (By Amicorp)",
                      textAlign: TextAlign.start,
                      style: textBold16(_selectedTextColor))),
              Spacer(),
              IconButton(
                  onPressed: () {
                    _displayFundsDocument();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Image.asset(
                    "assets/images/icon_down.png",
                    color: _selectedTextColor,
                  ))
            ],
          ),
        ),
      ),
      Visibility(
          visible: _isFundDcoumentVisible,
          child: Container(
              child: Card(
                  color: unselectedGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.likedFunds,
                            style: textNormal14(Colors.black)),
                      )))))
    ]);
  }
}
