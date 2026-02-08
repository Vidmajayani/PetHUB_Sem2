import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/review_provider.dart';
import '../../../providers/auth_provider.dart';
import '../widgets/review_card.dart';
import '../widgets/review_history_empty_view.dart';

class ReviewHistoryPage extends StatefulWidget {
  const ReviewHistoryPage({super.key});

  @override
  State<ReviewHistoryPage> createState() => _ReviewHistoryPageState();
}

class _ReviewHistoryPageState extends State<ReviewHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.user != null) {
        Provider.of<ReviewProvider>(context, listen: false).fetchUserReviews(auth.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final reviewProvider = Provider.of<ReviewProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Reviews"),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final auth = Provider.of<AuthProvider>(context, listen: false);
          if (auth.user != null) {
            await Provider.of<ReviewProvider>(context, listen: false).fetchUserReviews(auth.user!.uid);
          }
        },
        child: reviewProvider.isLoading && reviewProvider.userReviews.isEmpty
            ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
            : reviewProvider.userReviews.isEmpty
                ? const ReviewHistoryEmptyView()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: reviewProvider.userReviews.length,
                    itemBuilder: (context, index) {
                      final review = reviewProvider.userReviews[index];
                      return ReviewCard(review: review);
                    },
                  ),
      ),
    );
  }
}



