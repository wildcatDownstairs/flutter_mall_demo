import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/mall/presentation/mall_page.dart';
import 'features/mall/presentation/mall_detail_page.dart';
import 'features/mall/presentation/native_bridge_demo_page.dart';
import 'features/mine/presentation/pages/mine_page.dart';
import 'features/discover/presentation/discover_page.dart';
import 'features/mall/models/mall_entity.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 根据宿主侧设置的 initialRoute（defaultRouteName）决定初始路由，
    // 便于在原生 add-to-app 场景中通过 FlutterEngine.initialRoute 进行深度链接跳转。
    final defaultRoute =
        WidgetsBinding.instance.platformDispatcher.defaultRouteName;
    final initialLocation = (defaultRoute.isNotEmpty && defaultRoute != '/')
        ? defaultRoute
        : '/';

    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(path: '/', builder: (context, state) => const MallPage()),
        GoRoute(
          path: '/detail/:id',
          builder: (context, state) {
            // 兼容从原生侧仅通过路径参数（/detail/:id）跳转的情况。
            // 优先使用 extra 中完整的 MallListingItem，
            // 如果 extra 为空，则根据 id 参数构造一个占位 Item。
            MallListingItem? item;

            final extra = state.extra;
            if (extra is MallListingItem) {
              item = extra;
            } else {
              final id = state.pathParameters['id'];
              if (id != null) {
                item = MallListingItem(
                  id: id,
                  imageUrl: 'https://picsum.photos/seed/native_$id/800/600',
                  title: '来自原生的商品 $id',
                  score: 0,
                  scoreText: '暂无评分',
                  commentCount: 0,
                  locationArea: '',
                  locationCity: '',
                );
              }
            }

            if (item == null) {
              return const Scaffold(body: Center(child: Text('数据缺失')));
            }
            return MallDetailPage(item: item);
          },
        ),
        GoRoute(
          path: '/native-bridge',
          builder: (context, state) {
            final uri = state.uri;
            final message = uri.queryParameters['message'] ?? '（未收到来自 iOS 的消息）';
            return NativeBridgeDemoPage(message: message);
          },
        ),
        GoRoute(
          path: '/discover',
          builder: (context, state) => const DiscoverPage(),
        ),
        GoRoute(path: '/mine', builder: (context, state) => const MinePage()),
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
    );
  }
}
