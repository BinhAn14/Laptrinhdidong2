import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController classIDController = TextEditingController();
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController studentCountController = TextEditingController();

  void _clearControllers() {
    classIDController.clear();
    classNameController.clear();
    studentCountController.clear();
  }

  // Hộp thoại thêm hoặc cập nhật lớp học
  void openClassBox(
      {String? docID,
      String? initialClassID,
      String? initialClassName,
      int? initialStudentCount}) {
    if (docID != null) {
      classIDController.text = initialClassID ?? '';
      classNameController.text = initialClassName ?? '';
      studentCountController.text = initialStudentCount?.toString() ?? '';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(docID == null ? "Thêm Lớp Học" : "Cập Nhật Lớp Học"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: classIDController,
              decoration: const InputDecoration(labelText: "Mã Lớp"),
            ),
            TextField(
              controller: classNameController,
              decoration: const InputDecoration(labelText: "Tên Lớp"),
            ),
            TextField(
              controller: studentCountController,
              decoration: const InputDecoration(labelText: "Sĩ Số"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                // Thêm mới
                firestoreService.addClass(
                  classIDController.text,
                  classNameController.text,
                  int.parse(studentCountController.text),
                );
              } else {
                // Cập nhật
                firestoreService.updateClass(
                  docID,
                  classIDController.text,
                  classNameController.text,
                  int.parse(studentCountController.text),
                );
              }
              _clearControllers();
              Navigator.pop(context);
            },
            child: Text(docID == null ? "Thêm" : "Cập Nhật"),
          ),
          TextButton(
            onPressed: () {
              _clearControllers();
              Navigator.pop(context);
            },
            child: const Text("Hủy"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản Lý Lớp Học")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openClassBox(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getClassesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Chưa có lớp học nào..."));
          }
          var classList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: classList.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = classList[index];
              String docID = document.id;

              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String classID = data['classID'];
              String className = data['className'];
              int studentCount = data['studentCount'];

              return ListTile(
                title: Text(className),
                subtitle: Text("Mã lớp: $classID, Sĩ số: $studentCount"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Cập nhật
                    IconButton(
                      onPressed: () => openClassBox(
                        docID: docID,
                        initialClassID: classID,
                        initialClassName: className,
                        initialStudentCount: studentCount,
                      ),
                      icon: const Icon(Icons.edit),
                    ),
                    // Xóa
                    IconButton(
                      onPressed: () => firestoreService.deleteClass(docID),
                      icon: const Icon(Icons.delete),
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
