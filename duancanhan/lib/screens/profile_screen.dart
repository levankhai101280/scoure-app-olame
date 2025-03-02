import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:duancanhan/screens/auth_screen.dart';
import 'package:flutter/foundation.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullName = "Người dùng";
  String email = "Chưa cập nhật";
  String? profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('loggedInUser');

    if (userData != null) {
      Map<String, dynamic> user = jsonDecode(userData);
      setState(() {
        fullName = user['fullName'] ?? "Người dùng";
        email = user['email'] ?? "Chưa cập nhật";
        profileImagePath = user['profileImagePath'];
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImagePath = pickedFile.path;
      });

      final prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString('loggedInUser');
      if (userData != null) {
        Map<String, dynamic> user = jsonDecode(userData);
        user['profileImagePath'] = pickedFile.path; // Lưu đường dẫn ảnh theo từng tài khoản
        await prefs.setString('loggedInUser', jsonEncode(user));

        // Cập nhật danh sách tài khoản
        List<String> accountsData = prefs.getStringList('accounts') ?? [];
        List<Map<String, dynamic>> accounts = [];
          if (accountsData != null) {
            try {
              accounts = accountsData.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
            } catch (e) {
              print("Lỗi khi chuyển JSON: $e");
            }
          }
        for (var acc in accounts) {
          if (acc['email'] == email) {
            acc['profileImagePath'] = pickedFile.path;
            break;
          }
        }
        await prefs.setStringList('accounts', accounts.map((acc) => jsonEncode(acc)).toList());
      }
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUser');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: profileImagePath != null && profileImagePath != ''
                            ? kIsWeb
                                ? NetworkImage(profileImagePath!)
                                : FileImage(File(profileImagePath!)) as ImageProvider
                            : AssetImage('assets/avatar.jpg'),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(5),
                          child: Icon(Icons.camera_alt, color: Colors.orange, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(fullName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(email, style: TextStyle(color: Colors.grey)),
                SizedBox(height: 5),
                Text("\$ Xu: 0", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {},
                  child: Text("Nâng cấp VIP", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(Icons.attach_money, "Nạp xu", Colors.orange),
                _buildMenuItem(Icons.notifications, "Thông báo", Colors.blue),
                _buildMenuItem(Icons.emoji_events, "Lịch sử nạp VIP", Colors.orange),
                _buildMenuItem(Icons.lock, "Danh sách chặn", Colors.red),
                _buildMenuItem(Icons.settings, "Cài đặt", Colors.purple),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text("CỘNG ĐỒNG", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                _buildMenuItem(Icons.facebook, "Cộng đồng Facebook", Colors.purple),
                _buildMenuItem(Icons.share, "Chia sẻ app", Colors.blue),
                Divider(),
                _buildMenuItem(Icons.book, "Điều khoản và Điều kiện", Colors.blue),
                _buildMenuItem(Icons.security, "Chính sách bảo mật", Colors.lightBlue),
                Divider(),
                ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.black),
                  title: Text("Đăng xuất"),
                  onTap: _logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color iconColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {},
    );
  }
}
