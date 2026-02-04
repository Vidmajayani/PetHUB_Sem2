import 'review_model.dart';

class Product {
  final String id;
  final String category; // e.g. "Dogs"
  final String subcategory; // e.g. "Food", "Toys", "Accessories", "Treats"
  final String name;
  final String description;
  final double price;
  final String image; // asset path or URL
  final double rating;
  final List<ReviewModel> reviews;
  
  // Detailed fields
  final String? ingredients;
  final String? healthBenefits;
  final String? targetAudience;
  final String? specialFeatures;
  final String? usageInstructions;

  Product({
    required this.id,
    required this.category,
    required this.subcategory,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.rating,
    this.reviews = const [],
    this.ingredients,
    this.healthBenefits,
    this.targetAudience,
    this.specialFeatures,
    this.usageInstructions,
  });

  /// Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'subcategory': subcategory,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'rating': rating,
      'reviews': reviews.map((r) => r.toMap()).toList(),
      if (ingredients != null) 'ingredients': ingredients,
      if (healthBenefits != null) 'healthBenefits': healthBenefits,
      if (targetAudience != null) 'targetAudience': targetAudience,
      if (specialFeatures != null) 'specialFeatures': specialFeatures,
      if (usageInstructions != null) 'usageInstructions': usageInstructions,
    };
  }

  /// Create Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      category: json['category'] as String,
      subcategory: json['subcategory'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((r) => ReviewModel.fromMap(r as Map<String, dynamic>, r['id'] ?? ''))
              .toList() ??
          [],
      ingredients: json['ingredients'] as String?,
      healthBenefits: json['healthBenefits'] as String?,
      targetAudience: json['targetAudience'] as String?,
      specialFeatures: json['specialFeatures'] as String?,
      usageInstructions: json['usageInstructions'] as String?,
    );
  }
}

