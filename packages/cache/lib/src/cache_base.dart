/// {@template cache}
/// An in-memory cache.
/// {@endtemplate}
class Cache{
  Cache(): _cache = <String, Object>{};

  final Map<String, Object> _cache;

  /// Writes to cache with provided [key],[value] pair.
  void write<T extends Object>({required String key, required T value}){
    _cache[key] = value;
  }

  /// Uses provided [key] to read value from cache.
  /// Returns null if value is not in cache.
  T? read<T extends Object>({required String key}){
    final value = _cache[key];
    if(value is T){
      return value;
    }
    return null;
  }
}