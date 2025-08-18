import 'package:bill/extension/data_formatter.dart';
import 'package:bill/data/global_data_model.dart';
import 'package:bill/data/transaction_model.dart';
import 'package:bill/l10n/app_localizations.dart';
import 'package:bill/resources/svg_icon.dart';
import 'package:flutter/material.dart';

// 列表项组件
class _TransactionItem extends StatelessWidget {
  const _TransactionItem({
    required this.model,
    required this.isSelecting,
    required this.isSelected,
    required this.onSelect,
    required this.onLongPress,
  });

  final TransactionModel model;
  final bool isSelecting;
  final bool isSelected;
  final void Function(TransactionModel, bool) onSelect;
  final void Function(TransactionModel) onLongPress;

  @override
  Widget build(BuildContext context) {
    // 根据交易类型确定金额颜色
    final isExpense = model.isExpense;
    final amountColor = isExpense ? Colors.red : Colors.green;

    // 格式化日期显示
    final formattedDate = DataFormatter.formatDate(model.date);

    return GestureDetector(
      onLongPress: () => onLongPress(model),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // 内容区域
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // 复选框 - 仅在选择模式下显示，添加动画
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: isSelecting ? 24 : 0,
                    height: isSelecting ? 24 : 0,
                    margin:
                        isSelecting
                            ? const EdgeInsets.only(right: 8)
                            : EdgeInsets.zero,
                    child:
                        isSelecting
                            ? Checkbox(
                              value: isSelected,
                              onChanged: (value) {
                                if (value != null) {
                                  onSelect(model, value);
                                }
                              },
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            )
                            : null,
                  ),

                  // 类别图标
                  Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgIcon(model.category!.icon),
                  ),

                  const SizedBox(width: 12),

                  // 中间内容区 - 评论和日期
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 评论内容
                        Text(
                          model.comment.isNotEmpty
                              ? model.comment
                              : model.category!.name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        // 日期
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 金额
                  Text(
                    '${isExpense ? '-' : '+'}${GlobalDataModel().get('UserConfig', 'currency.sign')}'
                    '${DataFormatter.formatAmountStringByLocale(DataFormatter.convertAmountToString(model.amount.abs()))}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: amountColor,
                    ),
                  ),
                ],
              ),
            ),

            // 底部分割线 - 动态调整左边距以适应复选框
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 0.5,
              color: Colors.grey[200],
              margin: EdgeInsets.only(left: isSelecting ? 74 : 68),
            ),
          ],
        ),
      ),
    );
  }
}

// 主组件 - 可选择的交易记录列表
class SelectableTransactionList extends StatefulWidget {
  final List<TransactionModel> transactions;
  final ScrollController scrollController;
  final void Function(List<TransactionModel>) onDeleteSelected;

  const SelectableTransactionList({
    super.key,
    required this.transactions,
    required this.onDeleteSelected,
    required this.scrollController,
  });

  @override
  State<SelectableTransactionList> createState() =>
      _SelectableTransactionListState();
}

class _SelectableTransactionListState extends State<SelectableTransactionList> {
  // 选择模式状态
  bool _isSelecting = false;
  // 选中的项目ID集合
  final Set<int> _selectedIds = {};
  late AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
  }

  // 处理长按事件 - 自动进入选择模式并选中当前项
  void _handleLongPress(TransactionModel model) {
    setState(() {
      // 进入选择模式
      _isSelecting = true;
      // 自动选中当前长按的项
      _selectedIds.add(model.id);
    });
  }

  // 处理项目选择状态变化
  void _handleSelect(TransactionModel model, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedIds.add(model.id);
        // 如果之前未进入选择模式，选中时自动开启
        if (!_isSelecting) {
          _isSelecting = true;
        }
      } else {
        _selectedIds.remove(model.id);
        // 当所有项都未选中时，关闭选择模式
        if (_selectedIds.isEmpty) {
          _isSelecting = false;
        }
      }
    });
  }

  // 获取选中的项目列表
  List<TransactionModel> get _selectedTransactions {
    return widget.transactions
        .where((t) => _selectedIds.contains(t.id))
        .toList();
  }

  // 取消选择所有项并退出选择模式
  void _clearSelection() {
    setState(() {
      _selectedIds.clear();
      _isSelecting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 选择模式下显示操作栏 - 添加淡入淡出和高度变化动画
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: _isSelecting ? 56 : 0,
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            opacity: _isSelecting ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localizations.selectableTransactionList_SelectedTextHint(
                      _selectedTransactions.length,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: _clearSelection,
                        child: Text(localizations.general_Cancel),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          widget.onDeleteSelected(_selectedTransactions);
                          _clearSelection();
                        },
                        child: Text(localizations.general_Delete),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            itemCount: widget.transactions.length,
            itemBuilder: (context, index) {
              final transaction = widget.transactions[index];
              return _TransactionItem(
                model: transaction,
                isSelecting: _isSelecting,
                isSelected: _selectedIds.contains(transaction.id),
                onSelect: _handleSelect,
                onLongPress: _handleLongPress,
              );
            },
          ),
        ),
      ],
    );
  }
}
