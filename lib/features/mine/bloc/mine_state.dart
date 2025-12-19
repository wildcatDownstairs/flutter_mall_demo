part of 'mine_bloc.dart';

enum MineStatus { initial, loading, success, failure }

class MineState extends Equatable {
  final MineStatus status;
  final UserEntity? user;
  final List<MenuItemEntity> menuItems;
  final List<ChartDataEntity> chartData;
  final bool isMenuExpanded;
  final String? errorMessage;

  const MineState({
    this.status = MineStatus.initial,
    this.user,
    this.menuItems = const [],
    this.chartData = const [],
    this.isMenuExpanded = true,
    this.errorMessage,
  });

  MineState copyWith({
    MineStatus? status,
    UserEntity? user,
    List<MenuItemEntity>? menuItems,
    List<ChartDataEntity>? chartData,
    bool? isMenuExpanded,
    String? errorMessage,
  }) {
    return MineState(
      status: status ?? this.status,
      user: user ?? this.user,
      menuItems: menuItems ?? this.menuItems,
      chartData: chartData ?? this.chartData,
      isMenuExpanded: isMenuExpanded ?? this.isMenuExpanded,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        menuItems,
        chartData,
        isMenuExpanded,
        errorMessage,
      ];
}
