import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class StudentScreen extends StatefulWidget {
  final String schoolId;
  const StudentScreen({super.key, required this.schoolId});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController classController = TextEditingController();

  void showStudentDialog(
      {String? docId, String? name, int? age, String? studentClass}) {
    nameController.text = name ?? '';
    ageController.text = age?.toString() ?? '';
    classController.text = studentClass ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(docId == null ? "Thêm Học Sinh" : "Cập Nhật Học Sinh"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Tên Học Sinh"),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: "Tuổi"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: classController,
              decoration: const InputDecoration(labelText: "Lớp"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docId == null) {
                firestoreService.addStudent(
                  widget.schoolId,
                  nameController.text,
                  int.parse(ageController.text),
                  classController.text,
                );
              } else {
                FirebaseFirestore.instance
                    .collection('schools')
                    .doc(widget.schoolId)
                    .collection('students')
                    .doc(docId)
                    .update({
                  'name': nameController.text,
                  'age': int.parse(ageController.text),
                  'class': classController.text,
                });
              }
              nameController.clear();
              ageController.clear();
              classController.clear();
              Navigator.pop(context);
            },
            child: Text(docId == null ? "Thêm" : "Cập Nhật"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Danh Sách Học Sinh")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showStudentDialog(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getStudents(widget.schoolId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var students = snapshot.data!.docs;
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              var student = students[index];
              var data = student.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['name']),
                subtitle: Text("Tuổi: ${data['age']}, Lớp: ${data['class']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => showStudentDialog(
                        docId: student.id,
                        name: data['name'],
                        age: data['age'],
                        studentClass: data['class'],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => student.reference.delete(),
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
}
