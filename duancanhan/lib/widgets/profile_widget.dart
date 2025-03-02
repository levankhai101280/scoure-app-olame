import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfileWidget extends StatelessWidget {
  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      context.read<UserProvider>().updateAvatar(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 5),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _pickImage(context),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(user.avatar),
            ),
          ),
          SizedBox(height: 10),
          Text(user.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("Bấm để xem trang cá nhân", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 5),
          Text("Xu: ${user.coins}", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () => context.read<UserProvider>().addCoins(10),
            child: Text("Nạp 10 Xu", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
