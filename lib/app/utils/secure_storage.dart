import 'package:disign/app/utils/storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CredentialSecureStorage implements SecureStorage {
  // Create storage
  final FlutterSecureStorage _storage;

  CredentialSecureStorage(this._storage);

  static const _key = 'oauth';
  String? value;

  @override
  Future read() async {
    // Read value
    return value = await _storage.read(key: _key);
  }

  @override
  Future<void> save(data) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<void> clear() {
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  Future<void> destroy() {
    // TODO: implement destroy
    throw UnimplementedError();
  }

// Read all values
// Map<String, String> allValues = await storage.readAll();

// // Delete value
// await storage.delete(key: key);

// // Delete all
// await storage.deleteAll();

// // Write value
// await storage.write(key: key, value: value);
}
