import 'package:flutter/material.dart';
import 'package:student_firebase/models/student.dart';
import 'package:student_firebase/services/firebase_service.dart';
import 'package:student_firebase/widgets/custom_text_field.dart';
import 'package:student_firebase/widgets/image_preview_avatar.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;

  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();

  late TextEditingController _studentIdController;
  late TextEditingController _nameController;
  late TextEditingController _majorController;
  late TextEditingController _gpaController;
  late TextEditingController _imageUrlController;

  bool _isLoading = false;

  bool get isEditMode => widget.student != null;

  @override
  void initState() {
    super.initState();
    _studentIdController = TextEditingController(text: widget.student?.studentId ?? '');
    _nameController = TextEditingController(text: widget.student?.name ?? '');
    _majorController = TextEditingController(text: widget.student?.major ?? '');
    _gpaController = TextEditingController(text: widget.student?.gpa.toString() ?? '');
    _imageUrlController = TextEditingController(text: widget.student?.imageUrl ?? '');

    _imageUrlController.addListener(_onImageUrlChanged);
  }

  void _onImageUrlChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _imageUrlController.removeListener(_onImageUrlChanged);
    _studentIdController.dispose();
    _nameController.dispose();
    _majorController.dispose();
    _gpaController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final String studentId = _studentIdController.text.trim();
      final String name = _nameController.text.trim();
      final String major = _majorController.text.trim();
      final double gpa = double.parse(_gpaController.text.trim());
      final String imageUrl = _imageUrlController.text.trim();

      if (isEditMode) {
        final updatedStudent = widget.student!.copyWith(
          studentId: studentId,
          name: name,
          major: major,
          gpa: gpa,
          imageUrl: imageUrl,
        );
        await _firebaseService.updateStudent(updatedStudent);
      } else {
        final newStudent = Student(
          id: '',
          studentId: studentId,
          name: name,
          major: major,
          gpa: gpa,
          imageUrl: imageUrl,
          createdAt: DateTime.now(),
        );
        await _firebaseService.addStudent(newStudent);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditMode ? 'Student updated successfully!' : 'Student added successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              isEditMode ? 'Edit Student Details' : 'Add New Student',
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              TextButton(
                onPressed: _isLoading ? null : _saveForm,
                child: const Text(
                  'SAVE',
                  style: TextStyle(
                    color: Color(0xFF6366F1),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImagePreviewAvatar(
                    imageUrl: _imageUrlController.text.trim(),
                    radius: 70,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Profile Image Preview',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: _studentIdController,
                    label: 'Student ID / Code',
                    icon: Icons.badge_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter student ID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _majorController,
                    label: 'Major / Department',
                    icon: Icons.school_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter major';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _gpaController,
                    label: 'Cumulative GPA',
                    icon: Icons.grade_outlined,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter GPA';
                      }
                      final gpa = double.tryParse(value);
                      if (gpa == null) {
                        return 'Please enter a valid number';
                      }
                      if (gpa < 0.0 || gpa > 4.0) {
                        return 'GPA must be between 0.00 and 4.00';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _imageUrlController,
                    label: 'Profile Image URL',
                    icon: Icons.link_outlined,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        isEditMode ? 'Update Student' : 'Add Student',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black45,
            child: const Center(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: Color(0xFF6366F1),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Saving data...',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
