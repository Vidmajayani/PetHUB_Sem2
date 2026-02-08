import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _reviewsCollection => _firestore.collection('reviews');

  /// Submit a new review
  Future<void> submitReview(ReviewModel review) async {
    try {
      await _reviewsCollection.doc(review.id).set(review.toMap());
    } catch (e) {
      print('Error submitting review: $e');
      rethrow;
    }
  }

  /// Get all reviews for a specific product
  Future<List<ReviewModel>> getReviewsByProductId(String productId) async {
    try {
      final querySnapshot = await _reviewsCollection
          .where('productId', isEqualTo: productId)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ReviewModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  /// Get all reviews submitted by a specific user
  Future<List<ReviewModel>> getReviewsByUserId(String userId) async {
    try {
      final querySnapshot = await _reviewsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ReviewModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching user reviews: $e');
      return [];
    }
  }

  /// Check if a user has already reviewed a product
  Future<bool> hasUserReviewedProduct(String userId, String productId) async {
    try {
      final querySnapshot = await _reviewsCollection
          .where('userId', isEqualTo: userId)
          .where('productId', isEqualTo: productId)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking review status: $e');
      return false;
    }
  }
}
