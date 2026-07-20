class AppConstants {
  static const String appName = 'PrepBite';

  // Recipe Categories
  static const List<String> categories = [
    'ทั้งหมด',
    'อาหารเช้า',
    'อาหารจานเดียว',
    'ของว่าง',
    'ของหวาน',
    'เครื่องดื่ม',
  ];

  // Categories for Form (excluding 'ทั้งหมด')
  static const List<String> formCategories = [
    'อาหารเช้า',
    'อาหารจานเดียว',
    'ของว่าง',
    'ของหวาน',
    'เครื่องดื่ม',
  ];

  // Recipe Difficulty Levels
  static const List<String> difficulties = [
    'ง่าย',
    'ปานกลาง',
    'ยาก',
  ];

  // Default Placeholder Images
  static const String defaultRecipeImage =
      'https://images.unsplash.com/photo-1495521821757-a1efb6729352?auto=format&fit=crop&w=800&q=80';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String recipesCollection = 'recipes';
  static const String favoritesSubcollection = 'favorites';
  static const String checklistsSubcollection = 'checklists';
}
