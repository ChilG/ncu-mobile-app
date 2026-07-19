import 'package:flutter/material.dart';
import 'package:student_firebase/models/student.dart';
import 'package:student_firebase/screens/student_detail_screen.dart';

class StudentCard extends StatelessWidget {
  final Student student;

  const StudentCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
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

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentDetailScreen(student: student),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Hero(
                  tag: 'avatar-${student.id}',
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: const Color(0x266366F1),
                    child: CircleAvatar(
                      radius: 33,
                      backgroundColor: const Color(0xFFEEF2F6),
                      child: ClipOval(
                        child: student.imageUrl.isNotEmpty
                            ? Image.network(
                                student.imageUrl,
                                width: 66,
                                height: 66,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.person, size: 30, color: Colors.grey),
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF6366F1),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Icon(Icons.person, size: 30, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          student.studentId,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.school_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              student.major,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: gpaColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        student.gpa.toStringAsFixed(2),
                        style: TextStyle(
                          color: gpaColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'GPA',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
