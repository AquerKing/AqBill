// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get general_Cancel => '取消';

  @override
  String get general_Delete => '删除';

  @override
  String get general_Add => '添加';

  @override
  String get general_Modify => '修改';

  @override
  String get general_Cost => '支出';

  @override
  String get general_Earned => '收入';

  @override
  String get general_About => '关于';

  @override
  String get general_Apply => '确认';

  @override
  String get general_Amount => '金额';

  @override
  String get general_NoRecords => '无相关数据';

  @override
  String get bottomNavigatorBar_Home_Label => '主页';

  @override
  String get bottomNavigatorBar_History_Label => '历史';

  @override
  String get bottomNavigatorBar_Mine_Label => '我的';

  @override
  String homePage_SummarizationCard_Summarization(
    String cost,
    String earned,
    String currencySign,
  ) {
    return '截至目前，你已经花费了$currencySign$cost，赚了$currencySign$earned';
  }

  @override
  String get appDrawer_SettingsTextHint => '设置';

  @override
  String get homePage_SummarizationCard_TotalAvailableBudgetTextHint => '总计';

  @override
  String get insertRecordDialog_Title => '添加记录';

  @override
  String get insertRecordDialog_TextField_AmountTextHint => '金额';

  @override
  String get insertRecordDialog_TextField_CommentTextHint => '备注';

  @override
  String get modifyRecordDialog_Title => '修改记录';

  @override
  String get historyPage_StatisticsButton_ExpenseTextHint => '支出数据';

  @override
  String get historyPage_StatisticsButton_IncomeTextHint => '收入数据';

  @override
  String get historyPage_DatePicker_YearLabel => '年';

  @override
  String get historyPage_DatePicker_MonthLabel => '月';

  @override
  String get historyPage_DatePicker_DayLabel => '日';

  @override
  String get historyPage_DatePicker_ChooseYearLabel => '选择年份';

  @override
  String get historyPage_DatePicker_ChooseMonthLabel => '选择月份';

  @override
  String get historyPage_DatePicker_ChooseDayLabel => '选择日期';

  @override
  String get historyPage_NoTransactionFoundLabel => '无相关记录';

  @override
  String selectableTransactionList_SelectedTextHint(int count) {
    return '已选中 $count 项';
  }

  @override
  String get minePage_Option_BudgetLabel => '预算';

  @override
  String get minePage_Option_BudgetExplanationLabel => '设置你的每月预算';

  @override
  String get minePage_Option_AlarmLabel => '提醒';

  @override
  String get minePage_Option_AlarmExplanationLabel => '提醒你记录收支';

  @override
  String get minePage_Option_PrivacyAndBackupLabel => '隐私与备份';

  @override
  String get minePage_Option_PrivacyAndBackupExplanationLabel => '保护你的数据';

  @override
  String get minePage_Option_HelpCenterLabel => '帮助';

  @override
  String get minePage_Option_HelpCenterExplanationLabel => '常见问题的解决方案';

  @override
  String get minePage_Option_AboutLabel => '关于';

  @override
  String get minePage_Option_AboutExplanationLabel => '关于AqBill';

  @override
  String get minePage_Dialog_SetMonthlyBudgetTitle => '每月预算';

  @override
  String get minePage_Dialog_EditAliasTitle => '修改昵称';

  @override
  String get warning_UnavailableAmount => '请输入正确的金额。';

  @override
  String get warning_UnavailableAlias => '请输入合法昵称。';

  @override
  String get inputHint_Amount => '输入金额';

  @override
  String get inputHint_Alias => '输入昵称';

  @override
  String get settingsPage_AppBar_Title => '设置';

  @override
  String get privacyPage_AppBar_Title => '隐私与备份';

  @override
  String get aboutPage_AppBar_Title => '关于';

  @override
  String get helpPage_AppBar_Title => '帮助';

  @override
  String aboutPage_VersionLabel(
    String version,
    String channel,
    String buildNumber,
  ) {
    return '版本: $version-$channel ($buildNumber)';
  }

  @override
  String get aboutPage_AppDescriptionLabel => '一款简单易用的日常收支记录软件，记录你生活的每一笔花销和收入。';

  @override
  String get aboutPage_DeveloperTitle => '开发者';

  @override
  String get settingPage_Title_General => '常规';

  @override
  String get settingPage_Config_ColorMode => '颜色模式';

  @override
  String get settingPage_Config_Language => '语言';

  @override
  String get expenseStatisticsPage_TotalExpenceLabel => '总支出';

  @override
  String get incomeStatisticsPage_TotalIncomeLabel => '总收入';

  @override
  String minePage_JoinTimeTextHint(String timeString) {
    return '于 $timeString 加入 AqBill';
  }
}
