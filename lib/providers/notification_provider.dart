import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final List<NotificationModel> _notifications = [];
  final NotificationService _service = NotificationService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription? _subscription;
  
  // Real-time notification broadcaster
  final _notificationStreamController = StreamController<NotificationModel>.broadcast();
  Stream<NotificationModel> get onNewNotification => _notificationStreamController.stream;

  List<NotificationModel> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationProvider() {
    _service.initialize();
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _startSyncing(user.uid);
      } else {
        _stopSyncing();
      }
    });
  }

  void _startSyncing(String uid) {
    _subscription?.cancel();
    _subscription = _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((doc) {
      if (doc.exists && doc.data()?['notifications'] != null) {
        final List<dynamic> data = doc.data()!['notifications'];
        _notifications.clear();
        _notifications.addAll(
          data.map((json) => NotificationModel.fromJson(json)).toList(),
        );
        // Sort by timestamp descending (newest first)
        _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        notifyListeners();
      }
    });
  }

  void _stopSyncing() {
    _subscription?.cancel();
    _subscription = null;
    _notifications.clear();
    notifyListeners();
  }

  Future<void> addNotification({required String title, required String message}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final notification = NotificationModel(
      id: const Uuid().v4(),
      title: title,
      message: message,
      timestamp: DateTime.now(),
    );

    // Show system notification
    await _service.showNotification(
      id: notification.id.hashCode,
      title: title,
      body: message,
    );

    // Broadcast for in-app pop-up
    _notificationStreamController.add(notification);

    // Push to Firestore
    final updatedList = [notification.toJson(), ..._notifications.map((n) => n.toJson())];
    await _firestore.collection('users').doc(uid).set({
      'notifications': updatedList,
      'lastNotificationAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Shows an in-app banner ONLY. 
  /// Does NOT save to history and does NOT send a system alert.
  void showTemporaryBanner({required String title, required String message}) {
    final notification = NotificationModel(
      id: const Uuid().v4(),
      title: title,
      message: message,
      timestamp: DateTime.now(),
    );

    // Broadcast ONLY for the in-app overlay
    _notificationStreamController.add(notification);
  }


  final Set<int> _triggeredThresholds = {};

  void checkCartReminder(int itemCount) {
    if (itemCount >= 10 && !_triggeredThresholds.contains(10)) {
      addNotification(
        title: 'Your Cart is Full! 🛒🐾',
        message: 'You have over $itemCount items waiting for you! Grab them now and treat your pet to something special! ✨',
      );
      _triggeredThresholds.add(10);
    } else if (itemCount < 10) {
      _triggeredThresholds.remove(10);
    }
  }

  Future<void> markAsRead(String id) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      await _syncToFirestore(uid);
    }
  }

  Future<void> markAllAsRead() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    for (var n in _notifications) {
      n.isRead = true;
    }
    await _syncToFirestore(uid);
  }

  Future<void> clearAll() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _notifications.clear();
    await _syncToFirestore(uid);
  }

  @override
  void dispose() {
    _notificationStreamController.close();
    super.dispose();
  }

  Future<void> _syncToFirestore(String uid) async {
    await _firestore.collection('users').doc(uid).set({
      'notifications': _notifications.map((n) => n.toJson()).toList(),
    }, SetOptions(merge: true));
  }
}
