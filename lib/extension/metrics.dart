import 'package:flutter/material.dart';

class Metrics {
  Metrics._internal();

  /// 计算给定文本在制定样式下所占宽度
  static double calculateTextWidth(String text, TextStyle style) {
    // 创建 TextSpan，包含文本内容和样式
    final textSpan = TextSpan(text: text, style: style);

    // 创建 TextPainter 并配置
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr, // 文本方向（根据实际需求设置）
    );

    // 布局文本（计算尺寸）
    textPainter.layout();

    // 返回文本的宽度
    return textPainter.width;
  }
}
