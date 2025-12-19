import 'dart:math' as math;
import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with TickerProviderStateMixin {
  late final AnimationController _bgController;
  late final AnimationController _pulseController;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5200),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pageController = PageController(viewportFraction: 0.86);
  }

  @override
  void dispose() {
    _bgController.dispose();
    _pulseController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B10),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, _) => CustomPaint(
              painter: _NeonParticlesPainter(t: _bgController.value),
              child: const SizedBox.expand(),
            ),
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(child: _buildHeroCarousel(context)),
              SliverToBoxAdapter(child: _buildCategoryChips()),
              SliverToBoxAdapter(child: _buildHotRow(context)),
              _buildMasonryGrid(),
              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: const Color(0xFF0B0B10),
      elevation: 0,
      titleSpacing: 16,
      title: Row(
        children: [
          ShaderMask(
            shaderCallback: (rect) => const LinearGradient(
              colors: [Color(0xFF25F4EE), Color(0xFFFE2C55)],
            ).createShader(rect),
            child: const Text(
              '发现',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const Spacer(),
          _NeonIconButton(
            icon: Icons.notifications_none_rounded,
            onTap: () => _toast(context, '演示：消息'),
          ),
          const SizedBox(width: 8),
          _NeonIconButton(
            icon: Icons.qr_code_scanner_rounded,
            onTap: () => _toast(context, '演示：扫一扫'),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: _SearchBar(
            onTap: () => _toast(context, '演示：搜索'),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCarousel(BuildContext context) {
    final cards = [
      const _HeroCardData(
        title: '热榜 · 今日趋势',
        subtitle: '算法精选 · 你可能喜欢',
        icon: Icons.local_fire_department_rounded,
        colors: [Color(0xFFFE2C55), Color(0xFF1A1A24)],
      ),
      const _HeroCardData(
        title: '直播 · 正在发生',
        subtitle: '高能现场 · 一键进入',
        icon: Icons.videocam_rounded,
        colors: [Color(0xFF25F4EE), Color(0xFF1A1A24)],
      ),
      const _HeroCardData(
        title: '同城 · 新鲜事',
        subtitle: '附近的人都在看',
        icon: Icons.location_on_rounded,
        colors: [Color(0xFF7C4DFF), Color(0xFF1A1A24)],
      ),
    ];

    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        itemCount: cards.length,
        padEnds: false,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double page = 0;
              if (_pageController.hasClients &&
                  _pageController.position.haveDimensions) {
                page = _pageController.page ?? _pageController.initialPage * 1.0;
              }
              final delta = (index - page).clamp(-1.0, 1.0);
              final scale = 1.0 - (delta.abs() * 0.06);
              final translate = delta * 18;
              return Transform.translate(
                offset: Offset(translate, 0),
                child: Transform.scale(scale: scale, child: child),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: _HeroCard(
                data: cards[index],
                pulse: _pulseController,
                onTap: () => _toast(context, '打开：${cards[index].title}'),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChips() {
    final chips = const [
      '推荐',
      '音乐',
      '科技',
      '游戏',
      '穿搭',
      '旅行',
      '美食',
      '健身',
      '二次元',
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: SizedBox(
        height: 34,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: chips.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final selected = index == 0;
            return _NeonChip(label: chips[index], selected: selected);
          },
        ),
      ),
    );
  }

  Widget _buildHotRow(BuildContext context) {
    final items = List.generate(
      8,
      (i) => _HotItemData(
        title: '热搜 ${i + 1}',
        subtitle: '🔥 ${(i + 1) * 12}w',
        color: i.isEven ? const Color(0xFF25F4EE) : const Color(0xFFFE2C55),
      ),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '实时热点',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _toast(context, '演示：查看更多'),
                child: const Text(
                  '查看更多',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 108,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                return _HotCard(
                  data: item,
                  onTap: () => _toast(context, '点击：${item.title}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasonryGrid() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.78,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 420 + (index % 6) * 70),
              curve: Curves.easeOutCubic,
              builder: (context, t, child) {
                final dy = (1 - t) * 18;
                return Opacity(
                  opacity: t,
                  child: Transform.translate(offset: Offset(0, dy), child: child),
                );
              },
              child: _DiscoverTile(
                index: index,
                onTap: () => _toast(context, '打开卡片 #$index'),
              ),
            );
          },
          childCount: 14,
        ),
      ),
    );
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1B1B22),
      ),
    );
  }
}

class _NeonIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NeonIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: const [
            Icon(Icons.search_rounded, color: Colors.white54, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '搜索话题 / 用户 / 视频',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ),
            Icon(Icons.mic_none_rounded, color: Colors.white54, size: 18),
          ],
        ),
      ),
    );
  }
}

