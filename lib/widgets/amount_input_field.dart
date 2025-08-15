import 'package:bill/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInputField extends StatefulWidget {
  final TextEditingController controller;
  final bool isExpense;

  const AmountInputField({
    super.key,
    required this.controller,
    required this.isExpense,
  });

  @override
  State<AmountInputField> createState() => _AmountInputFieldState();
}

class _AmountInputFieldState extends State<AmountInputField> {
  // 用于跟踪是否是用户主动输入还是程序修改
  bool _isProgrammaticChange = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {}

  // 自定义输入格式化器
  final TextInputFormatter _amountFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'\d*\.?\d{0,2}'),
  );

  // 验证并修正输入内容
  String _validateInput(String value) {
    // 防止多个小数点
    if (value.contains('.') && value.indexOf('.') != value.lastIndexOf('.')) {
      return value.substring(0, value.lastIndexOf('.'));
    }

    // 限制小数点后最多两位
    if (value.contains('.')) {
      final parts = value.split('.');
      if (parts.length > 1 && parts[1].length > 2) {
        return '${parts[0]}.${parts[1].substring(0, 2)}';
      }
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return TextField(
      controller: widget.controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      inputFormatters: [
        _amountFormatter,
        // 使用自定义格式化器
        TextInputFormatter.withFunction((oldValue, newValue) {
          final validatedText = _validateInput(newValue.text);

          // 如果内容有变化且是程序修改，标记状态
          if (validatedText != newValue.text) {
            _isProgrammaticChange = true;
            widget.controller.text = validatedText;
            // 保持光标在末尾
            widget.controller.selection = TextSelection.fromPosition(
              TextPosition(offset: validatedText.length),
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _isProgrammaticChange = false;
            });
            return TextEditingValue(
              text: validatedText,
              selection: TextSelection.fromPosition(
                TextPosition(offset: validatedText.length),
              ),
            );
          }
          return newValue;
        }),
      ],
      decoration: InputDecoration(
        labelText: l10n.insertRecordDialog_TextField_AmountTextHint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
