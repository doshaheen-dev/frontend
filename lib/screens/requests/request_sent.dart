import 'package:flutter/material.dart';

class RequestSent extends StatefulWidget {
  _RequestSentState createState() => _RequestSentState();
}

class _RequestSentState extends State<RequestSent> {
  List names = ["Abc", "DEF", "GHI"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemCount: 3,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) => Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey[200]),
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/social_media/google.png',
                      width: 45.0,
                      height: 45.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Row(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        names[index],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
