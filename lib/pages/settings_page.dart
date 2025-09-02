import 'package:bill/data/global_data_model.dart';
import 'package:bill/l10n/app_localizations.dart';
import 'package:bill/mediator/provider/locale_provider.dart';
import 'package:bill/mediator/provider/theme_provider.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late AppLocalizations localizations;

  // 示例设置状态
  bool _notificationsEnabled = true;
  bool _darkModeEnabled =
      GlobalDataModel().get('UserConfig', 'app.theme') == 'dark';
  // ignore: prefer_final_fields
  String _selectedLanguage = GlobalDataModel().get('UserConfig', 'app.lang');
  // ignore: prefer_final_fields
  double _fontSize = 16.0;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(localizations.settingsPage_AppBar_Title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 显示设置分类
            _buildSectionTitle(localizations.settingPage_Title_General),

            // 显示设置项
            _buildSwitchSettingItem(
              icon: Icons.dark_mode,
              title: localizations.settingPage_Config_ColorMode,
              value: _darkModeEnabled,
              onChanged: (value) {
                String themeName = value ? 'dark' : 'light';
                GlobalDataModel().set('UserConfig', 'app.theme', themeName);
                ThemeProvider().changeTheme(themeName);

                setState(() => _darkModeEnabled = value);
              },
            ),
            _buildDivider(),

            _buildSettingItem(
              icon: Icons.language,
              title: localizations.settingPage_Config_Language,
              subtitle: languageDisplayName[_selectedLanguage],
              onTap: () {
                showOptionSelector(
                  context,
                  options: supportLanguage,
                  displayNames: languageDisplayName,
                  onSelected: (language) {
                    _selectedLanguage = language;
                    GlobalDataModel().set('UserConfig', 'app.lang', language);
                    LocaleProvider().changeLocale(language);
                  },
                );
              },
            ),
            // _buildDivider(),

            // _buildSettingItem(
            //   icon: Icons.text_fields,
            //   title: 'Font Size',
            //   subtitle: '${_fontSize.toStringAsFixed(0)}px',
            //   onTap: () {}, // 【问题点】去掉这个 onTap，或根据需求决定是否保留
            // ),

            // // 通知设置分类
            // _buildSectionTitle('Notification'),

            // // 通知设置项
            // _buildSwitchSettingItem(
            //   icon: Icons.notifications,
            //   title: 'Enable Notification',
            //   value: _notificationsEnabled,
            //   onChanged: (value) {
            //     setState(() => _notificationsEnabled = value);
            //   },
            // ),
            // _buildDivider(),
          ],
        ),
      ),
    );
  }

  void showOptionSelector(
    BuildContext context, {
    required List<String> options,
    required Map<String, String> displayNames,
    required Function(String) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 选项列表
              ...options.map((option) {
                return ListTile(
                  title: Center(
                    child: Text(
                      displayNames[option] ?? option, // 优先使用映射表中的显示名
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  onTap: () {
                    // 调用选中回调
                    onSelected(option);
                    // 关闭对话框
                    Navigator.pop(context);
                  },
                );
              }),

              // 取消按钮
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                    minimumSize: const Size(200, 48),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(localizations.general_Cancel),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 构建分类标题
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  // 构建普通设置项
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  // 构建带开关的设置项
  Widget _buildSwitchSettingItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  // 构建分割线
  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 72, // 与图标的宽度对齐，形成缩进效果
      endIndent: 16,
    );
  }
}
