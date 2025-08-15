import 'package:bill/data/category_model.dart';
import 'package:bill/data/transaction_model.dart';
import 'package:bill/l10n/app_localizations.dart';
import 'package:bill/manager/category_manager.dart';
import 'package:bill/widgets/amount_input_field.dart';
import 'package:bill/widgets/category_selector.dart';
import 'package:bill/widgets/record_type_segmented_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ReusableTransactionDialog extends StatefulWidget {
  ReusableTransactionDialog({
    super.key,
    this.isEditing = false,
    this.isExpenseInitial = true,
    this.initialModel,
  });

  @override
  State<ReusableTransactionDialog> createState() =>
      _ReusableTransactionDialogState();

  bool isEditing = false;
  bool isExpenseInitial = true;
  TransactionModel? initialModel;
}

class _ReusableTransactionDialogState extends State<ReusableTransactionDialog>
    with SingleTickerProviderStateMixin {
  late bool _isExpense;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  final List<CategoryModel> _expenseCategoryOptions = CategoryManager()
      .getCategories(true);
  final List<CategoryModel> _incomeCategoryOptions = CategoryManager()
      .getCategories(false);

  // 动画相关变量
  late AnimationController _categoryController;
  late Animation<double> _categoryHeightAnimation;
  late FocusNode _amountFocusNode;
  late FocusNode _commentFocusNode;
  bool _isKeyboardVisible = false;
  CategoryModel? currentSelectedCategory;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    bool currentIsExpense = _isExpense;

    return AlertDialog(
      insetPadding: const EdgeInsets.only(left: 20, right: 20),
      title: Text(
        widget.isEditing
            ? localizations
                .modifyRecordDialog_Title // 编辑标题
            : localizations.insertRecordDialog_Title, // 新增标题
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.90,
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              RecordTypeSegmentedButton(
                onSelectionChanged: (isExpense) {
                  setState(() {
                    currentIsExpense = isExpense;
                    currentSelectedCategory =
                        isExpense
                            ? _expenseCategoryOptions[0]
                            : _incomeCategoryOptions[0];
                    _isExpense = isExpense;
                  });
                },
                isInitialExpense: currentIsExpense, // 编辑时默认选中原有类型
              ),
              AmountInputField(
                controller: _amountController,
                isExpense: currentIsExpense,
              ),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText:
                      localizations
                          .insertRecordDialog_TextField_CommentTextHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              AnimatedBuilder(
                animation: _categoryHeightAnimation,
                builder:
                    (context, child) => SizedBox(
                      height: _categoryHeightAnimation.value,
                      child: child,
                    ),
                child: CategorySelector(
                  key: ValueKey(currentIsExpense),
                  categories:
                      currentIsExpense
                          ? _expenseCategoryOptions
                          : _incomeCategoryOptions,
                  maxHeight: 250,
                  initialSelected: currentSelectedCategory, // 编辑时默认选中原有分类
                  onSelected: (selected) {
                    setState(() {
                      currentSelectedCategory = selected;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            widget.isEditing
                ? localizations
                    .modifyRecordDialog_Button_Modify_Label // 编辑按钮
                : localizations.insertRecordDialog_Button_Add_Label, // 新增按钮
          ),
          onPressed: () {
            // 验证金额
            if (_amountController.text.isEmpty ||
                double.tryParse(_amountController.text) == null ||
                double.parse(_amountController.text) <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please input a valid amount.')),
              );
              return;
            }

            // 构建结果模型（编辑时保留原id，新增时自动生成）
            final transaction =
                widget.isEditing
                    ? TransactionModel.fromMap({
                      "id": widget.initialModel!.id,
                      "amount":
                          (double.parse(_amountController.text) * 100).toInt(),
                      "comment": _commentController.text,
                      "category": currentSelectedCategory!.id,
                      "date": widget.initialModel!.date,
                    })
                    : TransactionModel.optional(
                      // 新增：生成新记录
                      amount:
                          (double.parse(_amountController.text) * 100).toInt(),
                      comment: _commentController.text,
                      category: currentSelectedCategory,
                    );

            Navigator.pop(context, transaction);
          },
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localizations.insertRecordDialog_Button_Cancel_Label),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.isEditing) {
      _isExpense = widget.initialModel!.isExpense;
      int number = widget.initialModel!.amount.abs();
      _amountController.text =
          '${number ~/ 100}.${(number % 100).toString().padLeft(2, '0')}';
      _commentController.text = widget.initialModel!.comment;
      currentSelectedCategory = widget.initialModel!.category;
    } else {
      _isExpense = widget.isExpenseInitial;
      currentSelectedCategory =
          _isExpense ? _expenseCategoryOptions[0] : _incomeCategoryOptions[0];
    }

    // 初始化焦点节点
    _amountFocusNode = FocusNode();
    _commentFocusNode = FocusNode();

    // 初始化动画控制器
    _categoryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    // 定义动画：从250高度到0
    _categoryHeightAnimation = Tween<double>(begin: 250, end: 0).animate(
      CurvedAnimation(parent: _categoryController, curve: Curves.easeInOut),
    );

    // 监听键盘可见性
    KeyboardVisibilityController().onChange.listen((visible) {
      if (!mounted) return;

      setState(() {
        _isKeyboardVisible = visible;
      });

      // 根据键盘状态控制动画
      if (visible) {
        _categoryController.forward(); // 折叠
      } else {
        _categoryController.reverse(); // 展开
      }
    });

    // 监听焦点变化（作为键盘监听的补充）
    _amountFocusNode.addListener(_onFocusChanged);
    _commentFocusNode.addListener(_onFocusChanged);
  }

  // 处理焦点变化
  void _onFocusChanged() {
    if (_amountFocusNode.hasFocus || _commentFocusNode.hasFocus) {
      // 输入框获得焦点，折叠类别选择器
      if (_categoryController.status != AnimationStatus.forward &&
          _categoryController.status != AnimationStatus.completed) {
        _categoryController.forward();
      }
    } else if (!_isKeyboardVisible) {
      // 失去焦点且键盘隐藏，展开类别选择器
      if (_categoryController.status != AnimationStatus.reverse &&
          _categoryController.status != AnimationStatus.dismissed) {
        _categoryController.reverse();
      }
    }
  }

  // void _resetInputStates() {
  //   // 重置输入框内容
  //   _amountController.clear();
  //   _commentController.clear();

  //   // 重置交易类型为支出
  //   _isExpense = true;

  //   // 重置焦点状态
  //   _amountFocusNode.unfocus();
  //   _commentFocusNode.unfocus();

  //   // 重置类别选择器动画状态（展开）
  //   if (_categoryController.status == AnimationStatus.completed) {
  //     _categoryController.reverse();
  //   }
  // }

  @override
  void dispose() {
    _categoryController.dispose();
    _amountFocusNode.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }
}
