import 'package:bill/data/global_data_model.dart';
import 'package:bill/extension/data_formatter.dart';
import 'package:bill/extension/date_getter.dart';
import 'package:bill/l10n/app_localizations.dart';
import 'package:bill/mediator/manager/transaction_repository.dart';
import 'package:bill/pages/about_page.dart';
import 'package:bill/pages/help_page.dart';
import 'package:bill/pages/privacy_page.dart';
import 'package:bill/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  // 模拟用户数据
  String userName = GlobalDataModel().get('UserConfig', 'user.name');
  int monthlyBudget = 200000;
  bool isNotificationEnabled = false;
  bool isBiometricEnabled = false;

  // 背景图片和头像变量
  File? _backgroundImage;
  File? _avatarImage;
  final ImagePicker _picker = ImagePicker();

  late AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  // 导航到设置详情页
  void _navigateToDetail(String title) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder:
    //         (context) => Scaffold(
    //           appBar: AppBar(title: Text(title)),
    //           body: Center(child: Text("$title 设置页面")),
    //         ),
    //   ),
    // );
    switch (title) {
      case 'AboutPage':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutPage()),
        );
        break;
      case 'SettingsPage':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
        break;
      case 'PrivacyPage':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PrivacyPage()),
        );
        break;
      case 'HelpPage':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HelpPage()),
        );
        break;
    }
  }

  // 显示预算输入弹窗
  void _showBudgetInputDialog() {
    // 转换当前预算为显示用的字符串 (例如200000 -> "2000.00")
    final currentBudgetStr = (monthlyBudget / 100).toStringAsFixed(2);

    // 创建文本编辑控制器并设置初始值
    final TextEditingController controller = TextEditingController(
      text: currentBudgetStr,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(localizations.minePage_Dialog_SetMonthlyBudgetTitle),
            content: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                // 限制只能输入数字和一个小数点
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                // 确保最多只有两位小数
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final text = newValue.text;
                  if (text.contains('.') && text.split('.').length > 1) {
                    final decimalPart = text.split('.')[1];
                    if (decimalPart.length > 2) {
                      return oldValue;
                    }
                  }
                  return newValue;
                }),
              ],
              decoration: InputDecoration(
                labelText: localizations.general_Amount,
                // prefixText: "¥ ",
                hintText: localizations.inputHint_Amount,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // 处理输入的金额
                  if (controller.text.isNotEmpty) {
                    try {
                      // 将输入的金额转换为100倍的整数 (例如2000.00 -> 200000)
                      final double inputValue = double.parse(controller.text);
                      final int newValue = (inputValue * 100).toInt();

                      setState(() {
                        monthlyBudget = newValue;
                      });

                      GlobalDataModel().set(
                        'UserData',
                        'budget.init',
                        newValue,
                      );

                      // 这里可以添加保存预算到本地或服务器的逻辑
                    } catch (e) {
                      // 处理无效输入
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            localizations.warning_UnavailableAmount,
                          ),
                        ),
                      );
                    }
                  }
                  Navigator.pop(context);
                },
                child: Text(localizations.general_Apply),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(localizations.general_Cancel),
              ),
            ],
          ),
    );
  }

  // 显示编辑用户名弹窗
  void _showEditNameDialog() {
    final TextEditingController nameController = TextEditingController(
      text: userName,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(localizations.minePage_Dialog_EditAliasTitle),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    setState(() {
                      userName = nameController.text;
                      GlobalDataModel().set(
                        'UserConfig',
                        'user.name',
                        userName,
                      );
                    });
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(localizations.warning_UnavailableAlias),
                      ),
                    );
                  }
                },
                child: Text(localizations.general_Apply),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(localizations.general_Cancel),
              ),
            ],
          ),
    );
  }

  // 选择本地图片作为背景
  Future<void> _pickBackgroundImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _backgroundImage = File(image.path);
          // 这里可以添加保存图片路径到本地存储的逻辑
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load picture: ${e.toString()}")),
      );
    }
  }

  // 选择本地图片作为头像
  Future<void> _pickAvatarImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _avatarImage = File(image.path);
          // 这里可以添加保存头像路径到本地存储的逻辑
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load picture: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 顶部用户信息区域 - 支持自定义背景图片
            Container(
              height: 160,
              decoration: BoxDecoration(
                // 优先显示用户选择的图片，否则显示默认渐变
                image:
                    _backgroundImage != null
                        ? DecorationImage(
                          image: FileImage(_backgroundImage!),
                          fit: BoxFit.cover, // 图片适应容器
                          colorFilter: const ColorFilter.mode(
                            Colors.black38,
                            BlendMode.darken, // 使图片暗化，确保文字清晰可见
                          ),
                        )
                        : null,
                gradient:
                    _backgroundImage == null
                        ? const LinearGradient(
                          colors: [Colors.teal, Colors.teal],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                        : null,
              ),
              child: Stack(
                // 使用Stack布局以便将按钮放置在右下角
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 用户头像 - 支持点击更换（移除了右下角图标）
                        GestureDetector(
                          // onTap: _pickAvatarImage, // 点击头像选择图片
                          child: CircleAvatar(
                            radius: 40,
                            // 优先显示用户选择的头像，否则显示默认头像
                            backgroundImage:
                                _avatarImage != null
                                    ? FileImage(_avatarImage!)
                                    : AssetImage('assets/images/user.png'),
                            backgroundColor: Colors.white,
                          ),
                        ),

                        const SizedBox(width: 16),

                        // 用户信息
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 用户名和编辑按钮
                              Row(
                                children: [
                                  Text(
                                    userName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // 编辑名字的小按钮
                                  IconButton(
                                    onPressed: _showEditNameDialog,
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // 加入日期
                              Text(
                                localizations.minePage_JoinTimeTextHint(
                                  GlobalDataModel().get(
                                    'UserConfig',
                                    'user.join_time',
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 背景修改按钮 - 移动至右下角
                  // Positioned(
                  //   bottom: 16,
                  //   right: 16,
                  //   child: IconButton(
                  //     onPressed: _pickBackgroundImage,
                  //     icon: const Icon(
                  //       Icons.photo_camera,
                  //       color: Colors.white54,
                  //       size: 24,
                  //     ),
                  //     tooltip: "更换背景图片",
                  //   ),
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 设置选项区域
            Column(
              children: [
                // 账户设置卡片
                Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // 每月预算设置
                      ListTile(
                        dense: true,
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.money, color: Colors.green),
                        ),
                        title: Text(
                          localizations.minePage_Option_BudgetLabel,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          localizations.minePage_Option_BudgetExplanationLabel,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              // "¥$displayBudget",
                              DataFormatter.getAmountLocaleString(GlobalDataModel().get('UserData', 'budget.init')),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                // color: Color(0xFF2D5BFF),
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        onTap: _showBudgetInputDialog,
                      ),

                      // 通知设置
                      // ListTile(
                      //   dense: true,
                      //   leading: Container(
                      //     width: 40,
                      //     height: 40,
                      //     decoration: BoxDecoration(
                      //       color: const Color(0xFFFDF2E9),
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     child: const Icon(
                      //       Icons.notifications,
                      //       color: Color(0xFFFF9F43),
                      //     ),
                      //   ),
                      //   title: Text(
                      //     localizations.minePage_Option_AlarmLabel,
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //   ),
                      //   subtitle: Text(
                      //     localizations.minePage_Option_AlarmExplanationLabel,
                      //     style: TextStyle(fontSize: 12, color: Colors.grey),
                      //   ),
                      //   trailing: Switch(
                      //     value: isNotificationEnabled,
                      //     onChanged: (value) {
                      //       setState(() {
                      //         isNotificationEnabled = value;
                      //       });
                      //     },
                      //     // activeColor: const Color(0xFF2D5BFF),
                      //   ),
                      // ),

                      // 隐私设置
                      // ListTile(
                      //   dense: true,
                      //   leading: Container(
                      //     width: 40,
                      //     height: 40,
                      //     decoration: BoxDecoration(
                      //       color: const Color(0xFFF4E8FF),
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     child: const Icon(
                      //       Icons.lock,
                      //       color: Color(0xFF9C27B0),
                      //     ),
                      //   ),
                      //   title: Text(
                      //     localizations.minePage_Option_PrivacyAndBackupLabel,
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //   ),
                      //   subtitle: Text(
                      //     localizations
                      //         .minePage_Option_PrivacyAndBackupExplanationLabel,
                      //     style: TextStyle(fontSize: 12, color: Colors.grey),
                      //   ),
                      //   trailing: const Icon(
                      //     Icons.arrow_forward_ios,
                      //     size: 18,
                      //     color: Colors.grey,
                      //   ),
                      //   onTap: () => _navigateToDetail('PrivacyPage'),
                      // ),
                    ],
                  ),
                ),

                // 安全与帮助卡片
                Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // 帮助中心
                      // ListTile(
                      //   dense: true,
                      //   leading: Container(
                      //     width: 40,
                      //     height: 40,
                      //     decoration: BoxDecoration(
                      //       color: const Color(0xFFFFEBEE),
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     child: const Icon(
                      //       Icons.help,
                      //       color: Color(0xFFF44336),
                      //     ),
                      //   ),
                      //   title: Text(
                      //     localizations.minePage_Option_HelpCenterLabel,
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //   ),
                      //   subtitle: Text(
                      //     localizations
                      //         .minePage_Option_HelpCenterExplanationLabel,
                      //     style: TextStyle(fontSize: 12, color: Colors.grey),
                      //   ),
                      //   trailing: const Icon(
                      //     Icons.arrow_forward_ios,
                      //     size: 18,
                      //     color: Colors.grey,
                      //   ),
                      //   onTap: () => _navigateToDetail('HelpPage'),
                      // ),

                      // 关于我们
                      ListTile(
                        dense: true,
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F7FA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.info,
                            color: Color(0xFF00BCD4),
                          ),
                        ),
                        title: Text(
                          localizations.minePage_Option_AboutLabel,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          localizations.minePage_Option_AboutExplanationLabel,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Colors.grey,
                        ),
                        onTap: () => _navigateToDetail('AboutPage'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
