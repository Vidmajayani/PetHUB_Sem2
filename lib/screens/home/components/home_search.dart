import 'dart:async';
import 'package:flutter/material.dart';
import '../../search/search_results_screen.dart';

class HomeSearch extends StatefulWidget {
  const HomeSearch({super.key});

  @override
  State<HomeSearch> createState() => _HomeSearchState();
}

class _HomeSearchState extends State<HomeSearch> {
  final List<String> _hints = [
    'Search pets...',
    'Search for dog food...',
    'Find new toys...',
    'Explore exotic friends...',
  ];

  int _hintIndex = 0;
  String _currentHint = "";
  int _charIndex = 0;
  Timer? _timer;
  bool _isTyping = true;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_isTyping) {
        if (_charIndex < _hints[_hintIndex].length) {
          setState(() {
            _currentHint = _hints[_hintIndex].substring(0, _charIndex + 1);
            _charIndex++;
          });
        } else {
          // Pause at complete word
          _isTyping = false;
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _isTyping = false; // Stay in false but trigger erasure next cycle
              });
              _startErasing();
            }
          });
          _timer?.cancel();
        }
      }
    });
  }

  void _startErasing() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_charIndex > 0) {
        setState(() {
          _currentHint = _hints[_hintIndex].substring(0, _charIndex - 1);
          _charIndex--;
        });
      } else {
        // Switch to next word
        _timer?.cancel();
        setState(() {
          _hintIndex = (_hintIndex + 1) % _hints.length;
          _isTyping = true;
          _charIndex = 0;
        });
        _startAnimation();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchResultsScreen(query: value.trim()),
              ),
            );
          }
        },
        decoration: InputDecoration(
          hintText: _currentHint,
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: cs.surface,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.primary.withOpacity(0.5), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.primary, width: 2.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }
}
