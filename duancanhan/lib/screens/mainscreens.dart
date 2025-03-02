import 'package:duancanhan/screens/contacts_screen.dart';
import 'package:duancanhan/screens/explore_screen.dart';
import 'package:duancanhan/screens/message_screen.dart';
import 'package:duancanhan/screens/profile_screen.dart';
import 'package:duancanhan/screens/walk_screen.dart';
import 'package:flutter/material.dart';
import 'package:duancanhan/screens/message_screen.dart';
import 'package:duancanhan/screens/explore_screen.dart';
import 'package:duancanhan/screens/walk_screen.dart';
import 'package:duancanhan/screens/contacts_screen.dart';
import 'package:duancanhan/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    MessageScreen(),
    ExploreScreen(),
    WalkScreen(),
    ContactsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Tin Nhắn"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Khám Phá"),
          BottomNavigationBarItem(icon: Icon(Icons.directions_walk), label: "Đi Dạo"),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: "Danh Bạ"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Hồ Sơ"),
        ],
      ),
    );
  }
}
