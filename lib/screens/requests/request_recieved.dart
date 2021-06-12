import 'package:flutter/material.dart';

class RequestRecieved extends StatefulWidget {
  _RequestRecievedState createState() => _RequestRecievedState();
}

class _RequestRecievedState extends State<RequestRecieved> {
  List names = ["Abc", "DEF", "GHI", "ikl", "hjs"];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 5, shrinkWrap: true, itemBuilder: _buildItem);
  }

  Widget _buildItem(BuildContext context, int index) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      margin: EdgeInsets.only(right: 20.0, top: 10.0, bottom: 10.0, left: 20.0),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(10.0)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 20.0,
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/investment_solutions/portfolio_manager.png',
                    width: 80.0,
                    height: 80.0,
                    fit: BoxFit.fill,
                  )),
              SizedBox(
                width: 20.0,
              ),
              Text(
                names[index],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Accept',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.green,
                          fontSize: 16.0,
                          fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.grey.withOpacity(0.4),
                width: 1,
              ), // THE DIVIDER. CHANGE THIS TO ACCOMMODATE YOUR NEEDS
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Decline',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.red,
                          fontSize: 16.0,
                          fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          // Row(
          //   children: <Widget>[
          //     Padding(
          //         padding: EdgeInsets.only(
          //             top: 20.0, bottom: 20.0, right: 20.0, left: 20.0)),
          //     Expanded(
          //       child: RichText(
          //         text: TextSpan(
          //           children: [
          //             WidgetSpan(
          //               child: Padding(
          //                 padding: const EdgeInsets.symmetric(horizontal: 2.0),
          //                 child: Icon(Icons.check, color: Colors.green),
          //               ),
          //             ),
          //             TextSpan(
          //                 text: 'Accept',
          //                 style: TextStyle(
          //                   color: Colors.green,
          //                   fontSize: 16.0,
          //                   fontFamily: 'Poppins',
          //                 )),
          //           ],
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: RichText(
          //         text: TextSpan(
          //           children: [
          //             WidgetSpan(
          //               child: Padding(
          //                 padding: const EdgeInsets.symmetric(horizontal: 2.0),
          //                 child: Icon(Icons.close, color: Colors.red),
          //               ),
          //             ),
          //             TextSpan(
          //                 text: 'Decline',
          //                 style: TextStyle(
          //                   color: Colors.red,
          //                   fontSize: 16.0,
          //                   fontFamily: 'Poppins',
          //                 )),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
