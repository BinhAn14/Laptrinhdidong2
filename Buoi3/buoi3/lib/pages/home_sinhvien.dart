import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_sinhvien.dart';

class HomeSinhVien extends StatefulWidget {
  const HomeSinhVien({super.key});

  @override
  State<HomeSinhVien> createState() => _HomeSinhVienState();
}

class _HomeSinhVienState extends State<HomeSinhVien> {
  final FirestoreSinhVien firestoreSinhVien = FirestoreSinhVien();
  final TextEditingController tenController = TextEditingController();
  final TextEditingController tuoiController = TextEditingController();
  String? tenLopDuocChon;

  void moHopThoai(
      {String? docID, String? tenBanDau, int? tuoiBanDau, String? tenLop}) {
    tenController.text = tenBanDau ?? '';
    tuoiController.text = tuoiBanDau?.toString() ?? '';
    tenLopDuocChon = tenLop;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(docID == null ? "Thêm Sinh Viên" : "Cập Nhật Sinh Viên"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tenController,
              decoration: const InputDecoration(labelText: "Tên Sinh Viên"),
            ),
            TextField(
              controller: tuoiController,
              decoration: const InputDecoration(labelText: "Tuổi"),
              keyboardType: TextInputType.number,
            ),
            // Dropdown chọn lớp học
            StreamBuilder<QuerySnapshot>(
              stream: firestoreSinhVien.layDanhSachLopHoc(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                List<DocumentSnapshot> lopHocList = snapshot.data!.docs;
                return DropdownButton<String>(
                  value: tenLopDuocChon,
                  hint: const Text("Chọn Lớp"),
                  onChanged: (String? newValue) {
                    setState(() {
                      tenLopDuocChon = newValue!;
                    });
                  },
                  items: lopHocList.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return DropdownMenuItem<String>(
                      value: data['tenLop'],
                      child: Text(data['tenLop']),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                firestoreSinhVien.themSinhVien(
                  tenController.text,
                  int.parse(tuoiController.text),
                  tenLopDuocChon!,
                );
              } else {
                firestoreSinhVien.capNhatSinhVien(
                  docID,
                  tenController.text,
                  int.parse(tuoiController.text),
                  tenLopDuocChon!,
                );
              }
              tenController.clear();
              tuoiController.clear();
              Navigator.pop(context);
            },
            child: Text(docID == null ? "Thêm" : "Cập Nhật"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản Lý Sinh Viên")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => moHopThoai(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreSinhVien.layDanhSachSinhVien(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List sinhVienList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: sinhVienList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = sinhVienList[index];
                String docID = document.id;

                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String tenSinhVien = data['tenSinhVien'];
                int tuoi = data['tuoi'];
                String tenLop = data['tenLop'];

                return ListTile(
                  title: Text(tenSinhVien),
                  subtitle: Text("Tuổi: $tuoi, Lớp: $tenLop"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Cập nhật
                      IconButton(
                        onPressed: () => moHopThoai(
                          docID: docID,
                          tenBanDau: tenSinhVien,
                          tuoiBanDau: tuoi,
                          tenLop: tenLop,
                        ),
                        icon: const Icon(Icons.edit),
                      ),
                      // Xóa
                      IconButton(
                        onPressed: () => firestoreSinhVien.xoaSinhVien(docID),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Chưa có sinh viên nào..."));
          }
        },
      ),
    );
  }
}
