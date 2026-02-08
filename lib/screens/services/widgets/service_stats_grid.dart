import 'package:flutter/material.dart';
import 'package:pet_supplies_app_v2/models/pet_service_model.dart';

class ServiceStatsGrid extends StatelessWidget {
  final PetServiceModel service;

  const ServiceStatsGrid({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Breed Characteristics",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            ),
            Icon(Icons.info_outline, size: 18, color: Colors.grey.shade400),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.8, // Slightly taller for icon + text
          children: [
            _buildStatItem(context, "Intelligence", service.intelligence, Icons.psychology_outlined),
            _buildStatItem(context, "Energy Level", service.energyLevel, Icons.bolt_outlined),
            _buildStatItem(context, "Affection", service.affectionLevel, Icons.favorite_border),
            _buildStatItem(context, "Child Friendly", service.childFriendly, Icons.child_care_outlined),
            _buildStatItem(context, "Dog Friendly", service.dogFriendly, Icons.pets_outlined),
            _buildStatItem(context, "Adaptability", service.adaptability, Icons.alt_route_outlined),
            _buildStatItem(context, "Grooming", service.groomingLevel, Icons.content_cut_outlined),
            _buildStatItem(context, "Social Needs", service.socialNeeds, Icons.groups_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, int? value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark ? Colors.orange.withOpacity(0.1) : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: Colors.orange.shade700),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            "Level",
            style: TextStyle(fontSize: 10, color: isDark ? Colors.grey[500] : Colors.grey, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(5, (index) {
              final isActive = index < (value ?? 0);
              return Container(
                margin: const EdgeInsets.only(right: 2),
                child: Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: isActive ? Colors.amber.shade600 : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
