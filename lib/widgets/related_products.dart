import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final int price;
  final double rating;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.image,
  });
}

class RelatedProducts extends StatelessWidget {
  const RelatedProducts({super.key});

  static final List<Product> products = [
    Product(
      id: 1,
      name: 'Classic Leather Boots',
      price: 129,
      rating: 4.7,
      image: 'https://images.unsplash.com/photo-1726133731501-b4ed4a6915eb?w=400',
    ),
    Product(
      id: 2,
      name: 'Urban Street Sneakers',
      price: 89,
      rating: 4.9,
      image: 'https://images.unsplash.com/photo-1759542890353-35f5568c1c90?w=400',
    ),
    Product(
      id: 3,
      name: 'Minimalist Slides',
      price: 59,
      rating: 4.5,
      image: 'https://images.unsplash.com/photo-1574201635302-388dd92a4c3f?w=400',
    ),
    Product(
      id: 4,
      name: 'Premium Canvas Shoes',
      price: 79,
      rating: 4.6,
      image: 'https://images.unsplash.com/photo-1548768041-2fceab4c0b85?w=400',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'You Might Also Like',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 2;
            if (constraints.maxWidth > 1024) {
              crossAxisCount = 4;
            } else if (constraints.maxWidth > 600) {
              crossAxisCount = 3;
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _buildProductCard(products[index]);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, size: 64, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border, size: 20),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.name,
            style: const TextStyle(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Color(0xFFFBBF24)),
              const SizedBox(width: 4),
              Text(
                '${product.rating}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '\$${product.price}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
