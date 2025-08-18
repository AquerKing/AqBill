import 'package:bill/data/global_data_model.dart';
import 'package:bill/data/transaction_model.dart';
import 'package:bill/extension/date_getter.dart';
import 'package:bill/l10n/app_localizations.dart';
import 'package:bill/manager/database_agent.dart';
import 'package:bill/manager/transcation_repository.dart';
import 'package:bill/widgets/segmented_date_picker.dart';
import 'package:bill/widgets/selectable_transaction_list.dart';
import 'package:bill/widgets/transaction_button_chart.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // 滚动控制与动画
  final ScrollController _scrollController = ScrollController();
  final double _expandedHeight = 165.0;
  final double _collapsedHeight = 0.0;
  final double _scrollThreshold = 20.0;
  bool _isCollapsed = false;
  bool _showScrollTopButton = false;

  // 日期选择器
  late int _selectedDateTime;

  // 交易数据与加载状态
  List<TransactionModel> _transactions = [];
  bool _isLoading = true; // 新增：加载状态标记

  late AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
  }

  @override
  void initState() {
    super.initState();
    // 初始化选中日期
    _selectedDateTime = DateGetter.getTodaysDateNumber();

    _scrollController.addListener(_handleScroll);
    _loadTransactions(); // 初始加载数据
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
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
      final transactions = await TransactionRepository().fetchByPeriod(
        _selectedDateTime,
      );

      setState(() {
        _transactions = transactions;
        _isLoading = false; // 加载完成
      });
    } catch (e) {
      // 处理加载错误
      setState(() => _isLoading = false);
      // 可以添加错误提示
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('加载失败: ${e.toString()}')));
      }
    }
  }

  // 切换选择模式
  // void _toggleSelectionMode() {
  //   setState(() {
  //     _isSelecting = !_isSelecting;
  //     if (!_isSelecting) _selectedIds.clear();
  //   });
  // }

  // 处理项目选择状态变化
  // void _handleSelect(TransactionModel model, bool isSelected) {
  //   setState(() {
  //     if (isSelected) {
  //       _selectedIds.add(model.id);
  //     } else {
  //       _selectedIds.remove(model.id);
  //     }
  //   });
  // }

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
            Text('正在加载交易记录...'),
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
                  TransactionChartButtons(transactions: _transactions),
                  SegmentedDatePicker(
                    onDateSelected: (year, month, day) {
                      setState(() {
                        _selectedDateTime = year * 10000 + month * 100 + day;
                      });
                      _loadTransactions(); // 选择日期后重新加载
                    },
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  ),
                ],
              ),
            ),
          ),

          // 交易列表区域
          Expanded(
            child:
                _isLoading
                    ? _buildLoadingIndicator() // 加载中显示动画
                    : _transactions.isEmpty
                    ? _buildEmptyState() // 空状态
                    : SelectableTransactionList(
                      // 正常显示列表
                      key: ValueKey(_transactions),
                      scrollController: _scrollController,
                      transactions: _transactions,
                      onDeleteSelected: (selected) {
                        for (TransactionModel model in selected) {
                          GlobalDataModel().revertRecord(model);
                          DatabaseAgent().deleteTransaction(model);
                        }
                        TransactionRepository().updateTodaysRecords();
                        _loadTransactions();
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
