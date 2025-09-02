import 'dart:math';

import 'package:bill/data/bill_themes.dart';
import 'package:bill/data/global_data_model.dart';
import 'package:bill/data/transaction_model.dart';
import 'package:bill/extension/date_getter.dart';
import 'package:bill/extension/id_generator.dart';
import 'package:bill/l10n/app_localizations.dart';
import 'package:bill/mediator/manager/category_manager.dart';
import 'package:bill/mediator/manager/user_data_manager.dart';
import 'package:bill/mediator/manager/database_agent.dart';
import 'package:bill/mediator/provider/locale_provider.dart';
import 'package:bill/mediator/provider/theme_provider.dart';
import 'package:bill/mediator/manager/transaction_repository.dart';
import 'package:bill/pages/about_page.dart';
import 'package:bill/pages/mine_page.dart';
import 'package:bill/pages/history_page.dart';
import 'package:bill/pages/settings_page.dart';
import 'package:bill/widgets/reusable_transaction_dialog.dart';
import 'package:flutter/material.dart';

import 'package:bill/pages/home_page.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 读取数据
  UserDataManager().checkBackupFolder;
  GlobalDataModel().initLifecycleListener();
  await GlobalDataModel().loadFromFiles();
  UserDataManager().checkLastRunTime();
  LocaleProvider().changeLocale(
    GlobalDataModel().get('UserConfig', 'app.lang'),
  );

  ThemeProvider().updateFromConfig();
  await TransactionRepository().updateTodaysRecords();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: GlobalDataModel()),
        ChangeNotifierProvider.value(value: TransactionRepository()),
        ChangeNotifierProvider.value(value: ThemeProvider()),
        ChangeNotifierProvider.value(value: LocaleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
        return MaterialApp(
          title: 'AqBill',
          locale: localeProvider.currentLocale,
          theme: themeProvider.theme['Material.ThemeData'],
          home: const AppHome(title: 'AqBill'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}

class AppHome extends StatefulWidget {
  const AppHome({super.key, required this.title});
  final String title;

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> with SingleTickerProviderStateMixin {
  int _currentPageIndex = 0;
  final List<Widget> _pages = [HomePage(), HistoryPage(), MinePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: IndexedStack(index: _currentPageIndex, children: _pages),
      ),
      drawer: _buildDrawer(context),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: AppLocalizations.of(context)!.bottomNavigatorBar_Home_Label,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restore),
            label:
                AppLocalizations.of(context)!.bottomNavigatorBar_History_Label,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppLocalizations.of(context)!.bottomNavigatorBar_Mine_Label,
          ),
        ],

        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Drawer(
      // 使用 ListView 作为抽屉内容的容器，方便展示多项内容并支持滚动
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 添加抽屉头部
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              'Sidebar',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          // 添加抽屉的各项列表内容
          ListTile(
            leading: const Icon(Icons.clear, color: Colors.red),
            title: Text('Reset Today\'s Data [DEBUG_ONLY]'),
            onTap: () {
              GlobalDataModel().clearTodaysTransactions();
              Navigator.pop(context); // 关闭抽屉
            },
          ),
          ListTile(
            leading: const Icon(Icons.add, color: Colors.red),
            title: Text('Add Some Records [DEBUG_ONLY]'),
            onTap: () {
              final List<TransactionModel> transacions = [
                TransactionModel.fromMap({
                  'id': IdGenerator().generateId(),
                  'amount': Random.secure().nextInt(200000) + 100,
                  'category': Random.secure().nextInt(11) + 10000,
                  'comment': '',
                  'date':
                      20250000 +
                      (Random.secure().nextInt(9) + 1) * 100 +
                      (Random.secure().nextInt(30) + 1),
                }),
                TransactionModel.fromMap({
                  'id': IdGenerator().generateId(),
                  'amount': Random.secure().nextInt(200000) + 100,
                  'category': Random.secure().nextInt(11) + 10000,
                  'comment': '',
                  'date':
                      20250000 +
                      (Random.secure().nextInt(9) + 1) * 100 +
                      (Random.secure().nextInt(30) + 1),
                }),
                TransactionModel.fromMap({
                  'id': IdGenerator().generateId(),
                  'amount': Random.secure().nextInt(200000) + 100,
                  'category': Random.secure().nextInt(11) + 10000,
                  'comment': '',
                  'date':
                      20250000 +
                      (Random.secure().nextInt(9) + 1) * 100 +
                      (Random.secure().nextInt(30) + 1),
                }),
                TransactionModel.fromMap({
                  'id': IdGenerator().generateId(),
                  'amount': Random.secure().nextInt(200000) + 100,
                  'category': Random.secure().nextInt(11) + 10000,
                  'comment': '',
                  'date':
                      20250000 +
                      (Random.secure().nextInt(9) + 1) * 100 +
                      (Random.secure().nextInt(30) + 1),
                }),
                TransactionModel.fromMap({
                  'id': IdGenerator().generateId(),
                  'amount': Random.secure().nextInt(200000) + 100,
                  'category': Random.secure().nextInt(11) + 10000,
                  'comment': '',
                  'date':
                      20250000 +
                      (Random.secure().nextInt(9) + 1) * 100 +
                      (Random.secure().nextInt(30) + 1),
                }),
                TransactionModel.fromMap({
                  'id': IdGenerator().generateId(),
                  'amount': Random.secure().nextInt(200000) + 100,
                  'category': Random.secure().nextInt(11) + 10000,
                  'comment': '',
                  'date':
                      20250000 +
                      (Random.secure().nextInt(9) + 1) * 100 +
                      (Random.secure().nextInt(30) + 1),
                }),
                TransactionModel.fromMap({
                  'id': IdGenerator().generateId(),
                  'amount': Random.secure().nextInt(200000) + 100,
                  'category': Random.secure().nextInt(11) + 10000,
                  'comment': '',
                  'date':
                      20250000 +
                      (Random.secure().nextInt(9) + 1) * 100 +
                      (Random.secure().nextInt(30) + 1),
                }),
                TransactionModel.fromMap({
                  'id': IdGenerator().generateId(),
                  'amount': Random.secure().nextInt(200000) + 100,
                  'category': Random.secure().nextInt(11) + 10000,
                  'comment': '',
                  'date':
                      20250000 +
                      (Random.secure().nextInt(9) + 1) * 100 +
                      (Random.secure().nextInt(30) + 1),
                }),
                TransactionModel.fromMap({
                  'id': IdGenerator().generateId(),
                  'amount': Random.secure().nextInt(200000) + 100,
                  'category': Random.secure().nextInt(11) + 10000,
                  'comment': '',
                  'date':
                      20250000 +
                      (Random.secure().nextInt(9) + 1) * 100 +
                      (Random.secure().nextInt(30) + 1),
                }),
                TransactionModel.fromMap({
                  'id': IdGenerator().generateId(),
                  'amount': Random.secure().nextInt(200000) + 100,
                  'category': Random.secure().nextInt(11) + 10000,
                  'comment': '',
                  'date':
                      20250000 +
                      (Random.secure().nextInt(9) + 1) * 100 +
                      (Random.secure().nextInt(30) + 1),
                }),
                TransactionModel.fromMap({
                  'id': IdGenerator().generateId(),
                  'amount': Random.secure().nextInt(200000) + 100,
                  'category': Random.secure().nextInt(11) + 10000,
                  'comment': '',
                  'date':
                      20250000 +
                      (Random.secure().nextInt(9) + 1) * 100 +
                      (Random.secure().nextInt(30) + 1),
                }),
              ];

              for (var element in transacions) {
                DatabaseAgent().insertTransaction(element);
                GlobalDataModel().insertRecord(element);
              }
              TransactionRepository().updateTodaysRecords();
              Navigator.pop(context); // 关闭抽屉
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(localizations.appDrawer_SettingsTextHint),
            onTap: () {
              // 点击后执行的操作，通常可做页面跳转或其他逻辑处理
              // Navigator.pop(context); // 关闭抽屉
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: Text(localizations.general_About),
            onTap: () {
              // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
