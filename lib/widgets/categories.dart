import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:acc/models/categories_model.dart';

class Categories extends StatefulWidget {
  final String type;
  final List<CategoriesModel> listOfCategories;
  Categories({@required this.type, @required this.listOfCategories});
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  String typeName;
  List<CategoriesModel> listOfCategories;
  @override
  void initState() {
    setState(() {
      this.typeName = widget.type;
      this.listOfCategories = widget.listOfCategories;
    });

    super.initState();
  }

  Widget _buildCategoryList(context, index, List<CategoriesModel> listImages) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // ClipRRect(
          //     borderRadius: BorderRadius.circular(10.0),
          //     child: Image.asset(
          //       listImages[index].image,
          //       width: 100.0,
          //       height: 50.0,
          //       fit: BoxFit.cover,
          //     )),
          ClipOval(
            child: Image.asset(
              listImages[index].image,
              height: 80,
              width: 50,
              fit: BoxFit.fitWidth,
            ),
          ),

          SizedBox(
            height: 10,
          ),
          Text(listImages[index].name)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 10.0,
          ),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                this.typeName,
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
              )),
        ),
        Container(
          padding: EdgeInsets.only(left: 10.0),
          height: 150.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: this.listOfCategories.length,
              itemBuilder: (context, index) {
                return _buildCategoryList(
                    context, index, this.listOfCategories);
              }),
        ),
      ],
    );
  }
}
