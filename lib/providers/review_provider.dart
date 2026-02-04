import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../services/review_service.dart';

class ReviewProvider with ChangeNotifier {
  final ReviewService _reviewService = ReviewService();
  
  List<ReviewModel> _currentProductReviews = [];
  bool _isLoading = false;
  Map<String, bool> _userReviewStatus = {}; // Map of productId to boolean (hasReviewed)

  List<ReviewModel> get currentProductReviews => _currentProductReviews;
  bool get isLoading => _isLoading;

  /// Fetch reviews for a specific product
  Future<void> fetchReviews(String productId) async {
    _isLoading = true;
    notifyListeners();

    _currentProductReviews = await _reviewService.getReviewsByProductId(productId);
    
    _isLoading = false;
    notifyListeners();
  }

  /// Submit a review
  Future<void> addReview(ReviewModel review) async {
    _isLoading = true;
    notifyListeners();

    await _reviewService.submitReview(review);
    
    // Add to local list for immediate feedback
    _currentProductReviews.insert(0, review);
    _userReviewStatus[review.productId] = true;

    _isLoading = false;
    notifyListeners();
  }

  /// Check if a user has already reviewed a product
  Future<bool> checkUserReview(String userId, String productId) async {
    if (_userReviewStatus.containsKey(productId)) {
      return _userReviewStatus[productId]!;
    }

    final hasReviewed = await _reviewService.hasUserReviewedProduct(userId, productId);
    _userReviewStatus[productId] = hasReviewed;
    return hasReviewed;
  }
  
  /// Clear data for specific product (e.g. when leaving the page)
  void clearReviews() {
    _currentProductReviews = [];
    notifyListeners();
  }
}
