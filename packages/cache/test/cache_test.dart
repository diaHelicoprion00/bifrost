import 'package:cache/cache.dart';
import 'package:test/test.dart';

void main() {
  group('Cache', () {
    test('can read, write and delete for a given key', () {
      final cache = Cache();
      const key = 'key';
      const value = 'value';

      expect(cache.read(key: key), isNull);
      cache.write(key: key, value: value);
      expect(cache.read(key: key), equals(value));

      expect(cache.delete(key: key), equals(value));
      expect(cache.delete(key: key), isNull);
    });
  });
}
