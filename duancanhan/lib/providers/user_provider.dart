import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel(
    name: "Văn Khải",
    avatar: "assets/profile.jpg",
    coins: 0,
  );

  UserModel get user => _user;

  void updateAvatar(String newAvatar) {
    _user = UserModel(name: _user.name, avatar: newAvatar, coins: _user.coins);
    notifyListeners();
  }

  void addCoins(int amount) {
    _user = UserModel(name: _user.name, avatar: _user.avatar, coins: _user.coins + amount);
    notifyListeners();
  }
}
