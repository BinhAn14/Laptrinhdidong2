import 'package:cloud_firestore/cloud_firestore.dart';

class DichVuFirestore {
  final CollectionReference lopHocCollection =
      FirebaseFirestore.instance.collection('lop_hoc');

  // Thêm lớp học
  Future<void> themLopHoc(String maLop, String tenLop, int siSo) {
    return lopHocCollection.add({
      'maLop': maLop,
      'tenLop': tenLop,
      'siSo': siSo,
      'thoiGian': Timestamp.now(),
    });
  }

  // Lấy danh sách lớp học
  Stream<QuerySnapshot> layDanhSachLopHoc() {
    return lopHocCollection.orderBy("thoiGian", descending: true).snapshots();
  }

  // Cập nhật lớp học
  Future<void> capNhatLopHoc(
      String maTaiLieu, String maLopMoi, String tenLopMoi, int siSoMoi) {
    return lopHocCollection.doc(maTaiLieu).update({
      'maLop': maLopMoi,
      'tenLop': tenLopMoi,
      'siSo': siSoMoi,
      'thoiGian': Timestamp.now(),
    });
  }

  // Xóa lớp học
  Future<void> xoaLopHoc(String maTaiLieu) {
    return lopHocCollection.doc(maTaiLieu).delete();
  }
}
