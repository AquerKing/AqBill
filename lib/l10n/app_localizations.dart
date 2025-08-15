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

  /// No description provided for @bottomNavigatorBar_Data_Label.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get bottomNavigatorBar_Data_Label;

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

  /// No description provided for @appDrawer_AboutTextHint.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get appDrawer_AboutTextHint;

  /// No description provided for @homePage_SummarizationCard_TotalAvailableBudgetTextHint.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get homePage_SummarizationCard_TotalAvailableBudgetTextHint;

  /// No description provided for @homePage_SummarizationCard_AvailableBudgetTextHint.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get homePage_SummarizationCard_AvailableBudgetTextHint;

  /// No description provided for @homePage_SummarizationCard_EarnedTextHint.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get homePage_SummarizationCard_EarnedTextHint;

  /// No description provided for @insertRecordDialog_Title.
  ///
  /// In en, this message translates to:
  /// **'Add Record'**
  String get insertRecordDialog_Title;

  /// No description provided for @insertRecordDialog_SegmentedButton_CostTextHint.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get insertRecordDialog_SegmentedButton_CostTextHint;

  /// No description provided for @insertRecordDialog_SegmentedButton_EarnedTextHint.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get insertRecordDialog_SegmentedButton_EarnedTextHint;

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

  /// No description provided for @insertRecordDialog_Button_Add_Label.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get insertRecordDialog_Button_Add_Label;

  /// No description provided for @insertRecordDialog_Button_Cancel_Label.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get insertRecordDialog_Button_Cancel_Label;

  /// No description provided for @transactionCard_BottomMenu_Option_ModifyTextHint.
  ///
  /// In en, this message translates to:
  /// **'Modify'**
  String get transactionCard_BottomMenu_Option_ModifyTextHint;

  /// No description provided for @modifyRecordDialog_Title.
  ///
  /// In en, this message translates to:
  /// **'Modify Record'**
  String get modifyRecordDialog_Title;

  /// No description provided for @modifyRecordDialog_Button_Modify_Label.
  ///
  /// In en, this message translates to:
  /// **'Modify'**
  String get modifyRecordDialog_Button_Modify_Label;

  /// No description provided for @transactionCard_BottomMenu_Option_DeleteTextHint.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get transactionCard_BottomMenu_Option_DeleteTextHint;

  /// No description provided for @transactionCard_BottomMenu_Button_CancelTextHint.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get transactionCard_BottomMenu_Button_CancelTextHint;
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
