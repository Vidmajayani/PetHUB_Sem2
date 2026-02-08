import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String userId;
  final String serviceId;
  final String serviceTitle;
  final String serviceImage;
  final DateTime date;
  final String timeSlot;
  final double price;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.serviceTitle,
    required this.serviceImage,
    required this.date,
    required this.timeSlot,
    required this.price,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'serviceId': serviceId,
      'serviceTitle': serviceTitle,
      'serviceImage': serviceImage,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'price': price,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      serviceId: json['serviceId'] ?? '',
      serviceTitle: json['serviceTitle'] ?? '',
      serviceImage: json['serviceImage'] ?? '',
      date: DateTime.parse(json['date']),
      timeSlot: json['timeSlot'] ?? '',
      price: (json['price'] as num).toDouble(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
}
