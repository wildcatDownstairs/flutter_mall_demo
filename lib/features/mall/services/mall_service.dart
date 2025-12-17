import '../models/mall_entity.dart';
import 'dart:math';

// Mock Data Generator
final _random = Random();
const _titles = [
  '五台山小圆满民宿',
  '大理沽月悦心海景民宿',
  '爱壹座城客栈',
  '三亚海边民宿',
  '丹霞山燕子呢喃民宿',
  '莫干山云端民宿',
  '丽江古城听雨轩',
  '阳朔西街江景房',
  '鼓浪屿琴岛之声',
  '凤凰古城吊脚楼',
];
const _locations = [
  '忻州市',
  '大理白族自治州',
  '丽江市',
  '三亚市',
  '韶关市',
  '湖州市',
  '丽江市',
  '桂林市',
  '厦门市',
  '湘西土家族苗族自治州',
];
const _tags = ['超值券 膨胀至25元', '榜单第7名', '超赞', '免费早餐', '落地窗', '海景', '浴缸'];

MallListingItem _generateItem(int index) {
  final id = index.toString();
  final title = '${_titles[index % _titles.length]} (${index + 1}号店)';
  final location = _locations[index % _locations.length];

  return MallListingItem(
    id: id,
    imageUrl:
        'https://picsum.photos/seed/$index/200/200', // Using Picsum for free images
    title: title,
    score: 4.5 + (_random.nextDouble() * 0.5),
    scoreText: '非常棒',
    commentCount: 100 + _random.nextInt(1000),
    locationArea: '风景区周边',
    locationCity: location,
    tags: List.generate(
      _random.nextInt(3),
      (i) => _tags[_random.nextInt(_tags.length)],
    ),
    groupBuyItems: List.generate(
      1 + _random.nextInt(3),
      (i) => GroupBuyItem(
        price: 100 + _random.nextDouble() * 500,
        originalPrice: 600 + _random.nextDouble() * 1000,
        discount: 3.0 + _random.nextDouble() * 5.0,
        title: '豪华大床房/双床房 ${_random.nextInt(100)}平米',
      ),
    ),
  );
}

// Service
class MallService {
  static Future<List<MallListingItem>> fetchListings({
    int page = 1,
    int pageSize = 20,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Simulate pagination limit
    if (page > 10) return []; // Max 100 items

    return List.generate(
      pageSize,
      (index) => _generateItem((page - 1) * pageSize + index),
    );
  }
}
