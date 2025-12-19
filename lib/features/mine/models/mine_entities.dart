import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserEntity extends Equatable {
  final String id;
  final String username;
  final String? avatarUrl;
  final String memberLevel;
  final int points;

  const UserEntity({
    required this.id,
    required this.username,
    this.avatarUrl,
    required this.memberLevel,
    required this.points,
  });

  @override
  List<Object?> get props => [id, username, avatarUrl, memberLevel, points];
}

class MenuItemEntity extends Equatable {
  final String id;
  final String title;
  final IconData icon;
  final String route;
  final String? badge;

  const MenuItemEntity({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    this.badge,
  });

  @override
  List<Object?> get props => [id, title, icon, route, badge];
}

class ChartDataEntity extends Equatable {
  final String label;
  final double value;
  final Color color;

  const ChartDataEntity({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  List<Object?> get props => [label, value, color];
}
