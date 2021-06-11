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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.asset(
                imageUrl,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Positioned(
              bottom: 0,
              right: 200,
              child: Container(
                width: 180,
                height: 60,
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 20,
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: ThemeColor.greenColor,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
