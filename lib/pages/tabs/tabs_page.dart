import 'package:flutter/material.dart';
import 'package:top_movies/pages/home/home_page.dart';
import 'package:top_movies/pages/search/search_page.dart';
import 'package:top_movies/utils/strings.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedScreenIndex = 0;
  List<Map<String, Object>> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens = [
      {
        "title": Strings.homePageTitle,
        "screen": HomePage(),
      },
      {
        "title": Strings.searchTitle,
        "screen": SearchPage(),
      },
    ];
  }

  _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedScreenIndex]['screen'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectScreen,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
        currentIndex: _selectedScreenIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.collections),
            label: Strings.homePageTitle,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_rounded),
            label: Strings.searchTitle,
          ),
        ],
      ),
    );
  }
}
