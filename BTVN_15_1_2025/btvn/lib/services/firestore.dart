import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference classes =
      FirebaseFirestore.instance.collection('classes');

  // CREATE: Thêm lớp học
  Future<void> addClass(String classID, String className, int studentCount) {
    return classes.add({
      'classID': classID,
      'className': className,
      'studentCount': studentCount,
      'timestamp': Timestamp.now(),
    });
  }

  // READ: Lấy danh sách lớp học
  Stream<QuerySnapshot> getClassesStream() {
    return classes.orderBy("timestamp", descending: true).snapshots();
  }

  // UPDATE: Cập nhật thông tin lớp học
  Future<void> updateClass(String docID, String newClassID, String newClassName,
      int newStudentCount) {
    return classes.doc(docID).update({
      'classID': newClassID,
      'className': newClassName,
      'studentCount': newStudentCount,
      'timestamp': Timestamp.now(),
    });
  }

  // DELETE: Xóa lớp học
  Future<void> deleteClass(String docID) {
    return classes.doc(docID).delete();
  }
}
