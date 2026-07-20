import 'package:flutter/material.dart';
import '../../models/recipe_model.dart';
import '../../services/auth_service.dart';
import '../../services/favorite_service.dart';
import '../../services/recipe_service.dart';
import '../../utils/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final RecipeService recipeService = RecipeService();
    final FavoriteService favoriteService = FavoriteService();

    final user = authService.currentUser;
    final String currentUserId = user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์ผู้ใช้งาน'),
      ),
      body: user == null
          ? const Center(child: Text('ไม่พบข้อมูลผู้ใช้'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Profile Avatar & Main Info
                  const CircleAvatar(
                    radius: 48,
                    backgroundColor: AppTheme.primaryColor,
                    child: Icon(
                      Icons.person_rounded,
                      size: 56,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    user.displayName?.isNotEmpty == true
                        ? user.displayName!
                        : 'เชฟ PrepBite',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    user.email ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Statistics Row (User Added Recipes & Favorites Count)
                  Row(
                    children: [
                      // Added Recipes Count
                      Expanded(
                        child: StreamBuilder<List<RecipeModel>>(
                          stream: recipeService.getRecipesByUser(currentUserId),
                          builder: (context, snapshot) {
                            final count = snapshot.data?.length ?? 0;
                            return _buildStatCard(
                              icon: Icons.soup_kitchen_rounded,
                              value: count.toString(),
                              label: 'สูตรที่เพิ่มไว้',
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Favorites Count
                      Expanded(
                        child: StreamBuilder<List<String>>(
                          stream: favoriteService.getFavoriteRecipeIds(currentUserId),
                          builder: (context, snapshot) {
                            final count = snapshot.data?.length ?? 0;
                            return _buildStatCard(
                              icon: Icons.favorite_rounded,
                              value: count.toString(),
                              label: 'สูตรที่ชอบ',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // User Settings / Actions Info Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person_outline_rounded,
                              color: AppTheme.primaryColor),
                          title: const Text('ID ผู้ใช้งาน'),
                          subtitle: Text(
                            user.uid,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.email_outlined,
                              color: AppTheme.primaryColor),
                          title: const Text('สถานะอีเมล'),
                          subtitle: Text(
                            user.emailVerified ? 'ยืนยันแล้ว' : 'ยังไม่ได้ยืนยัน',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('ออกจากระบบ'),
                            content: const Text('คุณต้องการออกจากระบบใช่หรือไม่?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('ยกเลิก'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.errorColor),
                                child: const Text('ออกจากระบบ'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await authService.signOut();
                        }
                      },
                      icon: const Icon(Icons.logout_rounded, color: AppTheme.errorColor),
                      label: const Text(
                        'ออกจากระบบ',
                        style: TextStyle(
                          color: AppTheme.errorColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.errorColor),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
