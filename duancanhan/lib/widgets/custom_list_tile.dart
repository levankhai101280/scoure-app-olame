import 'package:flutter/material.dart';
import '../utils/navigation.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Widget destination;

  CustomListTile({
    required this.icon,
    required this.text,
    required this.color,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () => navigateTo(context, destination),
    );
  }
}
