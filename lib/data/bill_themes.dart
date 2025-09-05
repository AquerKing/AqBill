import 'package:flutter/material.dart';

final Map<String, Map<String, dynamic>> themes = {
  'light': {
    'Material.ThemeData': lightTheme,
    'Border.Default.Color': Colors.grey[300]!,
    'BoxDecoration.Default.BackgroundColor': const Color.fromARGB(
      255,
      235,
      235,
      235,
    ),
  },
  'dark': {
    'Material.ThemeData': darkTheme,
    'Border.Default.Color': Colors.black87,
    'BoxDecoration.Default.BackgroundColor': const Color.fromARGB(
      255,
      70,
      69,
      69,
    ),
  },
};

/// 亮色主题（白色基底 + 青绿色调）
final ThemeData lightTheme = ThemeData(
  // 基础配置
  brightness: Brightness.light,
  primaryColor: Colors.teal[600]!, // 主色：较深的青绿色（确保与白色对比清晰）
  primaryColorLight: Colors.teal[400]!, // 浅青绿色（用于次要元素）
  primaryColorDark: Colors.teal[800]!, // 深青绿色（用于强调）
  secondaryHeaderColor: Colors.teal[50]!, // 极浅青绿色（辅助背景）
  // 颜色方案（强化白色基底与青绿色的对比）
  colorScheme: ColorScheme.light(
    primary: Colors.teal[600]!,
    secondary: Colors.teal[100]!,
    surface: Colors.white, // 页面背景：极浅青绿色（柔和不刺眼）
    error: Colors.red[600]!,
    onPrimary: Colors.white, // 青绿色上的文字（白色，高对比）
    onSecondary: Colors.teal[900]!, // 浅青绿色上的文字（深青绿，清晰）
    onSurface: Colors.grey[800]!,
    onError: Colors.white,
  ),

  dividerColor: Colors.grey[300]!,
  dividerTheme: DividerThemeData(color: Colors.grey[300]!, thickness: 1),

  // 文本主题（适配白色基底，确保可读性）
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.grey[800]!, // 深灰标题，与白色对比强烈
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.grey[800]!,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.teal[800]!, // 深青绿标题，强化主题
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Colors.grey[700]!, // 中灰正文，柔和不刺眼
    ),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[700]!),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white, // 按钮文字（白色，与青绿色主色对比）
    ),
  ),

  // 应用栏主题（白色基底 + 青绿色元素）
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.teal[800]!, // 深青绿标题/图标
    elevation: 1,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.teal[800]!,
    ),
    iconTheme: IconThemeData(color: Colors.teal[800]!),
  ),

  // 卡片主题（纯白基底 + 青绿色边框）
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.teal[100]!, width: 1), // 浅青绿边框
    ),
  ),

  // 按钮主题（青绿色主色，确保突出）
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.teal[600]!,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),

  // 开关主题（青绿色选中态，清晰可辨）
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected)
          ? Colors.teal[600]!
          : Colors.grey[400];
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected)
          ? Colors.teal[600]!.withValues(alpha: 0.3)
          : Colors.grey[300];
    }),
  ),

  // 列表项主题（深灰文字 + 青绿色图标）
  listTileTheme: ListTileThemeData(
    textColor: Colors.grey[800]!,
    iconColor: Colors.teal[600]!, // 青绿色图标，与白色对比清晰
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),

  // 滑块主题（青绿色进度条，适配白色基底）
  sliderTheme: SliderThemeData(
    activeTrackColor: Colors.teal[600]!,
    inactiveTrackColor: Colors.grey[200]!,
    thumbColor: Colors.teal[600]!,
    overlayColor: Colors.teal[600]!.withValues(alpha: 0.2),
  ),
);

/// 暗色主题（深灰基底 + 青绿色调）
final ThemeData darkTheme = ThemeData(
  // 基础配置
  brightness: Brightness.dark,
  primaryColor: Colors.teal[400]!, // 主色：明亮青绿色（与深灰对比强烈）
  primaryColorLight: Colors.teal[300]!, // 更亮的青绿色（突出显示）
  primaryColorDark: Colors.teal[500]!, // 稍深的青绿色（平衡视觉）
  secondaryHeaderColor: Colors.grey[800]!, // 深灰辅助色（基底区分）
  // 颜色方案（深灰基底与青绿色高对比）
  colorScheme: ColorScheme.dark(
    primary: Colors.teal[400]!,
    secondary: Colors.teal[800]!,
    surface: Colors.grey[900]!, // 页面背景：深灰（统一基调）
    error: Colors.red[400]!,
    onPrimary: Colors.grey[900]!, // 青绿色上的文字（深灰，高对比）
    onSecondary: Colors.teal[100]!, // 深青绿上的文字（浅青绿，清晰）
    onSurface: Colors.grey[100]!,
    onError: Colors.grey[900]!,
  ),

  dividerColor: Colors.black,
  dividerTheme: DividerThemeData(color: Colors.black, thickness: 1),

  // 文本主题（适配深灰基底，确保可读性）
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.grey[100]!, // 浅灰标题，与深灰对比强烈
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.grey[100]!,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.teal[300]!, // 亮青绿标题，强化主题
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Colors.grey[200]!, // 浅灰正文，柔和不刺眼
    ),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[200]!),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.grey[900]!, // 按钮文字（深灰，与青绿色主色对比）
    ),
  ),

  // 应用栏主题（深灰基底 + 青绿色元素）
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[900]!,
    foregroundColor: Colors.teal[300]!, // 亮青绿标题/图标
    elevation: 1,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.teal[300]!,
    ),
    iconTheme: IconThemeData(color: Colors.teal[300]!),
  ),

  // 卡片主题（深灰基底 + 青绿色边框）
  cardTheme: CardThemeData(
    color: Colors.grey[850]!, // 稍浅的深灰，与页面背景区分
    elevation: 2,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: Colors.teal[900]!.withValues(alpha: 0.3),
        width: 1,
      ), // 暗青绿边框
    ),
  ),

  // 按钮主题（亮青绿色，在深灰中突出）
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.teal[400]!,
      foregroundColor: Colors.grey[900]!,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),

  // 开关主题（亮青绿色选中态，深灰中清晰）
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected)
          ? Colors.teal[400]!
          : Colors.grey[600];
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected)
          ? Colors.teal[400]!.withValues(alpha: 0.3)
          : Colors.grey[700];
    }),
  ),

  // 列表项主题（浅灰文字 + 亮青绿色图标）
  listTileTheme: ListTileThemeData(
    textColor: Colors.grey[100]!,
    iconColor: Colors.teal[400]!, // 亮青绿色图标，与深灰对比清晰
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),

  // 滑块主题（亮青绿色进度条，适配深灰基底）
  sliderTheme: SliderThemeData(
    activeTrackColor: Colors.teal[400]!,
    inactiveTrackColor: Colors.grey[800]!,
    thumbColor: Colors.teal[400]!,
    overlayColor: Colors.teal[400]!.withValues(alpha: 0.2),
  ),
);
