// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 用于描述 SVG 图标数据的类，类似 IconData
class SvgIconData {
  final String assetPath;
  final String semanticsLabel;

  const SvgIconData(this.assetPath, {this.semanticsLabel = ''});

  String toJson() {
    Map<String, dynamic> map = {'asset': assetPath, 'label': semanticsLabel};
    return json.encode(map);
  }

  SvgIconData fromJson(String content) {
    Map<String, dynamic> map = {};
    map = json.decode(content);
    return SvgIconData(map['asset'], semanticsLabel: map['label']);
  }
}

// 用于显示 SVG 图标的组件，类似 Icon 组件
class SvgIcon extends StatelessWidget {
  final SvgIconData data;
  final double size;
  final Color? color;
  final BoxFit fit;

  const SvgIcon(
    this.data, {
    super.key,
    this.size = 24.0,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      data.assetPath,
      width: size,
      height: size,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      fit: fit,
      semanticsLabel: data.semanticsLabel,
      placeholderBuilder:
          (BuildContext context) => Container(
            width: size,
            height: size,
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
    );
  }
}

// 这个类用于集中管理所有的 SVG 图标，方便像 IconData 一样直接引用
class SvgIcons {
  static const SvgIconData clothes = SvgIconData(
    'assets/icons/clothes.svg',
    semanticsLabel: 'Clothes Icon',
  );
  static const SvgIconData education = SvgIconData(
    'assets/icons/education.svg',
    semanticsLabel: 'Education Icon',
  );
  static const SvgIconData entertainment = SvgIconData(
    'assets/icons/entertainment.svg',
    semanticsLabel: 'Entertainment Icon',
  );
  static const SvgIconData family = SvgIconData(
    'assets/icons/family.svg',
    semanticsLabel: 'Family Icon',
  );
  static const SvgIconData food = SvgIconData(
    'assets/icons/food.svg',
    semanticsLabel: 'Food Icon',
  );
  static const SvgIconData healthcare = SvgIconData(
    'assets/icons/healthcare.svg',
    semanticsLabel: 'Healthcare Icon',
  );
  static const SvgIconData house = SvgIconData(
    'assets/icons/house.svg',
    semanticsLabel: 'House Icon',
  );
  static const SvgIconData investment = SvgIconData(
    'assets/icons/investment.svg',
    semanticsLabel: 'Investment Icon',
  );
  static const SvgIconData misc = SvgIconData(
    'assets/icons/misc.svg',
    semanticsLabel: 'Misc Icon',
  );
  static const SvgIconData pocketMoney = SvgIconData(
    'assets/icons/pocket_money.svg',
    semanticsLabel: 'Pocket Money Icon',
  );
  static const SvgIconData refund = SvgIconData(
    'assets/icons/refund.svg',
    semanticsLabel: 'Refund Icon',
  );
  static const SvgIconData salary = SvgIconData(
    'assets/icons/salary.svg',
    semanticsLabel: 'Salary Icon',
  );
  static const SvgIconData scholarship = SvgIconData(
    'assets/icons/scholarship.svg',
    semanticsLabel: 'Scholarship Icon',
  );
  static const SvgIconData social = SvgIconData(
    'assets/icons/social.svg',
    semanticsLabel: 'Social Icon',
  );
  static const SvgIconData transportation = SvgIconData(
    'assets/icons/transportation.svg',
    semanticsLabel: 'Transportation Icon',
  );
  static const SvgIconData error = SvgIconData(
    'assets/icons/error.svg',
    semanticsLabel: 'Transportation Icon',
  );
  static const SvgIconData trash_can = SvgIconData(
    'assets/icons/trash_can.svg',
    semanticsLabel: 'Trash Can',
  );
}
