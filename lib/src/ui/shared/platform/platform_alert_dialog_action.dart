import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'platform_widget.dart';

class PlatformAlertDialogAction extends PlatformWidget {
  final Widget child;
  final Function onPressed;

  PlatformAlertDialogAction({
    @required this.child,
    @required this.onPressed,
  })  : assert(child != null),
        assert(onPressed != null);
  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return FlatButton(
      child: child,
      onPressed: onPressed,
    );
  }
}
