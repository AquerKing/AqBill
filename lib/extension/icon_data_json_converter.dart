import 'dart:convert';

import 'package:flutter/material.dart';

/// 用于IconData与JSON对象之间的转换
class IconDataJsonConverter {
  /// 将IconData转换为可序列化的JSON对象(Map)
  static Map<String, dynamic> toJson(IconData iconData) {
    return {
      'codePoint': iconData.codePoint,
      'fontFamily': iconData.fontFamily,
      'fontPackage': iconData.fontPackage,
      'matchTextDirection': iconData.matchTextDirection,
    };
  }

  /// 将JSON对象(Map)转换为IconData
  static IconData fromJson(Map<String, dynamic> json) {
    return IconData(
      json['codePoint'] as int,
      fontFamily: json['fontFamily'] as String?,
      fontPackage: json['fontPackage'] as String?,
      matchTextDirection: json['matchTextDirection'] as bool? ?? false,
    );
  }

  /// 将IconData直接转换为JSON字符串（可选）
  static String toJsonString(IconData iconData) {
    return json.encode(toJson(iconData));
  }

  /// 从JSON字符串直接转换为IconData（可选）
  static IconData fromJsonString(String jsonString) {
    return fromJson(json.decode(jsonString) as Map<String, dynamic>);
  }
}
