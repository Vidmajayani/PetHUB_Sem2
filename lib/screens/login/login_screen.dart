import 'package:flutter/material.dart';
import '../../widgets/common/app_header.dart';
import 'widgets/login_form.dart';
import 'widgets/login_background.dart';
import 'widgets/login_banner.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800; // breakpoint for desktop view

    return Scaffold(
      body: Stack(
        children: [
          // 🎨 Background Shapes
          const LoginBackground(),
          
          // 📲 Main Content
          SafeArea(
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
                            const Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: LoginBanner(isDesktop: true),
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
                            const SizedBox(height: 50), // Increased spacing to move image down further
                            LoginBanner(isDesktop: false),
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
        ],
      ),
    );
  }
}

