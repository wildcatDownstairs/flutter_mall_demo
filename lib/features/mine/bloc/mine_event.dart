part of 'mine_bloc.dart';

abstract class MineEvent extends Equatable {
  const MineEvent();

  @override
  List<Object?> get props => [];
}

class LoadMineData extends MineEvent {}

class UpdateAvatar extends MineEvent {
  final String imagePath;

  const UpdateAvatar(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class ReorderMenu extends MineEvent {
  final int oldIndex;
  final int newIndex;

  const ReorderMenu(this.oldIndex, this.newIndex);

  @override
  List<Object?> get props => [oldIndex, newIndex];
}

class ToggleMenuGroup extends MineEvent {
  final bool isExpanded;

  const ToggleMenuGroup(this.isExpanded);

  @override
  List<Object?> get props => [isExpanded];
}
