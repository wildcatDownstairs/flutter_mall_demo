# flutter_mall_demo

## 🚀 主要功能

## 🏗️ 应用架构

## 📁 项目结构(仅供参考)

`lib` 目录的组织结构清晰，保证了代码的可扩展性：

```
lib/
├── app.dart                              # 主应用组件，GoRouter 配置和主题设置
├── main.dart                             # 应用入口，服务初始化
│
├── core/                                 # 共享的业务逻辑、组件和工具
│   ├── components/                       # 可复用的 UI 组件
│   │   ├── banner/
│   │   │   └── swiper.dart              # 轮播图组件
│   │   └── refresh/
│   │       └── smart_refresh_list.dart  # 智能下拉刷新列表组件
│   ├── models/                          # API 响应的数据模型
│   │   ├── auth_model.dart              # 认证相关数据模型
│   │   ├── banner_model.dart            # 轮播图数据模型
│   │   ├── response_model.dart          # 通用响应数据模型
│   │   ├── user_model.dart              # 用户信息数据模型
│   │   └── video_model.dart             # 视频数据模型
│   ├── network/                         # 网络层
│   │   ├── interceptors/                # 网络拦截器
│   │   │   ├── logger_interceptor.dart  # 日志拦截器
│   │   │   └── token_interceptor.dart   # Token 拦截器
│   │   ├── api_client.dart              # API 客户端
│   │   └── api_exception.dart           # API 异常处理
│   ├── services/                        # 业务逻辑服务
│   │   ├── auth_service.dart            # 认证服务
│   │   ├── banner_service.dart          # 轮播图服务
│   │   ├── local_storage.dart           # 本地存储服务
│   │   ├── token_service.dart           # Token 管理服务
│   │   └── video_service.dart           # 视频服务
│   ├── theme/                           # 全局应用主题
│   │   └── app_theme.dart               # 应用主题配置
│   └── utils/                           # 工具类 (预留目录)
│
└── features/                            # 各个独立的功能模块
    ├── activity/                        # 活动页面模块
    │   └── presentation/
    │       └── activity_page.dart       # 活动页面 (WebView 展示)
    ├── auth/                            # 用户认证模块
    │   └── presentation/
    │       ├── login_screen.dart        # 登录页面
    │       └── register_screen.dart     # 注册页面
    ├── discovery/                       # 内容发现模块
    │   └── presentation/
    │       └── discovery_page.dart      # 发现页面
    ├── gallery/                         # 图库模块
    │   └── presentation/
    │       └── gallery_page.dart        # 图库页面
    ├── home/                            # 首页模块
    │   └── presentation/
    │       ├── hooks/                   # 钩子函数 (预留目录)
    │       ├── widgets/                 # 首页组件
    │       │   ├── home_search_header.dart    # 搜索头部组件
    │       │   ├── home_ulan_page.dart        # U蓝页面组件
    │       │   └── recommend_card.dart        # 推荐卡片组件
    │       └── home_page.dart           # 首页主页面
    ├── profile/                         # 个人中心模块
    │   └── presentation/
    │       ├── profile_page.dart        # 个人中心页面
    │       └── settings_page.dart       # 设置页面
    └── video/                           # 视频模块
        └── presentation/
            ├── widgets/                 # 视频相关组件
            │   ├── grid_card_block.dart      # 网格卡片块组件
            │   ├── horizontal_card_list.dart # 水平卡片列表组件
            │   ├── section_header.dart       # 区域头部组件
            │   └── video_card_item.dart      # 视频卡片项组件
            └── video_detail_page.dart   # 视频详情页面
```

## 🛠️ 核心依赖

- **状态管理**: `flutter_riverpod`
- **路由**: `go_router`
- **网络请求**: `dio`, `use_request`
- **视频**: `video_player`, `webview_flutter`
- **UI 组件**: `carousel_slider` (轮播图), `pull_to_refresh` (列表)
- **本地存储**: `shared_preferences`

## 🏃 如何运行

1.  **安装依赖:**
    ```bash
    flutter pub get
    ```
2.  **运行应用:**
    ```bash
    flutter run
    ```

## 🧩 iOS 常见问题

- CocoaPods 找不到 `Firebase/Auth (= 11.15.0)`：在 `.ios` 目录执行 `pod install --repo-update`
- Xcode 报 `iOS xx.x is not installed`：在 Xcode `Settings > Components` 安装对应 iOS Platform
