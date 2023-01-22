/*  An in-memory cache for Bifrost  */
class Cache {
  Cache() : _cache = <String, Object>{};

  final Map<String, Object> _cache;

  // Uses [key] to find corresponding [value] in the cache.
  // Returns subtype of Object or null if not found.
  T? read<T extends Object>({required String key}) {
    final value = _cache[key];
    if (value is T) return value;
    return null;
  }

  // Writes [key], [value] pair into cache.
  // [key] must be of type string.
  // [value] must be a subtype of Object.
  void write<T extends Object>({required String key, required T value}) {
    try {
      _cache[key] = value;
    } catch (e) {
      rethrow;
    }
  }

  // Deletes [key], [value] pair from cache.
  // Returns [value] if pair exists and is removed from cache.
  // Return null if [key] does not exist in cache.
  Object? delete({required String key}) {
    return _cache.remove(key);
  }
}
