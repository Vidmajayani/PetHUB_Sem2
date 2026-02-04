import 'package:flutter/material.dart';
import '../../widgets/common/app_header.dart';
import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800; // breakpoint for desktop view

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: isDesktop
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 🖼️ Larger image on desktop
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(
                              'assets/images/login_banner.png',
                              width: 400, // increased size
                              height: 400,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),

                        // 🧾 Form side
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const AppHeader(
                                title: '',
                                subtitle: 'Welcome back! Please login to continue.',
                              ),
                              const SizedBox(height: 16),
                              LoginForm(),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 🖼️ Image above form (mobile)
                        Image.asset(
                          'assets/images/login_banner.png',
                          width: screenWidth < 600 ? 200 : 260,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10),
                        const AppHeader(
                          title: '',
                          subtitle: 'Welcome back! Please login to continue.',
                        ),
                        const SizedBox(height: 10),
                        LoginForm(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
