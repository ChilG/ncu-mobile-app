import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_firebase/models/student.dart';

class FirebaseService {
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('students');

  Stream<List<Student>> getStudents() {
    return _studentsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Student.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addStudent(Student student) async {
    try {
      await _studentsCollection.add(student.toMap());
    } catch (e) {
      throw Exception('Failed to add student: $e');
    }
  }

  Future<void> updateStudent(Student student) async {
    try {
      await _studentsCollection.doc(student.id).update(student.toMap());
    } catch (e) {
      throw Exception('Failed to update student: $e');
    }
  }

  Future<void> deleteStudent(Student student) async {
    try {
      await _studentsCollection.doc(student.id).delete();
    } catch (e) {
      throw Exception('Failed to delete student: $e');
    }
  }
}
