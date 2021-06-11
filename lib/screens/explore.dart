import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_management/constants/caterories_type.dart';
import 'package:portfolio_management/widgets/categories.dart';
import 'package:portfolio_management/widgets/wavy_header.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              WavyHeader(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Container(
                    height: 50.0,
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    decoration: new BoxDecoration(
                      color: Color(0xFFFCFCFC).withOpacity(0.3),
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          'Search',
                          style: TextStyle(color: Color(0xFFFCFCFC)),
                        )),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {},
                          color: Color(0xFFFCFCFC),
                          iconSize: 30.0,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 40.0,
                  left: 10.0,
                ),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Portfolio Management",
                      style: TextStyle(
                          color: Color(0xFFFCFCFC),
                          fontSize: 30,
                          fontFamily: 'Poppin'),
                    )),
                // child: Text("Nearby",style: TextStyle(fontSize: 40.0,color: Color(0xFFFCFCFC),fontWeight: FontWeight.bold),)),
              )
            ],
          ),
          Categories(
              type: "Raise Capital",
              listOfCategories: CateroriesType.raiseCapital),
          Categories(
              type: "Investment Solutions",
              listOfCategories: CateroriesType.invenstmentManager),
        ],
      ),
    ));
  }
}
