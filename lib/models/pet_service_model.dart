class PetServiceModel {
  final String id;
  String title; // Removed final
  String description; // Removed final
  final double price;
  final String image;
  String category; // Removed final
  final String? temperament;

  final String? origin;
  final String? lifeSpan;
  final int? adaptability;
  final int? affectionLevel;
  final int? childFriendly;
  final int? dogFriendly;
  final int? energyLevel;
  final int? groomingLevel;
  final int? healthIssues;
  final int? intelligence;
  final int? sheddingLevel;
  final int? socialNeeds;
  final int? strangerFriendly;
  final int? vocalisation;

  PetServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.temperament,
    this.origin,
    this.lifeSpan,
    this.adaptability,
    this.affectionLevel,
    this.childFriendly,
    this.dogFriendly,
    this.energyLevel,
    this.groomingLevel,
    this.healthIssues,
    this.intelligence,
    this.sheddingLevel,
    this.socialNeeds,

    this.strangerFriendly,
    this.vocalisation,
  });

  factory PetServiceModel.fromJson(Map<String, dynamic> json) {
    // Robust parsing for Third-Party API data
    String imageUrl = 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?q=80&w=400';
    
    // Improve image URL logic for cats vs dogs
    // Improve image URL logic for cats vs dogs
    try {
      if (json['image'] is String) {
        imageUrl = json['image'];
      } else if (json['image'] != null && json['image']['url'] != null) {
        imageUrl = json['image']['url'];
      } else if (json['reference_image_id'] != null) {
        // We look for hints in the ID or name to decide which CDN to use
        // But the safest is checking the 'origin' or other cat-specific fields
        bool isCat = json['adaptability'] != null || json['vocalisation'] != null;
        String cdn = isCat ? 'thecatapi' : 'thedogapi';
        imageUrl = 'https://cdn2.$cdn.com/images/${json['reference_image_id']}.jpg';
      }
    } catch (e) {
      print('⚠️ Image parsing fallback for breed: ${json['name']}');
    }

    // Handle Dog API missing 'description' field
    String professionalDesc = json['description'] ?? json['bred_for'] ?? 'A professional consultation for this breed. Includes a health overview and behavioral assessment.';

    return PetServiceModel(
      id: json['id']?.toString() ?? '0',
      title: json['title'] ?? json['name'] ?? 'Pet Care Consultation',
      description: professionalDesc,
      price: (json['price'] as num?)?.toDouble() ?? 2500.0,
      image: imageUrl,
      category: json['category'] ?? 'Breed Professional Services',
      temperament: json['temperament'],
      origin: json['origin'],
      lifeSpan: json['life_span'] ?? json['lifeSpan'],
      adaptability: json['adaptability'],
      affectionLevel: json['affectionLevel'] ?? json['affection_level'],
      childFriendly: json['childFriendly'] ?? json['child_friendly'],
      dogFriendly: json['dogFriendly'] ?? json['dog_friendly'],
      energyLevel: json['energyLevel'] ?? json['energy_level'],
      groomingLevel: json['groomingLevel'] ?? json['grooming'],
      healthIssues: json['healthIssues'] ?? json['health_issues'],
      intelligence: json['intelligence'],
      sheddingLevel: json['sheddingLevel'] ?? json['shedding_level'],
      socialNeeds: json['socialNeeds'] ?? json['social_needs'],
      strangerFriendly: json['strangerFriendly'] ?? json['stranger_friendly'],
      vocalisation: json['vocalisation'],
    );

  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'temperament': temperament,
      'origin': origin,
      'lifeSpan': lifeSpan,
      'adaptability': adaptability,
      'affectionLevel': affectionLevel,
      'childFriendly': childFriendly,
      'dogFriendly': dogFriendly,
      'energyLevel': energyLevel,
      'groomingLevel': groomingLevel,
      'healthIssues': healthIssues,
      'intelligence': intelligence,
      'sheddingLevel': sheddingLevel,
      'socialNeeds': socialNeeds,
      'strangerFriendly': strangerFriendly,
      'vocalisation': vocalisation,
    };
  }

  void setCategory(String newCat) {
    category = newCat;
  }
}