# AqBill

AqBill 是一个基于 Flutter 开发的轻量级个人记账应用，聚焦于快速记账、月度预算跟踪与分类统计分析。

## 项目简介

本项目提供简洁实用的记账流程，支持：

- 记录支出与收入
- 查看当月预算消耗与收入目标进度
- 按日、月、年筛选历史账单
- 使用图表分析分类占比
- 管理主题与语言等个性化设置

当前代码已包含 Android、iOS、Web 目标工程，核心业务逻辑集中在 lib 目录。

## 功能说明

- 首页总览
  - 显示当月可用预算（结余）
  - 显示支出进度和收入目标进度
  - 提供快速新增账单入口
- 账单管理
  - 支持新增、编辑、删除账单
  - 支持收入/支出分段录入
  - 支持分类选择与备注输入
- 历史与统计
  - 支持按时间维度筛选历史数据
  - 支持可选择的账单列表与批量删除
  - 支持支出/收入分类饼图详情
- 我的与设置
  - 支持编辑用户名和月预算
  - 支持浅色/深色主题切换
  - 支持中英文切换
  - 提供关于、帮助、隐私入口页

## 技术要点

1. 状态管理架构
   - 使用 ChangeNotifier + Provider 进行全局状态分发。
   - 关键状态对象包括 GlobalDataModel、TransactionRepository、ThemeProvider、LocaleProvider。

2. 本地持久化策略（混合存储）
   - 交易明细通过 sqflite 持久化到 SQLite。
   - 用户配置与月度聚合数据通过 JSON 文件存储（user_config.json、user_data.json、app_data.json）。

3. 分层与职责隔离
   - TransactionRepository 负责查询编排与数据聚合。
   - DatabaseAgent 负责底层数据库访问。
   - CategoryManager 统一管理收入/支出分类元数据。

4. 国际化能力
   - 使用 Flutter 官方 l10n 生成流程（ARB + gen-l10n）。
   - 在 MaterialApp 中接入多语言委托与受支持地区。

5. 主题动态切换
   - ThemeProvider 在运行时切换 ThemeData。
   - 主题配置可持久化到用户配置文件。

6. 数据可视化
   - 使用 fl_chart 绘制分类饼图。
   - 结合进度条与汇总卡片展示月度关键指标。


## 目录结构

```text
lib/
  main.dart                    # 应用入口与 Provider 注入
  data/                        # 数据模型与主题定义
  mediator/
    manager/                   # 数据库、仓库、分类、备份等管理器
    provider/                  # 主题/语言/应用信息 Provider
  pages/                       # 页面层（首页、历史、我的、设置、关于等）
  widgets/                     # 可复用组件与对话框
  l10n/                        # 本地化生成代码
  extension/                   # 工具扩展（日期、格式化、压缩等）
assets/
  icons/, images/              # 静态资源
```

## 依赖说明

核心依赖如下：

- provider：状态管理
- sqflite：本地关系型存储
- path_provider：应用目录路径访问
- fl_chart：图表绘制
- flutter_localizations + intl：国际化支持
- flutter_svg：SVG 图标渲染
- image_picker：本地图片选择
- url_launcher：外部链接打开
- archive：压缩归档
- package_info_plus：应用版本信息读取

## 快速开始

### 环境要求

- Flutter SDK：^3.7.2
- Dart SDK：随 Flutter 提供

### 安装依赖

```bash
flutter pub get
```

### 运行项目

```bash
flutter run
```

指定平台运行示例：

```bash
flutter run -d android
flutter run -d ios
flutter run -d chrome
```

### 代码检查与测试

```bash
flutter analyze
flutter test
```

## 当前说明

- 项目已在 l10n.yaml 中配置本地化生成规则，并在 pubspec.yaml 中启用 generate: true。
- 帮助页、隐私页与部分备份能力当前为基础实现，可按需求继续扩展。
- 设置页当前语言切换逻辑以 en-US 与 zh-CN 为主。
