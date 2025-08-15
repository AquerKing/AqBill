// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get bottomNavigatorBar_Home_Label => 'Home';

  @override
  String get bottomNavigatorBar_History_Label => 'History';

  @override
  String get bottomNavigatorBar_Data_Label => 'Data';

  @override
  String homePage_SummarizationCard_Summarization(int cost, int earned, String currencySign) {
    return 'Up to now, you\'ve cost $cost$currencySign, earned $earned$currencySign';
  }

  @override
  String get appDrawer_SettingsTextHint => 'Settings';

  @override
  String get appDrawer_AboutTextHint => 'About';

  @override
  String get homePage_SummarizationCard_TotalAvailableBudgetTextHint => 'Total';

  @override
  String get homePage_SummarizationCard_AvailableBudgetTextHint => 'Available';

  @override
  String get homePage_SummarizationCard_EarnedTextHint => 'Earned';

  @override
  String get insertRecordDialog_Title => 'Add Record';

  @override
  String get insertRecordDialog_SegmentedButton_CostTextHint => 'Cost';

  @override
  String get insertRecordDialog_SegmentedButton_EarnedTextHint => 'Earned';

  @override
  String get insertRecordDialog_TextField_AmountTextHint => 'Amount';

  @override
  String get insertRecordDialog_TextField_CommentTextHint => 'Comment';

  @override
  String get insertRecordDialog_Button_Add_Label => 'Add';

  @override
  String get insertRecordDialog_Button_Cancel_Label => 'Cancel';

  @override
  String get transactionCard_BottomMenu_Option_ModifyTextHint => 'Modify';

  @override
  String get modifyRecordDialog_Title => 'Modify Record';

  @override
  String get modifyRecordDialog_Button_Modify_Label => 'Modify';

  @override
  String get transactionCard_BottomMenu_Option_DeleteTextHint => 'Delete';

  @override
  String get transactionCard_BottomMenu_Button_CancelTextHint => 'Cancel';
}
