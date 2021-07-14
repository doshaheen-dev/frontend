import 'package:flutter/material.dart';

class TempHome extends StatefulWidget {
  TempHome({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TempHomeState();
}

class _TempHomeState extends State<TempHome> {
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => Container(
              constraints: BoxConstraints.expand(),
              child: Column(
                children: <Widget>[
                  Expanded(
                      flex: 4,
                      child: Container(
                          alignment: Alignment.topCenter,
                          constraints: BoxConstraints.expand(),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              Text("Hello"),
                              Text("Hello"),
                              Text("Hello"),
                              Text("Hello"),
                              Text("Hello"),
                              Text("Hello"),
                              Text("Hello"),
                              Text("Hello"),
                              Text("Hello"),
                              Text("Hello"),
                              Text("Hello"),
                              Text("Hello"),
                              Text("Hello")
                            ],
                          )))),
                  Expanded(
                      flex: 1,
                      child: Container(
                          padding: EdgeInsets.all(25.0),
                          alignment: Alignment.bottomCenter,
                          constraints: BoxConstraints.expand(),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      child: Image.asset(
                                        'assets/images/investor/internet_browsing.png',
                                        fit: BoxFit.contain,
                                      ),
                                    )),
                                Expanded(
                                    flex: 5,
                                    child: Center(
                                        child: Text("Scan ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 45.0)))),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      child: Image.asset(
                                        'assets/images/investor/internet_browsing.png',
                                        fit: BoxFit.contain,
                                      ),
                                    )),
                              ])))
                ],
              ),
            ));
  }
}
