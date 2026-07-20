import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/ingredient_model.dart';
import '../../models/recipe_model.dart';
import '../../services/recipe_service.dart';
import '../../services/storage_service.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_text_field.dart';
import 'add_recipe_screen.dart'; // Reuses IngredientInputHolder

class EditRecipeScreen extends StatefulWidget {
  final RecipeModel recipe;

  const EditRecipeScreen({
    super.key,
    required this.recipe,
  });

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _prepTimeController;
  late TextEditingController _cookingTimeController;
  late TextEditingController _servingsController;
  late TextEditingController _imageUrlController;

  late String _selectedCategory;
  late String _selectedDifficulty;

  XFile? _selectedImageFile;
  bool _isSaving = false;

  final RecipeService _recipeService = RecipeService();
  final StorageService _storageService = StorageService();
  final ImagePicker _imagePicker = ImagePicker();

  late List<IngredientInputHolder> _ingredientHolders;
  late List<TextEditingController> _stepControllers;

  @override
  void initState() {
    super.initState();
    final r = widget.recipe;
    _titleController = TextEditingController(text: r.title);
    _descriptionController = TextEditingController(text: r.description);
    _prepTimeController = TextEditingController(text: r.prepTime.toString());
    _cookingTimeController = TextEditingController(text: r.cookingTime.toString());
    _servingsController = TextEditingController(text: r.servings.toString());
    _imageUrlController = TextEditingController(text: r.imageUrl);

    _selectedCategory = AppConstants.formCategories.contains(r.category)
        ? r.category
        : AppConstants.formCategories.first;
    _selectedDifficulty = AppConstants.difficulties.contains(r.difficulty)
        ? r.difficulty
        : AppConstants.difficulties.first;

    _ingredientHolders = r.ingredients.map((ing) {
      final h = IngredientInputHolder();
      h.nameController.text = ing.name;
      h.amountController.text = ing.amount;
      h.prepController.text = ing.preparation;
      return h;
    }).toList();

    if (_ingredientHolders.isEmpty) {
      _ingredientHolders.add(IngredientInputHolder());
    }

    _stepControllers = r.steps.map((s) => TextEditingController(text: s)).toList();
    if (_stepControllers.isEmpty) {
      _stepControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _prepTimeController.dispose();
    _cookingTimeController.dispose();
    _servingsController.dispose();
    _imageUrlController.dispose();

    for (var h in _ingredientHolders) {
      h.dispose();
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

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      String finalImageUrl = _imageUrlController.text.trim();

      if (_selectedImageFile != null) {
        finalImageUrl = await _storageService.uploadRecipeImage(_selectedImageFile!);
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

      final updatedRecipe = widget.recipe.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: finalImageUrl,
        category: _selectedCategory,
        prepTime: int.parse(_prepTimeController.text.trim()),
        cookingTime: int.parse(_cookingTimeController.text.trim()),
        servings: int.parse(_servingsController.text.trim()),
        difficulty: _selectedDifficulty,
        ingredients: ingredientsList,
        steps: stepsList,
      );

      await _recipeService.updateRecipe(updatedRecipe);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('แก้ไขสูตรอาหารเรียบร้อยแล้ว'),
          backgroundColor: AppTheme.secondaryColor,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _handleDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบสูตรอาหาร'),
        content: Text('คุณต้องการลบสูตรอาหาร "${widget.recipe.title}" ใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _recipeService.deleteRecipe(widget.recipe.id);
        if (widget.recipe.imageUrl.isNotEmpty) {
          await _storageService.deleteRecipeImage(widget.recipe.imageUrl);
        }
        if (!mounted) return;
        Navigator.pop(context); // Close edit screen
        Navigator.pop(context); // Close detail screen
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาดในการลบ: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขสูตรอาหาร'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded, color: AppTheme.errorColor),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Upload
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
                      : widget.recipe.imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                widget.recipe.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo_outlined, size: 48),
                                SizedBox(height: 8),
                                Text('แตะเพื่อเปลี่ยนรูปภาพ'),
                              ],
                            ),
                ),
              ),
              const SizedBox(height: 12),

              CustomTextField(
                controller: _imageUrlController,
                labelText: 'หรือ URL รูปภาพ',
                prefixIcon: Icons.link_rounded,
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: _titleController,
                labelText: 'ชื่อเมนูอาหาร',
                prefixIcon: Icons.restaurant_menu_rounded,
                validator: (v) => Validators.validateRequired(v, 'ชื่อเมนู'),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _descriptionController,
                labelText: 'คำอธิบาย',
                prefixIcon: Icons.description_outlined,
                maxLines: 3,
                validator: (v) => Validators.validateRequired(v, 'คำอธิบาย'),
              ),
              const SizedBox(height: 16),

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

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _prepTimeController,
                      labelText: 'เตรียม (นาที)',
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
                      prefixIcon: Icons.soup_kitchen_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) => Validators.validateNumber(v, 'เวลาทำ'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _servingsController,
                      labelText: 'เสิร์ฟ',
                      prefixIcon: Icons.people_outline_rounded,
                      keyboardType: TextInputType.number,
                      validator: (v) => Validators.validateNumber(v, 'เสิร์ฟ'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Dynamic Ingredients
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('รายการวัตถุดิบ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    onPressed: _addIngredientRow,
                    icon: const Icon(Icons.add),
                    label: const Text('เพิ่ม'),
                  ),
                ],
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _ingredientHolders.length,
                itemBuilder: (context, index) {
                  final holder = _ingredientHolders[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('วัตถุดิบที่ ${index + 1}',
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              const Spacer(),
                              if (_ingredientHolders.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: AppTheme.errorColor),
                                  onPressed: () => _removeIngredientRow(index),
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: CustomTextField(
                                  controller: holder.nameController,
                                  labelText: 'ชื่อ',
                                  validator: (v) => Validators.validateRequired(v, 'ชื่อ'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: CustomTextField(
                                  controller: holder.amountController,
                                  labelText: 'ปริมาณ',
                                  validator: (v) =>
                                      Validators.validateRequired(v, 'ปริมาณ'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: holder.prepController,
                            labelText: 'วิธีการเตรียม',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Dynamic Steps
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('ขั้นตอนการทำ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    onPressed: _addStepRow,
                    icon: const Icon(Icons.add),
                    label: const Text('เพิ่ม'),
                  ),
                ],
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _stepControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _stepControllers[index],
                            labelText: 'ขั้นตอนที่ ${index + 1}',
                            maxLines: 2,
                            validator: (v) =>
                                Validators.validateRequired(v, 'ขั้นตอน'),
                          ),
                        ),
                        if (_stepControllers.length > 1)
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: AppTheme.errorColor),
                            onPressed: () => _removeStepRow(index),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _handleUpdate,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('บันทึกการแก้ไข'),
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
