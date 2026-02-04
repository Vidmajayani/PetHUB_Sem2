import 'package:flutter/material.dart';
import '../../../services/public_api_service.dart';

class HomeTriviaCard extends StatefulWidget {
  const HomeTriviaCard({super.key});

  @override
  State<HomeTriviaCard> createState() => _HomeTriviaCardState();
}

class _HomeTriviaCardState extends State<HomeTriviaCard> {
  final PublicApiService _apiService = PublicApiService();
  String _trivia = 'Loading amazing pet fact...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrivia();
  }

  Future<void> _loadTrivia() async {
    setState(() => _isLoading = true);
    final result = await _apiService.fetchRandomPetTrivia();
    if (mounted) {
      setState(() {
        _trivia = result;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
            Theme.of(context).colorScheme.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                'Did You Know?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              if (!_isLoading)
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white70, size: 20),
                  onPressed: _loadTrivia,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (_isLoading)
            const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            )
          else
            Text(
              _trivia,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'Source: Public API (catfact.ninja)',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
