import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mall_demo/features/mine/presentation/pages/mine_page.dart';
import 'package:flutter_mall_demo/features/mine/presentation/widgets/user_header.dart';
import 'package:flutter_mall_demo/features/mine/presentation/widgets/grid_menu.dart';
import 'package:flutter_mall_demo/features/mine/presentation/widgets/data_chart.dart';

void main() {
  testWidgets('MinePage renders correctly', (WidgetTester tester) async {
    // Build the MinePage
    await tester.pumpWidget(const MaterialApp(home: MinePage()));
    
    // Verify loading state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // Wait for simulated network delay
    await tester.pumpAndSettle(const Duration(seconds: 1));
    
    // Verify content rendered
    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.byType(UserHeader), findsOneWidget);
    expect(find.byType(GridMenu), findsOneWidget);
    expect(find.byType(DataChart), findsOneWidget);
    
    // Verify user info
    expect(find.text('Flutter开发者'), findsOneWidget);
    expect(find.text('黄金会员'), findsOneWidget);
    
    // Verify menu items
    expect(find.text('我的订单'), findsOneWidget);
    
    // Verify chart title
    expect(find.text('数据概览'), findsOneWidget);
  });
}
