import 'package:flutter/material.dart';

class CheckoutStepper extends StatelessWidget {
  const CheckoutStepper({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _stepCircle(Icons.location_on_rounded, true, colorScheme),
          _stepLine(true, colorScheme),
          _stepCircle(Icons.credit_card_rounded, true, colorScheme),
          _stepLine(false, colorScheme),
          _stepCircle(Icons.check_circle_rounded, false, colorScheme),
        ],
      ),
    );
  }

  Widget _stepCircle(IconData icon, bool isActive, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? colorScheme.primary.withOpacity(0.12) : colorScheme.surfaceContainerHighest.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon, 
        color: isActive ? colorScheme.primary : colorScheme.outline.withOpacity(0.5), 
        size: 22
      ),
    );
  }

  Widget _stepLine(bool isFinished, ColorScheme colorScheme) {
    return Expanded(
      child: Container(
        height: 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.5),
          color: isFinished ? colorScheme.primary : colorScheme.outlineVariant.withOpacity(0.3),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}
