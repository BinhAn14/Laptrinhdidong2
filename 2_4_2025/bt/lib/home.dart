import 'package:flutter/material.dart';
import 'user_model.dart';
import 'user_service.dart';
import 'adduser.dart';

class UserListScreen extends StatelessWidget {
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách người dùng")),
      body: StreamBuilder<List<UserModel>>(
        stream: userService.getUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatarUrl),
                ),
                title: Text(user.name),
                subtitle: Text("Email: ${user.email} - Tuổi: ${user.age}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _editUser(context, user);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await userService.deleteUser(user.id);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  // Navigate to the User Detail Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailScreen(user: user),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUserScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _editUser(BuildContext context, UserModel user) {
    TextEditingController nameController =
        TextEditingController(text: user.name);
    TextEditingController emailController =
        TextEditingController(text: user.email);
    TextEditingController ageController =
        TextEditingController(text: user.age.toString());
    TextEditingController avatarController =
        TextEditingController(text: user.avatarUrl);
    TextEditingController addressController =
        TextEditingController(text: user.address);
    TextEditingController phoneController =
        TextEditingController(text: user.phoneNumber);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Chỉnh sửa người dùng"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Tên")),
            TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email")),
            TextField(
                controller: ageController,
                decoration: InputDecoration(labelText: "Tuổi")),
            TextField(
                controller: avatarController,
                decoration: InputDecoration(labelText: "Avatar URL")),
            TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: "Địa chỉ")),
            TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "Số điện thoại")),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Hủy")),
          ElevatedButton(
            onPressed: () async {
              await userService.updateUser(user.id, {
                "name": nameController.text,
                "email": emailController.text,
                "age": int.parse(ageController.text),
                "avatarUrl": avatarController.text,
                "address": addressController.text,
                "phoneNumber": phoneController.text,
              });
              Navigator.pop(context);
            },
            child: Text("Lưu"),
          ),
        ],
      ),
    );
  }
}

class UserDetailScreen extends StatelessWidget {
  final UserModel user;

  UserDetailScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${user.name} - Chi tiết")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.avatarUrl),
              radius: 50,
            ),
            SizedBox(height: 16),
            Text("Tên: ${user.name}", style: TextStyle(fontSize: 18)),
            Text("Email: ${user.email}", style: TextStyle(fontSize: 18)),
            Text("Tuổi: ${user.age}", style: TextStyle(fontSize: 18)),
            Text("Địa chỉ: ${user.address}", style: TextStyle(fontSize: 18)),
            Text("Số điện thoại: ${user.phoneNumber}",
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
