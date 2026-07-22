import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/recipe_model.dart';
import '../../services/auth_service.dart';
import '../../services/favorite_service.dart';
import '../../services/recipe_service.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = RecipeService();
  final FavoriteService _favoriteService = FavoriteService();
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'ทั้งหมด';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUserId = _authService.currentUser?.uid ?? '';
      if (currentUserId.isNotEmpty) {
        _recipeService.seedSampleRecipes(currentUserId);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildRecommendedSection(String currentUserId) {
    return StreamBuilder<List<RecipeModel>>(
      stream: _recipeService.getRecommendedRecipes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final recommendedList = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.local_fire_department_rounded, color: AppTheme.primaryColor),
                  SizedBox(width: 6),
                  Text(
                    'สูตรอาหารแนะนำ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: recommendedList.length,
                itemBuilder: (context, index) {
                  final recipe = recommendedList[index];
                  return Container(
                    width: 240,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(
                                recipeId: recipe.id,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: recipe.imageUrl.isNotEmpty
                                  ? recipe.imageUrl
                                  : AppConstants.defaultRecipeImage,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.75),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'แนะนำ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${recipe.prepTime + recipe.cookingTime} นาที • ${recipe.category}',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = _authService.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.soup_kitchen_rounded, color: AppTheme.primaryColor),
            SizedBox(width: 8),
            Text('PrepBite สูตรอาหาร'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome_rounded, color: AppTheme.primaryColor),
            tooltip: 'สร้างสูตรอาหารตัวอย่าง (5 เมนู)',
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              try {
                await _recipeService.seedSampleRecipes(currentUserId, force: true);
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('เพิ่มสูตรอาหารตัวอย่างสำเร็จ!'),
                    backgroundColor: AppTheme.secondaryColor,
                  ),
                );
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('เกิดข้อผิดพลาด: $e'),
                    backgroundColor: AppTheme.errorColor,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
              decoration: InputDecoration(
                hintText: 'ค้นหาชื่อสูตรอาหาร...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryColor),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Categories Filter Horizontal Selector
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: AppConstants.categories.length,
              itemBuilder: (context, index) {
                final category = AppConstants.categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryColor,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Main Body Stream
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show Recommended Section if not filtering/searching
                  if (_searchQuery.isEmpty && _selectedCategory == 'ทั้งหมด')
                    _buildRecommendedSection(currentUserId),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      _selectedCategory == 'ทั้งหมด'
                          ? 'สูตรอาหารทั้งหมด'
                          : 'หมวดหมู่: $_selectedCategory',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),

                  StreamBuilder<List<RecipeModel>>(
                    stream: _recipeService.getRecipes(),
                    builder: (context, recipeSnapshot) {
                      if (recipeSnapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingWidget(message: 'กำลังโหลดสูตรอาหาร...');
                      }

                      if (recipeSnapshot.hasError) {
                        return AppErrorWidget(
                          message: 'เกิดข้อผิดพลาดในการโหลดสูตรอาหาร: ${recipeSnapshot.error}',
                        );
                      }

                      final allRecipes = recipeSnapshot.data ?? [];

                      final filteredRecipes = allRecipes.where((recipe) {
                        final matchesSearch = recipe.title
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase());
                        final matchesCategory = _selectedCategory == 'ทั้งหมด' ||
                            recipe.category == _selectedCategory;
                        return matchesSearch && matchesCategory;
                      }).toList();

                      if (filteredRecipes.isEmpty) {
                        return EmptyStateWidget(
                          title: allRecipes.isEmpty
                              ? 'ยังไม่มีสูตรอาหารในระบบ'
                              : 'ไม่พบสูตรอาหารที่ค้นหา',
                          subtitle: allRecipes.isEmpty
                              ? 'กดปุ่ม ✨ ด้านบนเพื่อโหลดสูตรอาหารตัวอย่าง 5 เมนู'
                              : 'ลองเปลี่ยนคำค้นหาหรือเลือกหมวดหมู่อื่นดูสิ',
                          actionWidget: allRecipes.isEmpty
                              ? ElevatedButton.icon(
                                  onPressed: () async {
                                    await _recipeService.seedSampleRecipes(currentUserId, force: true);
                                  },
                                  icon: const Icon(Icons.download_rounded),
                                  label: const Text('โหลดสูตรอาหารตัวอย่าง'),
                                )
                              : null,
                        );
                      }

                      return StreamBuilder<List<String>>(
                        stream: _favoriteService.getFavoriteRecipeIds(currentUserId),
                        builder: (context, favSnapshot) {
                          final favIds = favSnapshot.data ?? [];

                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: filteredRecipes.length,
                            itemBuilder: (context, index) {
                              final recipe = filteredRecipes[index];
                              final isFav = favIds.contains(recipe.id);

                              return RecipeCard(
                                recipe: recipe,
                                isFavorite: isFav,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecipeDetailScreen(
                                        recipeId: recipe.id,
                                      ),
                                    ),
                                  );
                                },
                                onFavoriteTap: () async {
                                  if (isFav) {
                                    await _favoriteService.removeFavorite(
                                      currentUserId,
                                      recipe.id,
                                    );
                                  } else {
                                    await _favoriteService.addFavorite(
                                      currentUserId,
                                      recipe.id,
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
