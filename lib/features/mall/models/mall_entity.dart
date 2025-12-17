class MallListingItem {
  final String id;
  final String imageUrl;
  final String title;
  final double score;
  final String scoreText;
  final int commentCount;
  final String locationArea;
  final String locationCity;
  final List<String> tags; // e.g., ["超值券 膨胀至25元", "榜单第7名"]
  final List<GroupBuyItem> groupBuyItems;
  final bool isAd; // "广告" tag

  const MallListingItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.score,
    required this.scoreText,
    required this.commentCount,
    required this.locationArea,
    required this.locationCity,
    this.tags = const [],
    this.groupBuyItems = const [],
    this.isAd = false,
  });
}

class GroupBuyItem {
  final double price;
  final double originalPrice;
  final double discount;
  final String title;

  const GroupBuyItem({
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.title,
  });
}

class GroupBuyPackage {
  final String id;
  final String imageUrl;
  final String title;
  final double price;
  final double originalPrice;
  final String tag;

  const GroupBuyPackage({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.originalPrice,
    this.tag = '',
  });
}
