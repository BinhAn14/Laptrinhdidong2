import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import 'login_screen.dart';
import 'school_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();
    final FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách trường học'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          TextEditingController nameController = TextEditingController();
          TextEditingController addressController = TextEditingController();
          TextEditingController phoneController = TextEditingController();

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Thêm Trường Học'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(labelText: 'Tên Trường')),
                    TextField(
                        controller: addressController,
                        decoration:
                            const InputDecoration(labelText: 'Địa chỉ')),
                    TextField(
                        controller: phoneController,
                        decoration:
                            const InputDecoration(labelText: 'Số điện thoại')),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      firestoreService.addSchool(nameController.text,
                          addressController.text, phoneController.text);
                      Navigator.pop(context);
                    },
                    child: const Text('Thêm'),
                  ),
                ],
              );
            },
          );
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getSchools(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final schools = snapshot.data!.docs;

          return ListView.builder(
            itemCount: schools.length,
            itemBuilder: (context, index) {
              var school = schools[index];

              return ListTile(
                title: Text(school['name']),
                subtitle: Text(school['address']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        TextEditingController nameController =
                            TextEditingController(text: school['name']);
                        TextEditingController addressController =
                            TextEditingController(text: school['address']);
                        TextEditingController phoneController =
                            TextEditingController(text: school['phone']);

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Chỉnh sửa Trường Học'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                        labelText: 'Tên Trường'),
                                  ),
                                  TextField(
                                    controller: addressController,
                                    decoration: const InputDecoration(
                                        labelText: 'Địa chỉ'),
                                  ),
                                  TextField(
                                    controller: phoneController,
                                    decoration: const InputDecoration(
                                        labelText: 'Số điện thoại'),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Hủy'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    firestoreService.updateSchool(
                                      school.id,
                                      nameController.text,
                                      addressController.text,
                                      phoneController.text,
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Lưu'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => firestoreService.deleteSchool(school.id),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SchoolScreen(school.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
