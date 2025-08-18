import 'package:bill/extension/data_formatter.dart';
import 'package:bill/data/global_data_model.dart';
import 'package:bill/data/transaction_model.dart';
import 'package:bill/l10n/app_localizations.dart';
import 'package:bill/resources/svg_icon.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem(
    this.model, {
    required this.onDelete,
    required this.onEdit,
    super.key,
  });

  final TransactionModel model;
  final void Function(TransactionModel) onDelete;
  final void Function(TransactionModel) onEdit;

  @override
  Widget build(BuildContext context) {
    // 根据交易类型确定金额颜色
    final isExpense = model.isExpense;
    final amountColor = isExpense ? Colors.red : Colors.green;

    // 格式化日期显示
    // final formattedDate = DataFormatter.formatDate(model.date);

    return GestureDetector(
      onLongPress: () => _showActionMenu(context),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // 内容区域
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
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
                    child: Text(
                      model.comment.isNotEmpty
                          ? model.comment
                          : model.category!.name,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

            // 底部分割线
            Container(
              height: 0.5,
              color: Colors.grey[200],
              margin: const EdgeInsets.only(left: 68), // 与图标对齐
            ),
          ],
        ),
      ),
    );
  }

  // 显示长按菜单
  void _showActionMenu(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 修改选项
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.blue),
                  title: Text(localizations.general_Modify),
                  onTap: () {
                    Navigator.pop(context);
                    onEdit(model);
                  },
                ),

                // 删除选项
                ListTile(
                  leading: SvgIcon(SvgIcons.trash_can),
                  title: Text(
                    localizations.general_Delete,
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onDelete(model);
                  },
                ),

                // 取消按钮
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(localizations.general_Cancel),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
