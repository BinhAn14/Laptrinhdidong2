import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSinhVien {
  final CollectionReference sinhVienCollection =
      FirebaseFirestore.instance.collection('sinh_vien');
  final CollectionReference lopHocCollection =
      FirebaseFirestore.instance.collection('lop_hoc');

  Future<void> themSinhVien(String ten, int tuoi, String tenLop) {
    return sinhVienCollection.add({
      'tenSinhVien': ten,
      'tuoi': tuoi,
      'tenLop': tenLop,
      'thoiGian': Timestamp.now(),
    });
  }

  // Lấy danh sách sinh viên
  Stream<QuerySnapshot> layDanhSachSinhVien() {
    return sinhVienCollection.orderBy("thoiGian", descending: true).snapshots();
  }

  // Cập nhật sinh viên
  Future<void> capNhatSinhVien(
      String docID, String ten, int tuoi, String tenLop) {
    return sinhVienCollection.doc(docID).update({
      'tenSinhVien': ten,
      'tuoi': tuoi,
      'tenLop': tenLop,
    });
  }

  // Xóa sinh viên
  Future<void> xoaSinhVien(String docID) {
    return sinhVienCollection.doc(docID).delete();
  }

  // Lấy danh sách lớp học (tên lớp)
  Stream<QuerySnapshot> layDanhSachLopHoc() {
    return lopHocCollection.orderBy("thoiGian", descending: true).snapshots();
  }
}
