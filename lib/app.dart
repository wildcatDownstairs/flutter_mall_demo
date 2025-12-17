import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/mall/presentation/mall_page.dart';
import 'features/mall/presentation/mall_detail_page.dart';
import 'features/mall/models/mall_entity.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const MallPage()),
        GoRoute(
          path: '/detail/:id',
          builder: (context, state) {
            final item = state.extra as MallListingItem?;
            if (item == null) {
              return const Scaffold(body: Center(child: Text('数据缺失')));
            }
            return MallDetailPage(item: item);
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Flutter Mall Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF222222),
            height: 1.3,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF222222),
            height: 1.2,
          ),
          bodyMedium: TextStyle(fontSize: 13, color: Color(0xFF333333)),
          bodySmall: TextStyle(fontSize: 11, color: Color(0xFF666666)),
        ),
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: true,
    );
  }
}
