import 'package:flutter/material.dart';
import 'package:student_firebase/models/student.dart';
import 'package:student_firebase/services/firebase_service.dart';
import 'package:student_firebase/screens/student_form_screen.dart';
import 'package:student_firebase/widgets/student_card.dart';
import 'package:student_firebase/widgets/student_search_bar.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Student Hub',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  StreamBuilder<List<Student>>(
                    stream: _firebaseService.getStudents(),
                    builder: (context, snapshot) {
                      final count = snapshot.data?.length ?? 0;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$count Total',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: const Color(0x14FFFFFF),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      bottom: 40,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0x0DFFFFFF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: StudentSearchBar(
                controller: _searchController,
                showClearButton: _searchQuery.isNotEmpty,
                onClear: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim().toLowerCase();
                  });
                },
              ),
            ),
          ),
          StreamBuilder<List<Student>>(
            stream: _firebaseService.getStudents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF6366F1),
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              final allStudents = snapshot.data ?? [];
              final filteredStudents = allStudents.where((student) {
                return student.name.toLowerCase().contains(_searchQuery) ||
                    student.studentId.toLowerCase().contains(_searchQuery) ||
                    student.major.toLowerCase().contains(_searchQuery);
              }).toList();

              if (filteredStudents.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _searchQuery.isNotEmpty ? Icons.search_off : Icons.school_outlined,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'No students match your search'
                                : 'No students registered yet',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'Try searching for a different name or ID'
                                : 'Tap the floating action button below to add your first student.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final student = filteredStudents[index];
                      return StudentCard(student: student);
                    },
                    childCount: filteredStudents.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StudentFormScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF6366F1),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Student',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
