import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 演示原生 iOS 传递字符串到 Flutter，并由 Flutter 组件展示出来的页面。
class NativeBridgeDemoPage extends StatelessWidget {
  static const _nativeChannel = MethodChannel('mall_demo_native');

  final String message;

  const NativeBridgeDemoPage({super.key, required this.message});

  Future<void> _handleClose(BuildContext context) async {
    try {
      await _nativeChannel.invokeMethod<void>('closeNativeToFlutterDemo');
    } catch (_) {
      // 在纯 Flutter 环境中，降级为普通的 Navigator pop。
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '来自 iOS 的消息',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => _handleClose(context),
                child: const Text('关闭'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

