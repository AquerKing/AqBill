// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get general_Cancel => 'Cancel';

  @override
  String get general_Delete => 'Delete';

  @override
  String get general_Add => 'Add';

  @override
  String get general_Modify => 'Modify';

  @override
  String get general_Cost => 'Cost';

  @override
  String get general_Earned => 'Earned';

  @override
  String get general_About => 'About';

  @override
  String get general_Apply => 'Apply';

  @override
  String get general_Amount => 'Amount';

  @override
  String get bottomNavigatorBar_Home_Label => 'Home';

  @override
  String get bottomNavigatorBar_History_Label => 'History';

  @override
  String get bottomNavigatorBar_Mine_Label => 'Mine';

  @override
  String homePage_SummarizationCard_Summarization(int cost, int earned, String currencySign) {
    return 'Up to now, you\'ve cost $cost$currencySign, earned $earned$currencySign';
  }

  @override
  String get appDrawer_SettingsTextHint => 'Settings';

  @override
  String get homePage_SummarizationCard_TotalAvailableBudgetTextHint => 'Total';

  @override
  String get insertRecordDialog_Title => 'Add Record';

  @override
  String get insertRecordDialog_TextField_AmountTextHint => 'Amount';

  @override
  String get insertRecordDialog_TextField_CommentTextHint => 'Comment';

  @override
  String get modifyRecordDialog_Title => 'Modify Record';

  @override
  String get historyPage_StatisticsButton_ExpenseTextHint => 'Expense Statistics';

  @override
  String get historyPage_StatisticsButton_IncomeTextHint => 'Income Statistics';

  @override
  String get historyPage_DatePicker_YearLabel => 'Year';

  @override
  String get historyPage_DatePicker_MonthLabel => 'Month';

  @override
  String get historyPage_DatePicker_DayLabel => 'Day';

  @override
  String get historyPage_DatePicker_ChooseYearLabel => 'Choose a Year';

  @override
  String get historyPage_DatePicker_ChooseMonthLabel => 'Choose a Month';

  @override
  String get historyPage_DatePicker_ChooseDayLabel => 'Choose a Day';

  @override
  String get historyPage_NoTransactionFoundLabel => 'No records found.';

  @override
  String selectableTransactionList_SelectedTextHint(int count) {
    return '$count item(s) selected';
  }

  @override
  String get minePage_Option_BudgetLabel => 'Budget';

  @override
  String get minePage_Option_BudgetExplanationLabel => 'Set your monthly budget';

  @override
  String get minePage_Option_AlarmLabel => 'Alarm';

  @override
  String get minePage_Option_AlarmExplanationLabel => 'Remind you to record';

  @override
  String get minePage_Option_PrivacyAndBackupLabel => 'Privacy & Backup';

  @override
  String get minePage_Option_PrivacyAndBackupExplanationLabel => 'Protect your data';

  @override
  String get minePage_Option_HelpCenterLabel => 'Help';

  @override
  String get minePage_Option_HelpCenterExplanationLabel => 'Find some solutions here';

  @override
  String get minePage_Option_AboutLabel => 'About';

  @override
  String get minePage_Option_AboutExplanationLabel => 'About AqBill';

  @override
  String get minePage_Dialog_SetMonthlyBudgetTitle => 'Monthly Budget';

  @override
  String get minePage_Dialog_EditAliasTitle => 'Change Alias';

  @override
  String get warning_UnavailableAmount => 'Please input available amount.';

  @override
  String get warning_UnavailableAlias => 'Please input available Alias.';

  @override
  String get inputHint_Amount => 'Input Amount';

  @override
  String get inputHint_Alias => 'Input Alias';

  @override
  String get settingsPage_AppBar_Title => 'Settings';

  @override
  String get privacyPage_AppBar_Title => 'Privacy & Backup';

  @override
  String get aboutPage_AppBar_Title => 'About';

  @override
  String get helpPage_AppBar_Title => 'Help';
}
