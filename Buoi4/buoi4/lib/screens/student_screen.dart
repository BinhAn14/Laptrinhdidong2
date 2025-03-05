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
  String? selectedSchoolId; // Lưu trạng thái trường học được chọn

  void showStudentDialog({
    String? docId,
    String? name,
    int? age,
    String? studentClass,
    String? schoolId,
  }) {
    nameController.text = name ?? '';
    ageController.text = age?.toString() ?? '';
    classController.text = studentClass ?? '';
    selectedSchoolId =
        schoolId ?? widget.schoolId; // Mặc định là trường hiện tại

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title:
                  Text(docId == null ? "Thêm Học Sinh" : "Cập Nhật Học Sinh"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder<QuerySnapshot>(
                    future:
                        FirebaseFirestore.instance.collection('schools').get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      var schools = snapshot.data!.docs;
                      return DropdownButton<String>(
                        value: selectedSchoolId,
                        hint: Text('Chọn trường học'),
                        onChanged: (value) {
                          setDialogState(() {
                            selectedSchoolId = value;
                          });
                        },
                        items: schools.map((school) {
                          return DropdownMenuItem(
                            value: school.id,
                            child: Text(school['name']),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: "Tên Học Sinh"),
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
                    if (selectedSchoolId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Vui lòng chọn trường học")),
                      );
                      return;
                    }

                    if (docId == null) {
                      firestoreService.addStudent(
                        selectedSchoolId!,
                        nameController.text,
                        int.tryParse(ageController.text) ?? 0,
                        classController.text,
                      );
                    } else {
                      firestoreService.updateStudent(
                        docId,
                        selectedSchoolId!,
                        nameController.text,
                        int.parse(ageController.text),
                        classController.text,
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: Text(docId == null ? "Thêm" : "Cập Nhật"),
                ),
              ],
            );
          },
        );
      },
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
        stream: FirebaseFirestore.instance
            .collection('students')
            .where('schoolId', isEqualTo: widget.schoolId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var students = snapshot.data!.docs;

          if (students.isEmpty) {
            return const Center(child: Text("Không có học sinh nào."));
          }

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
                        schoolId: data[
                            'schoolId'], // Thêm schoolId để sửa học sinh đúng trường
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await student.reference.delete();
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
}
