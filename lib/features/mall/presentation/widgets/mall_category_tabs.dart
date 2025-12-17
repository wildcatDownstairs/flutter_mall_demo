import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MallCategoryTabs extends HookWidget {
  const MallCategoryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = ['综合', '团购', '视频', '图文', '用户', '商品', '直播'];
    final selectedIndex = useState(1); // Default to '团购' as per screenshot

    return Container(
      color: Colors.white,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final title = entry.value;
            final isSelected = selectedIndex.value == index;

            return GestureDetector(
              onTap: () => selectedIndex.value = index,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? Colors.black
                            : const Color(0xFF666666),
                      ),
                    ),
                    if (isSelected)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 20,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
