import 'package:flutter/cupertino.dart';
import './exception_indicator.dart';

/// Indicates that no items were found.
class EmptyListIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const ExceptionIndicator(
        title: 'Too much filtering',
        message: 'We couldn\'t find any results matching your applied filters.',
        assetName: 'assets/images/empty-box.png',
      );
}
