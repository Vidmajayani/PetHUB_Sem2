import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/location_provider.dart';

class ShippingForm extends StatelessWidget {
  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController phone;
  final TextEditingController street;
  final TextEditingController city;
  final TextEditingController state;
  final TextEditingController zip;
  final TextEditingController country;

  const ShippingForm({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildField(context, "Full Name", name, Icons.person, validator: _required),
        const SizedBox(height: 16),
        _buildField(context, "Email", email, Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail),
        const SizedBox(height: 16),
        _buildField(context, "Phone", phone, Icons.phone,
            keyboardType: TextInputType.phone, validator: _validatePhone),
        const SizedBox(height: 16),
        _buildField(
          context,
          "Street Address",
          street,
          Icons.home,
          validator: _required,
          suffixIcon: Consumer<LocationProvider>(
            builder: (context, location, child) {
              if (location.isLoading) {
                return const SizedBox(
                  width: 20,
                  height: 20,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.my_location, color: Colors.blue),
                onPressed: () async {
                  await location.updateCurrentLocation();
                  if (location.currentAddress != null) {
                    street.text = location.currentAddress!;
                  } else if (location.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(location.errorMessage!)),
                    );
                  }
                },
                tooltip: 'Use current location',
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildField(context, "City", city, Icons.location_city, validator: _required),
        const SizedBox(height: 16),
        _buildField(context, "State / Province", state, Icons.map, validator: _required),
        const SizedBox(height: 16),
        _buildField(context, "ZIP / Postal Code", zip, Icons.local_post_office,
            keyboardType: TextInputType.number, validator: _validateZip),
        const SizedBox(height: 16),
        _buildField(context, "Country", country, Icons.flag, validator: _required),
      ],
    );
  }

  Widget _buildField(
    BuildContext context, // Add context
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.grey[300] : Colors.black87)),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey.withOpacity(0.05),
            prefixIcon: Icon(icon, size: 20, color: isDark ? Colors.grey[400] : Colors.grey[600]),
            suffixIcon: suffixIcon,
            hintText: 'Enter $label',
            hintStyle: TextStyle(fontSize: 14, color: isDark ? Colors.grey[600] : Colors.grey.shade400),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  // Validators
  String? _required(String? value) =>
      value == null || value.isEmpty ? 'Required' : null;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    final emailReg = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailReg.hasMatch(value)) return 'Invalid email';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    final phoneReg = RegExp(r'^\+?\d{7,15}$');
    if (!phoneReg.hasMatch(value)) return 'Invalid phone number';
    return null;
  }

  String? _validateZip(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    final zipReg = RegExp(r'^[0-9]{4,10}$');
    if (!zipReg.hasMatch(value)) return 'Invalid ZIP code';
    return null;
  }
}
