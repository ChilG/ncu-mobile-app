import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String studentId;
  final String name;
  final String major;
  final double gpa;
  final String imageUrl;
  final DateTime createdAt;

  Student({
    required this.id,
    required this.studentId,
    required this.name,
    required this.major,
    required this.gpa,
    required this.imageUrl,
    required this.createdAt,
  });

  factory Student.fromMap(Map<String, dynamic> map, String documentId) {
    return Student(
      id: documentId,
      studentId: map['studentId'] ?? '',
      name: map['name'] ?? '',
      major: map['major'] ?? '',
      gpa: (map['gpa'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'name': name,
      'major': major,
      'gpa': gpa,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }

  Student copyWith({
    String? id,
    String? studentId,
    String? name,
    String? major,
    double? gpa,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return Student(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      name: name ?? this.name,
      major: major ?? this.major,
      gpa: gpa ?? this.gpa,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
