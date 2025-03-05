import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import 'teacher_screen.dart';
import 'student_screen.dart';

class SchoolScreen extends StatelessWidget {
  final String schoolId;
  const SchoolScreen(this.schoolId, {super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết Trường Học')),
      body: Column(
        children: [
          ListTile(
            title: const Text('Giáo viên'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TeacherScreen(schoolId))),
          ),
          ListTile(
            title: const Text('Học sinh'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StudentScreen(schoolId: schoolId))),
          ),
        ],
      ),
    );
  }
}
