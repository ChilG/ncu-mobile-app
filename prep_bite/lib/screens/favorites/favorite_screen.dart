import 'package:flutter/material.dart';
import '../../models/recipe_model.dart';
import '../../services/auth_service.dart';
import '../../services/favorite_service.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/recipe_card.dart';
import '../home/recipe_detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteService favoriteService = FavoriteService();
    final AuthService authService = AuthService();
    final String currentUserId = authService.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('สูตรอาหารโปรด'),
      ),
      body: StreamBuilder<List<RecipeModel>>(
        stream: favoriteService.getFavoriteRecipes(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: 'กำลังโหลดรายการโปรด...');
          }

          if (snapshot.hasError) {
            return AppErrorWidget(
              message: 'เกิดข้อผิดพลาดในการโหลดรายการโปรด: ${snapshot.error}',
            );
          }

          final recipes = snapshot.data ?? [];

          if (recipes.isEmpty) {
            return const EmptyStateWidget(
              title: 'ยังไม่มีสูตรอาหารโปรด',
              subtitle: 'กดปุ่มหัวใจในหน้าแรกเพื่อบันทึกสูตรอาหารที่คุณชอบเก็บไว้ที่นี่',
              icon: Icons.favorite_border_rounded,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return RecipeCard(
                recipe: recipe,
                isFavorite: true,
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
                  await favoriteService.removeFavorite(
                    currentUserId,
                    recipe.id,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
