class DateGetter {
  DateGetter._internal();

  static int getTodayDateNumber() {
    DateTime dateTime = DateTime.now();
    return dateTime.year * 10000 + dateTime.month * 100 + dateTime.day;
  }

  static String getTodaysDateString() {
    DateTime dateTime = DateTime.now();
    return '${dateTime.year.toString().padLeft(4, '0')}${dateTime.month.toString().padLeft(2, '0')}${dateTime.day.toString().padLeft(2, '0')}';
  }

  static String getTodaysFormattedDateString() {
    DateTime dateTime = DateTime.now();
    return '${dateTime.year.toString().padLeft(4, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}';
  }

  static int getTodaysYMNumber() {
    DateTime dateTime = DateTime.now();
    return dateTime.year * 100 + dateTime.month;
  }
}
