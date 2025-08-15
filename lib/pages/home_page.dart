import 'dart:math';

import 'package:bill/data/global_data_model.dart';
import 'package:bill/data/transaction_model.dart';
import 'package:bill/extension/data_formatter.dart';
import 'package:bill/extension/metrics.dart';
import 'package:bill/l10n/app_localizations.dart';
import 'package:bill/manager/database_agent.dart';
import 'package:bill/manager/transcation_repository.dart';
import 'package:bill/resources/svg_icon.dart';
import 'package:bill/widgets/reusable_transaction_dialog.dart';
import 'package:bill/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  // ignore: library_private_types_in_public_api
  static final GlobalKey<_HomePageState> homePageState = GlobalKey();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;
  final double _expandedHeight = 150.0;
  final double _collapsedHeight = 0.0;
  final double _scrollThreshold = 20.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.offset > _scrollThreshold && !_isCollapsed) {
      // 滚动超过阈值，触发收缩动画
      setState(() {
        _isCollapsed = true;
      });
    } else if (_scrollController.offset <= _scrollThreshold && _isCollapsed) {
      // 滚动回到阈值内，触发展开动画
      setState(() {
        _isCollapsed = false;
      });
    }
  }

  /// 添加交易记录弹窗
  Future<void> _insertRecord() async {
    // _resetInputStates();

    TransactionModel? transaction = await showDialog<TransactionModel>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ReusableTransactionDialog(
          isEditing: false,
          isExpenseInitial: true,
        );
      },
    );

    if (transaction != null) {
      DatabaseAgent().insertTransaction(transaction);
      GlobalDataModel().updateRecord(transaction);
      TranscationRepository().updateTodaysRecords();
      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(content: Text(transaction.toJson()));
      //   },
      // );
      //   showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         content: Text(
      //           CategoryManager().get(transaction.category!.id).toJson(),
      //         ),
      //       );
      //     },
      //   );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final double labelWidth =
        max(
          Metrics.calculateTextWidth(
            localizations.homePage_SummarizationCard_AvailableBudgetTextHint,
            const TextStyle(fontSize: 18),
          ),
          Metrics.calculateTextWidth(
            localizations.homePage_SummarizationCard_EarnedTextHint,
            const TextStyle(fontSize: 18),
          ),
        ) +
        5.0;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _insertRecord,
        tooltip: 'Add a record.',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          AnimatedContainer(
            padding: const EdgeInsets.all(12),
            duration: const Duration(milliseconds: 200),
            height: _isCollapsed ? _collapsedHeight : _expandedHeight,
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                spacing: 2,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizations
                            .homePage_SummarizationCard_TotalAvailableBudgetTextHint,
                        style: const TextStyle(fontSize: 26),
                      ),
                      Consumer<GlobalDataModel>(
                        builder: (context, value, child) {
                          return Text(
                            DataFormatter.getAmountLocaleString(
                              value.get('UserData', 'budget.available'),
                            ),
                            style: const TextStyle(fontSize: 26),
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      SizedBox(
                        width: labelWidth,
                        child: Text(
                          localizations
                              .homePage_SummarizationCard_AvailableBudgetTextHint,
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                      Expanded(
                        child: Consumer<GlobalDataModel>(
                          builder: (context, value, child) {
                            final int cost =
                                value.get<int>('UserData', 'cost.current') ?? 0;
                            final int budget =
                                value.get<int>('UserData', 'budget.init') ?? 0;
                            double usedProportion =
                                budget != 0 ? cost / budget : 0;
                            usedProportion = usedProportion.clamp(0.0, 1.0);
                            Color progressColor =
                                usedProportion <= 0.6
                                    ? Colors.green
                                    : usedProportion <= 0.85
                                    ? Colors.orange
                                    : Colors.redAccent;
                            return LinearProgressIndicator(
                              value: usedProportion,
                              minHeight: 8,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                              color: progressColor,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      SizedBox(
                        width: labelWidth,
                        child: Text(
                          localizations
                              .homePage_SummarizationCard_EarnedTextHint,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18),
                          softWrap: true,
                        ),
                      ),
                      Expanded(
                        child: Consumer<GlobalDataModel>(
                          builder: (context, value, child) {
                            final int earned =
                                value.get<int>('UserData', 'earn.current') ?? 0;
                            final int earningTarget =
                                value.get<int>('UserData', 'earn.target') ?? 0;
                            double proportion =
                                earningTarget == 0
                                    ? (earned > 0 ? double.infinity : 0)
                                    : earned / earningTarget;
                            proportion = proportion.clamp(0.0, 1.0);
                            Color progressColor =
                                proportion < 0.2
                                    ? Colors.redAccent
                                    : proportion < 0.8
                                    ? Colors.yellow
                                    : Colors.green;
                            return LinearProgressIndicator(
                              value: proportion,
                              minHeight: 8,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                              color: progressColor,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer<GlobalDataModel>(
                        builder: (context, value, child) {
                          final int costAmount =
                              value.get<int>('UserData', 'cost.current')!;
                          final int earnedAmount =
                              value.get<int>('UserData', 'earn.current')!;
                          final String formattedCostStr =
                              DataFormatter.formatAmountStringByLocale(
                                DataFormatter.convertAmountToString(costAmount),
                              );
                          final String formattedEarnedStr =
                              DataFormatter.formatAmountStringByLocale(
                                DataFormatter.convertAmountToString(
                                  earnedAmount,
                                ),
                              );
                          final String currencySign =
                              value.get<String>('UserConfig', 'currency.sign')!;
                          return Text(
                            'Up to now, you\'ve cost $currencySign$formattedCostStr, earned $currencySign$formattedEarnedStr.',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<TranscationRepository>(
              builder: (
                BuildContext context,
                TranscationRepository value,
                Widget? child,
              ) {
                return ListView.builder(
                  padding: const EdgeInsets.all(6),
                  itemCount: value.count,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return TransactionCard(
                      value.records[index],
                      onEdit: (model) async {
                        TransactionModel? transaction =
                            await showDialog<TransactionModel>(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return ReusableTransactionDialog(
                                  isEditing: true,
                                  initialModel: model,
                                );
                              },
                            );
                        if (transaction != null) {
                          DatabaseAgent().deleteTransaction(model);
                          GlobalDataModel().revertRecord(model);
                          DatabaseAgent().insertTransaction(transaction);
                          GlobalDataModel().updateRecord(transaction);
                          TranscationRepository().updateTodaysRecords();
                          // TranscationRepository();
                          // showDialog(
                          //   context: context,
                          //   builder: (context) {
                          //     return AlertDialog(
                          //       content: Text(transaction.toJson()),
                          //     );
                          //   },
                          // );
                          // showDialog(
                          //   context: context,
                          //   builder: (context) {
                          //     return AlertDialog(content: Text(model.toJson()));
                          //   },
                          // );
                          //   showDialog(
                          //     context: context,
                          //     builder: (context) {
                          //       return AlertDialog(
                          //         content: Text(
                          //           CategoryManager().get(transaction.category!.id).toJson(),
                          //         ),
                          //       );
                          //     },
                          //   );
                        }
                      },
                      onDelete: (model) {
                        DatabaseAgent().deleteTransaction(model);
                        GlobalDataModel().revertRecord(model);
                        TranscationRepository().updateTodaysRecords();
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
