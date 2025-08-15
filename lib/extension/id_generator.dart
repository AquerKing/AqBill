/// 交易ID生成器
class IdGenerator {
  IdGenerator._internal();
  static final IdGenerator _instance = IdGenerator._internal();
  factory IdGenerator() => _instance;

  int _lastTimestamp = 0;
  int _sequence = 0;

  int generateId() {
    final now = DateTime.now().millisecondsSinceEpoch;

    if (now > _lastTimestamp) {
      _lastTimestamp = now;
      _sequence = 0;
    } else {
      _sequence++;
      // 检查序列号是否超过22位所能表示的最大值
      if (_sequence > 0x3FFFFF) {
        // 22位最大为4,194,303
        // 等待下一毫秒
        while (DateTime.now().millisecondsSinceEpoch <= _lastTimestamp) {
          // 短暂延迟
        }
        _lastTimestamp = DateTime.now().millisecondsSinceEpoch;
        _sequence = 0;
      }
    }

    // 组合时间戳(42位)和序列号(22位)
    return (_lastTimestamp << 22) | _sequence;
  }
}
