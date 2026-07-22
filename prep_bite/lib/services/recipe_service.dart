import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';
import '../models/ingredient_model.dart';
import '../utils/constants.dart';

class RecipeService {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  CollectionReference get _recipesRef =>
      _firestore.collection(AppConstants.recipesCollection);

  // Stream of all recipes ordered by createdAt desc
  Stream<List<RecipeModel>> getRecipes() {
    try {
      return _recipesRef
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) =>
                RecipeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      });
    } catch (_) {
      return const Stream.empty();
    }
  }

  // Stream of recommended recipes
  Stream<List<RecipeModel>> getRecommendedRecipes() {
    try {
      return _recipesRef
          .where('isRecommended', isEqualTo: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) =>
                RecipeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      });
    } catch (_) {
      return const Stream.empty();
    }
  }

  // Get single recipe by ID stream
  Stream<RecipeModel?> getRecipeById(String recipeId) {
    return _recipesRef.doc(recipeId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return RecipeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    });
  }

  // Add new recipe
  Future<DocumentReference> addRecipe(RecipeModel recipe) async {
    return await _recipesRef.add(recipe.toMap());
  }

  // Update existing recipe
  Future<void> updateRecipe(RecipeModel recipe) async {
    await _recipesRef.doc(recipe.id).update(recipe.toMap());
  }

  // Delete recipe
  Future<void> deleteRecipe(String recipeId) async {
    await _recipesRef.doc(recipeId).delete();
  }

  // Get user's added recipes stream
  Stream<List<RecipeModel>> getRecipesByUser(String userId) {
    return _recipesRef
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              RecipeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  // Seed or Update sample recipes in Firestore
  Future<void> seedSampleRecipes(String currentUserId, {bool force = false}) async {
    try {
      final Map<String, String> newImageUrls = {
        'ต้มยำกุ้งน้ำข้น':
            'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=800&q=80',
        'ขนมปังกระเทียม':
            'https://images.unsplash.com/photo-1574894709920-11b28e7367e3?auto=format&fit=crop&w=800&q=80',
        'ซนขนมปังกระเทียม':
            'https://images.unsplash.com/photo-1574894709920-11b28e7367e3?auto=format&fit=crop&w=800&q=80',
        'ชาไทยเย็นนมหอม':
            'https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=800&q=80',
        'ข้าวผัดไข่':
            'https://images.unsplash.com/photo-1603133872878-684f208fb84b?auto=format&fit=crop&w=800&q=80',
        'แพนเค้กนุ่มฟู':
            'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?auto=format&fit=crop&w=800&q=80',
      };

      final snapshot = await _recipesRef.get();

      // If recipes already exist in Firestore, update all matching documents with new food images & corrected titles!
      if (snapshot.docs.isNotEmpty) {
        for (final doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final String title = data['title'] ?? '';

          if (newImageUrls.containsKey(title) || title.contains('กระเทียม') || title.contains('ต้มยำ')) {
            String newUrl = newImageUrls[title] ?? '';
            String correctedTitle = title;

            if (title.contains('ต้มยำ')) {
              newUrl = newImageUrls['ต้มยำกุ้งน้ำข้น']!;
            } else if (title.contains('กระเทียม')) {
              newUrl = newImageUrls['ขนมปังกระเทียม']!;
              correctedTitle = 'ขนมปังกระเทียม';
            }

            await _recipesRef.doc(doc.id).update({
              'imageUrl': newUrl,
              'title': correctedTitle,
              'isRecommended': title.contains('ต้มยำ') || title.contains('ข้าวผัด') || title.contains('ชาไทย'),
            });
          }
        }

        if (!force) return;
      }

      // If collection was empty or force is true, insert full set if missing
      if (snapshot.docs.isEmpty) {
        final List<RecipeModel> sampleRecipes = [
          RecipeModel(
            id: '',
            title: 'ข้าวผัดไข่',
            description: 'เมนูง่าย ๆ ใช้วัตถุดิบน้อย หอมกลิ่นกระทะ ทำง่ายกินอร่อย',
            imageUrl: newImageUrls['ข้าวผัดไข่']!,
            category: 'อาหารจานเดียว',
            prepTime: 5,
            cookingTime: 10,
            servings: 1,
            difficulty: 'ง่าย',
            isRecommended: true,
            ingredients: [
              IngredientModel(name: 'ข้าวสวย', amount: '1 ถ้วย', preparation: 'พักให้เย็น'),
              IngredientModel(name: 'ไข่ไก่', amount: '2 ฟอง', preparation: 'ตอกใส่ถ้วย'),
              IngredientModel(name: 'กระเทียม', amount: '1 ช้อนโต๊ะ', preparation: 'สับละเอียด'),
              IngredientModel(name: 'ต้นหอม', amount: '1 ต้น', preparation: 'ซอยละเอียด'),
              IngredientModel(name: 'ซีอิ๊วขาว', amount: '1 ช้อนชา', preparation: 'ตวงเตรียมไว้'),
              IngredientModel(name: 'น้ำมันพืช', amount: '1.5 ช้อนโต๊ะ', preparation: 'ตวงเตรียมไว้'),
            ],
            steps: [
              'ตั้งกระทะใสน้ำมัน ใช้ไฟปานกลาง ใส่กระเทียมสับลงผัดให้หอม',
              'ตอกไข่ไก่ลงกระทะ ใช้ตะหลิวยีไข่ให้พอสุกปานกลาง',
              'ใส่ข้าวสวยลงไป ผัดให้เข้ากันด้วยไฟแรง',
              'ปรุงรสด้วยซีอิ๊วขาว ซอสปรุงรส และพริกไทยป่นตามชอบ',
              'โรยต้นหอมซอย ผัดให้เข้ากันอีกรอบ จัดใส่จานพร้อมเสิร์ฟ'
            ],
            createdBy: currentUserId,
            createdAt: DateTime.now(),
          ),
          RecipeModel(
            id: '',
            title: 'ต้มยำกุ้งน้ำข้น',
            description: 'ต้มยำกุ้งรสแซ่บจัดจ้าน น้ำซุปเข้มข้น หอมกลิ่นสมุนไพรไทย',
            imageUrl: newImageUrls['ต้มยำกุ้งน้ำข้น']!,
            category: 'อาหารจานเดียว',
            prepTime: 15,
            cookingTime: 15,
            servings: 2,
            difficulty: 'ปานกลาง',
            isRecommended: true,
            ingredients: [
              IngredientModel(name: 'กุ้งแม่น้ำ', amount: '6 ตัว', preparation: 'แกะเปลือกผ่าหลังดึงเส้นดำออก'),
              IngredientModel(name: 'เห็ดฟาง', amount: '100 กรัม', preparation: 'ผ่าครึ่งล้างสะอาด'),
              IngredientModel(name: 'ข่า', amount: '5 แว่น', preparation: 'หั่นแว่น'),
              IngredientModel(name: 'ตะไคร้', amount: '2 ต้น', preparation: 'ทุบหั่นท่อน'),
              IngredientModel(name: 'ใบมะกรูด', amount: '4 ใบ', preparation: 'ฉีกก้านกลางออก'),
              IngredientModel(name: 'น้ำพริกเผา', amount: '2 ช้อนโต๊ะ', preparation: 'ตวงเตรียมไว้'),
              IngredientModel(name: 'นมข้นจืด', amount: '4 ช้อนโต๊ะ', preparation: 'ตวงเตรียมไว้'),
            ],
            steps: [
              'ต้มน้ำสต๊อกให้เดือด ใส่ข่า ตะไคร้ ใบมะกรูด และหอมแดงทุบลงไป',
              'ใส่น้ำพริกเผา คนให้ละลาย รอน้ำเดือดอีกครั้ง',
              'ใส่เห็ดฟางและกุ้งสดลงไป ปรุงรสด้วยน้ำปลา',
              'เมื่อกุ้งเริ่มสุก ใส่นมข้นจืด ยกลงจากเตา',
              'บีบน้ำมะนาว ใส่พริกขี้หนูทุบตามชอบ และโรยผักชีฝรั่ง'
            ],
            createdBy: currentUserId,
            createdAt: DateTime.now(),
          ),
          RecipeModel(
            id: '',
            title: 'แพนเค้กนุ่มฟู',
            description: 'ขนมหวานทำง่ายยามเช้า หอมเนย เนื้อนุ่มฟู ทานคู่กับเมเปิ้ลไซรัป',
            imageUrl: newImageUrls['แพนเค้กนุ่มฟู']!,
            category: 'ของหวาน',
            prepTime: 10,
            cookingTime: 10,
            servings: 2,
            difficulty: 'ง่าย',
            isRecommended: false,
            ingredients: [
              IngredientModel(name: 'แป้งสาลีอเนกประสงค์', amount: '1 ถ้วย', preparation: 'ร่อนผ่านกระชอน'),
              IngredientModel(name: 'ผงฟู', amount: '1 ช้อนชา', preparation: 'ร่อนพร้อมแป้ง'),
              IngredientModel(name: 'นมสด', amount: '3/4 ถ้วย', preparation: 'ตวงระดับอุณหภูมิห้อง'),
              IngredientModel(name: 'ไข่ไก่', amount: '1 ฟอง', preparation: 'แยกไข่แดงและไข่ขาว'),
              IngredientModel(name: 'เนยละลาย', amount: '2 ช้อนโต๊ะ', preparation: 'พักให้เย็น'),
            ],
            steps: [
              'ผสมแป้งสาลี ผงฟู น้ำตาลทราย และเกลือในอ่างผสม',
              'ผสมนมสด ไข่แดง และเนยละลายเข้าด้วยกัน นำไปเทใส่ส่วนผสมของแห้งแล้วคนให้เข้ากันพอเห็นเนื้อแป้งเนียน',
              'ตีไข่ขาวจนตั้งยอดอ่อน แล้วนำมาตะล่อมใส่ส่วนผสมแป้งเบา ๆ',
              'ตั้งกระทะเทฟลอนไฟอ่อน ทาเนยบาง ๆ หยอดแป้งลงไป พอมีฟองอากาศปูดขึ้นมาจึงพลิกด้าน',
              'จัดใส่จาน เสิร์ฟพร้อมเนยและน้ำเชื่อมเมเปิ้ล'
            ],
            createdBy: currentUserId,
            createdAt: DateTime.now(),
          ),
          RecipeModel(
            id: '',
            title: 'ขนมปังกระเทียม',
            description: 'ของว่างเคี้ยวเพลิน หอมกระเทียมและเนย สดใหม่จากเตาอบ',
            imageUrl: newImageUrls['ขนมปังกระเทียม']!,
            category: 'ของว่าง',
            prepTime: 10,
            cookingTime: 8,
            servings: 3,
            difficulty: 'ง่าย',
            isRecommended: false,
            ingredients: [
              IngredientModel(name: 'ขนมปังฝรั่งเศส', amount: '1 แถว', preparation: 'หั่นเฉียงหนา 1 นิ้ว'),
              IngredientModel(name: 'เนยสดรสเค็ม', amount: '100 กรัม', preparation: 'อ่อนตัวที่อุณหภูมิห้อง'),
              IngredientModel(name: 'กระเทียมสับ', amount: '2 ช้อนโต๊ะ', preparation: 'สับละเอียดมาก'),
              IngredientModel(name: 'พาร์สลีย์ซอย', amount: '1 ช้อนโต๊ะ', preparation: 'สับละเอียด'),
            ],
            steps: [
              'ผสมเนยสด กระเทียมสับ และพาร์สลีย์ซอยเข้าด้วยกันในถ้วย',
              'ทาเนยกระเทียมลงบนชิ้นขนมปังทั้งสองด้าน หรือเฉพาะด้านหน้า',
              'วางเรียงขนมปังลงบนถาดอบ',
              'อบที่อุณหภูมิ 180 องศาเซลเซียส ประมาณ 8-10 นาที จนกรอบทอง',
              'ยกออกจากเตาจัดเสิร์ฟขณะร้อน'
            ],
            createdBy: currentUserId,
            createdAt: DateTime.now(),
          ),
          RecipeModel(
            id: '',
            title: 'ชาไทยเย็นนมหอม',
            description: 'เครื่องดื่มชาไทยรสเข้มข้น หอมหวานมัน สดชื่นคลายร้อน',
            imageUrl: newImageUrls['ชาไทยเย็นนมหอม']!,
            category: 'เครื่องดื่ม',
            prepTime: 5,
            cookingTime: 5,
            servings: 1,
            difficulty: 'ง่าย',
            isRecommended: true,
            ingredients: [
              IngredientModel(name: 'ผงชาไทย', amount: '2 ช้อนโต๊ะ', preparation: 'ตวงเตรียมไว้'),
              IngredientModel(name: 'น้ำร้อน', amount: '150 มล.', preparation: 'ต้มให้เดือด'),
              IngredientModel(name: 'นมข้นหวาน', amount: '30 มล.', preparation: 'ตวงเตรียมไว้'),
              IngredientModel(name: 'นมข้นจืด', amount: '30 มล.', preparation: 'ตวงเตรียมไว้'),
              IngredientModel(name: 'น้ำแข็ง', amount: '1 แก้ว', preparation: 'เตรียมใส่แก้ว'),
            ],
            steps: [
              'ชงผงชาไทยด้วยน้ำร้อนในถุงกรองชา แช่ไว้ 3 นาทีแล้วชงสลับไปมา',
              'กรองเอาเฉพาะน้ำชาเข้มข้นใส่แก้วผสม',
              'เติมนมข้นหวานและนมข้นจืด คนให้เข้ากันจนละลายดี',
              'เทชาไทยลงในแก้วที่ใส่น้ำแข็งเตรียมไว้',
              'ราดนมสดหรือนมข้นจืดด้านบนเพิ่มความหอมมัน'
            ],
            createdBy: currentUserId,
            createdAt: DateTime.now(),
          ),
        ];

        for (final recipe in sampleRecipes) {
          await addRecipe(recipe);
        }
      }
    } catch (_) {}
  }
}
