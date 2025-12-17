import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/mall_entity.dart';
import 'package:flutter_mall_demo/core/utils/format.dart';
import 'package:flutter_mall_demo/core/theme/app_theme.dart';

class MallListingCard extends StatelessWidget {
  final MallListingItem item;

  const MallListingCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Image + Basic Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Listing Image with rounded corners
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Hero(
                  tag: item.id,
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[200]),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Right: Title, Score, Location, Tags
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6), // Increased spacing
                    // Score and Comments row
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          size: 12,
                          color: Color(0xFFFF4D4F),
                        ), // Smaller icon
                        const SizedBox(width: 2),
                        Text(
                          formatScore(item.score),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF4D4F),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.scoreText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF4D4F),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '"老板热情,环境舒适..." 等${item.commentCount}条评价',
                            style: const TextStyle(
                              fontSize: 11, // Smaller text
                              color: Color(0xFF666666),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.locationArea,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF666666),
                          ),
                        ),
                        Text(
                          item.locationCity,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Tags
                    if (item.tags.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: item.tags.map((tag) {
                          final isRedTag =
                              tag.contains('超值券') || tag.contains('膨胀');
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: isRedTag
                                  ? const Color(0xFFFFF0F0)
                                  : const Color(0xFFFFF7E6), // Lighter bg
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                color: isRedTag
                                    ? const Color(0xFFFF4D4F)
                                    : const Color(0xFFFF9500),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 10,
                                color: isRedTag
                                    ? const Color(0xFFFF4D4F)
                                    : const Color(0xFFFF9500),
                                height: 1.1,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 8),
                    ...item.groupBuyItems.map(
                      (gbItem) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 3,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF4D4F),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: const Text(
                                '团',
                                style: AppTextStyles.priceLabelWhite10,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              formatCurrency(gbItem.price),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF4D4F),
                                height: 1,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formatCurrency(gbItem.originalPrice),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF999999),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFFF4D4F),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                formatDiscount(gbItem.discount),
                                style: AppTextStyles.priceLabelRed10,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                gbItem.title,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF333333),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
