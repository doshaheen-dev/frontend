import 'package:flutter/cupertino.dart';
import './exception_indicator.dart';

/// Indicates that no items were found.
class EmptyListText extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const ExceptionIndicator(
        title: 'Too much filtering',
        message: 'No Items added yet to this list.',
        assetName: 'assets/images/empty-box.png',
      );
}
