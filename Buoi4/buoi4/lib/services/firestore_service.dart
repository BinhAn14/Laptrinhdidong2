import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 📌 Trường học
  Stream<QuerySnapshot> getSchools() {
    return _db.collection('schools').snapshots();
  }

  Future<void> addSchool(String name, String address, String phone) async {
    await _db
        .collection('schools')
        .add({'name': name, 'address': address, 'phone': phone});
  }

  Future<void> updateSchool(
      String id, String name, String address, String phone) async {
    await _db
        .collection('schools')
        .doc(id)
        .update({'name': name, 'address': address, 'phone': phone});
  }

  Future<void> deleteSchool(String id) async {
    await _db.collection('schools').doc(id).delete();
  }

  // 📌 Giáo viên
  Stream<QuerySnapshot> getTeachers(String schoolId) {
    return _db
        .collection('schools')
        .doc(schoolId)
        .collection('teachers')
        .snapshots();
  }

  Future<void> addTeacher(
      String schoolId, String name, String email, String subject) async {
    await _db
        .collection('schools')
        .doc(schoolId)
        .collection('teachers')
        .add({'name': name, 'email': email, 'subject': subject});
  }

  Future<void> updateTeacher(String schoolId, String teacherId, String name,
      String email, String subject) async {
    await _db
        .collection('schools')
        .doc(schoolId)
        .collection('teachers')
        .doc(teacherId)
        .update({
      'name': name,
      'email': email,
      'subject': subject,
    });
  }

  Future<void> deleteTeacher(String schoolId, String teacherId) async {
    await _db
        .collection('schools')
        .doc(schoolId)
        .collection('teachers')
        .doc(teacherId)
        .delete();
  }

  // 📌 Học sinh
  Future<void> addStudent(
      String schoolId, String name, int age, String studentClass) async {
    await _db.collection('students').add({
      'schoolId': schoolId,
      'name': name,
      'age': age,
      'class': studentClass,
    });
  }

  Future<void> updateStudent(String studentId, String schoolId, String name,
      int age, String studentClass) async {
    await _db.collection('students').doc(studentId).update({
      'schoolId': schoolId,
      'name': name,
      'age': age,
      'class': studentClass,
    });
  }

  Stream<QuerySnapshot> getStudents(String schoolId) {
    return _db
        .collection('students')
        .where('schoolId', isEqualTo: schoolId)
        .snapshots();
  }

  Future<void> deleteStudent(String schoolId, String studentId) async {
    await _db
        .collection('schools')
        .doc(schoolId)
        .collection('students')
        .doc(studentId)
        .delete();
  }
}
