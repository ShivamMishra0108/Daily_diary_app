import 'package:flutter/material.dart';

class Review {
  final int id;
  final String author;
  final int rating;
  final String date;
  final String comment;
  final int helpful;
  final bool verified;

  Review({
    required this.id,
    required this.author,
    required this.rating,
    required this.date,
    required this.comment,
    required this.helpful,
    required this.verified,
  });
}

class ProductReviews extends StatelessWidget {
  const ProductReviews({super.key});

  static final List<Review> reviews = [
    Review(
      id: 1,
      author: 'Sarah M.',
      rating: 5,
      date: 'December 15, 2025',
      comment:
          'Absolutely love these! The quality is outstanding and they fit perfectly. Super comfortable for all-day wear.',
      helpful: 24,
      verified: true,
    ),
    Review(
      id: 2,
      author: 'James K.',
      rating: 4,
      date: 'December 10, 2025',
      comment:
          'Great product overall. The design is sleek and modern. Only minor issue is they run slightly large, so consider sizing down.',
      helpful: 18,
      verified: true,
    ),
    Review(
      id: 3,
      author: 'Emily R.',
      rating: 5,
      date: 'December 5, 2025',
      comment:
          'Best purchase I made this year! The attention to detail is incredible. Highly recommend to anyone looking for quality.',
      helpful: 31,
      verified: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Customer Reviews',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Write a Review'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Rating Summary
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFF9FAFB),
                Colors.grey[100]!,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  children: [
                    Expanded(child: _buildOverallRating()),
                    const SizedBox(width: 48),
                    Expanded(child: _buildRatingBreakdown()),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildOverallRating(),
                    const SizedBox(height: 24),
                    _buildRatingBreakdown(),
                  ],
                );
              }
            },
          ),
        ),
        const SizedBox(height: 24),
        // Review List
        ...reviews.map((review) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildReviewCard(review),
            )),
      ],
    );
  }

  Widget _buildOverallRating() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '4.8',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) => Icon(
              index < 4 ? Icons.star : Icons.star_border,
              color: index < 4 ? const Color(0xFFFBBF24) : Colors.grey[300],
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Based on 127 reviews',
          style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildRatingBreakdown() {
    final Map<int, int> ratings = {5: 89, 4: 25, 3: 8, 2: 3, 1: 2};

    return Column(
      children: [5, 4, 3, 2, 1].map((stars) {
        final count = ratings[stars]!;
        final percentage = (count / 127 * 100).round();

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text('$stars', style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              const Icon(Icons.star, size: 16, color: Color(0xFFFBBF24)),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFFFBBF24)),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 30,
                child: Text(
                  '$count',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                review.author,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (review.verified) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1FAE5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Verified',
                    style: TextStyle(fontSize: 12, color: Color(0xFF059669)),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ...List.generate(
                5,
                (index) => Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  size: 16,
                  color: index < review.rating
                      ? const Color(0xFFFBBF24)
                      : Colors.grey[300],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                review.date,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            review.comment,
            style: const TextStyle(
              color: Color(0xFF374151),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.thumb_up_outlined, size: 16),
            label: Text('Helpful (${review.helpful})'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF3F4F6),
              foregroundColor: Colors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
