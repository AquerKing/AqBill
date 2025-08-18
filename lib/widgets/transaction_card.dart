import 'package:bill/extension/data_formatter.dart';
import 'package:bill/data/global_data_model.dart';
import 'package:bill/data/transaction_model.dart';
import 'package:bill/l10n/app_localizations.dart';
import 'package:bill/resources/svg_icon.dart';
import 'package:flutter/material.dart';

@Deprecated('此组件已废弃，请改用TransactionItem')
class TransactionCard extends Card {
  const TransactionCard(
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
    return GestureDetector(
      onLongPress: () => _showActionMenu(context),
      // onTap: () {},
      child: Card(
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Row(
            spacing: 6,
            children: [
              SvgIcon(model.category!.icon),
              Text(
                '${GlobalDataModel().get('UserConfig', 'currency.sign')}${DataFormatter.formatAmountStringByLocale(DataFormatter.convertAmountToString(model.amount))}',
                style: const TextStyle(fontSize: 20),
              ),
              const VerticalDivider(
                thickness: 2,
                color: Colors.grey,
                indent: 20,
                endIndent: 0,
                width: 20,
              ),
              Text(
                model.comment,
                style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
              ),
            ],
          ),
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
                    Navigator.pop(context); // 关闭菜单
                    onEdit(model); // 调用修改回调
                  },
                ),
                // 删除选项
                ListTile(
                  leading: SvgIcon(SvgIcons.trash_can),
                  title: Text(
                    localizations.general_Delete,
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context); // 关闭菜单
                    onDelete(model); // 调用删除回调
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
