import 'package:flutter/material.dart';

class GlobalOfflineBanner extends StatefulWidget {
  final bool isOffline;

  const GlobalOfflineBanner({super.key, required this.isOffline});

  @override
  State<GlobalOfflineBanner> createState() => _GlobalOfflineBannerState();
}

class _GlobalOfflineBannerState extends State<GlobalOfflineBanner> {
  bool _showOnlineSuccess = false;

  @override
  void didUpdateWidget(GlobalOfflineBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Transition from Offline -> Online
    if (oldWidget.isOffline && !widget.isOffline) {
      _triggerOnlineSuccess();
    }
  }

  void _triggerOnlineSuccess() {
    setState(() => _showOnlineSuccess = true);
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _showOnlineSuccess = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isOffline && !_showOnlineSuccess) return const SizedBox.shrink();

    final isActuallyOffline = widget.isOffline;
    
    // Premium Red Design for Offline, Green for Online
    final icon = isActuallyOffline ? Icons.wifi_off_rounded : Icons.wifi_rounded;
    final message = isActuallyOffline 
        ? "App is Offline - Enable Wi-Fi or Mobile Data to restore connectivity" 
        : "Back Online - Connectivity Restored";

    return Material(
      elevation: 4,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isActuallyOffline 
              ? [Colors.red.shade900, Colors.red.shade700] 
              : [Colors.green.shade900, Colors.green.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8, 
          bottom: 12,
          left: 16,
          right: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
