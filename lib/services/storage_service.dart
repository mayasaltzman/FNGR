import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  static final StorageService _instance = StorageService._internal();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  /// Upload a single image to Firebase Storage
  /// Returns the download URL of the uploaded image
  Future<String> uploadProfileImage({
    required File imageFile,
    required String userId,
    required int imageIndex,
  }) async {
    try {
      // Create a unique filename
      final String fileName = 'profile_${imageIndex}_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      
      // Reference to the storage location
      final Reference ref = _storage
          .ref()
          .child('users')
          .child(userId)
          .child('profile_images')
          .child(fileName);

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );
      // Upload the file
      final UploadTask uploadTask = ref.putFile(imageFile);
      
      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;
      
      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Upload multiple images and return list of download URLs
  Future<List<String>> uploadMultipleProfileImages({
    required List<File> imageFiles,
    required String userId,

    }) async {
    List<String> downloadUrls = [];
    
    for (int i = 0; i < imageFiles.length; i++) {
      try {

        
        final url = await uploadProfileImage(
          imageFile: imageFiles[i],
          userId: userId,
          imageIndex: i,
        );
        downloadUrls.add(url);


        print('Uploaded image ${i + 1}/${imageFiles.length}');
      } catch (e) {
        print('Error uploading image $i: $e');
        // Continue with other images even if one fails
      }
    } 
    if (downloadUrls.isEmpty) {
      throw Exception('Failed to upload any images.');
    }

    return downloadUrls;
  }

  /// Delete a profile image
  Future<void> deleteProfileImage(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  /// Delete all profile images for a user
  Future<void> deleteAllProfileImages(String userId) async {
    try {
      final Reference ref = _storage
          .ref()
          .child('users')
          .child(userId)
          .child('profile_images');
      
      final ListResult result = await ref.listAll();
      
      for (Reference fileRef in result.items) {
        await fileRef.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete all images: $e');
    }
  }
  
  
  Future<String> replaceProfileImage({
    required File newImageFile,
    required String userId,
    required int imageIndex,
    String? oldImageUrl,
  }) async {
    try {
      // Delete old image if URL provided
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        try {
          await deleteProfileImage(oldImageUrl);
        } catch (e) {
          print('Could not delete old image: $e');
          // Continue with upload even if delete fails
        }
      }
      
      // Upload new image
      return await uploadProfileImage(
        imageFile: newImageFile,
        userId: userId,
        imageIndex: imageIndex,
      );
    } catch (e) {
      throw Exception('Failed to replace image: $e');
    }
  }

  Future<double> getFileSizeInMB(File file) async {
    final bytes = await file.length();
    return bytes / (1024 * 1024);
  }

  Future<bool> isFileSizeAcceptable(File file, {int maxSizeMB = 10}) async {
    final sizeInMB = await getFileSizeInMB(file);
    return sizeInMB <= maxSizeMB;
  }
}