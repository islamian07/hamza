import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:userapp/screens/categories.dart';
import 'package:userapp/screens/homepage.dart';
import 'package:userapp/screens/user.dart';
import 'package:userapp/screens/wishlist/wishlist_screen.dart';

import '../providers/dark_theme_provider.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {'page': const HomePage(), 'title': 'Home Screen'},
    {'page': CategoriesScreen(), 'title': 'Categories Screen'},
    //{'page': const WishlistScreen(), 'title': 'Wishlist Screen'},
   {'page': const UserScreen(), 'title': 'User Screen'},
  ];

  void selectedPage(int index){
setState(() {
  _selectedIndex = index;
});
}
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    return Scaffold(
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _isDark ? Theme.of(context).cardColor : Colors.white,
        unselectedItemColor: _isDark ? Colors.white10 : Colors.black12,
        selectedItemColor: _isDark ? Colors.lightBlue[200] : Colors.black87 ,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: selectedPage,
        currentIndex: _selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
              label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 1 ? IconlyBold.category : IconlyLight.category),
              label: 'Categories'
          ),
         /* BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 2 ? IconlyBold.heart : IconlyLight.heart),
              label: 'Wishlist'
          ),*/
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2),
              label: 'User'
          )
        ],
      ),
    );
  }
}
