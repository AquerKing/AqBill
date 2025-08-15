// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:bill/resources/svg_icon.dart';

/// Category模型
abstract class CategoryModel {
  CategoryModel();
  CategoryModel.construct({
    required this.icon,
    required this.name,
    required this.description,
  });

  CategoryModel.fullyConstruct({
    required this.id,
    required this.icon,
    required this.name,
    required this.description,
  });

  int getHash();

  int id = 0;
  SvgIconData icon = SvgIcons.misc;
  String name = 'Category';
  String description = '';

  Map<String, dynamic> toMap() {
    return {
      // 替换IconData的序列化，改为存储SVG资源路径
      'id': id,
      'icon': icon.toJson(),
      'name': name,
      'description': description,
      // 保留类型标识，用于反序列化时区分收支分类
      'type': this is ExpenseCategory ? 'expense' : 'income',
    };
  }

  // 重构序列化方法：存储SVG路径而非IconData
  String toJson() {
    return json.encode(toMap());
  }

  // 重构反序列化方法：从SVG路径恢复SvgIconData
  static CategoryModel fromJson(Map<String, dynamic> json) {
    // 从JSON中获取SVG路径并创建SvgIconData
    final svgIconData = SvgIconData(
      json['aset'], // 读取SVG路径
      semanticsLabel: json['name'] ?? 'Category Icon', // 语义化标签
    );

    // 根据类型创建对应分类实例
    if (json['id'] > 10000 && json['id'] < 20000) {
      CategoryModel category = ExpenseCategory.construct(
        icon: svgIconData, // 替换原有的icon参数
        name: json['name'],
        description: json['description'],
      );
      category.id = json['id'];
      return category;
      // } else if (json['id'] > 20000 && json['id'] < 30000) {
    } else {
      CategoryModel category = ExpenseCategory.construct(
        icon: svgIconData, // 替换原有的icon参数
        name: json['name'],
        description: json['description'],
      );
      category.id = json['id'];
      return category;
    }
  }
}

class ExpenseCategory extends CategoryModel {
  ExpenseCategory();
  ExpenseCategory.construct({
    required super.icon,
    required super.name,
    required super.description,
  }) : super.construct();
  ExpenseCategory.fullyConstruct({
    required super.id,
    required super.icon,
    required super.name,
    required super.description,
  }) : super.fullyConstruct();

  @override
  int getHash() {
    // 使用两个大质数作为初始哈希值，降低碰撞概率
    int hash1 = 3571428571; // 较大的质数
    int hash2 = 9876543211; // 另一个较大的质数

    // 处理第一个字符串，使用更复杂的哈希算法
    for (int i = 0; i < name.length; i++) {
      hash1 = ((hash1 ^ name.codeUnitAt(i)) * 0x9e3779b9) >>> 0;
      hash1 = (hash1 + i) >>> 0; // 加入索引信息，增加独特性
    }

    // 处理第二个字符串
    final String iconString = icon.toString();
    for (int i = 0; i < iconString.length; i++) {
      hash2 = ((hash2 ^ iconString.codeUnitAt(i)) * 0x9e3779b9) >>> 0;
      hash2 = (hash2 + i) >>> 0; // 加入索引信息
    }

    // 组合两个哈希值，使用更复杂的混合算法
    int combinedHash = (hash1 * 313 + hash2 * 101) & 0xFFFFFFFF;

    combinedHash |= 0x80000000;

    return combinedHash;
  }
}

class IncomeCategory extends CategoryModel {
  IncomeCategory();
  IncomeCategory.construct({
    required super.icon,
    required super.name,
    required super.description,
  }) : super.construct();
  IncomeCategory.fullyConstruct({
    required super.id,
    required super.icon,
    required super.name,
    required super.description,
  }) : super.fullyConstruct();

  @override
  int getHash() {
    // 使用两个大质数作为初始哈希值，降低碰撞概率
    int hash1 = 3571428571; // 较大的质数
    int hash2 = 9876543211; // 另一个较大的质数

    // 处理第一个字符串，使用更复杂的哈希算法
    for (int i = 0; i < name.length; i++) {
      hash1 = ((hash1 ^ name.codeUnitAt(i)) * 0x9e3779b9) >>> 0;
      hash1 = (hash1 + i) >>> 0; // 加入索引信息，增加独特性
    }

    // 处理第二个字符串
    final String iconString = icon.toString();
    for (int i = 0; i < iconString.length; i++) {
      hash2 = ((hash2 ^ iconString.codeUnitAt(i)) * 0x9e3779b9) >>> 0;
      hash2 = (hash2 + i) >>> 0; // 加入索引信息
    }

    // 组合两个哈希值，使用更复杂的混合算法
    int combinedHash = (hash1 * 313 + hash2 * 101) & 0xFFFFFFFF;

    combinedHash &= 0x7FFFFFFF;

    return combinedHash;
  }
}
