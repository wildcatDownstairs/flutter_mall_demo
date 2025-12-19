import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import '../../bloc/mine_bloc.dart';
import '../../models/mine_entities.dart';

class DataChart extends StatefulWidget {
  const DataChart({super.key});

  @override
  State<DataChart> createState() => _DataChartState();
}

class _DataChartState extends State<DataChart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int? _touchedIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MineBloc, MineState>(
      builder: (context, state) {
        if (state.chartData.isEmpty) return const SliverToBoxAdapter();

        return SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '数据概览',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return GestureDetector(
                        onTapUp: (details) => _handleTap(details, context, state.chartData),
                        child: CustomPaint(
                          painter: _ChartPainter(
                            data: state.chartData,
                            progress: _animation.value,
                            touchedIndex: _touchedIndex,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // 图例
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: state.chartData.map((e) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: e.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${e.label} (${e.value.toInt()})',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleTap(TapUpDetails details, BuildContext context, List<ChartDataEntity> data) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final center = Offset(size.width / 2, size.height / 2); // 这里的 center 需要和 Painter 中的一致
    // 注意：这里的 context 是 AnimatedBuilder 的 context，可能不是 SizedBox 的
    // 实际上触摸判定比较复杂，为了简化，这里简单演示触摸交互反馈：随机高亮一个，或者重置动画
    
    // 简单的交互：点击图表区域重播动画
    _controller.reset();
    _controller.forward();
    
    // 如果要精确判定点击了哪个扇区，需要计算角度
    // final touchAngle = math.atan2(details.localPosition.dy - center.dy, details.localPosition.dx - center.dx);
  }
}

class _ChartPainter extends CustomPainter {
  final List<ChartDataEntity> data;
  final double progress;
  final int? touchedIndex;

  _ChartPainter({
    required this.data,
    required this.progress,
    this.touchedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.8;
    final strokeWidth = 20.0;

    double startAngle = -math.pi / 2;
    final totalValue = data.fold<double>(0, (sum, item) => sum + item.value);

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final sweepAngle = (item.value / totalValue) * 2 * math.pi * progress;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = item.color
        ..strokeCap = StrokeCap.round;

      // 选中高亮效果（变大）
      if (touchedIndex == i) {
        paint.strokeWidth = strokeWidth + 6;
      }

      // 绘制圆弧
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
    
    // 绘制中心文字
    const textStyle = TextStyle(
      color: Colors.black87,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
    final textSpan = TextSpan(
      text: '${(totalValue * progress).toInt()}',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.touchedIndex != touchedIndex;
  }
}
