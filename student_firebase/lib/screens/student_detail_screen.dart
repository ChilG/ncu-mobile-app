import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_firebase/models/student.dart';
import 'package:student_firebase/services/firebase_service.dart';
import 'package:student_firebase/screens/student_form_screen.dart';
import 'package:student_firebase/widgets/student_detail_row.dart';

class StudentDetailScreen extends StatefulWidget {
  final Student student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _deleteStudent(Student student) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('DELETE', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF6366F1)),
      ),
    );

    try {
      await _firebaseService.deleteStudent(student);
      if (!mounted) return;
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student record deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete student: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('students').doc(widget.student.id).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Color(0xFF6366F1))),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
            body: const Center(
              child: Text(
                'Student record does not exist or has been deleted.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          );
        }

        final studentData = snapshot.data!.data() as Map<String, dynamic>;
        final student = Student.fromMap(studentData, snapshot.data!.id);

        Color gpaColor;
        if (student.gpa >= 3.5) {
          gpaColor = Colors.green;
        } else if (student.gpa >= 2.5) {
          gpaColor = Colors.indigo;
        } else if (student.gpa >= 2.0) {
          gpaColor = Colors.orange;
        } else {
          gpaColor = Colors.redAccent;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 220,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.white24,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 60,
                      child: Text(
                        'Student Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -60,
                      child: Hero(
                        tag: 'avatar-${student.id}',
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 61,
                              backgroundColor: const Color(0xFFEEF2F6),
                              child: ClipOval(
                                child: student.imageUrl.isNotEmpty
                                    ? Image.network(
                                        student.imageUrl,
                                        width: 122,
                                        height: 122,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.person, size: 70, color: Colors.grey),
                                      )
                                    : const Icon(Icons.person, size: 70, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 75),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Text(
                        student.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'ID: ${student.studentId}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Card(
                    elevation: 1,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          StudentDetailRow(
                            icon: Icons.school_outlined,
                            title: 'Major / Department',
                            value: student.major,
                          ),
                          const Divider(height: 32),
                          StudentDetailRow(
                            icon: Icons.grade_outlined,
                            title: 'Cumulative GPA',
                            value: student.gpa.toStringAsFixed(2),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: gpaColor.withAlpha(25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                student.gpa >= 3.5 ? 'Excellent' : (student.gpa >= 2.5 ? 'Good' : 'Average'),
                                style: TextStyle(
                                  color: gpaColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const Divider(height: 32),
                          StudentDetailRow(
                            icon: Icons.calendar_today_outlined,
                            title: 'Registration Date',
                            value: '${student.createdAt.day}/${student.createdAt.month}/${student.createdAt.year}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _deleteStudent(student),
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          label: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.redAccent, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentFormScreen(student: student),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit_outlined, color: Colors.white),
                          label: const Text('Edit Details', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
