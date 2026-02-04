import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import 'dart:io';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storageService = StorageService();
  
  User? _user;
  UserModel? _userProfile;
  bool _isLoading = false;

  User? get user => _user;
  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  AuthProvider() {
    // Listen to authState changes
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      if (user != null) {
        await fetchUserProfile();
      } else {
        _userProfile = null;
      }
      notifyListeners();
    });
  }

  // Fetch User Profile from Firestore
  Future<void> fetchUserProfile() async {
    if (_user == null) return;
    try {
      final doc = await _firestore
          .collection('users')
          .doc(_user!.uid)
          .get()
          .timeout(const Duration(seconds: 10));
      if (doc.exists) {
        _userProfile = UserModel.fromMap(doc.data()!);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching user profile: $e");
    }
  }

  // Update User Profile in Firestore
  Future<String?> updateUserProfile(UserModel profile) async {
    _setLoading(true);
    try {
      await _firestore
          .collection('users')
          .doc(profile.uid)
          .set(profile.toMap())
          .timeout(const Duration(seconds: 10));
      _userProfile = profile;
      _setLoading(false);
      notifyListeners();
      return null; // Success
    } catch (e) {
      _setLoading(false);
      debugPrint("Firestore Error: $e");
      if (e.toString().contains("TimeoutException")) {
        return "Connection timed out. Please check your internet or Firebase console.";
      }
      return e.toString();
    }
  }

  // Login
  Future<String?> login(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await fetchUserProfile();
      _setLoading(false);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      return e.message ?? "Authentication failed";
    } catch (e) {
      _setLoading(false);
      return "An unknown error occurred";
    }
  }

  // Register
  Future<String?> register({
    required String email, 
    required String password, 
    required String displayName,
    required String phoneNumber,
    required String address,
  }) async {
    _setLoading(true);
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      final user = userCredential.user;
      if (user != null) {
        // Update display name in Firebase Auth
        await user.updateDisplayName(displayName);

        // Save profile to Firestore
        final newUser = UserModel(
          uid: user.uid,
          email: email,
          displayName: displayName,
          phoneNumber: phoneNumber,
          address: address,
        );
        
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        _userProfile = newUser;
      }
      
      _setLoading(false);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      return e.message ?? "Registration failed";
    } catch (e) {
      _setLoading(false);
      return "An unknown error occurred";
    }
  }
  
  // Update Profile Image
  Future<String?> updateProfileImage(File imageFile) async {
    if (_user == null || _userProfile == null) return "User not logged in";
    
    _setLoading(true);
    try {
      final downloadUrl = await _storageService.uploadProfileImage(_user!.uid, imageFile);
      if (downloadUrl != null) {
        final updatedProfile = UserModel(
          uid: _userProfile!.uid,
          email: _userProfile!.email,
          displayName: _userProfile!.displayName,
          phoneNumber: _userProfile!.phoneNumber,
          address: _userProfile!.address,
          profileImageUrl: downloadUrl,
        );
        
        return await updateUserProfile(updatedProfile);
      }
      _setLoading(false);
      return "Failed to upload image";
    } catch (e) {
      _setLoading(false);
      return e.toString();
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    _userProfile = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
