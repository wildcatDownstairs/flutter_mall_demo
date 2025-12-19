import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:use_request/use_request.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/mall_entity.dart';
import '../services/mall_service.dart';
import 'widgets/mall_search_header.dart';
import 'widgets/mall_category_tabs.dart';
import 'widgets/mall_filter_bar.dart';
import 'widgets/mall_listing_card.dart';
import 'widgets/mall_group_buy_section.dart';
import 'package:go_router/go_router.dart';

const _nativeChannel = MethodChannel('mall_demo_native');

class MallPage extends HookWidget {
  const MallPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller for pull-to-refresh
    final refreshController = useMemoized(
      () => RefreshController(initialRefresh: false),
    );
    final scrollController = useScrollController();
    final page = useState(1);
    final listData = useState<List<MallListingItem>>([]);
    final hasMore = useState(true);
    final isAutoLoading = useState(false);
    final currentSort = useState<SortOption>(SortOption.smart);
    final currentCity = useState<String>('全城');
    final currentStars = useState<List<String>>([]);

    final lastScrollOffset = useState(0.0);
    final isTabBarHidden = useState(false);

    // useRequest for data fetching
    final request = useRequest<List<MallListingItem>, Map<String, int>>(
      (Map<String, int> params) => MallService.fetchListings(
        page: params['page'] ?? 1,
        pageSize: params['pageSize'] ?? 20,
      ),
      options: UseRequestOptions(
        manual: false,
        defaultParams: const {'page': 1, 'pageSize': 20},
        onSuccess: (data, params) {
          final isRefresh = (params['page'] == 1);
          if (isRefresh) {
            listData.value = data;
            refreshController.refreshCompleted();
            refreshController.resetNoData();
            page.value = 1;
          } else {
            listData.value = [...listData.value, ...data];
            refreshController.loadComplete();
            page.value = params['page'] ?? page.value;
          }

          isAutoLoading.value = false;

          if (data.isEmpty || data.length < (params['pageSize'] ?? 20)) {
            hasMore.value = false;
            refreshController.loadNoData();
          } else {
            hasMore.value = true;
          }
        },
        onError: (error, _) {
          refreshController.refreshFailed();
          refreshController.loadFailed();
          isAutoLoading.value = false;
        },
      ),
    );

    useEffect(() {
      void listener() {
        if (!scrollController.hasClients) return;
        final position = scrollController.position;
        final offset = position.pixels;
        final delta = offset - lastScrollOffset.value;
        lastScrollOffset.value = offset;

        const threshold = 6.0;
        if (delta > threshold && !isTabBarHidden.value) {
          isTabBarHidden.value = true;
          _nativeChannel.invokeMethod<void>('hideTabBar');
        } else if (delta < -threshold && isTabBarHidden.value) {
          isTabBarHidden.value = false;
          _nativeChannel.invokeMethod<void>('showTabBar');
        }

        if (position.pixels >= position.maxScrollExtent - 120) {
          if (hasMore.value && !isAutoLoading.value) {
            isAutoLoading.value = true;
            request.run({'page': page.value + 1, 'pageSize': 20});
          }
        }
      }

      scrollController.addListener(listener);
      return () {
        scrollController.removeListener(listener);
      };
    }, [scrollController, hasMore.value, page.value]);

    // Mock Group Buy Packages (Static for now, could also be fetched)
    final groupBuyPackages = [
      const GroupBuyPackage(
        id: 'gb1',
        imageUrl: 'https://picsum.photos/seed/gb1/280/200',
        title: '【错峰游】丹霞山燕子呢喃民宿',
        price: 421.3,
        originalPrice: 901,
        tag: '超值券膨胀',
      ),
      const GroupBuyPackage(
        id: 'gb2',
        imageUrl: 'https://picsum.photos/seed/gb2/280/200',
        title: '三亚海边民宿1晚',
        price: 40,
        originalPrice: 199,
        tag: '超值券 减10',
      ),
      const GroupBuyPackage(
        id: 'gb3',
        imageUrl: 'https://picsum.photos/seed/gb3/280/200',
        title: '小象民宿【银基动物王国、冰雪世...',
        price: 219,
        originalPrice: 598,
        tag: '3.7折',
      ),
      const GroupBuyPackage(
        id: 'gb4',
        imageUrl: 'https://picsum.photos/seed/gb4/280/200',
        title: '雪乡梦幻家园',
        price: 888,
        originalPrice: 1288,
        tag: '热销',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MallSearchHeader(),
                const MallCategoryTabs(),
                MallFilterBar(
                  onCityApplied: (city) {
                    currentCity.value = city;
                    request.run(const {'page': 1, 'pageSize': 20});
                  },
                  onSortApplied: (sort) {
                    currentSort.value = sort;
                    final sorted = List<MallListingItem>.from(listData.value);
                    if (sort == SortOption.lowPrice) {
                      sorted.sort((a, b) {
                        final ap = a.groupBuyItems.isNotEmpty
                            ? a.groupBuyItems
                                .map((e) => e.price)
                                .reduce((v, e) => v < e ? v : e)
                            : double.infinity;
                        final bp = b.groupBuyItems.isNotEmpty
                            ? b.groupBuyItems
                                .map((e) => e.price)
                                .reduce((v, e) => v < e ? v : e)
                            : double.infinity;
                        return ap.compareTo(bp);
                      });
                    } else if (sort == SortOption.highScore) {
                      sorted.sort((a, b) => b.score.compareTo(a.score));
                    }
                    listData.value = sorted;
                  },
                  onStarApplied: (stars) {
                    currentStars.value = stars;
                    request.run(const {'page': 1, 'pageSize': 20});
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SmartRefresher(
              controller: refreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: const WaterDropHeader(),
              footer: const ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
                completeDuration: Duration(milliseconds: 500),
              ),
              onRefresh: () =>
                  request.run(const {'page': 1, 'pageSize': 20}),
              onLoading: () =>
                  request.run({'page': page.value + 1, 'pageSize': 20}),
              child: Builder(
                builder: (context) {
                  if (request.loading && listData.value.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (request.error != null && listData.value.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('加载失败'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => request.run(const {
                                  'page': 1,
                                  'pageSize': 20,
                                }),
                            child: const Text('重试'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (listData.value.isEmpty) {
                    return const Center(child: Text('暂无数据'));
                  }
                  return ListView.separated(
                    controller: scrollController,
                    itemCount: listData.value.length + 1,
                    separatorBuilder: (context, index) =>
                        Container(height: 1, color: const Color(0xFFF5F5F5)),
                    itemBuilder: (context, index) {
                      if (index == 1) {
                        return MallGroupBuySection(
                          packages: groupBuyPackages,
                        );
                      }
                      final itemIndex = index > 1 ? index - 1 : index;
                      if (itemIndex >= listData.value.length) {
                        return const SizedBox();
                      }
                      final item = listData.value[itemIndex];
                      return InkWell(
                        onTap: () =>
                            context.push('/detail/${item.id}', extra: item),
                        child: MallListingCard(item: item),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
