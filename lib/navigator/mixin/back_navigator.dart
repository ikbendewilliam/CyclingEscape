import 'package:cycling_escape/navigator/main_navigator.dart';
import 'package:flutter/material.dart';

// ignore: one_member_abstracts
abstract class BackNavigator {
  void goBack<T>({T? result});
}

mixin BackNavigatorMixin<T extends StatefulWidget> on State<T> implements BackNavigator {
  @override
  void goBack<E>({E? result}) => MainNavigatorWidget.of(context).goBack<E>(result: result);
}
