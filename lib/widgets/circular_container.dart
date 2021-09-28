import 'package:flutter/material.dart';

class CircularContainer extends StatelessWidget {
  const CircularContainer({
    Key key,
    @required this.circleRadius,
    @required this.innerContHeight,
  }) : super(key: key);

  final double circleRadius;
  final double innerContHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(circleRadius)),
      width: innerContHeight,
      height: innerContHeight,
      child: Icon(
        Icons.camera_alt,
        color: Colors.grey[800],
      ),
    );
  }
}
