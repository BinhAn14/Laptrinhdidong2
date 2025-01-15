import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Thêm lớp học
  Future<void> addLopHoc(String maLop, String tenLop, int siSo) async {
    await _db.collection('lop_hoc').add({
      'maLop': maLop,
      'tenLop': tenLop,
      'siSo': siSo,
    });
  }

  // Cập nhật lớp học
  Future<void> updateLopHoc(
      String docID, String maLop, String tenLop, int siSo) async {
    await _db.collection('lop_hoc').doc(docID).update({
      'maLop': maLop,
      'tenLop': tenLop,
      'siSo': siSo,
    });
  }

  // Xóa lớp học
  Future<void> deleteLopHoc(String docID) async {
    await _db.collection('lop_hoc').doc(docID).delete();
  }

  // Lấy dữ liệu các lớp học
  Stream<QuerySnapshot> getLopHocStream() {
    return _db.collection('lop_hoc').snapshots();
  }

  // Lấy thông tin lớp học theo docID
  Future<Map<String, dynamic>?> getLopHocByID(String docID) async {
    DocumentSnapshot docSnapshot =
        await _db.collection('lop_hoc').doc(docID).get();

    if (docSnapshot.exists) {
      return docSnapshot.data() as Map<String, dynamic>?;
    }
    return null;
  }
}
