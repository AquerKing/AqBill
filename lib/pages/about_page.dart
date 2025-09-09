import 'package:bill/l10n/app_localizations.dart';
import 'package:bill/mediator/provider/app_info.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late AppLocalizations localizations = AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
  }

  // 启动URL
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to launch: $url')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.aboutPage_AppBar_Title),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 应用信息区域 - 左侧图标，右侧信息
            const SizedBox(height: 30),
            _buildAppInfoSection(),

            // 开发者信息区域
            _buildDeveloperSection(),

            // 额外链接区域
            // _buildLinksSection(),

            // 版权信息
            const SizedBox(height: 40),
            Text(
              AppData.copyright,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 应用信息部分 - 左侧图标，右侧信息
  Widget _buildAppInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          // 左侧应用图标
          _buildAppIcon(),

          const SizedBox(width: 20),

          // 右侧应用信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 应用名称
                Text(
                  AppData.applicationName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // 版本信息
                Text(
                  localizations.aboutPage_VersionLabel(
                    AppData.version,
                    AppData.buildNumber,
                  ),
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 16),

                // 应用描述
                Text(
                  localizations.aboutPage_AppDescriptionLabel,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 应用图标组件
  Widget _buildAppIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Image.asset('assets/images/bill_icon_temp.png'),
    );
  }

  // 开发者信息部分
  Widget _buildDeveloperSection() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            localizations.aboutPage_DeveloperTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        // 开发者名称
        Text(AppData.developer, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),

        // 联系信息
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 网站链接
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: () => _launchUrl(AppData.website),
            ),

            // 邮件链接
            IconButton(
              icon: const Icon(Icons.email),
              onPressed: () => _launchUrl("mailto:${AppData.email}"),
            ),

            // GitHub链接
            IconButton(
              icon: const Icon(Icons.code),
              onPressed: () => _launchUrl("https://github.com"),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(height: 1),
      ],
    );
  }
}
