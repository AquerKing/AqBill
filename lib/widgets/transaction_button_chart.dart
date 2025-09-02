import 'package:bill/l10n/app_localizations.dart';
import 'package:bill/mediator/manager/category_manager.dart';
import 'package:flutter/material.dart';
import 'package:bill/data/transaction_model.dart';
import 'transaction_pie_chart.dart'; // 假设之前的饼图组件在这个文件中

// 连体按钮组件
class TransactionChartButtons extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TransactionChartButtons({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            // 支出按钮
            Expanded(
              child: _buildChartButton(
                context: context,
                label:
                    localizations.historyPage_StatisticsButton_ExpenseTextHint,
                color: Colors.redAccent,
                isExpense: true,
              ),
            ),
            // 分隔线
            Container(width: 1, color: Colors.white.withOpacity(0.5)),
            // 收入按钮
            Expanded(
              child: _buildChartButton(
                context: context,
                label:
                    localizations.historyPage_StatisticsButton_IncomeTextHint,
                color: Colors.greenAccent,
                isExpense: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建单个按钮
  Widget _buildChartButton({
    required BuildContext context,
    required String label,
    required Color color,
    required bool isExpense,
  }) {
    return Material(
      color: color,
      child: InkWell(
        onTap: () => _navigateToChartPage(context, isExpense),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 导航到图表页面
  void _navigateToChartPage(BuildContext context, bool isExpense) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ChartDetailPage(
              transactions: transactions,
              isExpense: isExpense,
            ),
      ),
    );
  }
}

// 图表详情页面
class ChartDetailPage extends StatelessWidget {
  final List<TransactionModel> transactions;
  final bool isExpense;

  const ChartDetailPage({
    super.key,
    required this.transactions,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isExpense
              ? localizations.historyPage_StatisticsButton_ExpenseTextHint
              : localizations.historyPage_StatisticsButton_IncomeTextHint,
        ),
        // backgroundColor: isExpense ? Colors.redAccent : Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 显示总金额
            _buildTotalAmountCard(localizations),

            const SizedBox(height: 12),

            // 显示饼状图
            Expanded(
              child: TransactionPieChart(
                transactions: transactions,
                isExpense: isExpense,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建总金额卡片
  Widget _buildTotalAmountCard(AppLocalizations localizations) {
    // 计算总金额
    double totalAmount = 0;
    for (final transaction in transactions) {
      if (transaction.isExpense == isExpense && transaction.category != null) {
        totalAmount += transaction.amount.abs().toInt() ~/ 100;
      }
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isExpense
                    ? localizations.expenseStatisticsPage_TotalExpenceLabel
                    : localizations.incomeStatisticsPage_TotalIncomeLabel,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                '¥${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isExpense ? Colors.redAccent : Colors.greenAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
