import 'package:cycling_escape/navigator/route_names.dart';
import 'package:cycling_escape/screen/debug/debug_screen.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = RouteNames.homeScreen;

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DataProviderWidget(
      childBuilderLocalization: (context, localization) => Scaffold(
        body: IndexedStack(
          children: [
            Container(),
            const DebugScreen(),
          ],
          index: _currentIndex,
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onTap,
          currentIndex: _currentIndex,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.list),
              // label: localization.todoTitle,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: localization.settingsTitle,
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(int newIndex) {
    setState(() => _currentIndex = newIndex);
  }
}
