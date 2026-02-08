import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../models/review_model.dart';
import '../../../providers/review_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/storage_service.dart';
import '../widgets/rate_star_selector.dart';
import '../widgets/review_image_selector.dart';

class ReviewDialog extends StatefulWidget {
  final String productId;
  final String productName;

  const ReviewDialog({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  double _rating = 0.0;
  final TextEditingController _commentController = TextEditingController();
  final StorageService _storageService = StorageService();
  final ImagePicker _picker = ImagePicker();
  
  File? _selectedImage;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 50,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _submitReview() async {
    // 1. Validate Rating
    if (_rating == 0.0) {
      setState(() => _errorMessage = 'Please pick at least one star! 🐾');
      return;
    }

    // 2. Validate Comment
    if (_commentController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Tell us a bit more about what you liked! 🐾');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);

      // 3. Process Image if exists
      String? reviewImageUrl;
      if (_selectedImage != null) {
        reviewImageUrl = await _storageService.uploadProfileImage(
          auth.user?.uid ?? 'temp', 
          _selectedImage!
        );
      }

      final review = ReviewModel(
        id: const Uuid().v4(),
        productId: widget.productId,
        userId: auth.user?.uid ?? 'unknown',
        userName: auth.userProfile?.displayName ?? 'Anonymous',
        userImage: auth.userProfile?.profileImageUrl ?? '',
        reviewImage: reviewImageUrl,
        rating: _rating,
        comment: _commentController.text.trim(),
        date: DateTime.now(),
      );

      await reviewProvider.addReview(review);

      if (mounted) {
        Navigator.of(context).pop(true);
      }

    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Error: $e');
      }

    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          color: colorScheme.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10, 8),
                child: Row(
                  children: [
                    const SizedBox(width: 40),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Rate & Review",
                            style: TextStyle(
                              color: colorScheme.primary, 
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.productName,
                            style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 20),
                      ),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),

              const Divider(height: 1),

              // SCROLLABLE CONTENT
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_errorMessage != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline_rounded, color: Colors.red.shade700, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),

                      RateStarSelector(
                        rating: _rating,
                        onRatingSelected: (val) {
                          setState(() {
                            _rating = val;
                            _errorMessage = null;
                          });
                        },
                      ),
                      
                      const SizedBox(height: 28),
                      const Text("Feedback (Mandatory)", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _commentController,
                        maxLines: 4,
                        onChanged: (v) {
                          if (_errorMessage != null) setState(() => _errorMessage = null);
                        },
                        decoration: InputDecoration(
                          hintText: "What did you like or dislike about the ${widget.productName}?",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: colorScheme.outlineVariant),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.2),
                        ),
                      ),
                      const SizedBox(height: 28),
                      
                      ReviewImageSelector(
                        selectedImage: _selectedImage,
                        onImagePick: (source) => _pickImage(source),
                        onImageRemove: _removeImage,
                      ),
                    ],
                  ),
                ),
              ),

              const Divider(height: 1),

              // FOOTER BUTTON
              Padding(
                padding: const EdgeInsets.all(20),
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _submitReview,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text("Submit Review", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


