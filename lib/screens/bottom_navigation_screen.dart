import 'package:flutter/services.dart';

import '../screens/profile_screen.dart';
import '../util/constant.dart';
import '../screens/cart_screen.dart';
import '../screens/home_screen.dart';
import '../util/styling.dart';
import 'package:flutter/material.dart';
import 'order_history_screen.dart';

class MyBottomNavScreen extends StatefulWidget {
  MyBottomNavScreen({Key key}) : super(key: key);

  @override
  _MyBottomNavScreenState createState() => _MyBottomNavScreenState();
}

class _MyBottomNavScreenState extends State<MyBottomNavScreen> {
  int _selectedIndex = 0;

  final List<Map<String, Object>> _page = [
    {
      'page': HomeScreen(),
      'title': 'Home Screen',
    },
    {
      'page': CartScreen(),
      'title': 'Cart Screen',
    },
    {
      'page': OrderHistoryScreen(),
      'title': 'Order History Screen',
    },
    {
      'page': ProfileScreen(),
      'title': 'Profile',
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    var selectedIndex = ModalRoute.of(context).settings.arguments as int;
    if (selectedIndex != null) {
      _selectedIndex = selectedIndex;
    }

    print('_selectedIndex : ${_selectedIndex} : ');
  }

  void _onItemTapped(int index) {
    print('_onItemTapped : ${index}');
    setState(() {
      _selectedIndex = index;

      // Navigator.of(context).pushReplacementNamed(
      //     Constant.BOTTOM_NAVIGATION_NAME,
      //     arguments: _selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    // var selectedIndex = ModalRoute.of(context).settings.arguments as int;
    // if (selectedIndex != null) {
    //   _selectedIndex = selectedIndex;
    // }

    return WillPopScope(
      onWillPop: () {
        print('WillPopScope');
        setState(() {
          if (_selectedIndex != 0) {
            Navigator.of(context).pushReplacementNamed(
                Constant.BOTTOM_NAVIGATION_NAME,
                arguments: 0);
          } else {
            SystemNavigator.pop();
          }
        });
      },
      child: Scaffold(
        body: Center(
          child: _page[_selectedIndex]['page'],
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Color(0xFF6B6B6B),
          selectedItemColor: AppTheme.redButtonColor,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text('Cart'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note),
              title: Text('Order'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text('User'),
            ),
          ],
        ),
      ),
    );
  }
}
