import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';
import '../providers/notification_provider.dart';
import 'package:uuid/uuid.dart';

class BookingProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<BookingModel> _bookings = [];
  bool _isLoading = false;

  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;

  // Fetch Bookings from Firestore for a specific user
  Future<void> fetchBookings(String userId) async {
    _setLoading(true);
    try {
      final querySnapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _bookings.clear();
      for (var doc in querySnapshot.docs) {
        _bookings.add(BookingModel.fromJson(doc.data()));
      }
    } catch (e) {
      debugPrint('Error fetching bookings: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Create a new Booking
  Future<bool> createBooking({
    required String userId,
    required String serviceId,
    required String serviceTitle,
    required String serviceImage,
    required DateTime date,
    required String timeSlot,
    required double price,
    required NotificationProvider notificationProvider,
  }) async {
    _setLoading(true);
    try {
      final bookingId = const Uuid().v4();
      final newBooking = BookingModel(
        id: bookingId,
        userId: userId,
        serviceId: serviceId,
        serviceTitle: serviceTitle,
        serviceImage: serviceImage,
        date: date,
        timeSlot: timeSlot,
        price: price,
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestore.collection('bookings').doc(bookingId).set(newBooking.toJson());

      // Update local list
      _bookings.insert(0, newBooking);

      // System & In-App Notification
      await notificationProvider.addNotification(
        title: 'Booking Confirmed! 🐾',
        message: 'Your session for $serviceTitle on ${date.day}/${date.month} at $timeSlot is scheduled.',
      );

      _setLoading(false);
      return true;
    } catch (e) {
      debugPrint('Error creating booking: $e');
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
