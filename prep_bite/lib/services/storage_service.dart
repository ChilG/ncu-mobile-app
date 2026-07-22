import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  FirebaseStorage get _storage => FirebaseStorage.instance;

  Future<String> uploadRecipeImage(XFile imageFile) async {
    try {
      final String fileName =
          'recipe_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage.ref().child('recipe_images/$fileName');

      final UploadTask uploadTask = ref.putFile(File(imageFile.path));
      final TaskSnapshot snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw 'เกิดข้อผิดพลาดในการอัปโหลดรูปภาพ: ${e.toString()}';
    }
  }

  Future<void> deleteRecipeImage(String imageUrl) async {
    try {
      if (imageUrl.startsWith('https://firebasestorage.googleapis.com')) {
        final Reference ref = _storage.refFromURL(imageUrl);
        await ref.delete();
      }
    } catch (_) {
      // Ignore if image not found or fails to delete
    }
  }
}
