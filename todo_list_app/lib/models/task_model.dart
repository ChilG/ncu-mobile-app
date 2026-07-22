import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime? createdAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.createdAt,
  });

  /// Factory constructor to build a TaskModel from a Firestore DocumentSnapshot
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final timestamp = data['createdAt'] as Timestamp?;
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdAt: timestamp?.toDate(),
    );
  }

  /// Converts the TaskModel instance to a Map for Firestore write operations
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
