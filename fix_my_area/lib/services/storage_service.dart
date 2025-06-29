import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fix_my_area/services/auth_service.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AuthService _authService = AuthService();

  // Pick an image from gallery
  Future<XFile?> pickImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  // Upload profile picture and return the download URL
  Future<String> uploadProfilePicture(XFile imageFile) async {
    final String userId = _authService.currentUser!.uid;
    final ref = _storage.ref().child('profile_pictures/$userId/profile.jpg');
    await ref.putFile(File(imageFile.path));
    return await ref.getDownloadURL();
  }
}
