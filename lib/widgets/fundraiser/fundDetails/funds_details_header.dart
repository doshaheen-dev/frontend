import 'package:acc/screens/fundraiser/dashboard/fundraiser_home.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/material.dart';

class FundsDetailHeader extends StatefulWidget {
  final SubmittedFunds likedFunds;

  FundsDetailHeader(
    this.likedFunds,
  );

  @override
  _FundsDetailHeaderState createState() => _FundsDetailHeaderState();
}

class _FundsDetailHeaderState extends State<FundsDetailHeader> {
  @override
  Widget build(BuildContext context) {
    MaterialColor iconColor;
    if (widget.likedFunds.type == "Listed") {
      iconColor = Colors.green;
    } else if (widget.likedFunds.type == "Under Scrutiny") {
      iconColor = Colors.blue;
    } else if (widget.likedFunds.type == "Not Listed") {
      iconColor = Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10, left: 10),
          child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Image.asset("assets/images/icon_close.png"),
            onPressed: () => {Navigator.pop(context)},
          ),
        ),
        Image(
          image: widget.likedFunds.fundLogo != ""
              ? NetworkImage(widget.likedFunds.fundLogo)
              : AssetImage("assets/images/dummy/investment1.png"),
          height: 250,
          fit: BoxFit.fill,
        ),
        SizedBox(
          height: 5,
        ),
        Center(
            child: Text(
          widget.likedFunds.name,
          style: textBold18(headingBlack),
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.circle,
              color: iconColor,
              size: 15.0,
            ),
            SizedBox(
              width: 5,
            ),
            Text(widget.likedFunds.type,
                style: textNormal16(HexColor("#2B2B2B")))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/map.png",
              height: 30,
              width: 30,
            ),
            Text(
              "Pune",
              // _likedFunds.location,
              style: textNormal(HexColor("#404040"), 12.0),
            )
          ],
        ),
        Center(
          child: Text(
            // "Minimum Investment : ${_likedFunds.minimumInvestment}",
            "Minimum Investment : 10000",
            style: textNormal(HexColor("#404040"), 12.0),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Center(
            child: Text(
          widget.likedFunds.fundInvstmtObj,
          textAlign: TextAlign.center,
          style: textNormal(HexColor("#3A3B3F"), 14.0),
        ))
      ],
    );
  }
}
