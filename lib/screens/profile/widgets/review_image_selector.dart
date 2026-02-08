import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReviewImageSelector extends StatelessWidget {
  final File? selectedImage;
  final Function(ImageSource) onImagePick;
  final VoidCallback onImageRemove;

  const ReviewImageSelector({
    super.key,
    required this.selectedImage,
    required this.onImagePick,
    required this.onImageRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Add Photo (Optional)", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (selectedImage != null)
          Stack(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: FileImage(selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: onImageRemove,
                  ),
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              _buildPickerButton(
                context,
                icon: Icons.camera_alt_rounded,
                label: "Camera",
                onTap: () => onImagePick(ImageSource.camera),
              ),
              const SizedBox(width: 16),
              _buildPickerButton(
                context,
                icon: Icons.photo_library_rounded,
                label: "Gallery",
                onTap: () => onImagePick(ImageSource.gallery),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPickerButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
