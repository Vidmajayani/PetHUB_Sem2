import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../../widgets/common/error_notification_box.dart';
import '../../../widgets/common/custom_text_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage; // Add error state

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    // Clear previous error
    setState(() => _errorMessage = null);

    if (_formKey.currentState!.validate()) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      
      final error = await auth.register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        displayName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );

      if (mounted) {
        if (error != null) {
          // Set error message to display in the box
          setState(() => _errorMessage = error);
        } else {
          // SUCCESSFUL REGISTRATION
          
          // 1. Log out immediately to force manual login
          await auth.logout();

          // 2. Show success message
          if (mounted) { // Check mounted again after async logout
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account created! Please log in with your new credentials. 🐾'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 4),
              ),
            );

            // 3. Redirect to Login Screen
            // If we came from Login, pop. Otherwise, go to Login.
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/login');
            }
          }
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    // Reusable spacer
    const gap = SizedBox(height: 16);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Error Box
          ErrorNotificationBox(
            errorMessage: _errorMessage,
            onClose: () => setState(() => _errorMessage = null),
          ),
            
          CustomTextField(
            controller: _nameController,
            label: 'Full Name',
            icon: Icons.person_outline,
            validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
          ),
          gap,
          
          CustomTextField(
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter your email';
              if (!value.contains('@')) return 'Invalid email format';
              return null;
            },
          ),
          gap,

          CustomTextField(
            controller: _phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) => value == null || value.isEmpty ? 'Please enter phone number' : null,
          ),
          gap,

          CustomTextField(
            controller: _addressController,
            label: 'Shipping Address',
            icon: Icons.home_outlined,
            maxLines: 2,
            validator: (value) => value == null || value.isEmpty ? 'Please enter your address' : null,
          ),
          gap,

          CustomTextField(
            controller: _passwordController,
            label: 'Password',
            icon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter a password';
              if (value.length < 8) return 'Must be at least 8 characters';
              if (!value.contains(RegExp(r'[A-Za-z]'))) return 'Must contain at least 1 letter';
              if (!value.contains(RegExp(r'[0-9]'))) return 'Must contain at least 1 number';
              if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return 'Must contain a special character';
              return null;
            },
          ),
          gap,

          CustomTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            icon: Icons.lock_reset_outlined,
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
            validator: (value) => value != _passwordController.text ? 'Passwords do not match' : null,
          ),
          
          const SizedBox(height: 24),
          
          FilledButton(
            onPressed: auth.isLoading ? null : _handleRegister,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: auth.isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          
          gap,
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?"),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Login'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
