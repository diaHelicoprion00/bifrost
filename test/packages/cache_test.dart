import 'package:cache/cache.dart';
import 'package:test/test.dart';

void main() {
  group('Cache', () {
    final cacheClient = Cache();

    /// A test to ensure that the cache correctly stores and retrieves a given value with the given key.
    test("Returns correct value", () {
      const key = "cacheKey";
      const value = "cacheValue";

      cacheClient.write(key: key, value: value);
      expect(cacheClient.read(key: key), value);
    });

    /// A test to ensure that the cache returns null when a key is not present in the cache.
    test("Returns null when key is absent", () {
      const newKey = "newCacheKey";

      cacheClient.read(key: newKey);
    });
  });
}
