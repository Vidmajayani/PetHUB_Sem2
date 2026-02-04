import 'package:flutter/material.dart';
import '../../widgets/common/app_header.dart';
import 'register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Theme.of(context).colorScheme.primary),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: isDesktop
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image side
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            'assets/images/login_banner.png', // Reusing same banner for consistency
                            height: 400,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 40),
                        // Form side
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const AppHeader(
                                title: 'Create Account',
                                subtitle: 'Join us and take care of your pets better!',
                              ),
                              const SizedBox(height: 16),
                              RegisterForm(),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/login_banner.png',
                          width: 180,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10),
                        const AppHeader(
                          title: 'Create Account',
                          subtitle: 'Join us and take care of your pets better!',
                        ),
                        const SizedBox(height: 10),
                        RegisterForm(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
