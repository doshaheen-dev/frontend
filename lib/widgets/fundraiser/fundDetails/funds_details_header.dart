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
    if (widget.likedFunds.type == "Approve") {
      iconColor = Colors.green;
    } else if (widget.likedFunds.type == "UnderScrutiny") {
      iconColor = Colors.blue;
    } else if (widget.likedFunds.type == "Reject") {
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

        Image.network(
          widget.likedFunds.fundLogo,
          height: 250,
          width: double.infinity,
          fit: BoxFit.fill,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return Center(
                child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null));
            // You can use LinearProgressIndicator or CircularProgressIndicator instead
          },
          errorBuilder: (context, error, stackTrace) =>
              Image.asset("assets/images/dummy/investment1.png"),
        ),
        // Image(
        //   image: widget.likedFunds.fundLogo != ""
        //       ? NetworkImage(widget.likedFunds.fundLogo)
        //       : AssetImage("assets/images/dummy/investment1.png"),
        //   height: 250,
        //   fit: BoxFit.fill,
        //   loadingBuilder: (context, child, loadingProgress) {
        //     if (loadingProgress == null) return child;
        //     return Center(
        //         child: CircularProgressIndicator(
        //       backgroundColor: Colors.orange,
        //       valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber),
        //     ));
        //     // You can use LinearProgressIndicator or CircularProgressIndicator instead
        //   },
        //   errorBuilder: (context, error, stackTrace) =>
        //       Image.asset("assets/images/dummy/investment1.png"),
        // ),
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
              // "Pune",
              "${widget.likedFunds.fundCityName}, ${widget.likedFunds.fundCountryName}",
              style: textNormal(HexColor("#404040"), 12.0),
            )
          ],
        ),
        Center(
          child: Text(
            "Minimum Investment : ${widget.likedFunds.minimumInvestment}",
            // "Minimum Investment : 10000",
            style: textNormal(HexColor("#404040"), 12.0),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
              child: Text(
            widget.likedFunds.fundInvstmtObj,
            textAlign: TextAlign.left,
            style: textNormal(HexColor("#3A3B3F"), 14.0),
          )),
        )
      ],
    );
  }
}
