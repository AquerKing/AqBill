// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get bottomNavigatorBar_Home_Label => '主页';

  @override
  String get bottomNavigatorBar_History_Label => '历史';

  @override
  String get bottomNavigatorBar_Data_Label => '数据';

  @override
  String homePage_SummarizationCard_Summarization(int cost, int earned, String currencySign) {
    return '截至目前，您已经花了 $cost$currencySign，赚了 $earned$currencySign';
  }

  @override
  String get appDrawer_SettingsTextHint => '设置';

  @override
  String get appDrawer_AboutTextHint => '关于';

  @override
  String get homePage_SummarizationCard_TotalAvailableBudgetTextHint => '可用预算';

  @override
  String get homePage_SummarizationCard_AvailableBudgetTextHint => '支出';

  @override
  String get homePage_SummarizationCard_EarnedTextHint => '收入';

  @override
  String get insertRecordDialog_Title => '添加记录';

  @override
  String get insertRecordDialog_SegmentedButton_CostTextHint => '支出';

  @override
  String get insertRecordDialog_SegmentedButton_EarnedTextHint => '收入';

  @override
  String get insertRecordDialog_TextField_AmountTextHint => '金额';

  @override
  String get insertRecordDialog_TextField_CommentTextHint => '备注';

  @override
  String get insertRecordDialog_Button_Add_Label => '添加';

  @override
  String get insertRecordDialog_Button_Cancel_Label => '取消';

  @override
  String get transactionCard_BottomMenu_Option_ModifyTextHint => '修改';

  @override
  String get modifyRecordDialog_Title => 'Modify Record';

  @override
  String get modifyRecordDialog_Button_Modify_Label => 'Modify';

  @override
  String get transactionCard_BottomMenu_Option_DeleteTextHint => '删除';

  @override
  String get transactionCard_BottomMenu_Button_CancelTextHint => '取消';
}
