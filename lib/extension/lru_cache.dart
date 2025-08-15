import 'dart:collection';

class LruCache<K, V> {
  final int maxSize;
  final LinkedHashMap _map = LinkedHashMap<K, V>();

  LruCache({required this.maxSize});

  // 获取值，如果存在则将其移到最新位置
  V? get(K key) {
    if (!_map.containsKey(key)) {
      return null;
    }
    // 先移除再插入，保证移到最后（最新位置）
    final value = _map.remove(key);
    if (value != null) {
      _map[key] = value;
    }
    return value;
  }

  // 存入键值对，如果超出最大容量则移除最久未使用的
  void put(K key, V value) {
    // 如果已存在则先移除
    if (_map.containsKey(key)) {
      _map.remove(key);
    }
    // 如果达到最大容量，移除第一个（最久未使用的）
    else if (_map.length >= maxSize) {
      final oldestKey = _map.keys.first;
      _map.remove(oldestKey);
    }
    // 插入新值到最后（最新位置）
    _map[key] = value;
  }

  // 移除指定键值对
  void remove(K key) {
    _map.remove(key);
  }

  // 获取最早插入/最久未使用的数据
  MapEntry? get oldest {
    if (_map.isEmpty) return null;
    return _map.entries.first;
  }

  // 获取最近插入/使用的数据
  MapEntry? get newest {
    if (_map.isEmpty) return null;
    return _map.entries.last;
  }

  // 交换两个键的位置（改变它们的使用顺序）
  bool swap(K key1, K key2) {
    if (!_map.containsKey(key1) || !_map.containsKey(key2)) {
      return false;
    }

    final value1 = _map[key1]!;
    final value2 = _map[key2]!;

    // 先移除两个元素
    _map.remove(key1);
    _map.remove(key2);

    // 按相反顺序重新插入，实现位置交换
    _map[key1] = value1;
    _map[key2] = value2;

    return true;
  }

  void clear() => _map.clear();

  int get size => _map.length;

  bool containsKey(K key) => _map.containsKey(key);

  Iterable get keys => _map.keys;

  Iterable get values => _map.values;
}
