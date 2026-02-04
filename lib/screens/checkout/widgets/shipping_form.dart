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
        _buildField("Full Name", name, Icons.person, validator: _required),
        const SizedBox(height: 16),
        _buildField("Email", email, Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail),
        const SizedBox(height: 16),
        _buildField("Phone", phone, Icons.phone,
            keyboardType: TextInputType.phone, validator: _validatePhone),
        const SizedBox(height: 16),
        _buildField(
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
        _buildField("City", city, Icons.location_city, validator: _required),
        const SizedBox(height: 16),
        _buildField("State / Province", state, Icons.map, validator: _required),
        const SizedBox(height: 16),
        _buildField("ZIP / Postal Code", zip, Icons.local_post_office,
            keyboardType: TextInputType.number, validator: _validateZip),
        const SizedBox(height: 16),
        _buildField("Country", country, Icons.flag, validator: _required),
      ],
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            suffixIcon: suffixIcon,
            border: const OutlineInputBorder(),
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
