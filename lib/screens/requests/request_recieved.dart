import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RequestRecieved extends StatefulWidget {
  _RequestRecievedState createState() => _RequestRecievedState();
}

class _RequestRecievedState extends State<RequestRecieved> {
  List names = [
    "Mutual Fund Advisor",
    "Bajaj Allianz General Insurance Company Limited",
    "Capital Group",
    "Larsen & Toubro Mutual Fund",
    "Tata Investment Corporation"
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: names.length, shrinkWrap: true, itemBuilder: _buildItem);
  }

  Widget _buildItem(BuildContext context, int index) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.only(right: 20.0, top: 10.0, bottom: 10.0, left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  child: Image.asset(
                    'assets/images/dummy/dummy_request.png',
                    width: 450.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  )),
              Container(
                margin:
                    EdgeInsets.only(left: 10, top: 10, right: 0, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      names[index],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      DateFormat.yMMMMd().format(DateTime.now()),
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 14.0,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 0.4,
            height: 1,
          ),
          //Bottom Buttons
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                    onPressed: () {
                      _openDialog(context,
                          'Are you sure you want to accept this request?');
                    },
                    icon: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    label: Text("Accept",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.green,
                            fontSize: 16.0,
                            fontFamily: 'Poppins-Regular'))),
              ),

              //Reject Button
              Expanded(
                child: TextButton.icon(
                    onPressed: () {
                      _openDialog(context,
                          'Are you sure you want to decline this request?');
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    label: Text("Decline",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.red,
                            fontSize: 16.0,
                            fontFamily: 'Poppins-Regular'))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _openDialog(BuildContext context, String message) {
    // set up the buttons
    Widget negativeButton = TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: Text("Cancel",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xff00A699),
                fontSize: 16.0,
                fontFamily: 'Poppins-Regular')));

    Widget positiveButton = TextButton(
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
      child: Text("Yes",
          style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xff00A699),
              fontSize: 16.0,
              fontFamily: 'Poppins-Regular')),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(message),
      actions: [
        negativeButton,
        positiveButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
