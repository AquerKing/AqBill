import 'dart:math';

import 'package:bill/data/global_data_model.dart';
import 'package:bill/data/transaction_model.dart';
import 'package:bill/extension/data_formatter.dart';
import 'package:bill/extension/metrics.dart';
import 'package:bill/l10n/app_localizations.dart';
import 'package:bill/mediator/manager/database_agent.dart';
import 'package:bill/mediator/manager/transaction_repository.dart';
import 'package:bill/mediator/provider/theme_provider.dart';
import 'package:bill/widgets/reusable_transaction_dialog.dart';
import 'package:bill/widgets/transaction_item.dart';
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
      GlobalDataModel().insertRecord(transaction);
      TransactionRepository().updateTodaysRecords();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    final double labelWidth =
        max(
          Metrics.calculateTextWidth(
            localizations.general_Cost,
            theme.textTheme.titleMedium!.copyWith(fontSize: 20),
          ),
          Metrics.calculateTextWidth(
            localizations.general_Earned,
            theme.textTheme.titleMedium!.copyWith(fontSize: 20),
          ),
        ) +
        5.0;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _insertRecord,
        // tooltip: 'Add a record.',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          AnimatedContainer(
            // padding: const EdgeInsets.all(12),
            duration: const Duration(milliseconds: 200),
            // height: _isCollapsed ? _collapsedHeight : _expandedHeight,
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              // color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: ThemeProvider().theme['Border.Default.Color'],
                  width: 1,
                ),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child:
                  _isCollapsed
                      ? SizedBox(width: double.infinity, height: 0)
                      : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            spacing: 2,
                            children: [
                              // 总计预算使用金额
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      localizations
                                          .homePage_SummarizationCard_TotalAvailableBudgetTextHint,
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 26,
                                          ),
                                    ),
                                    Consumer<GlobalDataModel>(
                                      builder: (context, value, child) {
                                        int availableBudget =
                                            value.get(
                                              'UserData',
                                              'budget.init',
                                            ) -
                                            value.get(
                                              'UserData',
                                              'cost.current',
                                            );
                                        return Text(
                                          DataFormatter.getAmountLocaleString(
                                            availableBudget,
                                          ),
                                          style: theme.textTheme.headlineSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 26,
                                                color:
                                                    availableBudget < 0
                                                        ? Colors.red
                                                        : Colors.green,
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              // 预算使用金额进度条
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  spacing: 8,
                                  children: [
                                    SizedBox(
                                      width: labelWidth,
                                      child: Text(
                                        localizations.general_Cost,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(fontSize: 20),
                                        textAlign: TextAlign.start,
                                        softWrap: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: Consumer<GlobalDataModel>(
                                        builder: (context, value, child) {
                                          final int cost =
                                              value.get<int>(
                                                'UserData',
                                                'cost.current',
                                              ) ??
                                              0;
                                          final int budget =
                                              value.get<int>(
                                                'UserData',
                                                'budget.init',
                                              ) ??
                                              0;
                                          double usedProportion =
                                              budget != 0 ? cost / budget : 0;
                                          usedProportion = usedProportion.clamp(
                                            0.0,
                                            1.0,
                                          );
                                          Color progressColor =
                                              usedProportion <= 0.6
                                                  ? Colors.green
                                                  : usedProportion <= 0.85
                                                  ? Colors.orange
                                                  : Colors.redAccent;
                                          return LinearProgressIndicator(
                                            value: usedProportion,
                                            minHeight: 8,
                                            borderRadius:
                                                const BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                            color: progressColor,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // 收入目标金额百分比
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  spacing: 8,
                                  children: [
                                    SizedBox(
                                      width: labelWidth,
                                      child: Text(
                                        localizations.general_Earned,
                                        textAlign: TextAlign.start,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(fontSize: 20),
                                        softWrap: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: Consumer<GlobalDataModel>(
                                        builder: (context, value, child) {
                                          final int earned =
                                              value.get<int>(
                                                'UserData',
                                                'earn.current',
                                              ) ??
                                              0;
                                          final int earningTarget =
                                              value.get<int>(
                                                'UserData',
                                                'earn.target',
                                              ) ??
                                              0;
                                          double proportion =
                                              earningTarget == 0
                                                  ? (earned > 0
                                                      ? double.infinity
                                                      : 0)
                                                  : earned / earningTarget;
                                          proportion = proportion.clamp(
                                            0.0,
                                            1.0,
                                          );
                                          Color progressColor =
                                              proportion < 0.2
                                                  ? Colors.redAccent
                                                  : proportion < 0.8
                                                  ? Colors.yellow
                                                  : Colors.green;
                                          return LinearProgressIndicator(
                                            value: proportion,
                                            minHeight: 8,
                                            borderRadius:
                                                const BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                            color: progressColor,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Consumer<GlobalDataModel>(
                                    builder: (context, value, child) {
                                      final int costAmount =
                                          value.get<int>(
                                            'UserData',
                                            'cost.current',
                                          )!;
                                      final int earnedAmount =
                                          value.get<int>(
                                            'UserData',
                                            'earn.current',
                                          )!;
                                      final String formattedCostStr =
                                          DataFormatter.formatAmountStringByLocale(
                                            DataFormatter.convertAmountToString(
                                              costAmount,
                                            ),
                                          );
                                      final String formattedEarnedStr =
                                          DataFormatter.formatAmountStringByLocale(
                                            DataFormatter.convertAmountToString(
                                              earnedAmount,
                                            ),
                                          );
                                      final String currencySign =
                                          value.get<String>(
                                            'UserConfig',
                                            'currency.sign',
                                          )!;
                                      return Text(
                                        localizations
                                            .homePage_SummarizationCard_Summarization(
                                              formattedCostStr,
                                              formattedEarnedStr,
                                              currencySign,
                                            ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
            ),
          ),
          Expanded(
            child: Consumer2<GlobalDataModel, TransactionRepository>(
              builder: (
                BuildContext context,
                GlobalDataModel globalData,
                TransactionRepository repository,
                Widget? child,
              ) {
                return ListView.builder(
                  padding: const EdgeInsets.all(6),
                  itemCount: TransactionRepository().count + 1,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if (index == TransactionRepository().count) {
                      return SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.2,
                      );
                    }

                    return TransactionItem(
                      repository.records[index],
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
                          DatabaseAgent().modifyTransaction(
                            model.id,
                            transaction,
                          );
                          repository.updateTodaysRecords();
                          globalData.updateRecord(transaction, model);
                        }
                      },
                      onDelete: (model) {
                        DatabaseAgent().deleteTransaction(model);
                        repository.updateTodaysRecords();
                        globalData.revertRecord(model);
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
