import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import '../../bloc/mine_bloc.dart';
import '../../models/mine_entities.dart';

class GridMenu extends StatelessWidget {
  const GridMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MineBloc, MineState>(
      builder: (context, state) {
        if (state.menuItems.isEmpty) return const SliverToBoxAdapter();

        return SliverToBoxAdapter(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // 标题栏 + 折叠按钮
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '我的服务',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          state.isMenuExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),
                        onPressed: () {
                          context.read<MineBloc>().add(
                                ToggleMenuGroup(!state.isMenuExpanded),
                              );
                        },
                      ),
                    ],
                  ),
                ),
                
                // 宫格区域
                AnimatedCrossFade(
                  firstChild: Container(
                    height: _calculateGridHeight(state.menuItems.length),
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ReorderableGridView.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.8,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      onReorder: (oldIndex, newIndex) {
                        context.read<MineBloc>().add(
                              ReorderMenu(oldIndex, newIndex),
                            );
                      },
                      children: state.menuItems.map((item) {
                        return _buildMenuItem(context, item);
                      }).toList(),
                    ),
                  ),
                  secondChild: const SizedBox(width: double.infinity),
                  crossFadeState: state.isMenuExpanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _calculateGridHeight(int itemCount) {
    // 粗略计算：(itemCount / 4).ceil() * itemHeight
    // 假设每个 item 高度约为 90 (aspectRatio 0.8 + spacing)
    // 实际可以通过 LayoutBuilder 获取更精确的值，这里简化处理
    const itemHeight = 90.0;
    const spacing = 16.0;
    final rows = (itemCount / 4).ceil();
    return rows * itemHeight + (rows - 1) * spacing + 16; 
  }

  Widget _buildMenuItem(BuildContext context, MenuItemEntity item) {
    return Container(
      key: ValueKey(item.id),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // 路由跳转
            // GoRouter.of(context).push(item.route);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('点击了 ${item.title}')),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item.icon, color: Colors.blue, size: 24),
                  ),
                  if (item.badge != null)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Text(
                          item.badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.title,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
