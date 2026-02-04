import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class StorageService {
  /// Converts an image file to a Base64 string for storage in Firestore.
  /// This avoids the need for Firebase Storage billing/upgrade.
  Future<String?> uploadProfileImage(String userId, File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      // Use base64Encode to get the string representation
      final String base64String = base64Encode(bytes);
      
      // We return the data URI format so the UI can easily display it
      return "data:image/jpeg;base64,$base64String";
    } catch (e) {
      debugPrint("Storage Error (Base64): $e");
      return null;
    }
  }

  /// No-op for Base64 as it's just a string in the database
  Future<void> deleteFile(String url) async {}
}
