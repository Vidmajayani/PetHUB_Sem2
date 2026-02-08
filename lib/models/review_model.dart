import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String userImage;
  final String? reviewImage; // Optional image for the review
  final double rating;
  final String comment;
  final DateTime date;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.userImage,
    this.reviewImage,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'reviewImage': reviewImage,
      'rating': rating,
      'comment': comment,
      'date': Timestamp.fromDate(date),
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map, String docId) {
    DateTime parsedDate;
    final dateField = map['date'];

    if (dateField is Timestamp) {
      parsedDate = dateField.toDate();
    } else if (dateField is String) {
      parsedDate = DateTime.tryParse(dateField) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return ReviewModel(
      id: docId,
      productId: map['productId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Anonymous',
      userImage: map['userImage'] ?? '',
      reviewImage: map['reviewImage'],
      rating: (map['rating'] ?? 0.0).toDouble(),
      comment: map['comment'] ?? '',
      date: parsedDate,
    );
  }

}

