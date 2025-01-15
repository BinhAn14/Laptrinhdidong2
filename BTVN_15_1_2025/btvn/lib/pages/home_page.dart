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
  final TextEditingController _maLopController = TextEditingController();
  final TextEditingController _tenLopController = TextEditingController();
  final TextEditingController _siSoController = TextEditingController();
  String? currentDocID;

  // Hàm thêm lớp học
  void _addLopHoc() {
    firestoreService
        .addLopHoc(
      _maLopController.text,
      _tenLopController.text,
      int.parse(_siSoController.text),
    )
        .then((_) {
      Navigator.pop(context);
      _clearTextFields();
    });
  }

  // Hàm cập nhật lớp học
  void _updateLopHoc() {
    if (currentDocID != null) {
      firestoreService
          .updateLopHoc(
        currentDocID!,
        _maLopController.text,
        _tenLopController.text,
        int.parse(_siSoController.text),
      )
          .then((_) {
        Navigator.pop(context);
        _clearTextFields();
      });
    }
  }

  // Hàm xóa lớp học
  void _deleteLopHoc(String docID) {
    firestoreService.deleteLopHoc(docID);
  }

  void _clearTextFields() {
    _maLopController.clear();
    _tenLopController.clear();
    _siSoController.clear();
  }

  void _showDialog({String? docID}) {
    currentDocID = docID;
    if (docID != null) {
      firestoreService.getLopHocByID(docID).then((data) {
        if (data != null) {
          _maLopController.text = data['maLop'];
          _tenLopController.text = data['tenLop'];
          _siSoController.text = data['siSo'].toString();
        }
      });
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(docID == null ? "Thêm Lớp Học" : "Cập Nhật Lớp Học"),
        content: Column(
          children: [
            TextField(
              controller: _maLopController,
              decoration: const InputDecoration(labelText: "Mã lớp"),
            ),
            TextField(
              controller: _tenLopController,
              decoration: const InputDecoration(labelText: "Tên lớp"),
            ),
            TextField(
              controller: _siSoController,
              decoration: const InputDecoration(labelText: "Sĩ số"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: docID == null ? _addLopHoc : _updateLopHoc,
            child: Text(docID == null ? "Thêm" : "Cập Nhật"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý Lớp Học"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getLopHocStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Không có lớp học"));
          }
          var lopHocList = snapshot.data!.docs;
          return ListView.builder(
            itemCount: lopHocList.length,
            itemBuilder: (context, index) {
              var doc = lopHocList[index];
              String docID = doc.id;
              var data = doc.data() as Map<String, dynamic>;
              String maLop = data['maLop'];
              String tenLop = data['tenLop'];
              int siSo = data['siSo'];

              return ListTile(
                title: Text(tenLop),
                subtitle: Text('Mã lớp: $maLop, Sĩ số: $siSo'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showDialog(docID: docID),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteLopHoc(docID),
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
