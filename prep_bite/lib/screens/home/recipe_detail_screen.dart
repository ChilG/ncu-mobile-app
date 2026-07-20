import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/recipe_model.dart';
import '../../services/auth_service.dart';
import '../../services/favorite_service.dart';
import '../../services/recipe_service.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import '../checklist/preparation_checklist_screen.dart';
import '../recipe/edit_recipe_screen.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    final RecipeService recipeService = RecipeService();
    final FavoriteService favoriteService = FavoriteService();
    final AuthService authService = AuthService();
    final String currentUserId = authService.currentUser?.uid ?? '';

    return StreamBuilder<RecipeModel?>(
      stream: recipeService.getRecipeById(recipeId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: LoadingWidget(message: 'กำลังโหลดรายละเอียดสูตร...'),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const AppErrorWidget(message: 'ไม่พบข้อมูลสูตรอาหารนี้'),
          );
        }

        final recipe = snapshot.data!;
        final bool isOwner = recipe.createdBy == currentUserId;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Image Header SliverAppBar
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: recipe.imageUrl.isNotEmpty
                            ? recipe.imageUrl
                            : AppConstants.defaultRecipeImage,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.broken_image, size: 64, color: Colors.grey),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  // Favorite Action
                  StreamBuilder<bool>(
                    stream: favoriteService.isFavorite(currentUserId, recipe.id),
                    builder: (context, favSnapshot) {
                      final isFav = favSnapshot.data ?? false;
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFav ? Colors.red : Colors.white,
                        ),
                        onPressed: () async {
                          if (isFav) {
                            await favoriteService.removeFavorite(currentUserId, recipe.id);
                          } else {
                            await favoriteService.addFavorite(currentUserId, recipe.id);
                          }
                        },
                      );
                    },
                  ),
                  if (isOwner)
                    IconButton(
                      icon: const Icon(Icons.edit_rounded, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditRecipeScreen(recipe: recipe),
                          ),
                        );
                      },
                    ),
                ],
              ),

              // Recipe Body Details
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          recipe.category,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Title
                      Text(
                        recipe.title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Description
                      Text(
                        recipe.description,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Meta Stats Row (Prep time, Cooking time, Servings, Difficulty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              Icons.hourglass_top_rounded,
                              '${recipe.prepTime} นาที',
                              'เตรียม',
                            ),
                            _buildStatItem(
                              Icons.soup_kitchen_rounded,
                              '${recipe.cookingTime} นาที',
                              'ทำอาหาร',
                            ),
                            _buildStatItem(
                              Icons.restaurant_rounded,
                              '${recipe.servings} เสิร์ฟ',
                              'จำนวน',
                            ),
                            _buildStatItem(
                              Icons.speed_rounded,
                              recipe.difficulty,
                              'ความยาก',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Start Preparation Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PreparationChecklistScreen(
                                  recipe: recipe,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.fact_check_rounded, size: 24),
                          label: const Text(
                            'เริ่มเตรียมวัตถุดิบ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.secondaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Ingredients Header & List
                      Row(
                        children: [
                          const Icon(Icons.format_list_bulleted_rounded,
                              color: AppTheme.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'วัตถุดิบ (${recipe.ingredients.length} รายการ)',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: recipe.ingredients.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = recipe.ingredients[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                const Icon(Icons.fiber_manual_record,
                                    size: 10, color: AppTheme.primaryColor),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  item.amount,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                if (item.preparation.isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    '(${item.preparation})',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.textSecondary,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 28),

                      // Steps Header & List
                      Row(
                        children: [
                          const Icon(Icons.menu_book_rounded, color: AppTheme.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'ขั้นตอนการทำอาหาร (${recipe.steps.length} ขั้นตอน)',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: recipe.steps.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE0E0E0)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: AppTheme.primaryColor,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    recipe.steps[index],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: AppTheme.textPrimary,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
