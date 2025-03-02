import 'package:duancanhan/screens/mainscreens.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:duancanhan/screens/profile_screen.dart';
import 'package:duancanhan/screens/mainscreens.dart';
import 'dart:convert';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();

  String fullName = '';
  String email = '';
  String phoneNumber = '';
  String password = '';
  String confirmPassword = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Kiểm tra xem có người dùng đã đăng nhập không
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedUser = prefs.getString('loggedInUser');

    if (savedUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  void _toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final prefs = await SharedPreferences.getInstance();

      // Lấy danh sách tài khoản từ SharedPreferences (nếu có)
      List<String> accountsData = prefs.getStringList('accounts') ?? [];
      List<Map<String, String>> accounts = accountsData
          .map((e) => Map<String, String>.from(jsonDecode(e)))
          .toList();

      if (isLogin) {
        // Kiểm tra tài khoản trong danh sách
        bool found = false;
        Map<String, dynamic>? loggedInUser;
        for (var account in accounts) {
          if (account['email'] == email && account['password'] == password) {
            found = true;
            loggedInUser = account;
            prefs.setString('loggedInUser', jsonEncode(account)); // Lưu tài khoản đã đăng nhập
            break;
          }
        }

        if (found) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Sai email hoặc mật khẩu!")),
          );
        }
      } else {
        // Kiểm tra xem email đã tồn tại chưa
        bool emailExists = accounts.any((acc) => acc['email'] == email);

        if (emailExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Email đã tồn tại!")),
          );
        } else {
          // Thêm tài khoản mới vào danh sách
          Map<String, String> newAccount = {
            'fullName': fullName,
            'email': email,
            'phoneNumber': phoneNumber,
            'password': password,
            'profileImagePath': ''
          };

          accounts.add(newAccount);

          // Lưu danh sách tài khoản vào SharedPreferences
          prefs.setStringList(
              'accounts', accounts.map((acc) => jsonEncode(acc)).toList());

          // Lưu tài khoản đăng nhập hiện tại
          prefs.setString('loggedInUser', jsonEncode(newAccount));

          // Chuyển sang màn hình MainScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isLogin ? "Đăng Nhập" : "Đăng Ký"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isLogin)
                  TextFormField(
                    decoration: InputDecoration(labelText: "Họ và Tên"),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 3) {
                        return 'Vui lòng nhập tên hợp lệ';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      fullName = value;
                    },
                  ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    email = value;
                  },
                ),
                SizedBox(height: 10),
                if (!isLogin)
                  TextFormField(
                    decoration: InputDecoration(labelText: "Số điện thoại"),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 10) {
                        return 'Số điện thoại không hợp lệ';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      phoneNumber = value;
                    },
                  ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: "Mật khẩu"),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    password = value;
                  },
                ),
                SizedBox(height: 10),
                if (!isLogin)
                  TextFormField(
                    decoration: InputDecoration(labelText: "Xác nhận Mật khẩu"),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty || value != password) {
                        return 'Mật khẩu không khớp';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      confirmPassword = value;
                    },
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  onPressed: _submitForm,
                  child: Text(isLogin ? "Đăng Nhập" : "Đăng Ký", style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: _toggleAuthMode,
                  child: Text(isLogin ? "Chưa có tài khoản? Đăng ký" : "Đã có tài khoản? Đăng nhập"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}