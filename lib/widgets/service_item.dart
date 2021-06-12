import 'package:flutter/material.dart';

import '../constants/theme_colors.dart';

class ServiceItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  ServiceItem(
    this.title,
    this.imageUrl,
  );

  void selectService(BuildContext context) {
    // Navigator.of(context).pushNamed(
    //   ServiceDetailScreen.routeName,
    //   arguments: {
    //     "id": id,
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectService(context),
      child: Card(
        color: ThemeColor.greenColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Image.asset(
                imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
