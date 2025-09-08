import 'package:bill/data/global_data_model.dart';
import 'package:bill/data/transaction_model.dart';
import 'package:bill/extension/date_getter.dart';
import 'package:bill/l10n/app_localizations.dart';
import 'package:bill/mediator/manager/database_agent.dart';
import 'package:bill/mediator/manager/transaction_repository.dart';
import 'package:bill/mediator/provider/theme_provider.dart';
import 'package:bill/widgets/segmented_date_picker.dart';
import 'package:bill/widgets/selectable_transaction_list.dart';
import 'package:bill/widgets/transaction_button_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with WidgetsBindingObserver {
  // 滚动控制与动画
  final ScrollController _scrollController = ScrollController();
  late double _scrollThreshold;
  bool _isCollapsed = false;
  bool _showScrollTopButton = false;

  // 日期选择器
  // late int _selectedDateTime;

  // 交易数据与加载状态
  bool _isLoading = true; // 新增：加载状态标记

  late AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
    _scrollThreshold = MediaQuery.of(context).size.height * 0.15;
  }

  @override
  void initState() {
    super.initState();
    // 初始化选中日期
    // _selectedDateTime = TransactionRepository().periodNumber;
    _loadTransactions();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // TransactionRepository().updateByPeriod(_selectedDateTime);
      _loadTransactions();
    }
  }

  // 处理滚动事件
  void _handleScroll() {
    if (_scrollController.offset > _scrollThreshold && !_isCollapsed) {
      setState(() => _isCollapsed = true);
    } else if (_scrollController.offset <= _scrollThreshold && _isCollapsed) {
      setState(() => _isCollapsed = false);
    }

    setState(() {
      _showScrollTopButton = _isCollapsed && _scrollController.offset > 300;
    });
  }

  // 滚动到顶部
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // 加载交易记录（抽取为独立方法）
  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true); // 开始加载，显示加载动画

    try {
      // 实际加载数据
      // await TransactionRepository().updateByPeriod(_selectedDateTime);
      await TransactionRepository().updateRecords();

      setState(() {
        _isLoading = false; // 加载完成
      });
    } catch (e) {
      // 处理加载错误
      setState(() => _isLoading = false);
      // 可以添加错误提示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Load: ${e.toString()}')),
        );
      }
    }
  }

  // 加载动画组件
  Widget _buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }

  // 空状态组件
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(localizations.historyPage_NoTransactionFoundLabel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        opacity: _showScrollTopButton ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Visibility(
          visible: _showScrollTopButton || _isCollapsed,
          child: FloatingActionButton(
            onPressed: _scrollToTop,
            child: const Icon(Icons.arrow_upward),
          ),
        ),
      ),
      body: Column(
        children: [
          // 可折叠的顶部区域
          AnimatedContainer(
            // padding: const EdgeInsets.all(12),
            duration: const Duration(milliseconds: 200),
            // height: _isCollapsed ? _collapsedHeight : _expandedHeight,
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
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
                              TransactionChartButtons(
                                transactions:
                                    TransactionRepository().periodicRecords,
                              ),
                              SegmentedDatePicker(
                                onDateSelected: (year, month, day) {
                                  setState(() {
                                    TransactionRepository().periodNumber =
                                        year * 10000 + month * 100 + day;
                                    _loadTransactions(); // 选择日期后重新加载
                                  });
                                },
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              ),
                            ],
                          ),
                        ),
                      ),
            ),
          ),

          // 交易列表区域
          Expanded(
            child:
                _isLoading
                    ? _buildLoadingIndicator() // 加载中显示动画
                    : Consumer2<TransactionRepository, GlobalDataModel>(
                      builder: (context, repository, globalDataModel, child) {
                        return TransactionRepository().periodicRecords.isEmpty
                            ? _buildEmptyState()
                            : SelectableTransactionList(
                              // 正常显示列表
                              scrollController: _scrollController,
                              transactions: repository.periodicRecords,
                              reservedSpaceHeight:
                                  MediaQuery.of(context).size.height * 0.2,
                              onDeleteSelected: (selected) {
                                for (TransactionModel model in selected) {
                                  globalDataModel.revertRecord(model);
                                  DatabaseAgent().deleteTransaction(model);
                                }
                                repository.updateTodaysRecords();
                                _loadTransactions();
                                _isCollapsed = false;
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
