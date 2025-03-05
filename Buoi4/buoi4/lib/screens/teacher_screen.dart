import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class TeacherScreen extends StatelessWidget {
  final String schoolId;
  const TeacherScreen(this.schoolId, {super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách Giáo viên')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showTeacherDialog(context, firestoreService, schoolId);
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getTeachers(schoolId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final teachers = snapshot.data!.docs;
          return ListView.builder(
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              var teacher = teachers[index];
              return ListTile(
                title: Text(teacher['name']),
                subtitle: Text(teacher['subject']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _showTeacherDialog(context, firestoreService, schoolId,
                            teacherId: teacher.id,
                            currentName: teacher['name'],
                            currentEmail: teacher['email'],
                            currentSubject: teacher['subject']);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _confirmDelete(
                            context, firestoreService, schoolId, teacher.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Hiển thị dialog thêm/sửa giáo viên
  void _showTeacherDialog(
      BuildContext context, FirestoreService firestoreService, String schoolId,
      {String? teacherId,
      String? currentName,
      String? currentEmail,
      String? currentSubject}) {
    TextEditingController nameController =
        TextEditingController(text: currentName ?? "");
    TextEditingController emailController =
        TextEditingController(text: currentEmail ?? "");
    TextEditingController subjectController =
        TextEditingController(text: currentSubject ?? "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              teacherId == null ? 'Thêm Giáo viên' : 'Chỉnh sửa Giáo viên'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Tên')),
              TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email')),
              TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(labelText: 'Môn dạy')),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (teacherId == null) {
                  firestoreService.addTeacher(schoolId, nameController.text,
                      emailController.text, subjectController.text);
                } else {
                  firestoreService.updateTeacher(
                      schoolId,
                      teacherId,
                      nameController.text,
                      emailController.text,
                      subjectController.text);
                }
                Navigator.pop(context);
              },
              child: Text(teacherId == null ? 'Thêm' : 'Lưu'),
            ),
          ],
        );
      },
    );
  }

  // Xác nhận xóa giáo viên
  void _confirmDelete(BuildContext context, FirestoreService firestoreService,
      String schoolId, String teacherId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc muốn xóa giáo viên này không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                firestoreService.deleteTeacher(schoolId, teacherId);
                Navigator.pop(context);
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}
