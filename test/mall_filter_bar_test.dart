import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mall_demo/features/mall/presentation/widgets/mall_filter_bar.dart';

void main() {
  testWidgets('opens sort sheet and applies selection', (tester) async {
    SortOption? selected;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MallFilterBar(
          onSortApplied: (s) => selected = s,
        ),
      ),
    ));

    expect(find.text('智能排序'), findsOneWidget);
    await tester.tap(find.text('智能排序'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('低价优先'));
    await tester.pumpAndSettle();

    expect(selected, SortOption.lowPrice);
  });

  testWidgets('opens star sheet and confirms selection', (tester) async {
    List<String>? stars;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MallFilterBar(
          onStarApplied: (s) => stars = s,
        ),
      ),
    ));

    await tester.tap(find.text('星级房型'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('豪华型/5星'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('查看最新结果'));
    await tester.pumpAndSettle();

    expect(stars, isNotNull);
    expect(stars!.contains('豪华型/5星'), isTrue);
  });
}
