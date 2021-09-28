import 'package:flutter/material.dart';

class ImageCircle extends StatelessWidget {
  const ImageCircle({
    Key key,
    @required this.borderRadius,
    @required this.image,
  }) : super(key: key);

  final double borderRadius;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: image,
    );
  }
}
