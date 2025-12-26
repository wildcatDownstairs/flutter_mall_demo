import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mall_demo/core/utils/format.dart';
import '../models/mall_entity.dart';

class MallDetailPage extends StatefulWidget {
  final MallListingItem item;

  const MallDetailPage({super.key, required this.item});

  @override
  State<MallDetailPage> createState() => _MallDetailPageState();
}

class _MallDetailPageState extends State<MallDetailPage>
    with SingleTickerProviderStateMixin {
  static const _nativeChannel = MethodChannel('mall_demo_native');

  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !_showTitle) {
        setState(() => _showTitle = true);
      } else if (_scrollController.offset <= 200 && _showTitle) {
        setState(() => _showTitle = false);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(),
              _buildInfoCard(),
              _buildLiveStreamEntry(),
              _buildStickyTabBar(),
              _buildDateAndFilter(),
              _buildCouponBanner(),
              _buildRoomList(),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Future<void> _handleBack() async {
    if (context.canPop()) {
      context.pop();
    } else {
      SystemNavigator.pop();
    }
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: _showTitle
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      leading: Center(
        child: GestureDetector(
          onTap: _handleBack,
          child: const CircleAvatar(
            backgroundColor: Color(0x4D000000),
            radius: 18,
            child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
      ),
      automaticallyImplyLeading: false,
      title: _showTitle
          ? Text(
              widget.item.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
      actions: [
        _buildActionIcon(Icons.search),
        _buildActionIcon(Icons.star_border),
        _buildActionIcon(Icons.share),
        _buildActionIcon(Icons.more_horiz),
        const SizedBox(width: 12),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: widget.item.id,
              child: CachedNetworkImage(
                imageUrl: widget.item.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black26, Colors.transparent],
                  stops: [0.0, 0.3],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x80000000),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Text(
                      '封面 外观 房间 餐厅 休闲 公',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '|',
                      style: TextStyle(color: Colors.white54, fontSize: 10),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '1/217',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white, size: 8),
                  ],
                ),
              ),
            ),
            const Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.keyboard_double_arrow_down,
                      color: Colors.white70,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '下滑可看更多大图',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: CircleAvatar(
        backgroundColor: const Color(0x4D000000),
        radius: 18,
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildInfoCard() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.item.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4D4F),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 14),
                      Text(
                        '关注',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildTag('大理观景民宿人气榜第1名', true),
                const SizedBox(width: 6),
                _buildTag('消费人数 3千+', false),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildServiceIcon(Icons.home_outlined, '客栈民宿'),
                _buildServiceIcon(Icons.construction_outlined, '2024装修'),
                _buildServiceIcon(Icons.camera_alt_outlined, '网红打卡'),
                _buildServiceIcon(Icons.filter_hdr_outlined, '白族风情'),
                _buildServiceIcon(Icons.local_parking_outlined, '免费停车'),
                const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: Color(0xFFFF4D4F),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formatScore(widget.item.score),
                              style: const TextStyle(
                                color: Color(0xFFFF4D4F),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.item.scoreText,
                              style: const TextStyle(
                                color: Color(0xFFFF4D4F),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.item.commentCount}条',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '"店员服务很热心，环境很清新舒适"',
                          style: TextStyle(color: Colors.black87, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.grey[300],
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '距${widget.item.locationArea}步行980米',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.item.locationCity}${widget.item.locationArea}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Column(
                          children: [
                            Icon(
                              Icons.near_me_outlined,
                              color: Colors.blue,
                              size: 20,
                            ),
                            Text(
                              '地图',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, bool isHighlight) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isHighlight ? const Color(0xFFFFF0E6) : const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isHighlight)
            const Padding(
              padding: EdgeInsets.only(right: 2),
              child: Icon(Icons.thumb_up, color: Color(0xFFFF9500), size: 10),
            ),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFFB8741A),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isHighlight)
            const Icon(
              Icons.keyboard_arrow_right,
              color: Color(0xFFB8741A),
              size: 10,
            ),
        ],
      ),
    );
  }

  Widget _buildServiceIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.black87, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildLiveStreamEntry() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFFFEAEA)),
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF6F6), Colors.white],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFF4D4F),
                    width: 1.5,
                  ),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.item.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      'V',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.item.title.substring(0, 6),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFFF4D4F),
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: const Text(
                            '官方直播',
                            style: TextStyle(
                              color: Color(0xFFFF4D4F),
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '讲解中 | 挖色海鸥季🔥2晚180°日落...',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Text(
                '¥ 672',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              const Row(
                children: [
                  Text(
                    '去看看',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                    size: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStickyTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _StickyTabBarDelegate(
        child: Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFFFF4D4F),
            unselectedLabelColor: Colors.black87,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 16),
            indicatorColor: const Color(0xFFFF4D4F),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: '团购'),
              Tab(text: '预订'),
              Tab(text: '设施'),
              Tab(text: '评价 2577'),
              Tab(text: '推荐'),
            ],
          ),
        ),
      ),
    );
  }

  /// 点击“预订”时，调用原生弹出 LiquidGlassDialogViewController。
  Future<void> _handleBookPressed() async {
    final title = widget.item.title;
    final shortTitle = title.length <= 18
        ? title
        : '${title.substring(0, 18)}...';
    final message = '已为您锁定「$shortTitle」的预订权益（演示用）';

    try {
      await _nativeChannel.invokeMethod<void>(
        'showNativeDialog',
        <String, dynamic>{'message': message},
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('原生弹窗通道未就绪')));
    }
  }

  Widget _buildDateAndFilter() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    '12月17日',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '今天',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Container(height: 12, width: 1, color: Colors.grey[300]),
                  const SizedBox(width: 12),
                  const Text(
                    '12月18日',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '明天',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Spacer(),
                  const Text(
                    '共1晚',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right,
                    size: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip('双床房'),
                  _buildFilterChip('大床房'),
                  _buildFilterChip('含早餐'),
                  _buildFilterChip('☾ 多晚连住', isSelected: true),
                  _buildFilterChip('酒店套餐'),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          '筛选',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 14,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFF0F0) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(4),
        border: isSelected
            ? Border.all(color: const Color(0xFFFF4D4F), width: 0.5)
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? const Color(0xFFFF4D4F) : const Color(0xFF333333),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildCouponBanner() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F0),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4D4F),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text(
                  '超值券',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '本店下单立减27元',
                style: TextStyle(color: Color(0xFF333333), fontSize: 12),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '01 : 54 : 55',
                  style: TextStyle(color: Color(0xFFFF4D4F), fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomList() {
    final mockItems = [
      _RoomItemData(
        image:
            'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?q=80&w=400&auto=format&fit=crop',
        title: '挖色海鸥季🔥1晚180°日落海景房大床亲子5选1+免费停车+精美双早',
        tags: [
          '住·全海景阳光房 / 月夜星辰海景亲子房 / 日落海景大床房...',
          '享·早餐 (2份)+免费停车 (1份) + 贴心管家服务 (1... 共5项',
        ],
        price: 372,
        originalPrice: 590,
        lowestPriceDesc: '180天最低',
        sales: '已售 2000+',
        couponDesc: '超值券膨胀减27',
        couponSubDesc: '券后直降218元',
      ),
      _RoomItemData(
        image:
            'https://images.unsplash.com/photo-1611892440504-42a792e24d32?q=80&w=400&auto=format&fit=crop',
        title: '挖色海鸥季🔥2晚180°日落海景房大床亲子5选1+免费停车+精美双早',
        tags: [
          '住·全海景阳光房 / 月夜星辰海景亲子房 / 日落海景... 共2晚',
          '享·早餐 (2份)+免费停车 (1份) + 贴心管家服务 (1... 共5项',
        ],
        price: 672,
        originalPrice: 989,
        lowestPriceDesc: '180天最低',
        sales: '已售 2000+',
        couponDesc: '超值券膨胀减27',
        couponSubDesc: '券后直降317元',
        priceSuffix: '/2晚',
        needsReservation: true,
      ),
      _RoomItemData(
        image:
            'https://images.unsplash.com/photo-1540541338287-41700207dee6?q=80&w=400&auto=format&fit=crop',
        title: '海鸥来了🌊2晚 270°落地窗浴缸海景大床房+小普陀游船票+免费停车+双早',
        tags: ['住·月光繁星海景套房共2晚', '享·早餐 (2份)+小普陀游船票 (2份) + 贴心管家服...共6项'],
        price: 1072,
        originalPrice: 1449,
        sales: '已售 100+',
        couponDesc: '超值券膨胀减27',
        couponSubDesc: '券后直降377元',
        priceSuffix: '/2晚',
        needsReservation: true,
      ),
      _RoomItemData(
        image:
            'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?q=80&w=400&auto=format&fit=crop',
        title: '【门前喂海鸥】1晚·治愈侧海景大床房+电瓶车使用+精美双早',
        tags: ['住·追云侧海景房共1晚', '享·早餐 (2份)+免费停车 (1份) + 贴心管家服务 (1... 共5项'],
        price: 172,
        originalPrice: 415,
        lowestPriceDesc: '180天最低',
        sales: '已售 1000+',
        couponDesc: '超值券膨胀减27',
        couponSubDesc: '券后直降243元',
        needsReservation: true,
      ),
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = mockItems[index];
        return _buildRoomItem(item);
      }, childCount: mockItems.length),
    );
  }

  Widget _buildRoomItem(_RoomItemData item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: item.image,
                    width: 110,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF4D4F),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '超值团',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      ...item.tags.map(
                        (tag) => Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF666666),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (item.needsReservation)
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF409EFF),
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: const Text(
                            '需提前1分钟预约',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF409EFF),
                            ),
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF999999),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const Text(
                          '不可退',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        item.sales,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (item.lowestPriceDesc != null)
                        Text(
                          '${item.lowestPriceDesc} ¥${item.originalPrice} ',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFFFF4D4F),
                          ),
                        ),
                      if (item.lowestPriceDesc == null)
                        Text(
                          '¥${item.originalPrice} ',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Text(
                        '超值价 ',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFFFF4D4F),
                        ),
                      ),
                      Text(
                        '¥',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFF4D4F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${item.price}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFFFF4D4F),
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                      if (item.priceSuffix != null)
                        Text(
                          item.priceSuffix!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFF4D4F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _handleBookPressed,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF4D4F),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '预订',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF855E),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2),
                            bottomLeft: Radius.circular(2),
                          ),
                        ),
                        child: Text(
                          item.couponDesc,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFFF855E),
                            width: 0.5,
                          ),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(2),
                            bottomRight: Radius.circular(2),
                          ),
                        ),
                        child: Text(
                          item.couponSubDesc,
                          style: const TextStyle(
                            color: Color(0xFFFF855E),
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Row(
          children: [
            _buildBottomNavItem(Icons.manage_search_outlined, '找酒店'),
            _buildBottomNavItem(Icons.assignment_outlined, '订单'),
            _buildBottomNavItem(Icons.rate_review_outlined, '写评价'),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F5E6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lightbulb, color: Color(0xFF8B572A), size: 18),
                    SizedBox(width: 4),
                    Text(
                      '点亮门店',
                      style: TextStyle(
                        color: Color(0xFF8B572A),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.black54, size: 22),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class _RoomItemData {
  final String image;
  final String title;
  final List<String> tags;
  final int price;
  final int originalPrice;
  final String? lowestPriceDesc;
  final String sales;
  final String couponDesc;
  final String couponSubDesc;
  final String? priceSuffix;
  final bool needsReservation;

  _RoomItemData({
    required this.image,
    required this.title,
    required this.tags,
    required this.price,
    required this.originalPrice,
    this.lowestPriceDesc,
    required this.sales,
    required this.couponDesc,
    required this.couponSubDesc,
    this.priceSuffix,
    this.needsReservation = false,
  });
}
