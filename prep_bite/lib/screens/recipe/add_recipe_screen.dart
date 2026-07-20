import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/ingredient_model.dart';
import '../../models/recipe_model.dart';
import '../../services/auth_service.dart';
import '../../services/recipe_service.dart';
import '../../services/storage_service.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_text_field.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _cookingTimeController = TextEditingController();
  final _servingsController = TextEditingController(text: '1');
  final _imageUrlController = TextEditingController();

  String _selectedCategory = AppConstants.formCategories.first;
  String _selectedDifficulty = AppConstants.difficulties.first;
  bool _isRecommended = false;

  XFile? _selectedImageFile;
  bool _isUploadingImage = false;
  bool _isSaving = false;

  final RecipeService _recipeService = RecipeService();
  final StorageService _storageService = StorageService();
  final AuthService _authService = AuthService();
  final ImagePicker _imagePicker = ImagePicker();

  // Dynamic lists for ingredients & steps
  final List<IngredientInputHolder> _ingredientHolders = [
    IngredientInputHolder(),
  ];

  final List<TextEditingController> _stepControllers = [
    TextEditingController(),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _prepTimeController.dispose();
    _cookingTimeController.dispose();
    _servingsController.dispose();
    _imageUrlController.dispose();

    for (var holder in _ingredientHolders) {
      holder.dispose();
    }
    for (var c in _stepControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        _selectedImageFile = picked;
      });
    }
  }

  void _addIngredientRow() {
    setState(() {
      _ingredientHolders.add(IngredientInputHolder());
    });
  }

  void _removeIngredientRow(int index) {
    if (_ingredientHolders.length > 1) {
      setState(() {
        final removed = _ingredientHolders.removeAt(index);
        removed.dispose();
      });
    }
  }

  void _addStepRow() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  void _removeStepRow(int index) {
    if (_stepControllers.length > 1) {
      setState(() {
        final removed = _stepControllers.removeAt(index);
        removed.dispose();
      });
    }
  }

  Future<void> _submitRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเข้าสู่ระบบก่อนเพิ่มสูตรอาหาร')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      String finalImageUrl = _imageUrlController.text.trim();

      // If user picked a local file, upload it to Firebase Storage
      if (_selectedImageFile != null) {
        setState(() => _isUploadingImage = true);
        finalImageUrl = await _storageService.uploadRecipeImage(_selectedImageFile!);
        setState(() => _isUploadingImage = false);
      }

      final ingredientsList = _ingredientHolders
          .map((h) => IngredientModel(
                name: h.nameController.text.trim(),
                amount: h.amountController.text.trim(),
                preparation: h.prepController.text.trim(),
              ))
          .toList();

      final stepsList = _stepControllers
          .map((c) => c.text.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final newRecipe = RecipeModel(
        id: '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: finalImageUrl,
        category: _selectedCategory,
        prepTime: int.parse(_prepTimeController.text.trim()),
        cookingTime: int.parse(_cookingTimeController.text.trim()),
        servings: int.parse(_servingsController.text.trim()),
        difficulty: _selectedDifficulty,
        isRecommended: _isRecommended,
        ingredients: ingredientsList,
        steps: stepsList,
        createdBy: currentUser.uid,
        createdAt: DateTime.now(),
      );

      await _recipeService.addRecipe(newRecipe);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เพิ่มสูตรอาหารสำเร็จ!'),
          backgroundColor: AppTheme.secondaryColor,
          behavior: SnackBarBehavior.floating,
        ),
      );

      _resetForm();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $e'),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _isUploadingImage = false;
        });
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    _prepTimeController.clear();
    _cookingTimeController.clear();
    _servingsController.text = '1';
    _imageUrlController.clear();

    setState(() {
      _selectedImageFile = null;
      _selectedCategory = AppConstants.formCategories.first;
      _selectedDifficulty = AppConstants.difficulties.first;

      for (var h in _ingredientHolders) {
        h.dispose();
      }
      _ingredientHolders.clear();
      _ingredientHolders.add(IngredientInputHolder());

      for (var c in _stepControllers) {
        c.dispose();
      }
      _stepControllers.clear();
      _stepControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มสูตรอาหารใหม่'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe Image Section
              const Text(
                'รูปภาพประกอบสูตรอาหาร',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: _selectedImageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            File(_selectedImageFile!.path),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_a_photo_outlined,
                                size: 48, color: AppTheme.primaryColor),
                            const SizedBox(height: 8),
                            const Text(
                              'แตะเพื่อเลือกรูปภาพจากแกลเลอรี',
                              style: TextStyle(color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 12),

              CustomTextField(
                controller: _imageUrlController,
                labelText: 'หรือวาง URL รูปภาพ',
                hintText: 'https://example.com/image.jpg',
                prefixIcon: Icons.link_rounded,
              ),
              const SizedBox(height: 20),

              // Title Field
              CustomTextField(
                controller: _titleController,
                labelText: 'ชื่อเมนูอาหาร',
                hintText: 'เช่น ข้าวผัดต้มยำกุ้ง',
                prefixIcon: Icons.restaurant_menu_rounded,
                validator: (v) => Validators.validateRequired(v, 'ชื่อเมนูอาหาร'),
              ),
              const SizedBox(height: 16),

              // Description Field
              CustomTextField(
                controller: _descriptionController,
                labelText: 'คำอธิบายสั้น ๆ',
                hintText: 'อธิบายรสชาติ หรือจุดเด่นของเมนูนี้...',
                prefixIcon: Icons.description_outlined,
                maxLines: 3,
                validator: (v) => Validators.validateRequired(v, 'คำอธิบาย'),
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'หมวดหมู่อาหาร',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: AppConstants.formCategories.map((c) {
                  return DropdownMenuItem(value: c, child: Text(c));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 16),

              // Recommended Switch
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('ตั้งเป็นเมนูแนะนำ (Recommended)'),
                subtitle: const Text('เมนูนี้จะถูกนำไปแสดงในแถบเมนูแนะนำหน้าแรก'),
                value: _isRecommended,
                activeThumbColor: AppTheme.primaryColor,
                onChanged: (val) {
                  setState(() {
                    _isRecommended = val;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Difficulty Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedDifficulty,
                decoration: const InputDecoration(
                  labelText: 'ระดับความยาก',
                  prefixIcon: Icon(Icons.speed_rounded),
                ),
                items: AppConstants.difficulties.map((d) {
                  return DropdownMenuItem(value: d, child: Text(d));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedDifficulty = val);
                },
              ),
              const SizedBox(height: 16),

              // Timings & Servings Row
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _prepTimeController,
                      labelText: 'เตรียม (นาที)',
                      hintText: '10',
                      prefixIcon: Icons.timer_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) => Validators.validateNumber(v, 'เวลาเตรียม'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _cookingTimeController,
                      labelText: 'ทำ (นาที)',
                      hintText: '15',
                      prefixIcon: Icons.soup_kitchen_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) => Validators.validateNumber(v, 'เวลาทำอาหาร'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _servingsController,
                      labelText: 'เสิร์ฟ (คน)',
                      hintText: '2',
                      prefixIcon: Icons.people_outline_rounded,
                      keyboardType: TextInputType.number,
                      validator: (v) => Validators.validateNumber(v, 'จำนวนเสิร์ฟ'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Ingredients List Builder Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'รายการวัตถุดิบ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: _addIngredientRow,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('เพิ่มวัตถุดิบ'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _ingredientHolders.length,
                itemBuilder: (context, index) {
                  final holder = _ingredientHolders[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'วัตถุดิบ',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              if (_ingredientHolders.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded,
                                      color: AppTheme.errorColor),
                                  onPressed: () => _removeIngredientRow(index),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: CustomTextField(
                                  controller: holder.nameController,
                                  labelText: 'ชื่อวัตถุดิบ *',
                                  hintText: 'หมูสับ',
                                  validator: (v) =>
                                      Validators.validateRequired(v, 'ชื่อวัตถุดิบ'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: CustomTextField(
                                  controller: holder.amountController,
                                  labelText: 'ปริมาณ *',
                                  hintText: '100 กรัม',
                                  validator: (v) =>
                                      Validators.validateRequired(v, 'ปริมาณ'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: holder.prepController,
                            labelText: 'วิธีการเตรียม (ถ้ามี)',
                            hintText: 'เช่น สับละเอียด, ล้างสะดาด, หั่นท่อน',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Steps List Builder Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ขั้นตอนการทำอาหาร',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: _addStepRow,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('เพิ่มขั้นตอน'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _stepControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _stepControllers[index],
                            labelText: 'ขั้นตอนที่ ${index + 1} *',
                            hintText: 'อธิบายสิ่งที่ต้องทำในขั้นตอนนี้...',
                            maxLines: 2,
                            validator: (v) =>
                                Validators.validateRequired(v, 'ขั้นตอนการทำ'),
                          ),
                        ),
                        if (_stepControllers.length > 1)
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded,
                                color: AppTheme.errorColor),
                            onPressed: () => _removeStepRow(index),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _submitRecipe,
                  icon: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save_rounded, size: 24),
                  label: Text(
                    _isUploadingImage
                        ? 'กำลังอัปโหลดรูปภาพ...'
                        : _isSaving
                            ? 'กำลังบันทึก...'
                            : 'บันทึกสูตรอาหาร',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class IngredientInputHolder {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController prepController = TextEditingController();

  void dispose() {
    nameController.dispose();
    amountController.dispose();
    prepController.dispose();
  }
}
