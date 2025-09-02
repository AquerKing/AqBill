import 'package:bill/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum _DatePickerType { year, month, day }

class SegmentedDatePicker extends StatefulWidget {
  final Function(int year, int month, int day) onDateSelected;
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const SegmentedDatePicker({
    super.key,
    required this.onDateSelected,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<SegmentedDatePicker> createState() => _SegmentedDatePickerState();
}

class _SegmentedDatePickerState extends State<SegmentedDatePicker> {
  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;

  late List<int> _years;
  final List<int> _months = List.generate(13, (index) => index); // 0-12（0=All）
  late List<int> _days;

  // ignore: unused_field
  bool _isBottomSheetVisible = false;
  _DatePickerType? _currentPickerType;
  late AppLocalizations localizations;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialDate ?? DateTime.now();
    _selectedYear = initial.year;
    _selectedMonth = initial.month;
    _selectedDay = initial.day;

    _clampYear();
    _initYears();
    _updateDays();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
  }

  void _initYears() {
    _years = [];
    for (
      int year = widget.lastDate.year;
      year >= widget.firstDate.year;
      year--
    ) {
      _years.add(year);
    }
  }

  void _updateDays() {
    if (_selectedMonth == 0) {
      // 月份为All时，日期列表显示0-31（0=All）
      _days = List.generate(1, (index) => index);
      return;
    }

    // 计算实际月份天数
    int daysInMonth;
    if (_selectedMonth == 2) {
      bool isLeapYear =
          (_selectedYear % 4 == 0 && _selectedYear % 100 != 0) ||
          (_selectedYear % 400 == 0);
      daysInMonth = isLeapYear ? 29 : 28;
    } else if ([4, 6, 9, 11].contains(_selectedMonth)) {
      daysInMonth = 30;
    } else {
      daysInMonth = 31;
    }

    _days = List.generate(daysInMonth + 1, (index) => index);

    // 调整日期范围（非All状态下）
    if (_selectedDay != 0 && _selectedDay > daysInMonth) {
      _selectedDay = daysInMonth;
    }
  }

  void _clampYear() {
    if (_selectedYear < widget.firstDate.year) {
      _selectedYear = widget.firstDate.year;
    }
    if (_selectedYear > widget.lastDate.year) {
      _selectedYear = widget.lastDate.year;
    }
  }

  void _showBottomPicker(_DatePickerType type) {
    setState(() {
      _currentPickerType = type;
      _isBottomSheetVisible = true;
    });

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildBottomPickerContent(),
    ).whenComplete(() {
      setState(() {
        _isBottomSheetVisible = false;
        _currentPickerType = null;
      });
    });
  }

  Widget _buildBottomPickerContent() {
    if (_currentPickerType == null) return Container();

    String title;
    List<Widget> items = [];

    switch (_currentPickerType!) {
      case _DatePickerType.year:
        title = localizations.historyPage_DatePicker_ChooseYearLabel;
        items =
            _years
                .map(
                  (year) => _buildPickerItem(
                    label: year.toString(),
                    onTap: () => _onYearSelected(year),
                    isSelected: _selectedYear == year,
                  ),
                )
                .toList();
        break;
      case _DatePickerType.month:
        title = localizations.historyPage_DatePicker_ChooseMonthLabel;
        items =
            _months
                .map(
                  (month) => _buildPickerItem(
                    label: month == 0 ? 'All' : month.toString(),
                    onTap: () => _onMonthSelected(month),
                    isSelected: _selectedMonth == month,
                  ),
                )
                .toList();
        break;
      case _DatePickerType.day:
        title = localizations.historyPage_DatePicker_ChooseDayLabel;
        items =
            _days
                .map(
                  (day) => _buildPickerItem(
                    label: day == 0 ? 'All' : day.toString(),
                    onTap: () => _onDaySelected(day),
                    isSelected: _selectedDay == day,
                  ),
                )
                .toList();
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 250,
          child: GridView.count(
            crossAxisCount: 5,
            childAspectRatio: 1.5,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: items,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.general_Cancel),
          ),
        ),
      ],
    );
  }

  Widget _buildPickerItem({
    required String label,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.blue[50] : Colors.grey[100],
          border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.blue : Colors.black87,
          ),
        ),
      ),
    );
  }

  void _onYearSelected(int year) {
    Navigator.pop(context);
    setState(() {
      _selectedYear = year;
      _clampYear();
      _updateDays();
    });
    widget.onDateSelected(_selectedYear, _selectedMonth, _selectedDay);
  }

  // 核心优化：月份选择为All时，自动将日期同步为All
  void _onMonthSelected(int month) {
    Navigator.pop(context);
    setState(() {
      _selectedMonth = month;
      // 当月份选择为All（0）时，强制日期也为All（0）
      if (month == 0) {
        _selectedDay = 0;
      }
      _updateDays();
    });
    widget.onDateSelected(_selectedYear, _selectedMonth, _selectedDay);
  }

  void _onDaySelected(int day) {
    Navigator.pop(context);
    setState(() {
      _selectedDay = day;
    });
    widget.onDateSelected(_selectedYear, _selectedMonth, _selectedDay);
  }

  Widget _buildSegmentedDisplay() {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withValues(alpha: 0.2),
        //     spreadRadius: 1,
        //     blurRadius: 3,
        //     offset: const Offset(0, 1),
        //   ),
        // ],
      ),
      child: Row(
        children: [
          // 年份显示
          Expanded(
            child: InkWell(
              onTap: () => _showBottomPicker(_DatePickerType.year),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedYear.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      localizations.historyPage_DatePicker_YearLabel,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          // 月份显示
          Expanded(
            child: InkWell(
              onTap: () => _showBottomPicker(_DatePickerType.month),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedMonth == 0 ? 'All' : _selectedMonth.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      localizations.historyPage_DatePicker_MonthLabel,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          // 日期显示
          Expanded(
            child: InkWell(
              onTap: () => _showBottomPicker(_DatePickerType.day),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedDay == 0 ? 'All' : _selectedDay.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      localizations.historyPage_DatePicker_DayLabel,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSegmentedDisplay();
  }
}
