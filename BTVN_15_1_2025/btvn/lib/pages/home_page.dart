import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _TrangChuState();
}

class _TrangChuState extends State<HomePage> {
  final DichVuFirestore dichVuFirestore = DichVuFirestore();
  final TextEditingController maLopController = TextEditingController();
  final TextEditingController tenLopController = TextEditingController();
  final TextEditingController siSoController = TextEditingController();

  void moHopThoai({
    String? maTaiLieu,
    String? maLopHienTai,
    String? tenLopHienTai,
    int? siSoHienTai,
  }) {
    if (maTaiLieu != null) {
      maLopController.text = maLopHienTai ?? '';
      tenLopController.text = tenLopHienTai ?? '';
      siSoController.text = siSoHienTai?.toString() ?? '';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(maTaiLieu == null ? "Thêm Lớp Học" : "Cập Nhật Lớp Học"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: maLopController,
              decoration: const InputDecoration(labelText: "Mã Lớp"),
            ),
            TextField(
              controller: tenLopController,
              decoration: const InputDecoration(labelText: "Tên Lớp"),
            ),
            TextField(
              controller: siSoController,
              decoration: const InputDecoration(labelText: "Sĩ Số"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (maTaiLieu == null) {
                dichVuFirestore.themLopHoc(
                  maLopController.text,
                  tenLopController.text,
                  int.parse(siSoController.text),
                );
              } else {
                dichVuFirestore.capNhatLopHoc(
                  maTaiLieu,
                  maLopController.text,
                  tenLopController.text,
                  int.parse(siSoController.text),
                );
              }
              _xoaNoiDungController();
              Navigator.pop(context);
            },
            child: Text(maTaiLieu == null ? "Thêm" : "Cập Nhật"),
          ),
          TextButton(
            onPressed: () {
              _xoaNoiDungController();
              Navigator.pop(context);
            },
            child: const Text("Hủy"),
          ),
        ],
      ),
    );
  }

  void _xoaNoiDungController() {
    maLopController.clear();
    tenLopController.clear();
    siSoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản Lý Lớp Học")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => moHopThoai(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: dichVuFirestore.layDanhSachLopHoc(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List danhSachLop = snapshot.data!.docs;

            return ListView.builder(
              itemCount: danhSachLop.length,
              itemBuilder: (context, index) {
                DocumentSnapshot taiLieu = danhSachLop[index];
                String maTaiLieu = taiLieu.id;

                Map<String, dynamic> duLieu =
                    taiLieu.data() as Map<String, dynamic>;
                String maLop = duLieu['maLop'];
                String tenLop = duLieu['tenLop'];
                int siSo = duLieu['siSo'];

                return ListTile(
                  title: Text(tenLop),
                  subtitle: Text("Mã Lớp: $maLop, Sĩ Số: $siSo"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => moHopThoai(
                          maTaiLieu: maTaiLieu,
                          maLopHienTai: maLop,
                          tenLopHienTai: tenLop,
                          siSoHienTai: siSo,
                        ),
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => dichVuFirestore.xoaLopHoc(maTaiLieu),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Chưa có lớp học nào..."));
          }
        },
      ),
    );
  }
}
