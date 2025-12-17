import 'package:flutter/material.dart';

/// 全局颜色常量
class AppColors {
  static const background = Color(0xFF111111); // 背景色
  static const cardBg = Color(0xFF2E2E2E); // 卡片背景色
  static const lightCardBg = Color(0xFFFFF2E5); // 浅色卡片背景色
  static const accentGreen = Color(0xFF8FF08C); // 绿色
  static const accentCyan = Color(0xFF3CD6CF); // 青色
  static const accentOrange = Color(0xFFFF7B00); // 橙色
  static const accentOrangeDark = Color(0xFFFF4600); // 深橙色
  static const textPrimary = Colors.white; // 主要文本颜色
  static const textSecondary = Colors.white70; // 次要文本颜色
  static const textBlue = Colors.blueAccent; // 蓝色文本
}

/// 全局文本样式
class AppTextStyles {
  /// 主要文本样式
  static const title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// 次要文本样式
  static const subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  /// 其他文本样式
  static const body = TextStyle(fontSize: 12, color: AppColors.textSecondary);

  /// 按钮文本样式
  static const button = TextStyle(
    fontSize: 12,
    color: Colors.white,
    height: 1.0, // ✅ 关键！避免 baseline 偏差
  );

  static const priceLabelRed10 = TextStyle(
    fontSize: 10,
    color: Color(0xFFFF4D4F),
    height: 1.1,
    fontWeight: FontWeight.w500,
  );

  static const priceLabelWhite10 = TextStyle(
    fontSize: 10,
    color: Colors.white,
    height: 1.1,
    fontWeight: FontWeight.w500,
  );

  static const filterLabel = TextStyle(fontSize: 13, color: Color(0xFF666666));

  static const filterLabelActive = TextStyle(
    fontSize: 13,
    color: Color(0xFFFF4D4F),
    fontWeight: FontWeight.w600,
  );
}

/// 全局间距／圆角
class AppSpacing {
  static const pagePadding = EdgeInsets.symmetric(horizontal: 24, vertical: 30);
  static const sectionGap = SizedBox(height: 24);
  static const smallGap = SizedBox(height: 10);
}

/// 全局圆角
class AppRadius {
  static const card = Radius.circular(24);
  static const button = Radius.circular(12);
}
