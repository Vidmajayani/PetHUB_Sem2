import 'dart:convert';
import 'package:http/http.dart' as http;

class PublicApiService {
  static const String _catFactUrl = 'https://catfact.ninja/fact';

  /// Fetches a random pet fact from a public API
  Future<String> fetchRandomPetTrivia() async {
    try {
      print('📡 Fetching trivia from Cat Fact Ninja...');
      final response = await http.get(Uri.parse(_catFactUrl)).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['fact'] ?? 'Did you know? Pets make life better!';
      }
      return 'Pets are amazing companions!';
    } catch (e) {
      print('❌ Trivia API error: $e');
      return 'Did you know? Cats have been domesticated for over 4,000 years.';
    }
  }
}
