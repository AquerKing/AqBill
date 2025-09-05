import 'package:bill/l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:bill/data/transaction_model.dart';
import 'package:bill/mediator/manager/category_manager.dart';

class TransactionPieChart extends StatelessWidget {
  final List<TransactionModel> transactions;
  final bool isExpense; // true表示展示支出，false表示展示收入

  const TransactionPieChart({
    super.key,
    required this.transactions,
    required this.isExpense,
  });

  // 生成鲜明可辨的颜色列表
  final List<Color> _colors = const [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.pinkAccent,
    Colors.tealAccent,
    Colors.indigoAccent,
    Colors.cyanAccent,
    Colors.limeAccent,
    Colors.amberAccent,
  ];

  // 统计各分类的金额总和
  Map<int, double> _calculateCategoryTotals() {
    final Map<int, double> totals = {};

    for (final transaction in transactions) {
      // 只统计符合当前类型（收入/支出）的交易
      if (transaction.isExpense == isExpense && transaction.category != null) {
        final categoryId = transaction.category!.id;
        // 累加金额（使用绝对值确保计算正确）
        totals[categoryId] =
            (totals[categoryId] ?? 0) + transaction.amount.abs().toDouble();
      }
    }

    return totals;
  }

  // 构建饼图数据
  List<PieChartSectionData> _buildPieSections(Map<int, double> categoryTotals) {
    final total = categoryTotals.values.fold(0.0, (sum, value) => sum + value);
    final sections = <PieChartSectionData>[];
    final categories = CategoryManager().getCategories(isExpense);

    if (categoryTotals.isEmpty) {
      sections.add(
        PieChartSectionData(
          value: 1,
          color: Colors.grey,
          radius: 50,
          title: '0%',
          titleStyle: TextStyle(
            fontSize: 12, // 占比小的文字稍小
            fontWeight: FontWeight.bold,
            // color: Colors.white,
          ),
        ),
      );
      return sections;
    }

    int colorIndex = 0;
    for (final entry in categoryTotals.entries) {
      final categoryId = entry.key;
      final amount = entry.value;

      // 跳过金额为0的分类
      if (amount <= 0) continue;

      // 计算占比
      final percentage = (amount / total) * 100;

      // 查找分类名称
      final category = categories.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => CategoryManager().get(categoryId),
      );

      // 添加饼图区块
      sections.add(
        PieChartSectionData(
          value: percentage,
          color: _colors[colorIndex % _colors.length],
          // radius: percentage > 10 ? 60 : 50, // 占比大的区块稍大一些
          radius: 60, // 占比大的区块稍大一些
          title: '${percentage.toStringAsFixed(1)}%',
          titleStyle: TextStyle(
            fontSize: percentage > 5 ? 12 : 10, // 占比小的文字稍小
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      );

      colorIndex++;
    }

    return sections;
  }

  // 构建图例
  Widget _buildLegends(
    Map<int, double> categoryTotals,
    AppLocalizations localizations,
  ) {
    final categories = CategoryManager().getCategories(isExpense);
    final total = categoryTotals.values.fold(0.0, (sum, value) => sum + value);
    final legends = <Widget>[];

    int colorIndex = 0;
    for (final entry in categoryTotals.entries) {
      final categoryId = entry.key;
      final amount = entry.value;

      // 跳过金额为0的分类
      if (amount <= 0) continue;

      // 计算占比和查找分类
      final percentage = (amount / total) * 100;
      final category = categories.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => CategoryManager().get(categoryId),
      );

      // 添加图例项
      legends.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              // 颜色标识
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _colors[colorIndex % _colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              // 分类名称
              Expanded(
                child: Text(
                  category.name,
                  // style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
              // 占比和金额
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );

      colorIndex++;
    }

    // // 如果没有数据，显示提示
    // if (legends.isEmpty) {
    //   return const Padding(
    //     padding: EdgeInsets.all(16.0),
    //     child: Text(
    //       '没有相关交易数据',
    //       style: TextStyle(color: Colors.grey, fontSize: 14),
    //     ),
    //   );
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   '${isExpense ? '支出' : '收入'}分类占比',
        //   style: const TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.bold,
        //     // margin: EdgeInsets.only(bottom: 8),
        //   ),
        // ),
        ...legends,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryTotals = _calculateCategoryTotals();
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        // 饼图部分
        Expanded(
          flex: 3,
          child: AspectRatio(
            aspectRatio: 1.0,
            child: PieChart(
              PieChartData(
                sections: _buildPieSections(categoryTotals),
                sectionsSpace: 2, // 区块之间的间距
                centerSpaceRadius: 40, // 中心空白区域大小
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    // 可以添加点击交互逻辑
                  },
                ),
              ),
            ),
          ),
        ),
        // 图例部分
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child:
                  categoryTotals.isEmpty
                      ? SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            localizations.general_NoRecords,
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      )
                      : _buildLegends(categoryTotals, localizations),
            ),
          ),
        ),
      ],
    );
  }
}
