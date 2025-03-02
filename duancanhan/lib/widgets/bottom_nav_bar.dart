import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.message), label: "Tin Nhắn"),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Khám Phá"),
        BottomNavigationBarItem(icon: Icon(Icons.directions_walk), label: "Đi Dạo"),
        BottomNavigationBarItem(icon: Icon(Icons.contacts), label: "Danh Bạ"),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Hồ Sơ"),
      ],
    );
  }
}
