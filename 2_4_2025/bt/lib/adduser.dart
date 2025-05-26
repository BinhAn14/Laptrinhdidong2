import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'user_model.dart';
import 'user_service.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _avatarController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final UserService userService = UserService();

  void _addUser() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _avatarController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _phoneNumberController.text.isEmpty) return;

    final newUser = UserModel(
      id: Uuid().v4(),
      name: _nameController.text,
      email: _emailController.text,
      age: int.parse(_ageController.text),
      avatarUrl: _avatarController.text,
      address: _addressController.text,
      phoneNumber: _phoneNumberController.text,
    );

    await userService.addUser(newUser);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thêm người dùng")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Tên"),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: "Tuổi"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _avatarController,
              decoration: InputDecoration(labelText: "Avatar URL"),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: "Địa chỉ"),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: "Số điện thoại"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addUser,
              child: Text("Thêm người dùng"),
            ),
          ],
        ),
      ),
    );
  }
}
