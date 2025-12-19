import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../models/mine_entities.dart';

part 'mine_event.dart';
part 'mine_state.dart';

class MineBloc extends Bloc<MineEvent, MineState> {
  MineBloc() : super(const MineState()) {
    on<LoadMineData>(_onLoadMineData);
    on<UpdateAvatar>(_onUpdateAvatar);
    on<ReorderMenu>(_onReorderMenu);
    on<ToggleMenuGroup>(_onToggleMenuGroup);
  }

  Future<void> _onLoadMineData(
    LoadMineData event,
    Emitter<MineState> emit,
  ) async {
    emit(state.copyWith(status: MineStatus.loading));
    try {
      // 模拟网络延迟
      await Future.delayed(const Duration(milliseconds: 800));

      final user = const UserEntity(
        id: 'u123',
        username: 'Flutter开发者',
        memberLevel: '黄金会员',
        points: 2580,
        avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      );

      final menuItems = List.generate(
        8,
        (index) => MenuItemEntity(
          id: 'menu_$index',
          title: _getMenuTitle(index),
          icon: _getMenuIcon(index),
          route: '/mine/menu_$index',
          badge: index == 1 ? '3' : null,
        ),
      );

      final chartData = [
        const ChartDataEntity(label: '访问', value: 120, color: Color(0xFF409EFF)),
        const ChartDataEntity(label: '收藏', value: 85, color: Color(0xFF67C23A)),
        const ChartDataEntity(label: '点赞', value: 240, color: Color(0xFFE6A23C)),
        const ChartDataEntity(label: '分享', value: 60, color: Color(0xFFF56C6C)),
        const ChartDataEntity(label: '评论', value: 180, color: Color(0xFF909399)),
      ];

      emit(state.copyWith(
        status: MineStatus.success,
        user: user,
        menuItems: menuItems,
        chartData: chartData,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MineStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onUpdateAvatar(UpdateAvatar event, Emitter<MineState> emit) {
    if (state.user != null) {
      // 在实际项目中，这里应该先上传图片到服务器，获取URL
      // 这里直接使用本地路径模拟更新
      final updatedUser = UserEntity(
        id: state.user!.id,
        username: state.user!.username,
        memberLevel: state.user!.memberLevel,
        points: state.user!.points,
        avatarUrl: event.imagePath, // 这里的路径可能需要 Image.file 来显示
      );
      emit(state.copyWith(user: updatedUser));
    }
  }

  void _onReorderMenu(ReorderMenu event, Emitter<MineState> emit) {
    if (state.menuItems.isEmpty) return;

    final items = List<MenuItemEntity>.from(state.menuItems);
    final oldIndex = event.oldIndex;
    var newIndex = event.newIndex;
    
    // ReorderableListView 的机制：向下拖动时，newIndex 会包含 item 本身，所以需要减1
    // 但在 GridView 中通常不需要这样，取决于具体的 Grid 实现
    // 这里假设使用的是 reorderable_grid_view，它的逻辑通常与 ReorderableListView 类似
    
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    emit(state.copyWith(menuItems: items));
  }

  void _onToggleMenuGroup(ToggleMenuGroup event, Emitter<MineState> emit) {
    emit(state.copyWith(isMenuExpanded: event.isExpanded));
  }

  String _getMenuTitle(int index) {
    const titles = ['我的订单', '待付款', '待收货', '评价', '退款/售后', '优惠券', '地址管理', '设置'];
    return titles[index % titles.length];
  }

  IconData _getMenuIcon(int index) {
    const icons = [
      Icons.assignment_outlined,
      Icons.payment_outlined,
      Icons.local_shipping_outlined,
      Icons.rate_review_outlined,
      Icons.assignment_return_outlined,
      Icons.card_giftcard_outlined,
      Icons.location_on_outlined,
      Icons.settings_outlined,
    ];
    return icons[index % icons.length];
  }
}