class _NeonChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _NeonChip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: const LinearGradient(
            colors: [Color(0xFF25F4EE), Color(0xFFFE2C55)],
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withOpacity(0.06),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _HeroCardData {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;

  const _HeroCardData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
  });
}

class _HeroCard extends StatelessWidget {
  final _HeroCardData data;
  final Animation<double> pulse;
  final VoidCallback onTap;

  const _HeroCard({required this.data, required this.pulse, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedBuilder(
        animation: pulse,
        builder: (context, _) {
          final glow = 0.15 + (pulse.value * 0.10);
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  data.colors.first.withOpacity(0.92),
                  data.colors.last,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: data.colors.first.withOpacity(glow),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(color: Colors.white.withOpacity(0.10)),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -30,
                  right: -30,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.black.withOpacity(0.22),
                          border: Border.all(color: Colors.white.withOpacity(0.12)),
                        ),
                        child: Icon(data.icon, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data.subtitle,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.white70, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HotItemData {
  final String title;
  final String subtitle;
  final Color color;

  _HotItemData({required this.title, required this.subtitle, required this.color});
}

class _HotCard extends StatelessWidget {
  final _HotItemData data;
  final VoidCallback onTap;

  const _HotCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 170,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF14141B),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: data.color.withOpacity(0.12),
                border: Border.all(color: data.color.withOpacity(0.25)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.trending_up_rounded, size: 16, color: data.color),
                  const SizedBox(width: 6),
                  Text(
                    data.subtitle,
                    style: TextStyle(
                      color: data.color,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              data.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '点击进入话题 · 看更多同类内容',
              style: TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscoverTile extends StatelessWidget {
  final int index;
  final VoidCallback onTap;

  const _DiscoverTile({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final seed = index * 97;
    final colorA = _seedColor(seed);
    final colorB = _seedColor(seed + 31);
    final heightBias = (index % 4) * 0.06;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorA, colorB],
          ),
          border: Border.all(color: Colors.white10),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.12,
                child: CustomPaint(painter: _NoisePainter(seed: seed)),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Row(
                children: [
                  const Icon(Icons.play_arrow_rounded,
                      color: Colors.white70, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${(index + 2) * 18}w',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25 + heightBias),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: const Text(
                      '精选',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
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

  Color _seedColor(int seed) {
    final r = (seed * 37) % 255;
    final g = (seed * 17) % 255;
    final b = (seed * 29) % 255;
    final base = Color.fromARGB(255, r, g, b);
    return Color.lerp(base, const Color(0xFF0B0B10), 0.35)!;
  }
}

class _NeonParticlesPainter extends CustomPainter {
  final double t;

  _NeonParticlesPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final particles = 18;
    for (var i = 0; i < particles; i++) {
      final p = (i / particles + t) % 1.0;
      final angle = p * math.pi * 2;
      final radius = (0.18 + (i % 5) * 0.06) * math.min(size.width, size.height);
      final cx = size.width * 0.5 + math.cos(angle) * radius;
      final cy = size.height * 0.25 + math.sin(angle * 1.4) * radius;
      final color = i.isEven ? const Color(0xFF25F4EE) : const Color(0xFFFE2C55);
      final alpha = (0.06 + (math.sin((p + i) * math.pi * 2) + 1) * 0.04)
          .clamp(0.04, 0.14);
      paint.color = color.withOpacity(alpha);
      canvas.drawCircle(Offset(cx, cy), 70 - (i % 7) * 6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NeonParticlesPainter oldDelegate) {
    return oldDelegate.t != t;
  }
}

class _NoisePainter extends CustomPainter {
  final int seed;

  _NoisePainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(seed);
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    final count = 180;
    for (var i = 0; i < count; i++) {
      final dx = rnd.nextDouble() * size.width;
      final dy = rnd.nextDouble() * size.height;
      final len = 0.5 + rnd.nextDouble() * 1.8;
      canvas.drawLine(Offset(dx, dy), Offset(dx + len, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NoisePainter oldDelegate) {
    return oldDelegate.seed != seed;
  }
}
