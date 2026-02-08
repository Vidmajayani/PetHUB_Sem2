import 'package:flutter/material.dart';

class LoginBanner extends StatelessWidget {
  final bool isDesktop;

  const LoginBanner({
    super.key,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/login_banner.png',
      width: isDesktop ? 400 : 260,
      height: isDesktop ? 400 : null,
      fit: BoxFit.contain,
    );
  }
}
