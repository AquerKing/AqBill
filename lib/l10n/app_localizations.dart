import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @general_Cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get general_Cancel;

  /// No description provided for @general_Delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get general_Delete;

  /// No description provided for @general_Add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get general_Add;

  /// No description provided for @general_Modify.
  ///
  /// In en, this message translates to:
  /// **'Modify'**
  String get general_Modify;

  /// No description provided for @general_Cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get general_Cost;

  /// No description provided for @general_Earned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get general_Earned;

  /// No description provided for @general_About.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get general_About;

  /// No description provided for @general_Apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get general_Apply;

  /// No description provided for @general_Amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get general_Amount;

  ///
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get bottomNavigatorBar_Home_Label;

  /// No description provided for @bottomNavigatorBar_History_Label.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get bottomNavigatorBar_History_Label;

  /// No description provided for @bottomNavigatorBar_Mine_Label.
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get bottomNavigatorBar_Mine_Label;

  /// No description provided for @homePage_SummarizationCard_Summarization.
  ///
  /// In en, this message translates to:
  /// **'Up to now, you\'ve cost {cost}{currencySign}, earned {earned}{currencySign}'**
  String homePage_SummarizationCard_Summarization(int cost, int earned, String currencySign);

  /// No description provided for @appDrawer_SettingsTextHint.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get appDrawer_SettingsTextHint;

  /// No description provided for @homePage_SummarizationCard_TotalAvailableBudgetTextHint.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get homePage_SummarizationCard_TotalAvailableBudgetTextHint;

  /// No description provided for @insertRecordDialog_Title.
  ///
  /// In en, this message translates to:
  /// **'Add Record'**
  String get insertRecordDialog_Title;

  /// No description provided for @insertRecordDialog_TextField_AmountTextHint.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get insertRecordDialog_TextField_AmountTextHint;

  /// No description provided for @insertRecordDialog_TextField_CommentTextHint.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get insertRecordDialog_TextField_CommentTextHint;

  /// No description provided for @modifyRecordDialog_Title.
  ///
  /// In en, this message translates to:
  /// **'Modify Record'**
  String get modifyRecordDialog_Title;

  /// No description provided for @historyPage_StatisticsButton_ExpenseTextHint.
  ///
  /// In en, this message translates to:
  /// **'Expense Statistics'**
  String get historyPage_StatisticsButton_ExpenseTextHint;

  /// No description provided for @historyPage_StatisticsButton_IncomeTextHint.
  ///
  /// In en, this message translates to:
  /// **'Income Statistics'**
  String get historyPage_StatisticsButton_IncomeTextHint;

  /// No description provided for @historyPage_DatePicker_YearLabel.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get historyPage_DatePicker_YearLabel;

  /// No description provided for @historyPage_DatePicker_MonthLabel.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get historyPage_DatePicker_MonthLabel;

  /// No description provided for @historyPage_DatePicker_DayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get historyPage_DatePicker_DayLabel;

  /// No description provided for @historyPage_DatePicker_ChooseYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose a Year'**
  String get historyPage_DatePicker_ChooseYearLabel;

  /// No description provided for @historyPage_DatePicker_ChooseMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose a Month'**
  String get historyPage_DatePicker_ChooseMonthLabel;

  /// No description provided for @historyPage_DatePicker_ChooseDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose a Day'**
  String get historyPage_DatePicker_ChooseDayLabel;

  /// No description provided for @historyPage_NoTransactionFoundLabel.
  ///
  /// In en, this message translates to:
  /// **'No records found.'**
  String get historyPage_NoTransactionFoundLabel;

  /// No description provided for @selectableTransactionList_SelectedTextHint.
  ///
  /// In en, this message translates to:
  /// **'{count} item(s) selected'**
  String selectableTransactionList_SelectedTextHint(int count);

  /// No description provided for @minePage_Option_BudgetLabel.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get minePage_Option_BudgetLabel;

  /// No description provided for @minePage_Option_BudgetExplanationLabel.
  ///
  /// In en, this message translates to:
  /// **'Set your monthly budget'**
  String get minePage_Option_BudgetExplanationLabel;

  /// No description provided for @minePage_Option_AlarmLabel.
  ///
  /// In en, this message translates to:
  /// **'Alarm'**
  String get minePage_Option_AlarmLabel;

  /// No description provided for @minePage_Option_AlarmExplanationLabel.
  ///
  /// In en, this message translates to:
  /// **'Remind you to record'**
  String get minePage_Option_AlarmExplanationLabel;

  /// No description provided for @minePage_Option_PrivacyAndBackupLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Backup'**
  String get minePage_Option_PrivacyAndBackupLabel;

  /// No description provided for @minePage_Option_PrivacyAndBackupExplanationLabel.
  ///
  /// In en, this message translates to:
  /// **'Protect your data'**
  String get minePage_Option_PrivacyAndBackupExplanationLabel;

  /// No description provided for @minePage_Option_HelpCenterLabel.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get minePage_Option_HelpCenterLabel;

  /// No description provided for @minePage_Option_HelpCenterExplanationLabel.
  ///
  /// In en, this message translates to:
  /// **'Find some solutions here'**
  String get minePage_Option_HelpCenterExplanationLabel;

  /// No description provided for @minePage_Option_AboutLabel.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get minePage_Option_AboutLabel;

  /// No description provided for @minePage_Option_AboutExplanationLabel.
  ///
  /// In en, this message translates to:
  /// **'About AqBill'**
  String get minePage_Option_AboutExplanationLabel;

  /// No description provided for @minePage_Dialog_SetMonthlyBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly Budget'**
  String get minePage_Dialog_SetMonthlyBudgetTitle;

  /// No description provided for @minePage_Dialog_EditAliasTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Alias'**
  String get minePage_Dialog_EditAliasTitle;

  /// No description provided for @warning_UnavailableAmount.
  ///
  /// In en, this message translates to:
  /// **'Please input available amount.'**
  String get warning_UnavailableAmount;

  /// No description provided for @warning_UnavailableAlias.
  ///
  /// In en, this message translates to:
  /// **'Please input available Alias.'**
  String get warning_UnavailableAlias;

  /// No description provided for @inputHint_Amount.
  ///
  /// In en, this message translates to:
  /// **'Input Amount'**
  String get inputHint_Amount;

  /// No description provided for @inputHint_Alias.
  ///
  /// In en, this message translates to:
  /// **'Input Alias'**
  String get inputHint_Alias;

  /// No description provided for @settingsPage_AppBar_Title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsPage_AppBar_Title;

  /// No description provided for @privacyPage_AppBar_Title.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Backup'**
  String get privacyPage_AppBar_Title;

  /// No description provided for @aboutPage_AppBar_Title.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutPage_AppBar_Title;

  /// No description provided for @helpPage_AppBar_Title.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpPage_AppBar_Title;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
