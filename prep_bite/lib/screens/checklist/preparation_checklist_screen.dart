import 'package:flutter/material.dart';
import '../../models/ingredient_model.dart';
import '../../models/recipe_model.dart';
import '../../services/auth_service.dart';
import '../../services/checklist_service.dart';
import '../../utils/app_theme.dart';
import '../../widgets/ingredient_check_tile.dart';

class PreparationChecklistScreen extends StatefulWidget {
  final RecipeModel recipe;

  const PreparationChecklistScreen({
    super.key,
    required this.recipe,
  });

  @override
  State<PreparationChecklistScreen> createState() =>
      _PreparationChecklistScreenState();
}

class _PreparationChecklistScreenState
    extends State<PreparationChecklistScreen> {
  final ChecklistService _checklistService = ChecklistService();
  final AuthService _authService = AuthService();

  late List<IngredientModel> _ingredients;
  bool _isLoading = true;
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = _authService.currentUser?.uid ?? '';
    _ingredients = List.from(widget.recipe.ingredients);
    _loadSavedChecklist();
  }

  Future<void> _loadSavedChecklist() async {
    if (_currentUserId.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final savedStream = _checklistService.getChecklistStream(
        _currentUserId,
        widget.recipe.id,
      );

      final saved = await savedStream.first;
      if (saved != null && saved.isNotEmpty && mounted) {
        setState(() {
          _ingredients = saved;
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateChecklist(List<IngredientModel> updatedList) async {
    setState(() {
      _ingredients = updatedList;
    });

    if (_currentUserId.isNotEmpty) {
      await _checklistService.saveChecklist(
        _currentUserId,
        widget.recipe.id,
        updatedList,
      );
    }

    _checkCompletion();
  }

  void _checkCompletion() {
    final completedCount = _ingredients.where((e) => e.isChecked).length;
    if (_ingredients.isNotEmpty && completedCount == _ingredients.length) {
      _showAllCompletedDialog();
    }
  }

  void _showAllCompletedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppTheme.secondaryColor, size: 28),
            SizedBox(width: 8),
            Text('เตรียมพร้อมแล้ว!'),
          ],
        ),
        content: const Text(
          'เตรียมวัตถุดิบครบแล้ว พร้อมเริ่มทำอาหาร!',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondaryColor,
            ),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  void _selectAll() {
    final updated = _ingredients
        .map((e) => e.copyWith(isChecked: true))
        .toList();
    _updateChecklist(updated);
  }

  void _clearAll() {
    final updated = _ingredients
        .map((e) => e.copyWith(isChecked: false))
        .toList();
    _updateChecklist(updated);
  }

  @override
  Widget build(BuildContext context) {
    final int completedCount = _ingredients.where((e) => e.isChecked).length;
    final int totalCount = _ingredients.length;
    final double progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('เตรียมวัตถุดิบ: ${widget.recipe.title}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : Column(
              children: [
                // Progress Bar Card Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'เตรียมแล้ว $completedCount จาก $totalCount รายการ',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          backgroundColor: Colors.grey.shade200,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Quick Action Buttons (Select All / Clear All)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _selectAll,
                            icon: const Icon(Icons.done_all_rounded, size: 18),
                            label: const Text('เลือกทั้งหมด'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: _clearAll,
                            icon: const Icon(Icons.restart_alt_rounded, size: 18),
                            label: const Text('ล้าง Checklist'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.errorColor,
                              side: const BorderSide(color: AppTheme.errorColor),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Ingredients Checklist Items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    itemCount: _ingredients.length,
                    itemBuilder: (context, index) {
                      final item = _ingredients[index];
                      return IngredientCheckTile(
                        ingredient: item,
                        onChanged: (val) {
                          final updated = List<IngredientModel>.from(_ingredients);
                          updated[index] = item.copyWith(isChecked: val ?? false);
                          _updateChecklist(updated);
                        },
                      );
                    },
                  ),
                ),

                // Bottom Ready to Cook Button
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (completedCount == totalCount) {
                            _showAllCompletedDialog();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'ยังเตรียมวัตถุดิบไม่ครบ (เหลืออีก ${totalCount - completedCount} รายการ)',
                                ),
                                backgroundColor: AppTheme.primaryColor,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.play_circle_fill_rounded, size: 24),
                        label: const Text(
                          'พร้อมเริ่มทำอาหาร',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: completedCount == totalCount
                              ? AppTheme.secondaryColor
                              : AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
