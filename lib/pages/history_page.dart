import 'package:bill/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // 滚动控制
  final ScrollController _scrollController = ScrollController();
  final double _expandedHeight = 150.0;
  final double _collapsedHeight = 0.0;
  final double _scrollThreshold = 20.0;
  bool _isCollapsed = false;
  bool _showScrollTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.offset > _scrollThreshold && !_isCollapsed) {
      // 滚动超过阈值，触发收缩动画
      setState(() {
        _isCollapsed = true;
      });
    } else if (_scrollController.offset <= _scrollThreshold && _isCollapsed) {
      // 滚动回到阈值内，触发展开动画
      setState(() {
        _isCollapsed = false;
      });
    }

    setState(() {
      _showScrollTopButton = _isCollapsed && _scrollController.offset > 300;
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        opacity: _showScrollTopButton ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Visibility(
          visible: _showScrollTopButton || _isCollapsed,
          child: FloatingActionButton(
            onPressed: _scrollToTop,
            child: const Icon(Icons.arrow_upward),
          ),
        ),
      ),
      body: Column(
        children: [
          AnimatedContainer(
            padding: const EdgeInsets.all(12),
            duration: const Duration(milliseconds: 200),
            height: _isCollapsed ? _collapsedHeight : _expandedHeight,
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: Text('Test'),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
                return Text(index.toString());
              },
            ),
          ),
        ],
      ),
    );
  }
}
