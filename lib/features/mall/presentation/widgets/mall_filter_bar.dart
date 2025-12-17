import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mall_demo/core/theme/app_theme.dart';

enum SortOption { smart, distance, lowPrice, highScore }

class MallFilterBar extends HookWidget {
  final ValueChanged<String>? onCityApplied;
  final ValueChanged<SortOption>? onSortApplied;
  final ValueChanged<List<String>>? onStarApplied;
  final ValueChanged<DateTime>? onDateApplied;

  const MallFilterBar({
    super.key,
    this.onCityApplied,
    this.onSortApplied,
    this.onStarApplied,
    this.onDateApplied,
  });

  @override
  Widget build(BuildContext context) {
    final selectedCity = useState('全城');
    final selectedSort = useState(SortOption.smart);
    final selectedStars = useState<List<String>>([]);
    final opening = useState<String>('');
    final selectedDate = useState<DateTime?>(null);

    void openDateSheet() async {
      opening.value = 'date';
      final result = await showModalBottomSheet<DateTime>(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color(0xFFF7F7F7),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) {
          final firstDate = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            1,
          );
          return SafeArea(
            child: SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.75,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '选择日期',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: 18,
                      itemBuilder: (context, index) {
                        final base = DateTime(
                          firstDate.year,
                          firstDate.month,
                          1,
                        );
                        final monthDate = DateTime(
                          base.year,
                          base.month + index,
                          1,
                        );
                        final nextMonth = DateTime(
                          monthDate.year,
                          monthDate.month + 1,
                          0,
                        );
                        final daysInMonth = nextMonth.day;
                        final firstWeekday = monthDate.weekday % 7;
                        final now = DateTime.now();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 8,
                                ),
                                child: Text(
                                  '${monthDate.year}年${monthDate.month}月',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 7,
                                      crossAxisSpacing: 6,
                                      mainAxisSpacing: 0,
                                      childAspectRatio: 2.6,
                                    ),
                                itemCount: 7,
                                itemBuilder: (context, idx) {
                                  const labels = [
                                    '日',
                                    '一',
                                    '二',
                                    '三',
                                    '四',
                                    '五',
                                    '六',
                                  ];
                                  final isWeekend = idx == 0 || idx == 6;
                                  return Center(
                                    child: Text(
                                      labels[idx],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isWeekend
                                            ? const Color(0xFFFF4D4F)
                                            : const Color(0xFF999999),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 7,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 6,
                                      childAspectRatio: 1.2,
                                    ),
                                itemCount: 42,
                                itemBuilder: (context, i) {
                                  if (i < firstWeekday ||
                                      i >= firstWeekday + daysInMonth) {
                                    return const SizedBox();
                                  }
                                  final day = i - firstWeekday + 1;
                                  final date = DateTime(
                                    monthDate.year,
                                    monthDate.month,
                                    day,
                                  );
                                  final disabled =
                                      monthDate.year == now.year &&
                                      monthDate.month == now.month &&
                                      day < now.day;
                                  final color = disabled
                                      ? const Color(0xFFCCCCCC)
                                      : const Color(0xFF111111);
                                  return InkWell(
                                    onTap: disabled
                                        ? null
                                        : () => Navigator.of(ctx).pop(date),
                                    borderRadius: BorderRadius.circular(6),
                                    child: Center(
                                      child: Text(
                                        '$day',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: color,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
      opening.value = '';
      if (result != null) {
        selectedDate.value = result;
        onDateApplied?.call(result);
      }
    }

    void openCitySheet() async {
      opening.value = 'city';
      final categories = ['全城', '热门', '商圈', '行政区'];
      final districts = ['江北区', '渝中区', '南岸区', '北部新区'];
      final bizMap = {
        '江北区': ['观音桥', '北滨路'],
        '渝中区': ['解放碑', '两路口'],
        '南岸区': ['南滨路', '南坪商圈'],
        '北部新区': ['光电园', '金开大道'],
      };

      String activeCategory = '全城';
      String activeDistrict = '';
      String activeBiz = '';
      bool allSelected = true;

      final result = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color(0xFFF7F7F7),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) {
          return SafeArea(
            child: SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.6,
              child: StatefulBuilder(
                builder: (ctx, setState) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('全城', style: AppTextStyles.filterLabelActive),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  allSelected = !allSelected;
                                  activeCategory = '全城';
                                  activeDistrict = '';
                                  activeBiz = '';
                                });
                              },
                              child: Text(allSelected ? '取消全选' : '全选'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 140,
                              child: ListView.builder(
                                itemCount: categories.length,
                                itemBuilder: (c, i) {
                                  final title = categories[i];
                                  final active = activeCategory == title;
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        activeCategory = title;
                                        activeDistrict = '';
                                        activeBiz = '';
                                        allSelected = title == '全城';
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                      child: Text(
                                        title,
                                        style: active
                                            ? AppTextStyles.filterLabelActive
                                            : AppTextStyles.filterLabel,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const VerticalDivider(
                              width: 1,
                              color: Color(0xFFF5F5F5),
                            ),
                            Expanded(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Builder(
                                  key: ValueKey(activeCategory),
                                  builder: (context) {
                                    if (activeCategory == '全城' ||
                                        activeCategory == '热门') {
                                      return ListView(
                                        children: [
                                          InkWell(
                                            onTap: () =>
                                                Navigator.of(ctx).pop('全城'),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 14,
                                                  ),
                                              child: Text(
                                                '全城',
                                                style: AppTextStyles
                                                    .filterLabelActive,
                                              ),
                                            ),
                                          ),
                                          ...['热门商圈', '近地铁', '景点周边'].map(
                                            (e) => InkWell(
                                              onTap: () =>
                                                  Navigator.of(ctx).pop(e),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 14,
                                                    ),
                                                child: Text(
                                                  e,
                                                  style:
                                                      AppTextStyles.filterLabel,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    if (activeCategory == '行政区') {
                                      return ListView(
                                        children: districts.map((d) {
                                          final active = activeDistrict == d;
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                activeDistrict = d;
                                              });
                                              Navigator.of(ctx).pop(d);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 14,
                                                  ),
                                              child: Text(
                                                d,
                                                style: active
                                                    ? AppTextStyles
                                                          .filterLabelActive
                                                    : AppTextStyles.filterLabel,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    }
                                    return ListView(
                                      children: districts
                                          .expand(
                                            (d) => bizMap[d]!.map((b) {
                                              final active = activeBiz == b;
                                              return InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    activeBiz = b;
                                                  });
                                                  Navigator.of(ctx).pop(b);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 14,
                                                      ),
                                                  child: Text(
                                                    b,
                                                    style: active
                                                        ? AppTextStyles
                                                              .filterLabelActive
                                                        : AppTextStyles
                                                              .filterLabel,
                                                  ),
                                                ),
                                              );
                                            }),
                                          )
                                          .toList(),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      );
      opening.value = '';
      if (result != null) {
        selectedCity.value = result;
        onCityApplied?.call(result);
      }
    }

    void openSortSheet() async {
      opening.value = 'sort';
      final options = {
        SortOption.smart: '智能排序',
        SortOption.distance: '距离优先',
        SortOption.lowPrice: '低价优先',
        SortOption.highScore: '好评优先',
      };
      final result = await showModalBottomSheet<SortOption>(
        context: context,
        builder: (ctx) {
          return SafeArea(
            child: ListView(
              children: options.entries.map((entry) {
                final active = selectedSort.value == entry.key;
                return InkWell(
                  onTap: () => Navigator.of(ctx).pop(entry.key),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Text(
                      entry.value,
                      style: active
                          ? AppTextStyles.filterLabelActive
                          : AppTextStyles.filterLabel,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      );
      opening.value = '';
      if (result != null) {
        selectedSort.value = result;
        onSortApplied?.call(result);
      }
    }

    void openStarSheet() async {
      opening.value = 'star';
      final labels = ['豪华型/5星', '高档型/4星', '舒适型/3星', '经济型'];
      List<String> temp = List<String>.from(selectedStars.value);
      final result = await showModalBottomSheet<List<String>>(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color(0xFFF7F7F7),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) {
          return SafeArea(
            child: SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.4,
              child: StatefulBuilder(
                builder: (ctx, setState) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '酒店星级',
                            style: AppTextStyles.filterLabelActive,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: labels.map((l) {
                            final active = temp.contains(l);
                            return ChoiceChip(
                              label: Text(l),
                              selected: active,
                              onSelected: (v) {
                                setState(() {
                                  if (v) {
                                    temp.add(l);
                                  } else {
                                    temp.remove(l);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => setState(() => temp = []),
                                child: const Text('重置'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.of(ctx).pop(temp),
                                child: const Text('查看最新结果'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      );
      opening.value = '';
      if (result != null) {
        selectedStars.value = result;
        onStarApplied?.call(result);
      }
    }

    TextStyle labelStyle(bool active) =>
        active ? AppTextStyles.filterLabelActive : AppTextStyles.filterLabel;
    Icon arrow(bool up) => Icon(
      up ? Icons.arrow_drop_up : Icons.arrow_drop_down,
      size: 16,
      color: const Color(0xFF999999),
    );

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: openDateSheet,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '选择日期',
                  style: labelStyle(
                    opening.value == 'date' || selectedDate.value != null,
                  ),
                ),
                arrow(opening.value == 'date'),
              ],
            ),
          ),
          InkWell(
            onTap: openCitySheet,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedCity.value,
                  style: labelStyle(
                    opening.value == 'city' || selectedCity.value != '全城',
                  ),
                ),
                arrow(opening.value == 'city'),
              ],
            ),
          ),
          InkWell(
            onTap: openSortSheet,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '智能排序',
                  style: labelStyle(
                    opening.value == 'sort' ||
                        selectedSort.value != SortOption.smart,
                  ),
                ),
                arrow(opening.value == 'sort'),
              ],
            ),
          ),
          InkWell(
            onTap: openStarSheet,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '星级房型',
                  style: labelStyle(
                    opening.value == 'star' || selectedStars.value.isNotEmpty,
                  ),
                ),
                arrow(opening.value == 'star'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
